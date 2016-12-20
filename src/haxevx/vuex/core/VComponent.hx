package haxevx.vuex.core;

import haxe.rtti.Rtti;
import haxevx.vuex.core.NativeTypes;
import haxevx.vuex.native.Vue.CreateElement;
import haxevx.vuex.native.Vue.VNode;
import haxevx.vuex.util.ReflectUtil;
import haxevx.vuex.util.RttiUtil;
/**
 * ...
 * @author Glidias
 */
class VComponent<D, P>
{
	var props(get, null):P;
	inline function get_props():P 
	{
		return untyped this;
	}

	var data(get, null):D;
	inline function get_data():D 
	{
		return untyped __js__("this.$data");
	}
	
	/**
	 * Optionally override this to reflect data types through field values and field metadata without having to rely on RTTI
	 * @return
	 */
	function GetProps():P {
		return null;
	}

	/**
	 * Optionally override this to determine starting prop values
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
		var useRtti:Bool = Rtti.hasRtti(cls);  
		//useRtti = false;  // TODO: non-rtti checking not working
		var baseClass:Class<Dynamic> =VComponent;


		var fields:Array<String> = useRtti ? RttiUtil.getInstanceFieldsUnderClass(cls) : Type.getInstanceFields(cls); // Type.getInstanceFields(Type.getClass(this));
		for (f in fields) {
			switch(f) {
				case "Created": if (useRtti || Created != ReflectUtil.getPrototypeField(baseClass, "Created")) comp.created = Created;
				case "BeforeCreate": if (useRtti || BeforeCreate != ReflectUtil.getPrototypeField(baseClass, "BeforeCreate")) comp.beforeCreate = BeforeCreate;
				case "BeforeDestroy": if (useRtti || BeforeDestroy != ReflectUtil.getPrototypeField(baseClass, "BeforeDestroy")) comp.beforeDestroy = BeforeDestroy;
				case "Destroy": if (useRtti || Destroy != ReflectUtil.getPrototypeField(baseClass, "Destroy")) comp.destroy = Destroy;
				case "BeforeMount":if (useRtti || BeforeMount != ReflectUtil.getPrototypeField(baseClass, "BeforeMount"))  comp.beforeMount = BeforeMount;
				case "Mounted": if (useRtti || Mounted != ReflectUtil.getPrototypeField(baseClass, "Mounted")) comp.mounted = Mounted;
				case "BeforeUpdate": if (useRtti || BeforeUpdate != ReflectUtil.getPrototypeField(baseClass, "BeforeUpdate")) comp.beforeUpdate = BeforeUpdate;
				case "Updated": if (useRtti || Updated != ReflectUtil.getPrototypeField(baseClass, "Updated")) comp.updated = Updated;
				case "Activated": if (useRtti || Activated != ReflectUtil.getPrototypeField(baseClass, "Activated")) comp.activated = Activated;
				case "Deactivated": if (useRtti || Deactivated != ReflectUtil.getPrototypeField(baseClass, "Deactivated")) comp.deactivated = Deactivated;
				
				case "GetProps": if (useRtti || GetProps != ReflectUtil.getPrototypeField(baseClass, "GetProps")) comp.props = _reflectPropsInstanceToNative(GetProps());
				case "GetPropsData": if (useRtti || GetPropsData != ReflectUtil.getPrototypeField(baseClass, "GetPropsData")) comp.propsData = GetPropsData();
				case "GetData": if (useRtti || GetData != ReflectUtil.getPrototypeField(baseClass, "GetData")) comp.data = GetData();
				
				case "Render": if (useRtti || Render != ReflectUtil.getPrototypeField(baseClass, "Render")) comp.render = Render;
				case "Template": if (useRtti || Template != ReflectUtil.getPrototypeField(baseClass, "Template")) comp.template = Template();
				case "El": if (useRtti || El != ReflectUtil.getPrototypeField(baseClass, "El")) comp.el = El();
			case "Components": 
				if (useRtti || Components != ReflectUtil.getPrototypeField(baseClass, "Components")) {
					componentsToAdd = Components();
					comp.components=nativeChildComponents;
				}
				default:
			}
		}
		
		// TODO: lazy recursive function approach for now. Should handle iteratively for better performance.
		if (componentsToAdd != null) {
			for (f in Reflect.fields(componentsToAdd)) {
				var c:VComponent<Dynamic,Dynamic> = Reflect.field(componentsToAdd, f);
				Reflect.setField(nativeChildComponents, f, c._toNative() );
				
			}
		}
		
		return comp;
	}
	
	function _reflectPropsInstanceToNative(props:P):Dynamic {
		// TODO
		return props;
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