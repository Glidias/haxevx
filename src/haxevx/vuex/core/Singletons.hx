package haxevx.vuex.core;
import haxe.ds.StringMap;

/**
 * ...
 * @author Glidias
 */
#if  !(production || skip_singleton_check )
class Singletons {
	static var NAMES:StringMap<Array<String>> = new StringMap<Array<String>>();
	public static function addLookup(classeName:String, from:String):Void {
		var arr:Array<String>;
		if (NAMES.exists(classeName)) {
			arr = NAMES.get(classeName);
		}
		else {
			arr = [];
			NAMES.set(classeName, arr);
		}
		arr.push(from);
	}
	private static var SINGLETON_CACHE:StringMap<Dynamic> = new StringMap<Dynamic>();
	public static function setAsSingleton(instance:Dynamic):Dynamic {
		SINGLETON_CACHE.set(Type.getClassName( Type.getClass(instance)), instance);
		return instance;
	}
	public static inline function getSingleton(classeName:String):Dynamic {
		return SINGLETON_CACHE.get(classeName);
	
	}
	public static function getClassNameOfInstance(instance:Dynamic):String {
		return Type.getClassName(Type.getClass(instance));
	}
	public static function clearLookups():Void {
		for (k in NAMES.keys()) {
			if (getSingleton(k) == null) {
				trace("Warning:: Could not find singleton dependency from/to: ["+ NAMES.get(k) + "] -> "+k);
			}
		}
		
		NAMES = new StringMap<Array<String>>();
	}
}
#end