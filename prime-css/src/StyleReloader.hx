import sys.FileSystem;

/**
	Small Neko program looking for style folder changes acting as remoting server.
	Flash connects with xml socket and is notified when change is detected.

	On folder change:
	- compile StyleSheet.hx (nothing else) into a SWF
	- rename class StyleSheet to a unique name  (haxe.macro.Compiler… macro)
	- tell Flash to load the new SWF, and what class to load

	Then in prime.gui.styling.ApplicationStyle
	- Create instance of this new StyleSheet class by reflection
	- apply it as new root stylesheet
*/
class StyleReloader {
	public static var clients = new List<ClientData>();

	static function initClientApi( scnx : haxe.remoting.SocketConnection, context : haxe.remoting.Context ) {
		trace("Client connected");
		var c = new ClientData(scnx);
		context.addObject("api",c);
	}

	static function onClientDisconnected( scnx:haxe.remoting.SocketConnection ) {
		trace("Client disconnected");
		clients.remove(ClientData.ofConnection(scnx));
	}

	static function printUsage() {
		Sys.println('Usage: ${Sys.executablePath()} <style folder> <style-build.hxml> [-swf|-js] <output folder>');
	}

	static function main()
	{
		var args = Sys.args();
		var stylePath = args[0] != null? args[0] : "";
		if (!sys.FileSystem.exists(stylePath)) {
			printUsage();
			Sys.println('Style folder:  "${stylePath}" not found.\n');
			Sys.exit(-1);
		}
		
		var hxml = args[1] != null? args[1] : "";
		if (!sys.FileSystem.exists(hxml)) {
			printUsage();
			Sys.println('HXML file:  "${hxml}" not found.\n');
			Sys.exit(-2);
		}

		var target = args[2] != null? args[2] : "";
		if (target == "") {
			printUsage();
			Sys.println('Compiler target should be -swf or -js.\n');
			Sys.exit(-3);
		}
		var ext = target == "-swf"? ".swf" : ".js";

		var out  = args[3] != null? args[3] : "";
		if (!sys.FileSystem.exists(out)) {
			printUsage();
			Sys.println('Output folder:  "${out}" not found.\n');
			Sys.exit(-2);
		}

		
		var s = new neko.net.ThreadRemotingServer(["localhost"]);
		s.initClientApi = initClientApi;
		s.clientDisconnected = onClientDisconnected;
		trace("Starting server...");
		neko.vm.Thread.create(s.run.bind("localhost", 8888));

		var version = 0;
		var parser  = new PrimeCSS(stylePath);
		Sys.println('Watching for changes in ${stylePath}');
		while (true)
		{
			Sys.sleep(0.1);
			if (parser.buildStyles() == PrimeCSS.OK_NEW_STYLE)
			{
				var oldFile = out + "/S" + version + ext;
				if (sys.FileSystem.exists(oldFile)) {
					Sys.println('Deleting file: ${oldFile}');
					sys.FileSystem.deleteFile(oldFile);
				}

				// Build a new SWF with just the StyleSheet
		        version++;
				var newName = "S" + version;
				var renameCall = "haxe.macro.Compiler.addMetadata('@:native(\\'"+ newName +"\\')', 'StyleSheet', null, true)";
				var buildArgs = [
					hxml,
					target, 'bin-debug/'+ newName + ext,
					'--macro', renameCall
				];

		        var p = new sys.io.Process('haxe', buildArgs);

	            try while ( true ) 
	            {
	                Sys.println(p.stdout.readLine());
	            } catch (e : haxe.io.Eof) { }
	            
	            try while ( true ) 
	            {
	                Sys.println(p.stderr.readLine());
	            } catch (e : haxe.io.Eof) { }
	            
	            if (p.exitCode() != 0) {
	            	p.close();
	                Sys.print('[!] Error compiling Style reload SWF with command: haxe "' + buildArgs.join('" "') + '"\n');
	                continue;
		        }
	            p.close();

		        for( c in clients ) c.reload(newName + ".swf", newName);
		        // Sleep until the next second, as file timestamps have per second accuracy anyway
		        Sys.sleep(Math.max(0.1, Sys.time() - FileSystem.stat(newFile).mtime.getTime()/1000));
			}
		}
	}
}

class ClientData {

	var scnx : haxe.remoting.SocketConnection;

	public function new( scnx : haxe.remoting.SocketConnection ) {
		this.scnx = scnx;
		scnx.setErrorHandler(function(e) { trace("Client error: " + e); });
		(cast scnx).__private = this;
		StyleReloader.clients.add(this);
	}

	public function hi() {
		trace("Client says hi!");
	}

	public function reload( file : String, newName : String ) {
		trace("  Telling client to reload: " + file + ", class name: " + newName);
		scnx.reload.reload.call([file, newName]);
	}

	public static function ofConnection( scnx : haxe.remoting.SocketConnection ) : ClientData {
		return (cast scnx).__private;
	}

}
