package haxevx.proxy.egoutput;

/**
 This interface must be implemented by classes (properties usually left blank), if it's POSSBILE
 for their references to be accessed as a nested reference under a given root state atom tree.
 *
 * @author Glidias
 */
interface ImmutableSetIn 
{
	public var _root_:ImmutableRoot;	// the current root state atom holder reference (if any)
	public var _path_:Array<String>;	// the current path to set from the root state atom
	
	// standard collection get/set dynamic
	public function set(prop:String, value:Dynamic):Void;
	public function get(prop:String):Dynamic;
}