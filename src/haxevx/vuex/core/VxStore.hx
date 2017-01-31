package haxevx.vuex.core;

/**
 *  Base generic class for Vuex Store instance helpers
 * @author Glidias
 */

class VxStore<T> implements IVxStoreContext<T>
{
	
	public var state:T;
	
	public function dispatch(type:String, payload:Dynamic=null):Void {}
	public function commit(type:String, payload:Dynamic = null):Void {}
	
	public var strict:Bool = false;
	
	
	
	
}