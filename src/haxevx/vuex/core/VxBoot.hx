package haxevx.vuex.core;
import haxevx.vuex.core.NativeTypes;
import haxevx.vuex.native.Vue;
import haxevx.vuex.native.Vuex.Payload;
import haxevx.vuex.native.Vuex.Store;

/**
 * Standard Boot utility to initialize Haxe codebase to convert it to native VueJS/Vuex App!
 * @author Glidias
 */
class VxBoot
{
	public function new() {
		
	}
	// saved parameter cache
	 var STORE:Store<Dynamic>;
	//public static var VUE:VComponent<Dynamic,Dynamic>;
	
	 public static inline function registerModuleWithStore(name:String, mod:Dynamic, store:Store<Dynamic>):Void {
		mod._Init(name+"/");
		untyped store[name] = mod; // Reflect.setField(store, name, mod);
		store.registerModule(name, mod);
		clearModuleInjStack(store);
		
	 }
	
	
	public function startStore<T>(storeParams:Dynamic):Store<Dynamic>  {
		if (STORE != null) {
			throw "Vuex store already started! Only 1 store is allowed";
		}
		
		var metaFields:Dynamic<Array<Dynamic>>;
		var md:Dynamic;
		var noNamespaceGetterProps:Dynamic;
		// use Vuex
		//Vue.use(Vuex);
	

		var store = new Store(storeParams);
		
		// below will depeeciate
				
		//if ( storeParams.getters!= null) {
			// define get_ utility functions under store.getters ( for non-namespced
			
			var o:Dynamic;
			// define get_utility functions under store.customGetters to store.getters namespaced
			//Reflect.field(opts.storeParams.getters
			var storeGetters:Dynamic = store.getters;
			//GetterFactory.hookupGettersFromPropsOver(storeParams.getters, storeGetters);
			var stack = ModuleStack.stack;
			var i:Int = stack.length;
			while (--i > -1) {
				stack[i]._InjNative(storeGetters);
			
			}
			stack = [];
				
			// below should be depcirated, ie. avoid recursion into tree 
			
			if (storeParams.modules != null) {  // todo: modules and fractal depth first traversal
				//var moduleNameStack:Array<String> = [];
				
				for (p in Reflect.fields((o = storeParams.modules))) {
					//moduleNameStack.push(p);
					
					var m:NativeModule<Dynamic,Dynamic> = Reflect.field(o, p);
					md = untyped storeParams[p];// Reflect.field(storeParams, p); //VModule<Dynamic>
					untyped store[p] = md;

					//if (m.getters != null) {
										
					//	noNamespaceGetterProps = GetterFactory.setupGettersFromInstance(md);
						
						//untyped md._stg = storeGetters;
					//	md._InjNative(storeGetters);

					//}
			
					//moduleNameStack.pop();
					
				}
			}
			
		//}

		STORE = store;
		return store;
	}
	
	
	 static function clearModuleInjStack(store:Store<Dynamic>):Void {
		 var storeGetters = store.getters;
		var stack = ModuleStack.stack;
		var i:Int = stack.length;
		while (--i > -1) {
			stack[i]._InjNative(storeGetters);
		
		}
		ModuleStack.stack = [];
	}
	
	public function startVueWithRootComponent<T>(el:String, rootComponent:VComponent<Dynamic, Dynamic>):Vue {
		var bootVueParams:Dynamic = {};
		bootVueParams.el = el;
		if (STORE != null) {
			Reflect.setField(bootVueParams, "store", STORE);
		}

		bootVueParams.render = getRenderComponentMethod(rootComponent);
		var vm =  new Vue(bootVueParams);
		notifyStarted();
		return vm;
	}
	
	public static function notifyStarted():Void {
		#if  !(production || skip_singleton_check )
			haxevx.vuex.core.Singletons.clearLookups( );
		#end
	}
	
	public  static function getRenderComponentMethod(nativeComp:Dynamic):CreateElement->VNode {
		return function(h:CreateElement):VNode {
			return h(nativeComp,null,null);
		}
	}

}



class ModuleStack {
	public static var stack:Array<Dynamic> = [];
}
