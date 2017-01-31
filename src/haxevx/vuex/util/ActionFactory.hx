package haxevx.vuex.util;
import haxe.ds.StringMap;
import haxe.rtti.Meta;
import haxe.rtti.Rtti;
import haxevx.vuex.core.VComponent;

/**
 * ...
 * @author Glidias
 */
class ActionFactory
{

	

	
	
	
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
	
	
	

	

	
}

