package haxevx.vuex.util;
import haxe.ds.StringMap;

/**
 * ...
 * @author Glidias
 */
class MutatorFactory
{
	
	// inlining macro to allow for dollar sign 
	static var store(get, null):Dynamic;
	static inline function get_store():Dynamic 
	{
		return untyped __js__("this.$store");
	}
	
	public static function getMutatorCommit(type:String):?Dynamic->Dynamic->Void {
		// to test: possible to precompute context out of here??
		return function(payload:Dynamic=null, context:Dynamic = null) {		
			(context != null ? context : store).commit(type, payload);
		};
	}
	
	static var REGISTERED_CLASSES:StringMap<Class<Dynamic>> = new StringMap<Class<Dynamic>>();
	public static function getClasses() {
		return REGISTERED_CLASSES.iterator();
	}
	
	public static function setupMutatorsOfInstanceOver(instance:Dynamic, over:Dynamic):Void {
		var handler:Dynamic;
		var cls:Class<Dynamic> = Type.getClass(instance);
		if (cls == null) throw "Couldn't resolve mutator class of: " + instance;
			
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
				
				var fieldName:String = ReflectUtil.getNamespaceForClass(ReflectUtil.getBaseClassForField(cls, f)) + f;
				if (!Reflect.hasField(over, fieldName)) 
					Reflect.setField(over, fieldName, handler);
				else
					trace("Exception occured repeated field handler set");
			}
			else {
				trace("Warning!! Mutator classes should only contain function fields! Fieldname: " + f);
			}
		}
		
	}
	
	
}