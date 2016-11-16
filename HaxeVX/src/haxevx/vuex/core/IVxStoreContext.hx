package haxevx.vuex.core;

/**
 * Vuex store context. If under a different module, state often results in a different value.
 * @author Glidias
 */
interface IVxStoreContext<T> extends IVxContext
{
  var state:T;
  function dispatch(type:String, payload:Dynamic=null):Void;
  function commit(type:String, payload:Dynamic = null):Void;
}