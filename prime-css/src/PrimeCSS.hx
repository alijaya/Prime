package ;

 import haxe.io.Path;
 import sys.FileSystem;
 import sys.io.Process;
#if !macro
 import mcli.CommandLine;
#end
  using Lambda;
  using StringTools;

/**
 * ...
 * @author EzeQL
 */

 
class PrimeCSS #if !macro extends CommandLine #end
{
    public var compileParser:Bool;
    
    public var compileStyles:Bool;
    
    private static inline var OK                            = 0;
    private static inline var ERR_NODE_NOT_FOUND            = 1;
    private static inline var ERR_HAXELIB_QUERY             = 2;
    private static inline var ERR_READING_INPUT_DIR         = 3;
    private static inline var ERR_BUILDING_STYLES_PARSER    = 4;
    private static inline var ERR_GENERATING_STYLES         = 5;
    private static inline var ERR_MISSING_STYLES_DIR        = 6;
    private static inline var ERR_MISSING_STYLE_CSS_FILE    = 7;

#if !macro 
	static function main() 
	{

        new mcli.Dispatch(Sys.args() ).dispatch(new PrimeCSS()); 
	}
    public function new ()
    {
         super();
    }
#end

    public static function buildstyles(?projectDir:String,?compileParser:Bool,?compileStyles:Bool,?args:String)
    {
        //trace(Sys.getCwd());
        if (projectDir == null)
        {
            projectDir = Path.directory(Sys.getCwd());
        }
        
        var p:Process = new Process("node", ["-v"]);
        p.stdout.readAll();
        
        if (p.exitCode() != 0)
        {
            
            Sys.println("ERROR: Node is not installed or is not in path");
            Sys.exit(ERR_NODE_NOT_FOUND);
        }
        p.close();
        
        
        p = new Process("haxelib", ["path", "prime-css"]);
        var primeCSSPath = "";
        if (p.exitCode() == 0)
        {
            primeCSSPath = p.stdout.readLine();
        }
        else
        {
            Sys.println("ERROR: running haxelib prime-css path query");
            p.close();
            Sys.exit(ERR_HAXELIB_QUERY);
        }
        p.close();
        
        
        var parserSources = new Array<String>();
        var buildParser = Path.directory(Path.directory(primeCSSPath)) + '//' + 'build-cssparser.hxml';
        parserSources.push(buildParser);
        parserSources.push((Path.directory(primeCSSPath)) + '//' + 'prime//tools//CSSParserMain.hx');
        parserSources.push((Path.directory(primeCSSPath)) + '//' + 'prime//tools//CSSParser.hx');
        
        var parserBin = Path.directory(Path.directory(primeCSSPath)) + '//bin//'+ 'parser.js';
        var buildArgs = 'haxe $buildParser -main prime.tools.CSSParserMain -js $parserBin';
        
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
            Sys.println("Prime Style Parser is up to date.");
        }
        
        var stylesSources:Array<String> = [];
        try
        {
            stylesSources = FileSystem.readDirectory('$projectDir//styles').filter( function(f) return f.endsWith(".css") ).map( function (f) return '$projectDir//styles//$f' );
        }
        catch (e:Dynamic)
        {
            Sys.println("ERROR: reading input dir");
            Sys.exit(ERR_READING_INPUT_DIR);
        }
        
        if ( !FileSystem.exists('$projectDir/styles') )
        {
            Sys.println("ERROR: Missing Styles dir");
            Sys.exit(ERR_MISSING_STYLES_DIR);
        }
        
        if ( !FileSystem.exists('$projectDir/styles/style.css') )
        {
            Sys.println("ERROR: Missing style.css file");
            Sys.exit(ERR_MISSING_STYLE_CSS_FILE);
        }
        
        if (compileStyles || !FileSystem.exists('$projectDir//styles//StyleSheet.hx') || !genedFileNewerThan('$projectDir//styles//StyleSheet.hx', stylesSources))
        {
            Sys.println("Building Styles...");
            
            //leave PrimeCSSPATH + "//"
            p = new Process('node', [parserBin, '$projectDir/styles', primeCSSPath + "//" ] );
            
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

