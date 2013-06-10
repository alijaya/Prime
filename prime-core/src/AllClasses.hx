package ;

import Assert;
import chx.lang.FatalException;
import prime.core.Error;
import prime.core.geom.Box;
import prime.core.geom.IBox;
import prime.core.geom.IntPoint;
import prime.core.geom.IRectangle;
import prime.core.geom.Point;
import prime.core.geom.Rectangle;
import prime.core.geom.space.Direction;
import prime.core.geom.space.Horizontal;
import prime.core.geom.space.MoveDirection;
import prime.core.geom.space.Position;
import prime.core.geom.space.Vertical;
import prime.core.traits.IClonable;
import prime.core.traits.IDisablable;
import prime.core.traits.IDisposable;
import prime.core.traits.IDuplicatable;
import prime.core.traits.IFlagOwner;
import prime.gui.input.KeyCodes;
import prime.types.DateInterval;
import prime.types.Factory;
import prime.types.FileType;
import prime.types.MimeType;
import prime.types.Number;
import prime.types.Reference;
import prime.types.RGBA;
import prime.types.RGBAType;
import prime.types.URI;
import prime.types.URIScheme;
import prime.types.URL;
import prime.utils.BitUtil;
import prime.utils.DuplicateUtil;
import prime.utils.FastArray;
import prime.utils.FileUtil;
import prime.utils.IfUtil;
import prime.utils.MacroUtils;
import prime.utils.NumberUtil;
import prime.utils.TimerUtil;
import prime.utils.TypeUtil;
import UInt;
#if neko
import prime.neko.traits.IHasTypeParameters;
import prime.neko.utils.Color;
#end

import prime.net.CommunicationType;
import prime.net.CommunicatorsGroup;
import prime.net.Cookie;
import prime.net.FileFilter;
#if flash
import prime.net.FileReference;
import prime.net.FileReferenceList;
import prime.net.IFileReference;
import prime.net.URLVariables;
#end

import prime.net.HttpStatusCodes;
import prime.net.ICommunicator;
import prime.net.RequestMethod;
#if (flash || js)
import prime.net.URLLoader;
#end
#if flash
import prime.avm2.net.FileReference;
import prime.avm2.net.FileReferenceList;
import prime.avm2.net.URLLoader;
#end

#if js
import prime.js.net.URLLoader;
#end

@IgnoreCover
class AllClasses
{
@IgnoreCover
	public static function main():AllClasses {return new AllClasses();}
@IgnoreCover
	public function new(){trace('This is a generated main class');}
}

