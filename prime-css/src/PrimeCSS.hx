package ;

 import haxe.io.Path;
 import sys.FileSystem;
 import sys.io.Process;
//#if !macro
 //import mcli.CommandLine;
//#end
  using Lambda;
  using StringTools;

/**
 * ...
 * @author EzeQL
 */

 
class PrimeCSS //#if !macro extends CommandLine #end
{
    
    private static inline var OK                            = 0;
    private static inline var ERR_NODE_NOT_FOUND            = 1;
    private static inline var ERR_HAXELIB_QUERY             = 2;
    private static inline var ERR_READING_INPUT_DIR         = 3;
    private static inline var ERR_BUILDING_STYLES_PARSER    = 4;
    private static inline var ERR_GENERATING_STYLES         = 5;
    private static inline var ERR_MISSING_STYLES_DIR        = 6;
    private static inline var ERR_MISSING_STYLE_CSS_FILE    = 7;
    private static inline var ERR_HAXELIB_QUERY_PATH        = 8;
//
//#if !macro 
	static function main() 
	{

        //new mcli.Dispatch(Sys.args() ).dispatch(new PrimeCSS()); 
	}
    //public function new ()
    //{
         //super();
    //}
//#end

    public static function buildstyles(?projectDir:String,?compileParser:Bool,?compileStyles:Bool,?args:String)
    {
        Sys.println(projectDir);
        if (projectDir == null)
        {
            projectDir = Path.directory(Sys.getCwd()) + "/styles"; //try default
        }
        trace(projectDir);
        
        //wont work if build is not called from project root
        
        var p:Process;
        try
        {
            var p:Process = new Process("node", ["-v"]);
            p.stdout.readAll();
            p.close();
        }
        catch (e:Dynamic)
        {
            Sys.println("ERROR: Node is not installed or is not in path");
            Sys.exit(ERR_NODE_NOT_FOUND);            
        }
        
        p = new Process("haxelib", ["path", "prime-css"]);
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
        
        
        var parserSources = new Array<String>();
        var buildParser = primeCSSPath + 'build-cssparser.hxml';
        
        parserSources.push(buildParser);
        parserSources.push(primeCSSPath + 'prime//tools//CSSParserMain.hx');
        parserSources.push(primeCSSPath + 'prime//tools//CSSParser.hx');
        
        var parserBin = primeCSSPath + 'parser.js';
        var buildArgs = 'haxe "$buildParser" -main prime.tools.CSSParserMain -js "$parserBin"';
        
        if ( compileParser || !FileSystem.exists(parserBin) || !genedFileNewerThan(parserBin, parserSources))
        {
            Sys.println("Building Prime Style Parser...");
            if (Sys.command(buildArgs) != 0)
            {
                Sys.print("error building style parser");
                Sys.exit(ERR_BUILDING_STYLES_PARSER);
            }
        }
        else
        {
            Sys.println("Prime Style Parser isaaaaaaaaa up to date.");
        }
        
        var stylesSources:Array<String> = [];
        try
        {
            stylesSources = FileSystem.readDirectory(projectDir).filter( function(f) return f.endsWith(".css") ).map( function (f) return '$projectDir/$f' );
        }
        catch (e:Dynamic)
        {
            Sys.println("ERROR: reading input dir");
            Sys.exit(ERR_READING_INPUT_DIR);
        }
        
        if ( !FileSystem.exists(projectDir) )
        {
            Sys.println("ERROR: Missing Styles dir");
            Sys.exit(ERR_MISSING_STYLES_DIR);
        }
        
        if ( !FileSystem.exists('$projectDir/style.css') )
        {
            Sys.println("ERROR: Missing style.css file");
            Sys.exit(ERR_MISSING_STYLE_CSS_FILE);
        }
        
        if (compileStyles || !FileSystem.exists('$projectDir/StyleSheet.hx') || !genedFileNewerThan('$projectDir/StyleSheet.hx', stylesSources))
        {
            Sys.println("Building Styles...");
            
            //leave PrimeCSSPATH + "//"
            p = new Process('node', [parserBin, projectDir, primeCSSPath + "//" ] );
            
            try while ( true ) 
            {
                Sys.println(p.stdout.readLine());
            } catch (e : haxe.io.Eof) { }
            
            try while ( true ) 
            {
                Sys.println(p.stderr.readLine());
            } catch (e : haxe.io.Eof) { }

            
            if (p.exitCode() != 0)
            {
                p.close();
                Sys.println("Error: building Styles.");
                Sys.exit(ERR_GENERATING_STYLES);
            }
            p.close();
        }
        else
        {
            Sys.println("Styles are up to date.");
        }
        
        return  OK;
    }
    
    static private function genedFileNewerThan(generatedFile:String, sourceFiles:Array<String>)
    {
        var mtime = FileSystem.stat(generatedFile).mtime.getTime();
        return sourceFiles.foreach( function(f) return mtime > FileSystem.stat(f).mtime.getTime() );
    }

    
}

