/*
 * Copyright (c) 2010, The PrimeVC Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PRIMEVC PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE PRIMVC PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 *
 * Authors:
 *  Danny Wilson	<danny @ onlinetouch.nl>
 */
package prime.types;
#if !CSSParser
 import prime.net.RequestMethod;	//also imports enums
#end
  using prime.utils.FileUtil;
  using prime.utils.IfUtil;
  using prime.utils.NumberUtil;


/**
 * A URI is a uniform resource <i>identifier</i> while a URL is a uniform
 * resource <i>locator</i>.  Hence every URL is a URI, abstractly speaking, but
 * not every URI is a URL.  This is because there is another subcategory of
 * URIs, uniform resource <i>names</i> (URNs), which name resources but do not
 * specify how to locate them.
 *  
 * A URL must be absolute, that is, it must always specify a scheme.
 * A URL string is parsed according to its scheme.
 *  
 *  http://en.wikipedia.org/wiki/URI_scheme
 *  
 *  Ook interessant: http://www.php.net/manual/en/function.parse-url.php#90365
 *
 * @author Danny Wilson
 */
class URI #if CSSParser implements prime.tools.generator.ICodeFormattable #end
{
#if debug
	static function __init__()
	{
		var u = new URI();
		var mailURI = "mailto:mediahuis@tntpost.nl?subject=Een onvergetelijke kerst";
		
		u.parse(mailURI);
		Assert.that(u.scheme == URIScheme.mailto,  u.string);
		Assert.that(u.userinfo == "mediahuis",  u.userinfo);
		Assert.that(u.host == "tntpost.nl",  u.host);
		Assert.that(u.query == "subject=Een onvergetelijke kerst",  u.query);
		Assert.that(u.string == mailURI, u.string);
		
		u.parse("http://decube.net/a");
		Assert.that(u.scheme == URIScheme.http, u.string);
		Assert.that(u.host == "decube.net", u.string);
		Assert.that(u.path == "/a", u.path);
		
		u.parse("/decube.net/a");
		Assert.that(u.scheme == null, u.string);
		Assert.that(u.host == null, u.string);
		Assert.that(u.path == "/decube.net/a", u.string);
		
		u.parse("decube.net/a");
		Assert.that(u.scheme == null, u.string);
		Assert.that(u.host == null, u.string);
		Assert.that(u.path == "decube.net/a", u.string);
		
		u.parse("decube.net:80/a");
		Assert.that(u.string == "decube.net:80/a", u.string);
		Assert.that(u.scheme == null, Std.string(u.scheme));
		Assert.that(u.host == "decube.net", u.host);
		Assert.that(u.port == 80, Std.string(u.port));
		Assert.that(u.path == "/a", u.path);
		
		u.parse("asset://aap");
		
		Assert.isEqual(u.string, "asset://aap");
		Assert.that(u.hasScheme( URIScheme.Scheme('asset') ));
	//	Assert.that(u.scheme == URIScheme.Scheme('asset'), Std.string(u.scheme));
		Assert.isEqual(u.host, "aap");
	}
#end
	
	
	public var string (get_string, null) : String;
	
	public var scheme	(default, set_scheme)	: URIScheme;
	public var userinfo	(default, set_userinfo)	: String;
	public var host		(default, set_host)		: String;
	public var port		(default, set_port)		: Int;
	public var path		(default, set_path)		: String;
	public var query	(default, set_query)	: String;
	public var fragment	(default, set_fragment)	: String;
	
	private inline function set_scheme(v)	{ string = null; return scheme = v; }
	private inline function set_userinfo(v)	{ string = null; return userinfo = v; }
	private inline function set_host(v)		{ string = null; return host = v; }
	private inline function set_port(v)		{ string = null; return port = v; }
	private inline function set_path(v)		{ string = null; return path = v; }
	private inline function set_query(v)	{ string = null; return query = v; }
	private inline function set_fragment(v)	{ string = null; return fragment = v; }
	
	/** Returns true if this URI has a scheme and thus is a URL **/
	public inline function isURL() : Bool			{ return scheme.notNull(); }
	/** Returns true if the host of URI is the URI, so when the port, path, query and fragment are empty **/
	public inline function hostIsURI () : Bool		{ return port == -1 && path == null && query == null && fragment == null; }
	
	public function hasScheme (searchedScheme:URIScheme) : Bool {
		return scheme != null && switch (searchedScheme) {
			case URIScheme.Scheme(schStr1):
				switch (scheme) {
					case URIScheme.Scheme(schStr2): schStr1 == schStr2;
					default:						false;
				}
			
			default:
				searchedScheme == scheme;
		}
	}
	
	/** Returns the string after the last dot in the path.
	 	Returns an empty string if it has no dots in the path.
	 	Returns empty string if the first char is a dot and there are no other dots (UNIX hidden file convention).
	*/
	public var fileExt	(get_fileExt,set_fileExt)	: String;
		private inline function get_fileExt()		: String	{ return path.getExtension().toLowerCase(); }
		private inline function set_fileExt(v)		: String	{ path.setExtension(v); return v; }
	
	
	public var isSet		(get_isSet, never) : Bool;
		private function get_isSet() return
		 	(string.notNull() && string.length.not0()) ||
		 	(  host.notNull() &&   host.length.not0()) ||
		 	(  path.notNull() &&   path.length.not0());
	
	
#if CSSParser
	public var _oid (default, null)		: Int;
#end
	
	
	public function new(str:String = null)
	{
#if CSSParser
		_oid	= prime.utils.ID.getNext();
#end
		port = -1;
		parse(str);
	}
	
	
	public inline function isEmpty () : Bool
	{
		return (scheme == null || host == null) && path == null;
	}


