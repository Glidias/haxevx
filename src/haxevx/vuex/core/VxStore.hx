package haxevx.vuex.core;
import haxe.Json;
import haxe.ds.StringMap;
import haxe.rtti.CType;
import haxe.rtti.CType.Classdef;
import haxe.rtti.Meta;
import haxe.rtti.Rtti;
import haxevx.vuex.core.NativeTypes.NativeGetters;
import haxevx.vuex.core.NativeTypes.NativeModule;
import haxevx.vuex.core.NativeTypes.NativeStore;
import haxevx.vuex.native.Vuex.GetterTree;
import haxevx.vuex.util.GetterFactory;
import haxevx.vuex.util.ReflectUtil;
import haxevx.vuex.util.RttiUtil;

/**
 *  Base generic class for Vuex Store instance helpers
 * @author Glidias
 */
@:rtti
class VxStore<T> implements IVxStoreContext<T>
{
	
	public var state:T;
	
	public function dispatch(type:String, payload:Dynamic=null):Void {}
	public function commit(type:String, payload:Dynamic = null):Void {}
	
	public var strict:Bool = false;
	
	public function _toNative():NativeStore<T> {
		
		var storeClass = Type.getClass(this);
		var storeInstanceFields = Type.getInstanceFields(storeClass);
		//getters = new G();
		
		var storeRTTI:Classdef = Rtti.hasRtti(storeClass) ? Rtti.getRtti(storeClass) : null;
	
		// dynamically instantiate getters/state if not already instantiated!
		if ( state == null) {
		
			if (storeRTTI == null) {
				throw "Failed to initialize store's state! Need RTTI to dynamically instatiate state!";
			}
	
			var typeIter =  storeRTTI.superClass.params.iterator();
			var typeParam:CType =typeIter.next();
			
			if (state == null) {
				switch(typeParam) {
					case CType.CClass(name, params):
						state = ReflectUtil.getNewInstanceByClassName(name);
					default: throw "Could not resolve for state CType:" + typeParam.getName();
				}
			}
		}
		
		var lookupMap:StringMap<Bool> = new StringMap<Bool>();
		var metaMap:StringMap<Bool> = new StringMap<Bool>();
		metaMap.set("getter", true);
		metaMap.set("module", true);
		var staticMetaMap:StringMap<Bool> = new StringMap<Bool>();
		staticMetaMap.set("mutator", true);
		staticMetaMap.set("action", true);
		
		var storeParams:NativeStore<T> = {};
		
		var getters:Dynamic = {};
		var mutators:Dynamic = {};
		var actions:Dynamic = {};
		var modules:Dynamic = {};
		
		if (state == null) throw "Store state failed to initialized for unknown reason...";
		storeParams.state = state;
		storeParams.mutations = mutators;
		storeParams.actions = actions;
		storeParams.getters = getters;
		storeParams.modules = modules;
		
		// getters
		if ( storeInstanceFields.indexOf("getters") >=0 ) {
			if ( Reflect.field(this, "getters") == null) {
				if (storeRTTI == null) {
					throw "Failed to initialize store's getters! Need RTTI to dynamically instatiate getters!";
				}
				
				lookupMap.set("getters", true);
				RttiUtil.injectNewInstance(this, storeRTTI, lookupMap);		
				if (Reflect.field(this, "getters") == null) throw "Couldn't dynamically instantiate getters for unknown reason!";
			}
			getters = GetterFactory.setupGettersFromInstance( Reflect.field(this, "getters") );
			
		}
		
		if (storeRTTI != null) {
			RttiUtil.injectNewInstance(this, storeRTTI, RttiUtil.NO_FIELDS, metaMap);
			RttiUtil.injectSingletonInstance(storeClass, storeRTTI, RttiUtil.NO_FIELDS, staticMetaMap);
		}
		
		var storeStaticMetas:Dynamic<Dynamic<Array<Dynamic>>>  = ReflectUtil.getStaticMetaFieldsOfClass(storeClass);
		var storeInstanceMetas:Dynamic<Dynamic<Array<Dynamic>>>  = ReflectUtil.getMetaFieldsOfClass(storeClass);
		var m:Dynamic<Array<Dynamic>>;
		var insta:Dynamic;
		
		for (f in Reflect.fields(storeStaticMetas)) {
			m = Reflect.field(storeStaticMetas, f);
			if (Reflect.hasField(m, "mutator")) {
				insta = Reflect.field(this, f);
				if (insta == null) {
					throw 'Field ${f} should not be undefined';
				}
				
				// todo:set up mutators via MutatorFactory
				
			}
			if (Reflect.hasField(m, "action")) {
				insta = Reflect.field(this, f);
				if (insta == null) {
					throw 'Field ${f} should not be undefined';
				}
				// todo:set up actions via ActionFactory
			}
		}
	
		for (f in Reflect.fields(storeInstanceMetas)) {
			m = Reflect.field(storeInstanceMetas, f);
			if (Reflect.hasField(m, "getter")) {
				insta = Reflect.field(this, f);
				if (insta == null) {
					throw 'Field ${f} should not be undefined';
				}
				GetterFactory.setupGettersFromInstance( insta, getters, ReflectUtil.getNamespaceForClass(Type.getClass(insta) ) );
			}
			if (Reflect.hasField(m, "modules")) {
				insta = Reflect.field(this, f);
				if (insta == null) {
					throw 'Field ${f} should not be undefined';
				}
				Reflect.setField(modules, f, getModuleTree(insta, f) );
			}
		}


		// plugins (todo)...should allow initilaization from outside as well...since plugins likely to be externalised, though you lose strict typing when externalised. Same with modules..??
		
		// strict
		storeParams.strict = strict;
		
		return storeParams;
	}
	
