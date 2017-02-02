package haxevx.vuex.native;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.MacroStringTools;
import haxe.macro.Type;
import haxe.macro.Type.ClassField;
import haxe.macro.Type.ClassType;
import haxe.macro.Type.FieldKind;
import haxe.macro.Type.MethodKind;
import haxe.macro.TypeTools;

/**
 * ...
 * @author Glidias
 */
class NativeMacro
{
	
	public static var VUE_INSTANCE_FIELDS:Array<Field> = [];

	macro public static function mixin():Array<Field>  { 
		
		var fields = Context.getBuildFields();
		
		if (VUE_INSTANCE_FIELDS.length == 0) {
			// somehow, this will initiate the base @:build of VueBase for saveVueBaseFields()
			Context.getType("haxevx.vuex.native.VueBase");
		}
		
		
		for (f in VUE_INSTANCE_FIELDS) {
			f.access.remove(Access.APrivate);
			fields.push(f);
		}
		
	
		return fields;
	}
	
	macro public static function saveVueBaseFields():Array<Field>  {
		
		var fields = Context.getBuildFields();
		///*
		if (VUE_INSTANCE_FIELDS.length != 0) return fields;
		
		///*
		for (field in fields) {
			VUE_INSTANCE_FIELDS.push(field);
		}
		//*/

		return fields;
	}
	
}