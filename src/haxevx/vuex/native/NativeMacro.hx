package haxevx.vuex.native;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.MacroStringTools;
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

	macro public static function mixin():Array<Field>  { 
		
		//trace("Mixing in VueBase");
		// mixin as public
		var fields = Context.getBuildFields();

		if (VUE_INSTANCE_FIELDS.length ==0) trace("Exception occured. VueBase fields not saved beforehand!");
		for (f in VUE_INSTANCE_FIELDS) {
			f.access.remove(Access.APrivate);
			
			fields.push(f);
		}
		
		return fields;
	}
	
	public static var VUE_INSTANCE_FIELDS:Array<Field> = [];
	
	macro public static function saveVueBaseFields():Array<Field>  {
		
		var fields = Context.getBuildFields();
		//trace("Saving base vue fields..");
		///*
		for (field in fields) {
			VUE_INSTANCE_FIELDS.push(field);
		}

		return fields;
	}
	
}