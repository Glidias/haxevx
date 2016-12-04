package haxevx.vuex.util;
import haxe.rtti.CType.Rights;
import haxe.rtti.Rtti;

/**
 * Getter generation utility class
 * @author Glidias
 */
class GetterFactory
{

	
	//Dynamic<T->Dynamic> 
	public static function setupGettersFromInstance<T>( instance:Dynamic, gettersObj:Dynamic = null, namespacePrefix:String=""):Dynamic {
		
		var classe:Class<Dynamic> = Type.getClass(instance);
	

		if (classe == null) {
			trace(instance);
			throw "Could not resolve class of instance:" + instance;
		}
		if (gettersObj == null) gettersObj = {};
		if (false && Rtti.hasRtti(classe)) {  // TODO: more precise runtime type-checking via RTTI for dev mode!
			var rtti = Rtti.getRtti(classe);
			for (f in rtti.fields.iterator() ) {
				//f.set.
			//	haxe.rtti.Rights
				// Reflect.field(instance, s)
			}
		}
		else{
			var fields = Type.getInstanceFields(classe);
			
			for (s in fields) {
				if ( ReflectUtil.inferIsHxGetter(s) ) {
					if (Reflect.isFunction( Reflect.field(instance, s) ) ) {
						Reflect.setField( gettersObj, namespacePrefix+ReflectUtil.inferHxGetterName(s) ,  ReflectUtil.inferReturnFunc( Reflect.field(instance, s), s, classe ) );
					}
					else {
						trace("Warning:: infered property: " + s+ " is not a function");
					}
				}
				
			}
		}
		
		
		return gettersObj;
	}
	
	public static function hookupGettersFromPropsOver(props:Dynamic, target:Dynamic):Void {
		for (p in Reflect.fields(props) ) {
			if (!ReflectUtil.isNamedSpaced(p)) ReflectUtil.setHiddenField(target, "get_" + p, GetterFactory.getGetterMethodForProperty(p) );
		}
	}
	
	public static function getGetterMethodForProperty(prop:String):Void->Dynamic {
		return function():Dynamic {
			return untyped __js__("this")[prop];
		}
	}
	
	public static function hookupGettersFromPropsOver2(props:Dynamic, target:Dynamic, getters:Dynamic, moduleNamespacePrefix:String=""):Void {
		var namespacePrefix:String = moduleNamespacePrefix != "" ? "" :  ReflectUtil.getNamespaceForClass(Type.getClass(target));
		// if got module namespace, assumed good enough
		
		for (p in Reflect.fields(props) ) {
			//if (!ReflectUtil.isNamedSpaced(p))
			ReflectUtil.setHiddenField(target, "get_" + p, GetterFactory.getGetterMethodForProperty2(moduleNamespacePrefix+namespacePrefix+p, getters) );
		}
	}
	
	public static function getGetterMethodForProperty2(prop:String, getters:Dynamic):Void->Dynamic {
		return function():Dynamic {
			return untyped getters[prop];
		}
	}
	
	
	

	
}