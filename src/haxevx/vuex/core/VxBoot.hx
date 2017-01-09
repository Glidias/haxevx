package haxevx.vuex.core;
import haxe.rtti.Rtti;
import haxevx.vuex.core.NativeTypes;
import haxevx.vuex.native.Vue;
import haxevx.vuex.native.Vuex;
import haxevx.vuex.util.ActionFactory;
import haxevx.vuex.util.MutatorFactory;
import haxevx.vuex.util.RttiUtil;

import haxevx.vuex.native.Vuex.Store;
import haxevx.vuex.util.GetterFactory;
import haxevx.vuex.util.ReflectUtil;


/**
 * Standard Boot utility to initialize Haxe codebase to convert it to native VueJS/Vuex App!
 * @author Glidias
 */
class VxBoot
{
	// saved parameter cache
	 static var STORE:Store<Dynamic>;
	//public static var VUE:VComponent<Dynamic,Dynamic>;


	
	public static function startStore<T>(storeInstance:VxStore<Dynamic>):Store<Dynamic>  {
		if (STORE != null) {
			throw "Vuex store already started! Only 1 store is allowed";
		}
		
		
		var storeParams = storeInstance._toNative();
		
		
		
		var metaFields:Dynamic<Array<Dynamic>>;
		var md:Dynamic;
		var noNamespaceGetterProps:Dynamic;
		// use Vuex
		//Vue.use(Vuex);
		
		var store = new Store(storeParams);
	
		if ( storeParams.getters!= null) {
			// define get_ utility functions under store.getters ( for non-namespced
			
			var o:Dynamic;
			// define get_utility functions under store.customGetters to store.getters namespaced
			//Reflect.field(opts.storeParams.getters
			var storeGetters:Dynamic = store.getters;
			GetterFactory.hookupGettersFromPropsOver(storeParams.getters, storeGetters);
			
			// find the fields with @getters under STORE and treat them as namespaced mixins
			// for each getter field instance
			metaFields = ReflectUtil.getMetaDataFieldsWithTag(Type.getClass(storeInstance), "getter");
			if (metaFields != null) {
				for (p in Reflect.fields(metaFields)) {
					md = Reflect.field(storeInstance, p);
					noNamespaceGetterProps = GetterFactory.setupGettersFromInstance(md);
					GetterFactory.hookupGettersFromPropsOver2(noNamespaceGetterProps, md, storeGetters);
				}
			}
			
				
			if (storeParams.modules != null) {  // todo: modules and fractal depth first traversal
				var moduleNameStack:Array<String> = [];
				
				for (p in Reflect.fields((o = storeParams.modules))) {
					moduleNameStack.push(p);
					
					var m:NativeModule<Dynamic,Dynamic> = Reflect.field(o, p);
					md = Reflect.field(storeInstance, p); //VModule<Dynamic>
						ReflectUtil.setHiddenField(store,  p,  md );
				
						/*  // why i included this;.. i dunno.
						if ( Reflect.field(md, "state") == null ) {
							trace("Setting state on native module:"+p);
							Reflect.setField(md, "state", opts.storeParams.state);
						
						}	
						*/
						
					if (m.getters != null) {
										
						noNamespaceGetterProps = GetterFactory.setupGettersFromInstance(md);
						GetterFactory.hookupGettersFromPropsOver2(noNamespaceGetterProps, md, storeGetters, moduleNameStack.join(ReflectUtil.MODULE_FRACTAL_SEP) + ReflectUtil.MODULES_SEPERATOR);
						

					}
					if (m.mutations != null) {
						
						
					}
					if (m.actions != null) {
						
					}
					if (m.modules != null) {
						// push to iterative stack..lol
					}					
					moduleNameStack.pop();
					
				}
			}
			
		}
		
		var sg:Dynamic;
		
		// finalise singleton initializations from Mutators and Actions accordingly, and re-rout their methods
		
		for (c in  MutatorFactory.getClasses()) {
			// check that all mutator singletons in factory  can be found
			sg = ReflectUtil.findSingletonByClassName(Type.getClassName(c));
			if (sg == null) throw "Fatal exception occured could not find mutator singleton by class name:" + Type.getClassName(c);
			
			MutatorFactory.finaliseClass(c, store);
			
		}
		
		for (c in  ActionFactory.getClasses()) {
			// check that all action signletons in factory can be found
			sg = ReflectUtil.findSingletonByClassName(Type.getClassName(c));
			if (sg == null) throw "Fatal exception occured could not find action singleton by class name:" + Type.getClassName(c);
			
			// inject mutators into action singletons 
			if (ReflectUtil.requiresInjection(null, ActionFactory.get_META_INJECTIONS(), c)) {
			
				RttiUtil.injectFoundSingletonInstances(c, Rtti.getRtti(c), null, ActionFactory.get_META_INJECTIONS());
			}
			
			ActionFactory.finaliseClass(c, store);
		}
		
		STORE = store;
		return store;
	}
	
	public static function startVueWithRootComponent<T>(el:String, rootComponent:VComponent<Dynamic, Dynamic>):Vue {
		var bootVueParams:Dynamic = {};
		bootVueParams.el = el;
		if (STORE != null) {
			Reflect.setField(bootVueParams, "store", STORE);
		}

		bootVueParams.render = getRenderComponentMethod(rootComponent);
		var vm =  new Vue(bootVueParams);
		
		return vm;
	}
	
	static function getRenderComponentMethod(nativeComp:Dynamic):CreateElement->VNode {
		return function(h:CreateElement):VNode {
			return h(nativeComp,null,null);
		}
	}
	
	
	public static function registerGlobalHxComponents( otherComponents:Dynamic):Void {  // originally otherComponents:Dynamic<VComponent<Dynamic,Dynamic>>
		for (i in Reflect.fields( otherComponents) ) {
			var comp:VComponent<Dynamic, Dynamic> = cast(Reflect.field( otherComponents, i));
			var compParams =  comp;
			Vue.component( i, compParams);
		}
	}
	
}

/*
typedef VxBootParams<T> = {
	var storeParams:NativeStore<T>;
	var vueParams:Dynamic;
}
*/