	private inline function reset ()
	{
		(untyped this).port = -1;
		(untyped this).scheme = null; (untyped this).userinfo = (untyped this).host = (untyped this).path = (untyped this).query = (untyped this).fragment = this.string = null;
	}

	
	
	/**
	 * toString will call getString to build the current string or return the
	 * cached version. This method can be extended by super-classes to add
	 * an extra prefix so no inline!
	 */
	public function toString ()
	{
		return string;
	}
	
	
	private function get_string()
	{
		if (this.string.notNull())	return this.string;
		if (isEmpty())				return null;
		var s:StringBuf = new StringBuf();
		
		if (scheme.notNull()) switch (scheme)
		{
			case mailto: s.add("mailto:");
			
			case Scheme(x):
				s.add(x);
				s.add("://");
			default:
				s.add(Std.string(scheme));
				s.add("://");
		}
		
		if (userinfo.notNull()) {
			s.add(userinfo);
			s.addChar('@'.code);
		}
		
		if (host.notNull())
			s.add(host);
		
		if (port != -1) {
			s.addChar(':'.code);
			s.add(Std.string(port));
		}
		if (path.notNull())
			s.add(path);
		
		if (query.notNull()) {
			s.addChar('?'.code);
			s.add(query);
		}
		if (fragment.notNull()) {
			s.addChar('#'.code);
			s.add(fragment);
		}
		
		return string = s.toString();
	}
	
#if flash9
	public function toRequest(method : prime.net.RequestMethod = null)
	{
		var r = new flash.net.URLRequest(this.toString());
		if (method != null && method != get)
		{
			r.method = "POST";
			if (method != post)
				r.requestHeaders.push(new flash.net.URLRequestHeader("X-HTTP-Method-Override", Std.string(method).toUpperCase()));
		}
		return r;
	}
#end
	
	public function parse(str:String) : URI
	{
		if (str.isNull()) return this;
		
		reset();
		var pos:Int = 0;
		
		var scheme_pos = str.indexOf(':');
		if (scheme_pos != -1)
		{	
			var has2slashes = str.charCodeAt(scheme_pos + 1) + str.charCodeAt(scheme_pos + 2) == '/'.code << 1;
			var scheme_str = str.substr(0, scheme_pos);
			
			var us = (untyped this).scheme = Reflect.field(URIScheme, scheme_str);
			if (us == null)
			{
				if (has2slashes) {
					(untyped this).scheme = URIScheme.Scheme(scheme_str);
					pos = scheme_pos + 3;
				}
				else {
					// No generic scheme specified, it's all URI - could be anything
				//	this.string = str;
				//	return this;
				}
			}
			else switch (us)
			{
				case URIScheme.javascript:
					this.string = str;
					return this;
				
				default:
					pos = scheme_pos + 1;
					if (has2slashes) pos += 2;
			}
		}
		
		var user_pos:Int  = str.indexOf('@', pos);
		if (user_pos != -1) {
			(untyped this).userinfo = str.substr(pos, user_pos - pos);
			pos = user_pos + 1;
		}
		
		var port_pos:Int  = str.indexOf(':', pos);
		var path_pos:Int  = str.indexOf('/', pos);
		var query_pos:Int = str.indexOf('?', (path_pos  == -1)? pos : path_pos);
		var frag_pos:Int  = str.indexOf('#', (query_pos == -1)? pos : query_pos);
		
		if (port_pos > path_pos)
			port_pos = -1;
		
		if (port_pos != -1)
		{
			var port_end = path_pos;
			if (port_end == -1) {
				port_end = query_pos;
				if (port_end == -1) {
					port_end = frag_pos;
					if (port_end == -1)
						port_end = str.length;
				}
			}
			
			(untyped this).host = str.substr(pos, port_pos - pos);
			(untyped this).port = Std.parseInt(str.substr(port_pos+1, port_end - port_pos));
			pos = port_end;
		}
		else if (scheme.notNull())
		{
			var host_end = path_pos;
			if (host_end == -1) {
				host_end = query_pos;
				if (host_end == -1) {
					host_end = frag_pos;
					if (host_end == -1)
						host_end = str.length;
				}
			}
			
			(untyped this).host = str.substr(pos, host_end - pos);
			pos = host_end;
		}
		
		if (query_pos != -1)
		{
			var query_end = frag_pos;
			if (query_end == -1)
				query_end = str.length;
			
			(untyped this).path		= str.substr(pos, query_pos - pos);
			(untyped this).query	= str.substr(query_pos + 1, query_end - pos);
		}
		else if (frag_pos != -1)
		{
			(untyped this).path		= str.substr(pos, frag_pos - pos);
			(untyped this).fragment	= str.substr(frag_pos + 1);
		}
		else
			(untyped this).path		= str.substr(pos);
		
		if (path == "")
			(untyped this).path		= null;
		
		(untyped this).string		= str;

		return this;
	}


#if CSSParser
	public function cleanUp () : Void {}
	public function toCode (code:prime.tools.generator.ICodeGenerator)	code.construct( this, [ get_string() ] )
#end
}


/**
 * @author 	Ruben Weijers
 * @since 	sep 8, 2011
 */
class URIUtil
{
	public static inline function hasScheme (str:String)	{ return str.indexOf(':') != -1; }
}
