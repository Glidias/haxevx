package haxevx.vuex.util;
import haxe.ds.StringMap;
import haxe.rtti.Rtti;
import haxevx.vuex.core.VComponent;

/**
 * ...
 * @author Glidias
 */
class ActionFactory
{

	// inlining macro to allow for dollar sign 
	static var store(get, null):Dynamic;
	static inline function get_store():Dynamic 
	{
		return untyped __js__("this.$store");
	}
	
	static function getActionDispatch(type:String):?Dynamic->Void {
		return function(payload:Dynamic=null) {		
			store.dispatch(type, payload);
		};
	}
	
	public static function finaliseClass(cls:Class<Dynamic>, store:Dynamic):Void {
		var fields:Array<String> = Type.getInstanceFields(cls); 
		for (f in fields) {
			ReflectUtil.setPrototypeField(cls, f, getActionDispatch(getDispatchString(cls, f)));
		}
		ReflectUtil.setPrototypeField(cls, "$store", store);
	
	}
	
	
	public static function reflectFunctionCall(func:Dynamic):String {
		
		var str:String = func.toString();
		str = str.split("return")[1];
		if (str == null) {
			throw "Reflection failed:" + func.toString();
		}
		str =  StringTools.trim( str.split("}")[0] );
		
		str = str.split("(")[0];
		str = str.split(".").pop();
		//trace(str);
		return str;
	}
	

	
	public static function getActionHandler(classe:Dynamic, funcName:String):Dynamic {
		var str:String = Reflect.field(classe, funcName);
		if (str == null) {
			throw "Could not find funcName field:" + str + " on class:" + Type.getClassName(classe);
		}
		var handlerStr = reflectFunctionCall(str);
		var handler:Dynamic = Reflect.field(classe, handlerStr);
		if (handler==null ) {
			throw "Could not find handler field:" + handlerStr + " on class:" + Type.getClassName(classe);
		}
		return handler;
	}
	
	
	
	static var REGISTERED_CLASSES:StringMap<Class<Dynamic>> = new StringMap<Class<Dynamic>>();
	public static function getClasses():Iterator<Class<Dynamic>> {
		return REGISTERED_CLASSES.iterator();
	}
	
	static var META_INJECTIONS:StringMap<Bool> = {
		var strMap = new StringMap<Bool>();
		strMap.set("mutator", true);
		return strMap;
	}
	public static function get_META_INJECTIONS():StringMap<Bool> {
		return META_INJECTIONS;
	}
	
	static inline function getDispatchString(cls:Class<Dynamic>, f:String):String {
		return ReflectUtil.getNamespaceForClass(ReflectUtil.getBaseClassForField(cls, f)) + f;
	}
	
	

	
	static function nothing(cls:Class<Dynamic>):Void {
		
	}

	
	public static function setupActionsOfInstanceOver(instance:Dynamic, over:Dynamic):Void {
		var handler:Dynamic;
		var cls:Class<Dynamic> = Type.getClass(instance);
		if (cls == null) throw "Couldn't resolve action class of: " + instance;
		
		var clsName:String = Type.getClassName(cls);
		
		ReflectUtil.reflectClassHierachyInto(cls, REGISTERED_CLASSES, nothing);
			
		// setup instance fields
		var fields:Array<String> = Type.getInstanceFields(cls);  // TODO: get all derived instnace fields as well as part of entire collection

		for (f in fields) {
			
			var checkF =  Reflect.field(instance, f) ;
			if  ( Reflect.isFunction(checkF)) {
				
				
				// RESOLVE HANDLER
				// todo: check from rtti or metadata, whether got specific return data type is  that is handler function or not.
				
				// Assumed function call will return handler
				// javascript allows executing function without supplygng explicit parameters
				handler = checkF();
				if (handler == null) continue;
				
				if (!Reflect.isFunction(handler)) {
					throw "Could not resolve handler for field: " + f;
				}
				
				// Assign Handler to 
				var fieldName:String = getDispatchString(cls, f);
				if (!Reflect.hasField(over, fieldName)) 
					Reflect.setField(over, fieldName, handler);
				else	
					trace("Exception occured repeated field handler set");
			}
			else {
				trace("Warning!! Action classes should only contain function fields! Fieldname: " + f);
			}
		}
		
	}
	
	
}

