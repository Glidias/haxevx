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
	
	
	static var REGISTERED_CLASSES:StringMap<Class<Dynamic>> = new StringMap<Class<Dynamic>>();
	public static function getClasses() {
		return REGISTERED_CLASSES.iterator();
	}
	
	
	

}