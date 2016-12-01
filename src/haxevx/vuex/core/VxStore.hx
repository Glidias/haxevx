package haxevx.vuex.core;
import haxevx.vuex.core.NativeTypes.NativeStore;

/**
 *  Base generic class for Vuex Store instance helpers
 * @author Glidias
 */
class VxStore<T,G> implements IVxStoreContext<T>
{
	
	public var state:T;
	
	public function dispatch(type:String, payload:Dynamic=null):Void {}
	public function commit(type:String, payload:Dynamic = null):Void {}
	
	public var strict:Bool = false;
	
	var gettersProxy:G;
	@getter public var getters(get, null):G;
	inline function get_getters():G 
	{
		return gettersProxy;
	}

	
	public function _toNative():NativeStore<T> {
		return null;
		// todo, convert to native VueX Store
	}
	
	public function _toNativeModule():Dynamic {
		return null;
		// todo, convert to native VueX module
	}
	
	
	
}