package haxevx.proxy.immutable;
import haxevx.proxy.immutable.Immutable;



/**
 * This won't work unless can dynamically generate link to dynamically generated Immutable.Record({DATA-TYPE}) externs beforehand, bleh..
 * @author Glidias
 */


 class ImmuteRecordText extends ImmutableRecord<ImmutableTypeDef>
{
	

	public function new() 
	{
		super({copy:"AFAWF"});
	}
	
	
	public var copy(get, never):String;
	
	public function copyTestGet():String {
		return copy + " >>>>";
	}
	
	inline function get_copy():String 
	{
		return get("copy");
	}
	
	public inline function setCopy(value:String):ImmuteRecordText
	{
		return set("copy", value );
	}
	

	
}