	function getModuleTree(moduleInstance:Dynamic, moduleNamespace:String):NativeModule<Dynamic, Dynamic> {
		
		// yea i know this is pretty similar to parsing of main Store.. bleh...ignoring DRY here..
		
		var rootModule:NativeModule<Dynamic, Dynamic> = {};

		var dynInsMap:StringMap<Bool> = new StringMap<Bool>();
		dynInsMap.set("getter", true);
		
		var dynStaticMap:StringMap<Bool> = new StringMap<Bool>();
		dynStaticMap.set("mutator", true);
		dynStaticMap.set("action", true);
		
		var moduleStack:Array<NativeModule<Dynamic,Dynamic>> = [];
		var moduleNameStack:Array<String> = moduleNamespace != "" ? [moduleNamespace] : [];
		moduleStack.push(rootModule);
		
		var insta:Dynamic;

	
		while (moduleStack.length > 0) {
			
			var curModule:NativeModule<Dynamic,Dynamic> = moduleStack.pop();
			var curModuleName:String=moduleNameStack.pop();
			
			var cls = Type.getClass(curModule);
			var fields:Dynamic<Array<Dynamic>>;
			
			var state = Reflect.field(curModule, "state");
			if ( state == null) {
			
				if (!Rtti.hasRtti(cls)) {
					throw "Failed to initialize store's state! Need RTTI to dynamically instatiate state!";
				}
		
				var moduleRTTI = Rtti.getRtti(cls);
				var typeIter =  moduleRTTI.superClass.params.iterator();
				var typeParam:CType =typeIter.next();
				
				if (state == null) {
					switch(typeParam) {
						case CType.CClass(name, params):
							state = ReflectUtil.getNewInstanceByClassName(name);
						default: throw "Could not resolve for state CType:" + typeParam.getName();
					}
				}
			}
		
			// Dynamically instantiate any required getters, mutators, and actions
			
			if ( ReflectUtil.requiresInjection(null, dynInsMap, curModule) ) {
				RttiUtil.injectNewInstance(curModule, Rtti.getRtti(cls), RttiUtil.NO_FIELDS, dynInsMap);
			}
			
			if ( ReflectUtil.requiresInjection(null, dynStaticMap, cls) ) {
				RttiUtil.injectSingletonInstance(cls, Rtti.getRtti(cls), RttiUtil.NO_FIELDS, dynStaticMap);
			}
			
		
			// retrieve mutator and action methods under classed namespace if haven't yet...
			fields =  ReflectUtil.getStaticMetaDataFieldsWithTag(cls, "mutator"); 
			if (fields != null) {
				curModule.mutations = {};
				for ( f  in Reflect.fields(fields) ) {
					insta = Reflect.field(fields, f);
					// todo:set up mutators via MutatorFactory
				}
			}
			
			fields =  ReflectUtil.getStaticMetaDataFieldsWithTag(cls, "action"); 
			if (fields != null) {
				curModule.actions = {};
				for ( f  in Reflect.fields(fields) ) {
					insta = Reflect.field(fields, f);
					// todo:set up mutators via ActionFactory
				}
			}
			
			// retrieve local getters under module namespace
			var newModuleNamespace =  moduleNameStack.concat([curModuleName]).join(ReflectUtil.MODULE_FRACTAL_SEP) + ReflectUtil.MODULES_SEPERATOR;
			curModule.getters = GetterFactory.setupGettersFromInstance(insta, null, newModuleNamespace);
			
			// retrieve getter mixins under module+classed namespace
			fields =  ReflectUtil.getMetaDataFieldsWithTag(cls, "getter"); 
			if (fields != null) {
				for ( f  in Reflect.fields(fields) ) {
					insta = Reflect.field(fields, f);
					GetterFactory.setupGettersFromInstance( insta, curModule.getters, newModuleNamespace +  ReflectUtil.getNamespaceForClass(Type.getClass(insta) ) );
				}
			}
		
			// additional modules to recurse into
			fields =  ReflectUtil.getMetaDataFieldsWithTag(cls, "module");
			if (fields != null) {
				curModule.modules = {};
				for ( f  in Reflect.fields(fields) ) {
					var newModule = {};
					Reflect.setField(curModule.modules, f, newModule);
					moduleStack.push(newModule);
				}
			}
		
			
			
		}
		
		
		
		
		return rootModule;
	}
	
	
}