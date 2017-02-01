package haxevx.vuex.native;
import haxevx.vuex.core.IPayload;
import haxevx.vuex.native.Vue.WatchOptions;
import haxevx.vuex.native.Vuex.Module;

/**
 * Port of https://github.com/vuejs/vuex/tree/dev/types 
 * wip
 * @author Glidias
 */
#if !vue_global
@:jsRequire("vuex", "Store") 
#else
@:native("Vuex.Store") 
#end
extern class Store<S>
{
	public var getters(default, never):Dynamic;
	public var state(default, never):S;
	public function replaceState(state:S):Void;
	
	@:overload(function(payloadWithType:IPayload, ?options:DispatchOptions):Void {} )
	@:overload(function(payloadWithType:Payload, ?options:DispatchOptions):Void {} )
	public function dispatch(type:String, ?payload:Dynamic, ?options:DispatchOptions):Void;
	 
	@:overload(function(payloadWithType:IPayload, ?options:CommitOptions):Void {} )
	@:overload(function(payloadWithType:Payload, ?options:CommitOptions):Void {} )
	public function commit(type:String, ?payload:Dynamic, ?options:CommitOptions):Void;


	function subscribe<P:Payload,S,R>(fn:P->S->R):Void->Void;
	function watch<T, S>(getter:S->T, cb:T->T->Void, ?options:WatchOptions):Void;
	//  watch<T>(getter: (state: S) => T, cb: (value: T, oldValue: T) => void, options?: WatchOptions): void;


	@:overload(function<T>(path:Array<String>, module:Module<T,S>):Void {} )
	public function registerModule<T>(path:String, module:Module<T,S>):Void;
		

	@:overload(function<T>(path:Array<String>):Void {} )
	public function unregisterModule<T>(path:String):Void;
	

	public function hotUpdate(options: {
		?actions: ActionTree<S, S>,
		?mutations: MutationTree<S>,
		?getters: GetterTree<S, S>,
		?modules: ModuleTree<S>
	  }): Void;
 

	public function new(options:StoreOptions<S>) 
	{
		
	}
	
}

@:native("Vuex") extern class Vuex
{
	//export declare function install(Vue: typeof _Vue): void; //??
	
}


typedef Payload = {
	var type(default, never):String;
}

typedef  DispatchOptions= {
  @:optional var root: Bool;
}

typedef CommitOptions = {
  @:optional var silent: Bool;
  @:optional var root: Bool;
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

 interface ActionContext<S, R> {

 @:overload(function(payloadWithType:IPayload, ?options:CommitOptions):Void {} )
 @:overload(function(payloadWithType:Dynamic, ?options:CommitOptions):Void {} )
 function dispatch(type:String, ?payload:Dynamic, ?options:CommitOptions):Void;
 
  @:overload(function(payloadWithType:IPayload, ?options:CommitOptions):Void {} )
 @:overload(function(payloadWithType:Dynamic, ?options:CommitOptions):Void {} )
 function commit(type:String, ?payload:Dynamic, ?options:CommitOptions):Void;
 
 var state: S;
 var  getters: Dynamic;
 var rootState: R;
}



typedef Getter<S, R> = S->Dynamic->R->Dynamic;// (state: S, getters: any, rootState: R) => any;
typedef Action<S, R> = S->ActionContext<S,R>->Dynamic;  //export type Action<S, R> = (injectee: ActionContext<S, R>, payload: any) => any;
typedef Mutation<S> = S->Dynamic->Dynamic;
typedef Plugin<S> = Store<S>->Dynamic;

//export interface 
typedef Module<S, R> = {
	@:optional var state: S;
	@:optional var getters: GetterTree<S, R>;
	@:optional var actions: ActionTree<S, R>;
	@:optional var mutations: MutationTree<S>;
	@:optional var modules: ModuleTree<R>;
}


typedef GetterTree<S, R> = Dynamic<Getter<S,R>>;
typedef ActionTree<S, R> = Dynamic<Action<S,R>>;
typedef MutationTree<S> = Dynamic<Mutation<S>>;
typedef ModuleTree<R> = Dynamic<Module<Dynamic, R>>;



