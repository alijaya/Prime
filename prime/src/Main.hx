package ;

 import haxe.ds.StringMap;
 import haxe.macro.Context;
 import neko.Lib;
 import sys.io.File;
 import sys.io.FileInput;
 import sys.io.Process;
  using sys.FileSystem;
  using haxe.io.Path;
  using Lambda;
/**
 * ...
 * @author EzeQL
 */

    
 
class Scaffolding extends mcli.CommandLine
{
    
    private static inline var OK                    :Int = 0;
    private static inline var ERR_OUTPUT_DIR        :Int = 1;
    private static inline var ERR_HAXELIB_QUERY     :Int = 2;
    private static inline var ERR_PROJECT_TYPE      :Int = 3;
    private static inline var ERR_COPYNG_TEMPLATE   :Int = 4;
    private static inline var CSS_DIR_NOT_FOUND     :Int = 5;
    
    
	private var DIR_SEP:String = "/";
    private var STYLES_FOLDER:String = "styles";
    private var map:Map<String, String>;
    
    public function help()
    {
        Sys.println(this.showUsage());
        Sys.exit(0);
    }

    public function generate(name:String, projectType:String, dest:String, ?extra:String)
    {
        //TODO: 
        //check if name has strange chars
        
        map = new Map();
		map.set("%AUTHOR%", "prime.vc scanfolding tool");
		map.set("%APP_NAME%", name);
		map.set("%PACKAGE%", "");
		map.set("%PROJECT_DIR%", FileSystem.fullPath(dest + DIR_SEP + name));
		map.set("%DIR_SEP%", DIR_SEP);
        
        
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
        var availableTemplates = FileSystem.readDirectory("templates");
        availableTemplates = availableTemplates.filter( function(file) return FileSystem.isDirectory("templates".addTrailingSlash() + file) );
        
        if (availableTemplates.indexOf(projectType) == -1)
        {
            Sys.println('project type "$projectType" is not available');
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
            traverseDirAndCopy(projectType, "templates", dest);
        } catch (e:Dynamic)
        {
            Sys.println('ERROR: copying template'); 
            Sys.println(e);
            Sys.println("");
            Sys.exit(ERR_COPYNG_TEMPLATE);
        }
		
        Sys.println('Project "$name" of type "$projectType" generated on "$dest"');
        return OK;
        
    }

    
	private function mkDir(dir:String)
	{
		if (FileSystem.exists(dir))
		{
            return;
			throw 'Output dir "$dir" already exists';
		}
        else
        {
            FileSystem.createDirectory(dir);
        }
	}

	private function traverseDirAndCopy(dir:String, root:String , dest:String)
	{
		var currentdir = root + DIR_SEP + dir;
        var dirs = FileSystem.readDirectory(currentdir);
        
        dirs.sort( function(f1, f2) return FileSystem.stat(currentdir + DIR_SEP + f1).size 
                                         - FileSystem.stat(currentdir + DIR_SEP + f2).size );
		
        for ( d in dirs)
		{
            
			var nextFile = currentdir + DIR_SEP + d;
			if (FileSystem.isDirectory(nextFile))
			{
				mkDir(dest + DIR_SEP +  dir + DIR_SEP + d);
				traverseDirAndCopy(dir + DIR_SEP  + d, root, dest);
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
				File.saveContent(dest + DIR_SEP + dir + DIR_SEP + d, out);
			}
		}
	}
	
}

class Main 
{
	static function main() 
	{
        new mcli.Dispatch(Sys.args() ).dispatch(new Scaffolding());
	}
}
