package haxevx.vuex.core;
import haxevx.vuex.native.CommitOptions;
import haxevx.vuex.native.DispatchOptions;
import js.Promise;

/**
 *  Base generic class for Vuex Store instance helpers
 * @author Glidias
 */

class VxStore<S> implements IVxStoreContext<S>
{
	

	public var strict:Bool = false;
	
	
	/* INTERFACE haxevx.vuex.core.IVxStoreContext.IVxStoreContext<S> */
	
	public var state:S;
	
	@:final public function dispatch<T>(type:String, ?payload:Dynamic, ?opts:DispatchOptions):Promise<T>
	{
		return null;
	}
	
	@:final  public function commit(type:String, ?payload:Dynamic, ?opts:CommitOptions):Void 
	{
		
	}
	
	
	
	
}