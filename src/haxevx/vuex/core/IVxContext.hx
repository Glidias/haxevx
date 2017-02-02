package haxevx.vuex.core;
import haxevx.vuex.native.CommitOptions;
import haxevx.vuex.native.DispatchOptions;
import js.Promise;

/**
 * Empty marker class atm
 * @author Glidias
 */
@:remove
interface IVxContext 
{
  function dispatch<T>(type:String, ?payload:Dynamic, ?opts:DispatchOptions):Promise<T>;
  function commit(type:String, ?payload:Dynamic, ?opts:CommitOptions):Void;
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