package haxevx.vuex.util;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;
import haxe.rtti.Meta;


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
	
	public static inline function getPrototypeField(cls:Class<Dynamic>, fieldName:String):Dynamic {
		return  untyped cls.prototype[fieldName];
	}
	public static inline function setPrototypeField(cls:Class<Dynamic>, fieldName:String, val:Dynamic):Void {
		 untyped cls.prototype[fieldName] = val;
	}
	
	public static function reflectClassHierachyInto(child:Class<Dynamic>, map:StringMap<Class<Dynamic>>, callback:Class<Dynamic>->Void, earlyOut:Bool = true):Void {
		var cls:Class<Dynamic> = child;
		while (cls != null) {
			var clsName:String = Type.getClassName(cls);
			if (map.exists(clsName)) {
				if (earlyOut) return;   // can safely return? assumed everything else further up hierachy is accounted for
				cls = Type.getSuperClass(cls);
				continue;
			}
			callback(cls);
		
			map.set(clsName, cls);
			cls = Type.getSuperClass(cls);
		}
	}
	
	public static inline function classHasInstanceField(cls:Class<Dynamic>, field:String):Bool {
		#if js 
			return untyped cls.prototype[field] != null;
		#else
			return Type.getInstanceFields(cls).indexOf(field) >= 0;
		#end
	}
	
	public static  function classFieldIsInherited(cls:Class<Dynamic>, field:String):Bool {
		cls = Type.getSuperClass(cls);
		return cls != null ? classHasInstanceField(cls, field) : false;
	}
	
	public static function getBaseClassForField(cls:Class<Dynamic>, field:String):Class<Dynamic> {
		var c:Class<Dynamic> = Type.getSuperClass(cls);
		while (c != null) {
			if (!classHasInstanceField(c, field)) {
				break;
			}
			cls = c;
			c = Type.getSuperClass(c);
		}
		return cls;
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
			var met = metaFields.f;
			
			var metaF:Dynamic<Array<Dynamic>> = Reflect.field(metaFields, f);
			for (m in Reflect.fields(metaF)) {
				var fieldsToMetaInfo:Dynamic<Array<Dynamic>> = fieldMap.get(m);
				if (fieldsToMetaInfo == null) {
					fieldsToMetaInfo = {};
					fieldMap.set(m, fieldsToMetaInfo);
					
				}
			
				var arrF:Array<Dynamic> = Reflect.field(metaF, m);
				if (arrF != null && !Std.is(arrF, Array)) {
					throw "PRoperty isn't array:" + arrF;
				}
				Reflect.setField(fieldsToMetaInfo, f, arrF);
			}
		}
	}
	

	
	public static  function getSingletonByClassName(name:String):Dynamic {
		if ( SINGLETON_CACHE.exists(name) ) return SINGLETON_CACHE.get(name);
		
		// warning, assumed instance constructor has zero required parameters
		SINGLETON_CACHE.set(name, getNewInstanceByClassName(name) );
		return SINGLETON_CACHE.get(name);
	}
	
	public static  function findSingletonByClassName(name:String):Dynamic {
		if ( SINGLETON_CACHE.exists(name) ) return SINGLETON_CACHE.get(name);
		throw "Could not find registered singleton by class name: " + name;
		return null;
	}
	
	public static  function checkForSingletonByClassName(name:String):Dynamic {
		if ( SINGLETON_CACHE.exists(name) ) return SINGLETON_CACHE.get(name);
		trace("Warning: Didn't find singleton registered by class name: " + name);
		return null;
	}
	
	static var PACKAGE_NAMESPACE:String = "";
	static public inline var MODULE_FRACTAL_SEP:String = ">";
	static public inline var MODULES_SEPERATOR:String = "/";
	
	// Deprecrated.. Sets up your app package path, like sg.myapp.project, which is useful for shortening namespaces
	//public static var NAMESPACE(default, set):String;
	/*
	static function set_NAMESPACE(value:String):String 
	{
		setPackageNamespace(value);
		return PACKAGE_NAMESPACE;
	}
	static inline function setPackageNamespace(namespace:String):Void {  
		PACKAGE_NAMESPACE = namespace.split(".").join("_") + "_";
	}
	*/
	
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
	
	#if js
	public inline function jsOverwritePrototypeField(cls:Class<Dynamic>, fieldName:String, withValue:Dynamic):Void {
		untyped cls.prototype[fieldName] = withValue;
	}
	#end
	
	
	public static inline function hasMetaTag(fieldName:String, metaFields:Dynamic<Dynamic<Array<Dynamic>>>, tagSet:StringMap<Bool>):Bool {
		return Reflect.hasField(metaFields, fieldName) && tagSetHasField(tagSet, Reflect.field(metaFields, fieldName) );
	}
	
	
	// useful for any  platform specific setting of hidden fields (eg. set enumberable:FALSE for JS properties)
	static public function setHiddenField(o:Dynamic, field:String , value:Dynamic):Void
	{
		
		Reflect.setField(o, field, value);
	}
	
	
	
	static public inline function isClass(instance:Dynamic):Bool
	{
		return Std.is(instance, Class);
	}
	
	static public function strToNativeType(str:String):Dynamic
	{
		switch( str) {
			case "String": return untyped __js__("String");
			case "Number": return untyped __js__("Number");
			case "Boolean": return untyped __js__("Boolean");
			case "Function": return untyped __js__("Function");
			case "Object": return untyped __js__("Object");
			case "Array": return untyped __js__("Array");	
			default: throw "Could not resolve string to native data type: " + str;
		}
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