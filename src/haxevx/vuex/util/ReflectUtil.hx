package haxevx.vuex.util;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;
import haxe.rtti.Meta;
import haxe.rtti.Rtti;

/**
 * Generic reflection utilities
 * @author Glidias
 */

typedef MetaFieldRemap = StringMap<Dynamic<Array<Dynamic>>>;
class ReflectUtil
{
	
	static var SINGLETON_CACHE:StringMap<Dynamic> = new StringMap<Dynamic>();
	static var METAFIELD_CACHE: StringMap<MetaFieldRemap> = new StringMap<MetaFieldRemap>();
	static var METAFIELD_CACHE_STATICS: StringMap<MetaFieldRemap> =  new StringMap<MetaFieldRemap>();
	
	public static function getMetaFieldsOfClass(cls:Class<Dynamic>): Dynamic<Dynamic<Array<Dynamic>>> {
		var rt = Meta.getFields(cls);
		var clsName:String = Type.getClassName(cls);
		if (!METAFIELD_CACHE.exists(clsName)) {
			saveMetaFields(METAFIELD_CACHE, rt, clsName);
		}
		return rt;
	}
		public static function getStaticMetaFieldsOfClass(cls:Class<Dynamic>): Dynamic<Dynamic<Array<Dynamic>>> {
		var rt = Meta.getStatics(cls);
		var clsName:String = Type.getClassName(cls);
		if (!METAFIELD_CACHE_STATICS.exists(clsName)) {
			saveMetaFields(METAFIELD_CACHE_STATICS, rt, clsName);
		}
		return rt;
	}

	
	public static function getMetaDataFieldsWithTag(cls:Class<Dynamic>, tag:String):Dynamic<Array<Dynamic>> {
		var clsName:String = Type.getClassName(cls);
		if (!METAFIELD_CACHE.exists(clsName)) {
			getMetaFieldsOfClass(cls);
		}
		return  METAFIELD_CACHE.get(clsName).get(tag);
	}
	
	public static function getStaticMetaDataFieldsWithTag(cls:Class<Dynamic>, tag:String):Dynamic<Array<Dynamic>> {
		var clsName:String = Type.getClassName(cls);
		if (!METAFIELD_CACHE_STATICS.exists(clsName)) {
			getStaticMetaFieldsOfClass(cls);
		}
		return  METAFIELD_CACHE_STATICS.get(clsName).get(tag);
	}
	
	

	
	 static function saveMetaFields(map:StringMap<MetaFieldRemap>, metaFields: Dynamic<Dynamic<Array<Dynamic>>>, saveName:String):Void {
		var fieldMap:MetaFieldRemap = new MetaFieldRemap();
		//Dynamic<Array<Dynamic>>
		map.set(saveName, fieldMap);
		for (f in Reflect.fields(metaFields)) {
			var metaF:Dynamic<Array<Dynamic>> = Reflect.field(metaFields, f);
			for (m in Reflect.fields(metaF)) {
				var fieldsToMetaInfo = fieldMap.get(m);
				if (fieldsToMetaInfo == null) {
					fieldsToMetaInfo = {};
					fieldMap.set(m, fieldsToMetaInfo);
					
				}
				Reflect.setField(fieldsToMetaInfo, f, metaF);
			}
		}
	}
	

	
	public static  function getSingletonByClassName(name:String):Dynamic {
		if ( SINGLETON_CACHE.exists(name) ) return SINGLETON_CACHE.get(name);
		
		// warning, assumed instance constructor has zero required parameters
		SINGLETON_CACHE.set(name, getNewInstanceByClassName(name) );
		return SINGLETON_CACHE.get(name);
	}
	
	static var PACKAGE_NAMESPACE:String = "";
	static public inline var MODULE_FRACTAL_SEP:String = ">";
	static public inline var MODULES_SEPERATOR:String = "/";
	
	// Sets up your app package path, like sg.myapp.project, which is useful for shortening namespaces
	public static var NAMESPACE(default, set):String;
	
	static function set_NAMESPACE(value:String):String 
	{
		setPackageNamespace(value);
		return PACKAGE_NAMESPACE;
	}
	static inline function setPackageNamespace(namespace:String):Void {  
		PACKAGE_NAMESPACE = namespace.split(".").join("_") + "_";
	}
	
	public static function getPackagePathForInstance(instance:Dynamic):String {
		var clas = Type.getClass(instance);
		if (clas == null) throw "Class could not be resolved for instance: " + instance;
		return getPackagePathForClass(clas);
	}
	
	public static function getPackagePathForClass(classe:Class<Dynamic>):String {
		var classeName =  Type.getClassName(classe);
		var arr = classeName.split(".");
		arr.pop();
		return arr.join(".");
	}
	
