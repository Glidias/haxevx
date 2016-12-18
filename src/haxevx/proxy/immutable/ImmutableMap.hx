package haxevx.proxy.immutable;

/**
 * ...
 * @author Glidias
 */
@:native("Immutable.Map") extern class  ImmutableMap<T>
{
	inline public function new(params:T) {
		
		
	}
	
	public function get(prop:String):Dynamic;
	public function set(prop:String, value:Dynamic):Dynamic;// ImmutableRecord<T>;
	
}