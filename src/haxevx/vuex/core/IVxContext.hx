package haxevx.vuex.core;

/**
 * Empty marker class atm
 * @author Glidias
 */
@:remove
interface IVxContext 
{
  function dispatch(type:String, payload:Dynamic=null):Void;
  function commit(type:String, payload:Dynamic = null):Void;
}

@:remove
interface IVxContext1<S> extends IVxContext
{
	var state:S;
}

@:remove
interface IVxContext2<S,G> extends IVxContext1<S>
{
	var getters:G;
}

@:remove
interface IVxContext3<S,G,RS>  extends IVxContext2<S,G>
{
	var rootState:RS;
}

@:remove
interface IVxContext4<S,G,RS,RG> extends IVxContext3<S,G,RS> {
	var rootGetters:RG;
}