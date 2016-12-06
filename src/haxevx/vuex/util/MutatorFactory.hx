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
	
	
}