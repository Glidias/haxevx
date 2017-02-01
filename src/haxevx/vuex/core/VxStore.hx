package haxevx.vuex.core;
import haxevx.vuex.native.Vuex.CommitOptions;
import haxevx.vuex.native.Vuex.DispatchOptions;

/**
 *  Base generic class for Vuex Store instance helpers
 * @author Glidias
 */

class VxStore<S> implements IVxStoreContext<S>
{
	

	public var strict:Bool = false;
	
	
	/* INTERFACE haxevx.vuex.core.IVxStoreContext.IVxStoreContext<S> */
	
	public var state:S;
	
	@:final public function dispatch(type:String, ?payload:Dynamic, ?opts:DispatchOptions):Void 
	{
		
	}
	
	@:final  public function commit(type:String, ?payload:Dynamic, ?opts:CommitOptions):Void 
	{
		
	}
	
	
	
	
}