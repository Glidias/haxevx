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
						state = ReflectUtil.getSingletonByClassName(name);
					default: throw "Could not resolve for state CType:" + typeParam.getName();
				}
			}
			else {
				 ReflectUtil.registerSingletonByClassName( Type.getClassName( Type.getClass(state)), state  );
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
		
		var getters:Dynamic = null;
		var mutators:Dynamic = null;
		var actions:Dynamic = null;
		var modules:Dynamic = null;
		
		// getters
		if ( storeInstanceFields.indexOf("getters") >=0 ) {
			if ( Reflect.field(this, "getters") == null) {
				if (storeRTTI == null) {
					throw "Failed to initialize store's getters! Need RTTI to dynamically instatiate getters!";
				}
				
				lookupMap.set("getters", true);
				RttiUtil.injectSingletonInstance(this, storeRTTI, lookupMap);		
				if (Reflect.field(this, "getters") == null) throw "Couldn't dynamically instantiate getters for unknown reason!";
			}
			getters = GetterFactory.setupGettersFromInstance( Reflect.field(this, "getters") );
			
		}
		
		if (storeRTTI != null) {
			RttiUtil.injectSingletonInstance(this, storeRTTI, RttiUtil.NO_FIELDS, metaMap);
			RttiUtil.injectSingletonInstance(storeClass, storeRTTI, RttiUtil.NO_FIELDS, staticMetaMap);
		}
		
		var storeStaticMetas:Dynamic<Dynamic<Array<Dynamic>>>  = ReflectUtil.getStaticMetaFieldsOfClass(storeClass);
		var storeInstanceMetas:Dynamic<Dynamic<Array<Dynamic>>>  = ReflectUtil.getMetaFieldsOfClass(storeClass);
		var m:Dynamic<Array<Dynamic>>;
		var insta:Dynamic;
		
		for (f in Reflect.fields(storeInstanceMetas)) {
			m = Reflect.field(storeInstanceMetas, f);
			if (Reflect.hasField(m, "getter")) {
				if (getters == null) getters = {};
				insta = Reflect.field(this, f);
				if (insta == null) {
					throw 'Field ${f} should not be undefined';
				}
				
				GetterFactory.setupGettersFromInstance( insta, getters, ReflectUtil.getNamespaceForClass(Type.getClass(insta) ) );
			}
			if (Reflect.hasField(m, "modules")) {
				if (modules == null) modules = {};
				insta = Reflect.field(this, f);
				if (insta == null) {
					throw 'Field ${f} should not be undefined';
				}
				// todo, setup module
				//Reflect.setField(modules, f, );
			}
		}
		
		for (f in Reflect.fields(storeStaticMetas)) {
			m = Reflect.field(storeStaticMetas, f);
			if (Reflect.hasField(m, "mutator")) {
				if (mutators == null) mutators = {};
				insta = Reflect.field(this, f);
				if (insta == null) {
					throw 'Static Field ${f} should not be undefined';
				}
				// todo, setup mutator
				
			}
			if (Reflect.hasField(m, "action")) {
				if (actions == null) actions = {};
				insta = Reflect.field(storeClass, f);
				if (insta == null) {
					throw 'Static Field ${f} should not be undefined';
				}
				// todo, setup action
			}
		}
		
		if (state == null) throw "Store state failed to initialized for unknown reason...";
		storeParams.state = state;
		
		if (mutators != null) {
			storeParams.mutations = mutators;
		}
		if (actions != null) {
			storeParams.actions = actions;
		}
		if (getters != null) {
			storeParams.getters = getters;
		}
		if (modules != null) {
			storeParams.modules = modules;
		}
		
		
		
		// plugins (todo)...should allow initilaization from outside as well...since plugins likely to be externalised, though you lose strict typing when externalised. Same with modules..??
		
		// strict
		storeParams.strict = strict;
		
		return storeParams;
	}
	
	
	
	
}