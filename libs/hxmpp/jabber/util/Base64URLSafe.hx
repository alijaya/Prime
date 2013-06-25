/*
 *	This file is part of HXMPP.
 *	Copyright (c)2009 http://www.disktree.net
 *	
 *	HXMPP is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  HXMPP is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *	See the GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with HXMPP. If not, see <http://www.gnu.org/licenses/>.
*/
package jabber.util;
 import haxe.io.Bytes;


/**
 * Base64 url-safe encoding/decoding utility.
 * Based on code from jabber.util.Base64
 * 	
 * @author	Ruben Weijers
 * @since	Apr 13, 2011
 * @see		http://en.wikipedia.org/wiki/Base64#URL_applications
 */
class Base64URLSafe
{
	/**
	 * Chars to be used in URLSave encoding
	 */
	public static var CHARS	= 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
	
#if (!nodejs && !php)
	static var bc = new haxe.crypto.BaseCode( Bytes.ofString( CHARS ) );
#end
	

	public static inline function encode( t : String ) : String {
#if php        return untyped __call__( "base64_encode", t );
#elseif nodejs return js.Node.newBuffer(t).toString( js.Node.BASE64 );
#else          return bc.encodeString( t ); #end
	}
	
	public static function decode( t : String ) : String {
#if php        return untyped __call__( "base64_decode", t );
#elseif nodejs return js.Node.newBuffer( t, js.Node.BASE64 ).toString( js.Node.ASCII );
#else          return bc.decodeString( t ); #end
	}
	
	public static function encodeBytes( b : Bytes ) : String {
#if php        return untyped __call__( "base64_encode", b.getData() );
#elseif nodejs return b.getData().toString( js.Node.BASE64 );
#else          return bc.encodeBytes( b ).toString(); #end
	}
	
	public static function decodeBytes( t : String ) : Bytes {
#if php        return Bytes.ofString( untyped __call__( "base64_decode", t ) );
#elseif nodejs return Bytes.ofData( js.Node.newBuffer( t, js.Node.BASE64 ) );
#else          return bc.decodeBytes( Bytes.ofString( t ) ); #end
	}
	
	/**
	 * Create a random string of given length.
	 */
	public static function random( len : Int = 1, ?chars : String ) : String {
		if( chars == null ) chars = CHARS;
		var r = "";
		for( i in 0...len ) r += chars.substr( Math.floor( Math.random()*chars.length ), 1 );
		return r;
	}
}