	public static inline function getNamespaceForClass(classe:Class<Dynamic>):String {
		return getNamespaceForClassName(Type.getClassName(classe));
	}
	public static inline function getNamespaceForClassName(className:String):String {
		return truncateNamespace( className.split(".").join("_")) + "|";
	}
	public static inline function isNamedSpaced(str:String):Bool {
		return str.indexOf("|") >= 0;
	}
	public static inline function truncateNamespace(name:String):String {
		return (PACKAGE_NAMESPACE!= "" && name.substr(0, PACKAGE_NAMESPACE.length) == PACKAGE_NAMESPACE) ? name.substr(PACKAGE_NAMESPACE.length) : name;
	}
	
	public static  function registerSingletonByClassName(name:String, instance:Dynamic):Dynamic {
		if ( SINGLETON_CACHE.exists(name) ) throw "Singleton of name:" + name + " already exists!";
		
		// warning, assumed instance constructor has zero required parameters
		SINGLETON_CACHE.set(name,instance );
		return SINGLETON_CACHE.get(name);
	}
	
	//inline
	
	public static inline function inferIsHxGetter(str:String):Bool {
		return str.substr(0, 4) == "get_";
	}
	public static inline function inferHxGetterName(str:String):String {
		return str.substr(4);
	}
	
	public static  function inferReturnFunc(func:Dynamic, prop:String, curClasse:Class<Dynamic>):Dynamic {
		var str:String = func.toString();
		var strArr:Array<String> = str.split("{");
		if (strArr.length <2 ) throw "BAD detection?:" + func.toString();
		str = strArr[1].split("}")[0];
		str = str.split("return ").pop();
		str = StringTools.trim(str);
		strArr = str.split("(");
		if (strArr.length < 2 ) throw "BAD detection?:" + func.toString();
		
		str = strArr[0];
		strArr = str.split(".");
		var prop = strArr.pop();
		if (strArr.length > 0) {
			str = strArr[0].split("_").join(".");
			curClasse = Type.resolveClass(str );
			if (curClasse == null) throw "Failed to resolve class by name: " + str;
		}
		var me =  Reflect.field(curClasse, prop);
		if (me == null) throw 'Could not resolve property lookup ${prop} under curClasse: ${curClasse}';
		return me;
	}

	
	public static  function getNewInstanceByClassName(name:String):Dynamic {
		// warning, assumed instance constructor has zero required parameters
		var cls:Class<Dynamic> = Type.resolveClass(name);
		if (cls == null) throw "could not resolve class by:" + name;
		return Type.createInstance(cls, [] );
	}
	
	
	
	public static inline function hasMetaTag(fieldName:String, metaFields:Dynamic<Dynamic<Array<Dynamic>>>, tagSet:StringMap<Bool>):Bool {
		return Reflect.hasField(metaFields, fieldName) && tagSetHasField(tagSet, Reflect.field(metaFields, fieldName) );
	}
	
	
	// useful for any  platform specific setting of hidden fields (eg. set enumberable:FALSE for JS properties)
	static public function setHiddenField(o:Dynamic, field:String , value:Dynamic):Void
	{
		
		Reflect.setField(o, field, value);
	}
	
	static public function requiresInjection(dynInsMap:StringMap<Bool>, metaMap:StringMap<Bool>, moduleInstance:Dynamic) :Bool
	{
		var requireInject:Bool = false;
		if (dynInsMap != null) {
			for (f in dynInsMap.keys()) {
				if ( dynInsMap.get(f) && Reflect.field(moduleInstance, f) == null) {
					requireInject = true;
					break;
				}
			}
		}
		if (requireInject  ) {
			if (!Rtti.hasRtti(Type.getClass(moduleInstance))) throw "Requires injection but lacks RTTI!";
			return true;
		}
		
		if (metaMap != null) {
			var cls = Type.getClass(moduleInstance);
			for (t in metaMap.keys()) {
				var props = getMetaDataFieldsWithTag( cls, t);
				for (f in Reflect.fields(props)) {
					if ( dynInsMap.get(f) && Reflect.field(moduleInstance, f) == null) {
						requireInject = true;
						break;
					}
				}
			}
		}
		
		if (requireInject  ) {
			if (!Rtti.hasRtti(Type.getClass(moduleInstance))) throw "Requires injection but lacks RTTI!";
			return true;
		}
		return requireInject;
	}
	
	static private function tagSetHasField(tagSet:StringMap<Bool>, fieldMeta:Dynamic):Bool
	{
		for (f in Reflect.fields(fieldMeta)) {
			if (tagSet.get(f)) {
				return true;
			}
		}
		return false;
	}
	
	
	
}