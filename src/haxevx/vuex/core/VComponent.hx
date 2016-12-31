package haxevx.vuex.core;

import haxe.ds.StringMap;
import haxe.rtti.Rtti;
import haxevx.vuex.core.NativeTypes;
import haxevx.vuex.native.Vue.CreateElement;
import haxevx.vuex.native.Vue.VNode;
import haxevx.vuex.util.ActionFactory;
import haxevx.vuex.util.ReflectUtil;
import haxevx.vuex.util.RttiUtil;
/**
 * ...
 * @author Glidias
 */
@:autoBuild(haxevx.vuex.core.VxMacros.buildComponent())
class VComponent<D, P>
{
	#if !remove_props_accessor
	var props(get, null):P;
	inline function get_props():P 
	{
		return untyped this;
	}
	#end


	var data(get, null):D;
	inline function get_data():D 
	{
		return untyped __js__("this.$data");
	}
	
	/**
	 * Optionally override this to determine starting prop values for Unit Testing only!
	 * @return
	 */
	function GetPropsData():P {
		return null;
	}
	
	/**
	 * Optionally override this to determine starting data values
	 * @return
	 */
	function GetData():D {
		return null;
	}
	
	// override these lifecyle hook implementations if needed
	function Created():Void {}
	function BeforeCreate():Void {}
	function BeforeDestroy():Void {}
	function Destroy():Void {}
	function BeforeMount():Void {}
	function Mounted():Void {}
	function BeforeUpdate():Void {}
	function Updated():Void {}
	function Activated():Void {}
	function Deactivated():Void {}
	

	function El():Dynamic {  // String or HTMLElement
		return null;
	}
	
	// override this implementation to use a custom render method instead to render Virtual DOM
	function Render(c:CreateElement):VNode {
		return null;
	}
	// override this implementation to use a custom template string reference or markup
	function Template():String {
		return null;
	}
	
	// override this register components locally
	function Components():Dynamic<VComponent<Dynamic,Dynamic>>  {
		return null;
	}
	
