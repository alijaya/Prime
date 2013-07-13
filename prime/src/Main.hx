package ;

 /**
 * ...
 * @author EzeQL
 */

 import haxe.ds.StringMap;
 import neko.Lib;
 import sys.io.File;
 import sys.io.Process;
  using sys.FileSystem;
  using haxe.io.Path;
  using Lambda;
  
/**
*	Prime project generator
**/
class Scaffolding extends mcli.CommandLine
{
    
    private static inline var OK                    :Int = 0;
    private static inline var ERR_OUTPUT_DIR        :Int = 1;
    private static inline var ERR_HAXELIB_QUERY     :Int = 2;
    private static inline var ERR_PROJECT_TYPE      :Int = 3;
    private static inline var ERR_COPYNG_TEMPLATE   :Int = 4;
    private static inline var CSS_DIR_NOT_FOUND     :Int = 5;
    
    
    private var DIR_SEP:String;
    private var STYLES_FOLDER:String = "styles";
    private var map:Map<String, String>;
    
    /**
     * Shows help 
     **/
    public function help()
    {
        Sys.println(this.showUsage());
        Sys.exit(0);
    }
    
    /**
     * Shows available templates
     **/
    public function templates(?haxeLib:String)
    {
        Sys.println("");
        Sys.println("Available Templates:");
        Sys.println(this.getTemplates().map(function (a) { return "   " + a; }  ).join("\n"));
        Sys.exit(0);
    }
    
    
	/**
     * Generates a Project. Example "haxelib run prime --generate name css-only output"
	**/
    public function generate(t:String, d:String, ?e:String)
    {
        DIR_SEP = Sys.systemName() == "Windows" ? "\\" : "/";
        
        if (!Tools.isAbsolutePath(d))
            d = e.addTrailingSlash() + d;
            
        var name = d.substring(d.lastIndexOf(DIR_SEP) + 1, d.length );
        var type = t;
        var dest = d;
        //TODO: 
        //check if name has strange chars
        
        map = new Map();
		map.set("%AUTHOR%", "prime.vc scanfolding tool");
		map.set("%APP_NAME%", name);
		//map.set("%PACKAGE%", "");
		//try 
        //{
            //map.set("%PROJECT_DIR%", FileSystem.fullPath( dest.addTrailingSlash() + name ));
        //}
        //catch (e:Dynamic)
        //{
            //trace(dest);
            //trace(dest.addTrailingSlash() + name);
            //trace(e)
            //Sys.exit(1);
        //}
        
		//map.set("%DIR_SEP%", DIR_SEP);
        
        
        //get haxelib/prime-css path
        var p = new Process("haxelib", ["path", "prime-css"]);
        var primeCSSPath = "";
        try while (true)
        {
            primeCSSPath = p.stdout.readLine();
            if (primeCSSPath.indexOf("prime-css") != -1)
                break;
        }
        catch (e:Dynamic)
        {
            Sys.println("ERROR: Unable to read prime-css path");
            p.close();
            Sys.exit(ERR_HAXELIB_QUERY);

        }
        
        if (p.exitCode() != 0)
        {
            Sys.println("ERROR: running haxelib prime-css path query");
            p.close();
            Sys.exit(ERR_HAXELIB_QUERY);
        }
        
        
        map.set("%HAXELIB_PRIMECSS_PATH%",primeCSSPath);
        

        //check if project type is correct
        var availableTemplates = getTemplates();
        
        if (availableTemplates.indexOf(type) == -1)
        {
            Sys.println('project type "$type" is not available');
            Sys.println( 'available project types: ' + availableTemplates.join(",") );
            Sys.exit(ERR_PROJECT_TYPE);
        }
        
        //attempt to create output dir
        try { mkDir(dest);}
        catch (e:Dynamic) 
        { 
            Sys.println('ERROR creating output dir:'); 
            Sys.println(e);
            Sys.println("");
            Sys.exit(ERR_OUTPUT_DIR);
        }
		
        try {
            traverseDirAndCopy(type, "templates", dest);
        } catch (e:Dynamic)
        {
            Sys.println('ERROR: copying template'); 
            Sys.println(e);
            Sys.println("");
            Sys.exit(ERR_COPYNG_TEMPLATE);
        }
		
        Sys.println('Project "$name" of type "$type" generated on "$dest"');
        return OK;
        
    }

    
	private function mkDir(dir:String)
	{
		if (FileSystem.exists(dir))
		{
			throw 'Output dir "$dir" already exists';
		}
        else
        {
            FileSystem.createDirectory(dir);
        }
	}

	private function traverseDirAndCopy(dir:String, root:String , dest:String)
	{
		var currentdir = root.addTrailingSlash() + dir;
        var dirs = FileSystem.readDirectory(currentdir);
        
        var trueIfDir = function(s) return FileSystem.isDirectory(currentdir.addTrailingSlash() + s) ? 0 : 1;
        
        dirs.sort( function(f1, f2) return trueIfDir(f1) - trueIfDir(f2) );
        
        for ( d in dirs)
		{
            
			var nextFile = currentdir.addTrailingSlash() + d;
			if (FileSystem.isDirectory(nextFile))
			{
				mkDir(dest.addTrailingSlash() +  dir.addTrailingSlash() + d);
				traverseDirAndCopy(dir.addTrailingSlash() + d, root, dest);
			}
			else
			{
                
				var contents = File.getContent(nextFile);
				var reg = new EReg("%([_A-Z]*)%","g");
				var out = reg.map(contents, function(r:EReg):String
				{
					var key = r.matched(0);
					var value = map.get(key);
					return value;
				});
				File.saveContent(dest.addTrailingSlash() + dir.addTrailingSlash() + d, out);
			}
		}
	}
    
    private function getTemplates()
    {
        return FileSystem.readDirectory("templates").filter( function(file) return FileSystem.isDirectory("templates".addTrailingSlash() + file) );
    }
    
    private function runDefault()
    {
        showUsage();
    }
}

class Main 
{
	static function main() 
	{
        var input = Sys.args();
        var len = input.length;
        if ( ( len < 4 ) && ( Tools.isAbsolutePath(input[len - 1]) ) )
        {
            //We assume that last param is haxelib added original Sys.cwd, then we remove it for showing proper error.
            input.pop();
        }
        new mcli.Dispatch(input).dispatch(new Scaffolding());
	}
}

class Tools
{
    public static inline function isAbsolutePath(path:String):Bool
    {
        return  if (Sys.systemName() == "Windows")
                    ~/[A-Za-z]:[\/\\]/.match(path)
                else
                    ["//", "~"].indexOf(path.charAt(0)) != -1;
    }
}
