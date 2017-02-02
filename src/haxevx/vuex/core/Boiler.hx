package haxevx.vuex.core;
import haxevx.vuex.native.CommitOptions;
import haxevx.vuex.native.DispatchOptions;
import js.Promise;

/**
 * A central boilerplate macro-inliner class to handle standard commit/dispatch routines.
 * May be  temporary. To be decpreciated when figure out a way to fully optimize the macro-generated calls 
 * to be purely macro-based with minimal code duplication.
 * @author Glidias
 */
class Boiler {
	
	/**
	 * Commit with asserted no return type
	 */
	public static inline function commit(context:IVxContext, type:String, ?payload:Dynamic, ?opts:CommitOptions, useNamespacing:Bool=false, ns:String=""):Void {
		if (useNamespacing) {
			context.commit(ns+type, payload, opts);
		}
		else {
			context.commit(type, payload, opts);
		}
	}

	/**
	 * Dispatch with asserted no return type
	 */
	public static inline function dispatch(context:IVxContext, type:String, ?payload:Dynamic, ?opts:DispatchOptions, useNamespacing:Bool=false, ns:String=""):Void {
		if (useNamespacing) {
			context.dispatch(ns+type, payload, opts);
		}
		else {
			context.dispatch(type, payload, opts);
		}
	}
	
	/**
	 * Dispatch with enforced return Promise return type
	 */
	public static inline function dispatch2<T>(context:IVxContext, type:String, ?payload:Dynamic, ?opts:DispatchOptions, useNamespacing:Bool=false, ns:String=""):Promise<T> {
		if (useNamespacing) {
			return context.dispatch(ns+type, payload, opts);
		}
		else {
			return context.dispatch(type, payload, opts);
		}
	}

}