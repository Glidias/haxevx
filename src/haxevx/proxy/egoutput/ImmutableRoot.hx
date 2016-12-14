package haxevx.proxy.egoutput;

/**
 * A root state atom tree implementation that can allow setting of properties either on it, or deep nested properties within it.
 * @author Glidias
 */
interface ImmutableRoot 
{
	public function setIn(path:Array<String>, value:Dynamic):Void;
	
	// standard collection get/set dynamic
	public function set(prop:String, value:Dynamic):Void;
	public function get(prop:String):Dynamic;
}