package haxevx.vuex.native;

/**
 * Port of https://github.com/vuejs/vuex/tree/dev/types 
 * wip
 * @author Glidias
 */
@:native("Vuex.Store") extern class Store<S>
{
	public var getters:Dynamic;

	public function new(options:StoreOptions<S>) 
	{
		
	}
	
}


@:native("Vuex") extern class Vuex
{

	
}


typedef StoreOptions<S> = {
	@:optional var state: S;
  @:optional var getters: GetterTree<S, S>;
   @:optional var actions: ActionTree<S, S>;
   @:optional var mutations: MutationTree<S>;
  @:optional var  modules: ModuleTree<S>; //todo
   @:optional var plugins: Array<Plugin<S>>; //todo
	@:optional var strict:Bool;
}


typedef ActionContext = Dynamic;
/*
 interface ActionContext<S, R> {
  var dispatch: Dispatch;
  var commit: Commit;
  var state: S;
 var  getters: Dynamic;
 var rootState: R;
}
*/

//export interface 
typedef Module<S, R> = {
	@:optional var state: S;
	@:optional var getters: GetterTree<S, R>;
	@:optional var actions: ActionTree<S, R>;
	@:optional var mutations: MutationTree<S>;
	@:optional var modules: ModuleTree<R>;
}


typedef Getter<S, R> = S->Dynamic->R->Dynamic;// (state: S, getters: any, rootState: R) => any;
typedef Action<S, R> = S->ActionContext->Dynamic;  //export type Action<S, R> = (injectee: ActionContext<S, R>, payload: any) => any;
typedef Mutation<S> = S->Dynamic->Dynamic;
typedef Plugin<S> = Store<S>->Dynamic;

typedef GetterTree<S, R> = Dynamic<Getter<S,R>>;
typedef ActionTree<S, R> = Dynamic<Action<S,R>>;
typedef MutationTree<S> = Dynamic<Mutation<S>>;
typedef ModuleTree<R> = Dynamic<Module<Dynamic, R>>;



