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
	public static var STORE:VxStore<Dynamic>;
	public static var VUE:VComponent<Dynamic,Dynamic>;

	public static function startParams<T>(rootVue:VComponent<Dynamic, Dynamic>, store:VxStore<Dynamic> = null, otherComponents:Dynamic<VComponent<Dynamic,Dynamic>> = null):VxBootParams<T> {
		VUE = rootVue;
		STORE = store;
		var storeParams = null;
		if (store != null) {
			storeParams = store._toNative();
			
		}
		if (otherComponents!= null) registerGlobalHxComponents(otherComponents);
		
		var rootVueOptions =  rootVue._toNative();
		return {storeParams:storeParams, vueParams:rootVueOptions};
	}
	
	public static function start<T>(rootVue:VComponent<Dynamic, Dynamic>, store:VxStore<Dynamic> = null, otherComponents:Dynamic<VComponent<Dynamic,Dynamic>> = null):Vue {
		var nativeStore:Store<Dynamic> = null;
		var opts:VxBootParams<T> = startParams(rootVue, store);
		if (opts.storeParams != null) {
			nativeStore = startStore(opts);
		}	
		return startVue(opts, nativeStore);
	}
	
	public static function startStore<T>(opts:VxBootParams<T>):Store<Dynamic>  {
		var metaFields:Dynamic<Array<Dynamic>>;
		var md:Dynamic;
		var noNamespaceGetterProps:Dynamic;
		// use Vuex
		//Vue.use(Vuex);
		
		var store = new Store(opts.storeParams);
	
		if ( opts.storeParams.getters!= null) {
			// define get_ utility functions under store.getters ( for non-namespced
			
			var o:Dynamic;
			// define get_utility functions under store.customGetters to store.getters namespaced
			//Reflect.field(opts.storeParams.getters
			var storeGetters:Dynamic = store.getters;
			GetterFactory.hookupGettersFromPropsOver(opts.storeParams.getters, storeGetters);
			
			// find the fields with @getters under STORE and treat them as namespaced mixins
			// for each getter field instance
			metaFields = ReflectUtil.getMetaDataFieldsWithTag(Type.getClass(STORE), "getter");
			if (metaFields != null) {
				for (p in Reflect.fields(metaFields)) {
					md = Reflect.field(STORE, p);
					noNamespaceGetterProps = GetterFactory.setupGettersFromInstance(md);
					GetterFactory.hookupGettersFromPropsOver2(noNamespaceGetterProps, md, storeGetters);
				}
			}
			
				
			if (opts.storeParams.modules != null) {  // todo: modules and fractal depth first traversal
				var moduleNameStack:Array<String> = [];
				
				for (p in Reflect.fields((o = opts.storeParams.modules))) {
					moduleNameStack.push(p);
					
					var m:NativeModule<Dynamic,Dynamic> = Reflect.field(o, p);
					md = Reflect.field(STORE, p); //VModule<Dynamic>
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
		
		return store;
	}
	
	public static function startVue<T>(opts:VxBootParams<T>, store:Store<Dynamic>):Vue {
		var bootVueParams:Dynamic = {};
		bootVueParams.el = "#app";
		
		var vueParams = opts.vueParams;
		if (opts.storeParams != null && store == null) {
			//throw "ERROR! Store params found but no store provided!";
			store = startStore(opts);
			
		}
		if (store != null) {
			
			Reflect.setField(bootVueParams, "store", store);
			
		}

		bootVueParams.render = getRenderComponentMethod(vueParams);
		var vm =  new Vue(bootVueParams);
		
		return vm;
	}
	
	public static function getRenderComponentMethod(nativeComp:Dynamic):CreateElement->VNode {
		return function(h:CreateElement):VNode {
			return h(nativeComp,null,null);
		}
	}
	
	
	public static function registerGlobalHxComponents( otherComponents:Dynamic<VComponent<Dynamic,Dynamic>>):Void {
		for (i in Reflect.fields( otherComponents) ) {
			var comp:VComponent<Dynamic, Dynamic> = cast(Reflect.field( otherComponents, i));
			var compParams =  comp._toNative();
			Vue.component( i, compParams);
		}
	}
	
}

typedef VxBootParams<T> = {
	var storeParams:NativeStore<T>;
	var vueParams:NativeComponent;
}