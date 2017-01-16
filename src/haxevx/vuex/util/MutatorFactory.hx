package haxevx.vuex.util;
import haxe.ds.StringMap;
import haxe.rtti.Meta;

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
	
	// consider, non-static store variable within getMutatorCommit parameter
	static function getMutatorCommit(type:String):?Dynamic->Void {
		// to test: possible to precompute context out of here??
		return function(payload:Dynamic=null) {		
			store.commit(type, payload);
		};
	}
	
	/*	// depreciated
	public static function finaliseClass(cls:Class<Dynamic>, store:Dynamic):Void {
		var fields:Array<String> = Type.getInstanceFields(cls); 
		for (f in fields) {
			ReflectUtil.setPrototypeField(cls, f, getMutatorCommit(getDispatchString(cls, f)));
		}
		ReflectUtil.setPrototypeField(cls, "$store", store);
	
	}
	*/
	
	static var REGISTERED_CLASSES:StringMap<Class<Dynamic>> = new StringMap<Class<Dynamic>>();
	public static function getClasses() {
		return REGISTERED_CLASSES.iterator();
	}
	
	
	
	
	static function nothing(cls:Class<Dynamic>):Void {
		
	}

	
	static inline function getDispatchString(cls:Class<Dynamic>, f:String):String {
		return ReflectUtil.getNamespaceForClass(ReflectUtil.getBaseClassForField(cls, f)) + f;
	}
	
	public static function setupMutatorsOfInstanceOver(instance:Dynamic, over:Dynamic):Void {
		var handler:Dynamic;
		
		var cls:Class<Dynamic> = Type.getClass(instance);
		if (cls == null) throw "Couldn't resolve mutator class of: " + instance;
			
		// setup instance fields
		var fields:Array<String> = Type.getInstanceFields(cls);  // TODO: get all derived instnace fields as well as part of entire collection
		
		ReflectUtil.reflectClassHierachyInto(cls, REGISTERED_CLASSES, nothing);
		
		var metaFields = Meta.getFields(cls);
		var metaStrMap = ["ignore" => true];
		for (f in fields) {
			
			var checkF =  Reflect.field(instance, f) ;
			if  ( Reflect.isFunction(checkF)   ) {
				
				
				// RESOLVE HANDLER
				// todo: check from rtti or metadata, whether got specific return data type is  that is handler function or not.
				
				// Assumed function call will return handler
				// javascript allows executing function without supplygng explicit parameters
				
				if (!ReflectUtil.hasMetaTag(f, metaFields, metaStrMap ) ) {
					handler = ReflectUtil.getPrototypeField(cls, f);
					
					if (!Reflect.isFunction(handler)) {
						throw "Could not resolve handler for field: " + f;
					}
					
					var fieldName:String = getDispatchString(cls, f);
					if (!Reflect.hasField(over, fieldName)) 
						Reflect.setField(over, fieldName, handler);
					else
						trace("Exception occured repeated field handler set");
						
				}
			}
			else {
				trace("Warning!! Mutator classes should only contain function fields! Fieldname: " + f);
			}
		}
		
	}
	
	
}