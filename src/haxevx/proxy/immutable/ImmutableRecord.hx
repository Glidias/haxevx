package haxevx.proxy.immutable;

/**
 * This wont't work unless can dynamically generate link to dynamically generated Immutable.Record({DATA-TYPE}) externs, bleh..
 * @author Glidias
 */
@:native("Immutable.Record") extern class  ImmutableRecord<T>
{
	inline public function new(params:T) {
		
		
	}
	
	public function get(prop:String):Dynamic;
	public function set(prop:String, value:Dynamic):Dynamic;// ImmutableRecord<T>;
	
}