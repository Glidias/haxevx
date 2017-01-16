package haxevx.vuex.core;
import haxe.macro.Expr.Field;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.Metadata;
import haxe.macro.Expr.MetadataEntry;
import haxe.macro.Expr.Position;
import haxe.macro.ExprTools;
import haxe.macro.MacroStringTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;

#if macro
/**
 * Haxe Macros for Vuex
 * @author Glidias
 */
class VuexMacros
{

	/**
	 * Generate public inlined "$store.commit" methods for mutator class which consists of private function handlers, among other things.
	 * @param	prefix	Prefix you want to append to the public commit function name 
	 * @return
	 */
	macro public static function buildMutator():Array<Field>  {
		return buildActionCalls("_", Context.getBuildFields(), "commit");
	}
	
		
	/**
	 * Generate public inlined "$store.dispatch" methods for action (aka action-dispatcher) classes which consists of private function handlers,  among other things.
	 * @param	prefix	Prefix you want to append to the public dispatch function name 
	 * @return
	 */
	macro public static function buildActions():Array<Field>  {
		
		return buildActionCalls("_", Context.getBuildFields(), "dispatch");
	}
	
	
	static function getClassNamespace():String {
		var str:String =  Context.getLocalClass().get().module;
		var className:String = Context.getLocalClass().get().name;
		var moduleStack:Array<String> = str.split(".");
		
		if (className != moduleStack[moduleStack.length-1]) {
			moduleStack.pop();
			moduleStack.push(className);
		}
		return  moduleStack.join("_") + "|";
	}

	
	static function ensureNoReturn(e:Expr):Void {
		  switch(e.expr) {
			case ExprDef.EReturn({expr:_, pos:pos }):
				Context.fatalError("If got 'return', need to supply return data type explicitly for action/mutator function", pos);
			case _:	 
		}
	}
	
	static function buildActionCalls(prefix:String, fields:Array<Field>, commitString:String ):Array<Field>  {

		var fieldsToAdd:Array<Field> = [];
		var contextPos:Position = Context.currentPos();
		
		var classeNamespace:String = getClassNamespace();

	
		
		for (field in fields ){
			if (field.access.indexOf(Access.AStatic) >= 0) {
				continue;
			}
			
			switch(field.kind) {
				case FieldType.FFun(f):
				
					if (field.access.indexOf(Access.APublic) >= 0) {
						Context.error("Functions in mutator/action classes cannot be public: "+field.name, field.pos);
					}
					
					if (field.access.indexOf(Access.AOverride) >= 0) {  // deemed to inherit namespace
						continue;
					}
					
					
					
					if (f.args.length == 0) {
						Context.error("Functions in mutator/action classes need at least 1 parameter for state/context: "+field.name, field.pos);
						
					}
					if (f.args.length > 2) {
						Context.error("Functions in mutator/action classes can have max 2 parameters at the most: "+field.name, field.pos);	
					}
					
					
					var gotRetType:Bool = false;
					if (f.ret == null) {
						ExprTools.iter(f.expr, ensureNoReturn);
					}
					
					var funcExpr:Expr;
					
					
					switch(f.ret) {
						case TPath({name:void , pack:_, params:_}):
							
						default:
							gotRetType = true;
					}
					var payload:FunctionArg = f.args.length == 2 ? f.args[1] : null;
		
					var contextType:ComplexType = ComplexType.TPath({pack:["haxevx", "vuex", "core"], name:"IVxStoreContext", params:[TPType(MacroStringTools.toComplex("Dynamic"))] });
					var contextArg:FunctionArg = {
						name: "context",
						type:  contextType
						
					};
					
								// todo: ensure IVxContext should be args[0]. IVxContext type param  should resolve to target store's state data type.
					
					var namespacedValue:String = classeNamespace + field.name;
					
					
					
					if (gotRetType) {
						funcExpr = payload != null ?   macro context.$commitString($v{namespacedValue}) : macro context.$commitString($v{namespacedValue});
					}
					else {
						funcExpr = payload != null ?   macro return context.$commitString($v{namespacedValue}, payload) :  macro return context.$commitString($v{namespacedValue});  // TODO: allow for return case
					}


					
					switch(f.expr.expr) {
						
						case ExprDef.EBlock([]): 
							field.meta = [{name:"ignore", pos:field.pos}];
						default:
							
					}
					
					///*
					fieldsToAdd.push( {
						name: prefix + field.name,
						access: [Access.APublic, Access.AInline],
						kind: FieldType.FFun({ params:f.params, ret:f.ret, args: payload != null ? [contextArg, payload] : [contextArg], expr:funcExpr  }),
						pos: contextPos,
						meta:  [{name:"ignore", pos:contextPos}] // todo: likely temp for now...
					});
					//*/
					
				default: 
					Context.error("Only private handler functions are allowed in mutator classes: "+field.name, field.pos);
			}
		}
		
		return fields.concat(fieldsToAdd);

	}
	// THis is rather hackish and may not be future-proof.
	// is this the "right" way to compare  pattern enums? oh well..
	static inline function isEqualComplexTypes(a:ComplexType, b:ComplexType):Bool {
		return ComplexTypeTools.toType(a) + "" == ComplexTypeTools.toType(b) + "";
	}
	
	

	
}



#end