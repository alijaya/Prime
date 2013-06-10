package ;
import haxe.io.Path;
import haxe.macro.Context;
import sys.FileSystem;
import sys.io.Process;


/**
 * ...
 * @author EzeQL
 */
class CSSMacros
{

    macro public static function rebuild()
    {
        var dir:String = Context.getPosInfos((macro null).pos).file;
        dir = Path.directory(Path.directory(FileSystem.fullPath(dir)));
        var p:Process = new Process("haxelib", ["run", "prime-css", "--buildstyles", dir]);
        if (p.exitCode() != 0)
        {
            trace(p.stdout.readAll());
            throw "error while regenerating stylesheet.hx";
        }
        p.close();
        return macro null;
    }
    
}