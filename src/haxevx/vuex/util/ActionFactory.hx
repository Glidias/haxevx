package haxevx.vuex.util;

/**
 * ...
 * @author Glidias
 */
class ActionFactory
{
	// inlining macro to allow for dollar sign 
	static var store(get, null):Dynamic;
	static inline function get_store():Dynamic 
	{
		return untyped __js__("this.$store");
	}
	
	public static function getActionDispatch(type:String):?Dynamic->Dynamic->Void {
		return function(payload:Dynamic=null, context:Dynamic=null) {		
			(context != null ? context : store).dispatch(type, payload);
		};
	}
	
	public static function reflectFunctionCall(func:Dynamic):String {
		
		var str:String = func.toString();
		str = str.split("return")[1];
		if (str == null) {
			throw "Reflection failed:" + func.toString();
		}
		str =  StringTools.trim( str.split("}")[0] );
		
		str = str.split("(")[0];
		str = str.split(".").pop();
		//trace(str);
		return str;
	}
	
	public static function getActionHandler(classe:Dynamic, funcName:String):Dynamic {
		var str:String = Reflect.field(classe, funcName);
		if (str == null) {
			throw "Could not find funcName field:" + str + " on class:" + Type.getClassName(classe);
		}
		var handlerStr = reflectFunctionCall(str);
		var handler:Dynamic = Reflect.field(classe, handlerStr);
		if (handler==null ) {
			throw "Could not find handler field:" + handlerStr + " on class:" + Type.getClassName(classe);
		}
		return handler;
	}
	
	
}

