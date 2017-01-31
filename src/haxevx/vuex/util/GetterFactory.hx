package haxevx.vuex.util;
import haxe.rtti.CType.Rights;
import haxe.rtti.Rtti;

/**
 * Getter generation utility class
 * @author Glidias
 */
class GetterFactory
{

	

	
	public static function hookupGettersFromPropsOver(props:Dynamic, target:Dynamic):Void {
	
			ReflectUtil.setHiddenField(props, "_stg", target  );
			//if (!ReflectUtil.isNamedSpaced(p)) ReflectUtil.setHiddenField(target, "get_" + p, GetterFactory.getGetterMethodForProperty(p) );
	
	}
	

	
	
	

	
}