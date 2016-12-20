package haxevx.vuex.util;
import haxe.ds.StringMap;
import haxe.rtti.CType;
import haxe.rtti.CType.ClassField;
import haxe.rtti.CType.Classdef;
import haxe.rtti.Meta;
import haxe.rtti.Rtti;

/**
 * Some basic lazy RTTI-required pseudo-dependency injection utilities 
 * (don't expect any full DI system here, (eg. constructor parameter injection, method parameter injection, etc.))
 * 
 * It's more like dynamic lazy instantation...rather then dependency injection.
 * 
 * @author Glidias
 */
class RttiUtil
{
	public static var NO_FIELDS:StringMap<Bool> = new StringMap<Bool>();
	

	public static function resetFieldSet(fields:StringMap<Bool>):Void {
		for (s in fields.keys()) {
			fields.set(s, false);
		}
	}
	
	public static function getInstanceFieldsUnderClass(cls:Class<Dynamic>):Array<String> {
		var arr:Array<String> = [];
		for (f in Rtti.getRtti(cls).fields){
			arr.push(f.name);
		}
		return arr;
		
	}
	
	/**
	 * Generic injection method
	 * @param	instance	The object to inject into
	 * @param	rtti	The class RTTI to faciliiate injecting into object. 
	 * @param	forFields	(Optional) A Stringmap<require:true> set of property field names that require injections 
	 * @param	forMeta		(Optional) A Stringmap<require:true> set of metadata tag names to mark fields that require injections 
	 * @param	injectorRetrieveMethod	(Optional) Factory method, given class name string parameter, to supply given instance, else will always attempt to create a new instance via constructor.
	 */
	public static function injectNewInstance(instance:Dynamic,  rtti:Classdef, forFields:StringMap<Bool> = null, forMeta:StringMap<Bool> = null, injectorRetrieveMethod:String->Dynamic=null):Void {
		if (injectorRetrieveMethod == null) injectorRetrieveMethod = ReflectUtil.getNewInstanceByClassName;
		
		if (forMeta ==  null) forMeta = NO_FIELDS;
		
	
		
		var isClassInstance:Bool = ReflectUtil.isClass(instance);
		var metaFields = isClassInstance ?  Meta.getStatics(instance) :  Meta.getFields( Type.getClass(instance));

		var cls:Class<Dynamic>;
		var usingSingletons:Bool =injectorRetrieveMethod == ReflectUtil.getSingletonByClassName;

		
		for ( f in (isClassInstance ? rtti.statics : rtti.fields )  ) {
				
			if ( (forFields == null || forFields.get(f.name)) || ReflectUtil.hasMetaTag(f.name, metaFields, forMeta) )  {
				
				if (Reflect.field(instance, f.name) == null) {
	

					switch (f.type) {
						case CType.CClass(name, params):
							//trace(name);
							cls = Type.resolveClass(name); 
							if (cls == null) {
								throw "Fatal error could not resolve field class by type: " + name + " , under "+f.name;
							}
							Reflect.setField(instance, f.name, injectorRetrieveMethod(name)  );
							
							//trace("Dynamic set!:"+f.name);
						case CType.CAnonymous(fields):
							throw "Anonymous structure data taypes not supported at the moment. Please manually instantiate instead!";
						default:
							throw "Could not resolve field injection type: " +f.type.getName() + " for: "+  f.name;
					}
					
				}
				else if (usingSingletons) {
					
					switch (f.type) {
						case CType.CClass(name, params):
							//trace(name);
							ReflectUtil.getSingletonByClassName(name);
						default:
							//throw "Could not resolve field injection type: " +f.type.getName() + " for: "+  f.name;
					}
				}
				
			}
			
		}
		
	
	}
	
	// lazy singleton mapping+injection on the fly?..may not be best practice here...
	/**
	 * Injects into singleton using built-in singleton registry under ReflectUtil.
	 * @param	instance	The object to inject into
	 * @param	rtti	The class RTTI to faciliiate injecting into object. 
	 * @param	forFields	(Optional) A Stringmap<require:true> set of property field names that require injections 
	 * @param	forMeta		(Optional) A Stringmap<require:true> set of metadata tag names to mark fields that require injections 
	 */
	public static  function injectSingletonInstance(instance:Dynamic,  rtti:Classdef, forFields:StringMap<Bool>=null, forMeta:StringMap<Bool>=null):Void  {
		
		injectNewInstance(instance, rtti, forFields, forMeta, ReflectUtil.getSingletonByClassName);
		
	}
	
	public static inline function getRttiOfInstance(instance:Dynamic):Classdef {
		return Rtti.getRtti( Type.getClass(instance) );
	}
	
}