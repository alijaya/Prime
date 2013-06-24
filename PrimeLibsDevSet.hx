package ;
 
import haxe.io.Path;
import sys.FileSystem;
import sys.io.Process;
 using sys.FileSystem;
 using haxe.io.Path;
 
/**
 * ...
 * @author EzeQL
 */
 
class PrimeLibsDevSet 
{
  
	static function main() 
	{
        var primeDirs = FileSystem.readDirectory(".").filter( function( f ) return FileSystem.isDirectory(f) && StringTools.startsWith(f, "prime-"));
        
        for ( d in primeDirs)
            var p = new Process( 'haxelib', ['dev', d, d.addTrailingSlash() + 'src']);
	}
	
}