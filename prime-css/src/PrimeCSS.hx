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
    public  static inline var OK_NEW_STYLE                  = 10;
    public  static inline var OK_NEW_PARSER                 = 20;
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

    public static function buildstyles(?projectDir:String,?forceCompileParser:Bool = false,?forceCompileStyles:Bool = false,?args:String) {
        var p = new PrimeCSS(projectDir);

        var status = p.buildParser(forceCompileParser);
        if (status == OK)
            return p.buildStyles(forceCompileStyles);
        else if (status == OK_NEW_PARSER)
            return p.buildStyles(true);
        else
            return status;
    }


    var projectDir   : String;
    var primeCSSPath : String;
    var parserBin    : String;


    public function new(projectDir)
    {
        this.projectDir = projectDir;
        primeCSSPath = "";

        if (projectDir == null)
            this.projectDir = Path.directory(Sys.getCwd()) + "/styles"; //try default
        
        var p = new Process("node", ["-v"]);
        try
        {
            p.stdout.readAll();
            p.close();
        }
        catch (e:Dynamic)
        {
            Sys.println("ERROR: Node is not installed or is not in path");
            p.close();
            Sys.exit(ERR_NODE_NOT_FOUND);
        }
        
        var p = new Process("haxelib", ["path", "prime-css"]);
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
            Sys.exit(ERR_HAXELIB_QUERY);
        }
        p.close();
        
        this.parserBin = primeCSSPath + 'parser.js';
    }

    public function buildParser(forceCompileParser:Bool = true)
    {
        var parserSources = new Array<String>();
        var buildParser = primeCSSPath + 'build-cssparser.hxml';
        
        parserSources.push(buildParser);
        parserSources.push(primeCSSPath + 'prime//tools//CSSParserMain.hx');
        parserSources.push(primeCSSPath + 'prime//tools//CSSParser.hx');
        
        var buildArgs = 'haxe "$buildParser" -main prime.tools.CSSParserMain -js "$parserBin"';
        
        if ( forceCompileParser || !FileSystem.exists(parserBin) || !genedFileNewerThan(parserBin, parserSources))
        {
            Sys.print("Building Prime Style Parser... ");
            if (Sys.command(buildArgs) != 0)
            {
                Sys.print("error building style parser");
                return ERR_BUILDING_STYLES_PARSER;
            }
            Sys.println("done!");
            return OK_NEW_PARSER;
        }
        else
        {
            #if verbose
            Sys.println("Prime Style Parser is up to date.");
            #end
        }

        return OK;
    }

    public function buildStyles(?forceCompileStyles:Bool = false)
    {
        var stylesSources:Array<String> = [];
        try
        {
            stylesSources = FileSystem.readDirectory(projectDir).filter( function(f) return f.endsWith(".css") ).map( function (f) return '$projectDir/$f' );
        }
        catch (e:Dynamic)
        {
            Sys.println("ERROR: reading input dir");
            return ERR_READING_INPUT_DIR;
        }
        
        if ( !FileSystem.exists(projectDir) )
        {
            Sys.println("ERROR: Missing Styles dir");
            Sys.println(projectDir);
            return ERR_MISSING_STYLES_DIR;
        }
        
        if ( !FileSystem.exists('$projectDir/Style.css') )
        {
            Sys.println("ERROR: Missing Style.css file");
            return ERR_MISSING_STYLE_CSS_FILE;
        }
        
        if (forceCompileStyles || !FileSystem.exists('$projectDir/StyleSheet.hx') || !genedFileNewerThan('$projectDir/StyleSheet.hx', stylesSources))
        {
            Sys.print("Building Styles... ");
            
            //leave PrimeCSSPATH + "//"
            var p = new Process('node', [parserBin, projectDir, primeCSSPath + "//" ] );
            var strBuffer = new StringBuf();
            var hasErrors = false;
            
            //We read stdout and then stderr else it will freeze on Windows.
            try while ( true ) 
            {
                strBuffer.add(p.stdout.readLine());
            } catch (e : haxe.io.Eof) { }

            try while ( true ) 
            {
                strBuffer.add(p.stderr.readLine());
                hasErrors = true;
            } catch (e : haxe.io.Eof) { }
            
            if (#if verbose true #else hasErrors #end) 
                Sys.println(strBuffer.toString());

            if (p.exitCode() != 0)
            {
                p.close();
                Sys.println("Error: building Styles.");
                return ERR_GENERATING_STYLES;
            }
            p.close();

            Sys.println("done!");
            return OK_NEW_STYLE;
        }
        else
        {
            #if verbose
            Sys.println("Styles are up to date.");
            #end
        }
        
        return  OK;
    }
    
    static private function genedFileNewerThan(generatedFile:String, sourceFiles:Array<String>)
    {
        var mtime = FileSystem.stat(generatedFile).mtime.getTime();
        /*
            If generation of StyleSheet.hx is completed in the same second as the Style.css was saved
               gennedFile.mtime will be equal to Style.css.mtime, not greater than.
        */
        return sourceFiles.foreach( function(f) return mtime >= FileSystem.stat(f).mtime.getTime() );
    }

    
}