	// internal method to convert VxComponent to native VueJS Component type or any native environment
    @:final public function _toNative():NativeComponent {
		// todo: create VUEJS component options from this component!	
		var comp:NativeComponent = {};
		var componentsToAdd:Dynamic<VComponent<Dynamic,Dynamic>> = null;
		var nativeChildComponents:Dynamic = {};
		
		var cls:Class<Dynamic> = Type.getClass(this);
		var hasRtti:Bool = Rtti.hasRtti(cls);
		var useRtti:Bool = hasRtti;
		//useRtti = false;  // TODO: non-rtti checking not working
		var baseClass:Class<Dynamic> =VComponent;

		
		var fields:Array<String> = useRtti ? RttiUtil.getInstanceFieldsUnderClass(cls) : Type.getInstanceFields(cls); // Type.getInstanceFields(Type.getClass(this));
		for (f in fields) {
			switch(f) {
				case "Created": if (useRtti || ReflectUtil.getPrototypeField(cls, "Created") != ReflectUtil.getPrototypeField(baseClass, "Created")) comp.created = ReflectUtil.getPrototypeField(cls, "Created");
				case "BeforeCreate": if (useRtti || ReflectUtil.getPrototypeField(cls, "BeforeCreate") != ReflectUtil.getPrototypeField(baseClass, "BeforeCreate")) comp.beforeCreate = ReflectUtil.getPrototypeField(cls, "BeforeCreate");
				case "BeforeDestroy": if (useRtti || ReflectUtil.getPrototypeField(cls, "BeforeDestroy") != ReflectUtil.getPrototypeField(baseClass, "BeforeDestroy")) comp.beforeDestroy = ReflectUtil.getPrototypeField(cls, "BeforeDestroy");
				case "Destroy": if (useRtti || ReflectUtil.getPrototypeField(cls, "Destroy") != ReflectUtil.getPrototypeField(baseClass, "Destroy")) comp.destroy = ReflectUtil.getPrototypeField(cls, "Destroy");
				case "BeforeMount":if (useRtti || ReflectUtil.getPrototypeField(cls, "BeforeMount") != ReflectUtil.getPrototypeField(baseClass, "BeforeMount"))  comp.beforeMount =  ReflectUtil.getPrototypeField(cls, "BeforeMount");
				case "Mounted": if (useRtti || ReflectUtil.getPrototypeField(cls, "Mounted") != ReflectUtil.getPrototypeField(baseClass, "Mounted")) comp.mounted = ReflectUtil.getPrototypeField(cls, "Mounted");
				case "BeforeUpdate": if (useRtti || ReflectUtil.getPrototypeField(cls, "BeforeUpdate") != ReflectUtil.getPrototypeField(baseClass, "BeforeUpdate")) comp.beforeUpdate = ReflectUtil.getPrototypeField(cls, "BeforeUpdate");
				case "Updated": if (useRtti || ReflectUtil.getPrototypeField(cls, "Updated") != ReflectUtil.getPrototypeField(baseClass, "Updated")) comp.updated = ReflectUtil.getPrototypeField(cls, "Updated");
				case "Activated": if (useRtti || ReflectUtil.getPrototypeField(cls, "Activated") != ReflectUtil.getPrototypeField(baseClass, "Activated")) comp.activated =  ReflectUtil.getPrototypeField(cls, "Activated");
				case "Deactivated": if (useRtti || ReflectUtil.getPrototypeField(cls, "Deactivated") != ReflectUtil.getPrototypeField(baseClass, "Deactivated")) comp.deactivated =  ReflectUtil.getPrototypeField(cls, "Deactivated") ;
				case "GetPropsData": if (useRtti || ReflectUtil.getPrototypeField(cls, "GetPropsData") != ReflectUtil.getPrototypeField(baseClass, "GetPropsData")) comp.propsData = GetPropsData();  //ReflectUtil.getPrototypeField(cls, "GetPropsData")
				
				case "GetData": if (useRtti || ReflectUtil.getPrototypeField(cls, "GetData") != ReflectUtil.getPrototypeField(baseClass, "GetData")) comp.data =  ReflectUtil.getPrototypeField(cls, "GetData");
				
				case "Render": if (useRtti || ReflectUtil.getPrototypeField(cls, "Render") != ReflectUtil.getPrototypeField(baseClass, "Render")) comp.render = ReflectUtil.getPrototypeField(cls, "Render");
				case "Template": if (useRtti || ReflectUtil.getPrototypeField(cls, "Template") != ReflectUtil.getPrototypeField(baseClass, "Template")) comp.template = Template();
				case "El": if (useRtti || ReflectUtil.getPrototypeField(cls, "El") != ReflectUtil.getPrototypeField(baseClass, "El")) comp.el = El();
			case "Components": 
				if (useRtti || ReflectUtil.getPrototypeField(cls, "Components") != ReflectUtil.getPrototypeField(baseClass, "Components")) {
					componentsToAdd = Components();
					comp.components=nativeChildComponents;
				}
				default:
					if (useRtti || ReflectUtil.getPrototypeField(cls, f) != ReflectUtil.getPrototypeField(baseClass, f) ) {
						if (Reflect.isFunction( Reflect.field(this, f)) && f != "get_store" ) {
							if (comp.methods == null) comp.methods = {};
							Reflect.setField(comp.methods, f, Reflect.field(this, f));
						}
					}
			}
		}
		
		if (ReflectUtil.requiresInjection(null, META_INJECTIONS, cls)) {
			RttiUtil.injectFoundSingletonInstances(cls, Rtti.getRtti(cls), null, META_INJECTIONS);
		}
		
		var cFields:Dynamic<Array<Dynamic>>;
		var t;
		var mInfo:Array<Dynamic>;
		
		cFields = ReflectUtil.getMetaDataFieldsWithTag(cls, "_computed");
		for ( f in Reflect.fields(cFields)) {
			
			t=  Reflect.field(this, "get_" + f);
			if (t == null || !Reflect.isFunction(t) ) throw "Invalid get_" + f;
			if (comp.computed == null) comp.computed = {}; 
			Reflect.setField(comp.computed, f,t );
		}
		
		cFields = ReflectUtil.getMetaDataFieldsWithTag(cls, "_prop");

		//if (comp.props == null) {
		comp.props = {}; 
		for ( f in Reflect.fields(cFields)) {
		
			var propMetaInfo:Dynamic = Reflect.field(cFields, f);
			//trace(f + " : " + cFields);
			if (propMetaInfo != null ) {
				
				if (Std.is(propMetaInfo, Array) ) {
					if ( propMetaInfo.length > 0 ) {
						propMetaInfo = _reflectPropsMetadataToNative(propMetaInfo, f, cls);
						//trace(f);
						//trace( propMetaInfo);
					}
					else  {
						propMetaInfo = {};
					}
					
				}
				else {
					throw "Prop meta-info isn't array!!";
				}
			}
			else {
				trace("No property params found:"+propMetaInfo);
				propMetaInfo = {};
			
			}
			Reflect.setField(comp.props, f, propMetaInfo );
		}

		
		//comp.watch = {};  // todo phase1...will strip away watchs function and supply into _getWatches()
		//comp.filters = {}  // likely to simply overwrite a Filters() hoook
		//comp.transitions = {}	// todo phase2     // 
		//comp.mixins;	// use macros instead for mixing in?
		
		// consider todo: lazy recursive function approach for now. Should handle iteratively for better performance.
		if (componentsToAdd != null) {
			for (f in Reflect.fields(componentsToAdd)) {
				var c:VComponent<Dynamic,Dynamic> = Reflect.field(componentsToAdd, f);
				Reflect.setField(nativeChildComponents, f, c._toNative() );
				
			}
		}
		
		return comp;
	}
	

	
	static function _reflectPropsMetadataToNative(props:Array<Dynamic>, propName:String, cls:Class<Dynamic>):Dynamic {

		var newProps:Dynamic = {};
		var referProps:Dynamic = props[0];
		if (referProps != null) {
			
			for (p in Reflect.fields(referProps)) {
				Reflect.setField(newProps, p, Reflect.field(referProps, p));
			}
		}
		
		if ( newProps.type != null) {
			newProps.type = ReflectUtil.strToNativeType(newProps.type);
		}
		if (props.length > 1 && props[1]) {
			var funcLookup:Dynamic =  ReflectUtil.getPrototypeField(cls, "get_" + propName);
			if (funcLookup == null) throw "Could not find function hander macro get for: " + propName;
			Reflect.setField(newProps, "default", funcLookup);
		}
		
		
		return newProps;
	}
	
	
	static var META_INJECTIONS:StringMap<Bool> = {
		var strMap = new StringMap<Bool>();
		strMap.set("mutator", true);
		strMap.set("action", true);
		strMap.set("getter", true);
		return strMap;
	}
	
	
	
	
	
	// internally unsupported  (bleh...but seldom used..)
	/*
	@:optional var parent: Vue;
	@:optional var mixins:Dynamic; // ComponentOptions; // mixins?: (ComponentOptions<Vue> | typeof Vue)[];
	@:optional var name:String;		// default impl?
	//@:optional var extends:Dynamic;// ComponentOptions<Vue> | typeof Vue; // TODO: urm can we alias this?? extends reserved Haxe keyword BAH!!
	@:optional var delimiters: Array<String>;
	*/
	
	

	
}