package haxevx.vuex.core;
import haxe.ds.StringMap;
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
	 * Generate public inlined "$store.commit" methods for mutator class which consists of private function handlers.
	 * @return
	 */
	macro public static function buildMutator():Array<Field>  {
		return buildActionCalls("_", Context.getBuildFields(), "commit");
	}
		
	/**
	 * Generate public inlined "$store.dispatch" methods for action (aka action-dispatcher) classes which consists of private function handlers.
	 * @return
	 */
	macro public static function buildActions():Array<Field>  {
		
		return buildActionCalls("_", Context.getBuildFields(), "dispatch");
	}
	static private function hasMetaTag(metaData:Metadata, tag:String):Bool {
		for ( m in metaData) {
			if (m.name == tag) return true;
		}
		return false;
	}
	
	macro public static function buildVModuleGettersBackup():Array<Field> {
		var fields = Context.getBuildFields();
		
		var contextPos:Position = Context.currentPos();
		// todo: ensure state data type from VModule<T> is matching all getter parameters!
		var fieldsToAdd:Array<Field> = [];
		
		var alreadyDeclaredGetters:StringMap<Bool> = new StringMap<Bool>();
		
		for (field in fields) {
			if (field.access.indexOf(Access.AStatic) >= 0) {
				continue;
			}
			
			
			switch( field.kind ) {
				case FieldType.FProp("get", "never", _, _):
					alreadyDeclaredGetters.set(field.name, true);
				
				default:
					
			}
		}
		
		for (field in fields) {
			if (field.access.indexOf(Access.AStatic) < 0) {
				continue;
			}
			
			switch( field.kind ) {
				case FieldType.FFun(f):
				
					if (field.name.indexOf("Get_") == 0) {
						var fieldName:String = field.name;
						var addFieldName:String = field.name.substr(4);
						if (f.args.length == 0) {
							Context.error("Static store getters need to  accept 1 or 2 parameter which is store states ", field.pos);
						}
						if (!alreadyDeclaredGetters.get(addFieldName) ) {
							fieldsToAdd.push( {
								name:addFieldName,
								access: [Access.APublic],
								kind: FieldType.FProp("get", "never", f.ret),
								pos:contextPos
							});
						}
						fieldsToAdd.push( {
							name:"get_" + addFieldName,
							kind: FieldType.FFun({
								args:[],
								ret:f.ret,
								expr: macro return $i{fieldName}(state)
							}),
							pos:contextPos
						});
						
					}
				default:
					
			}
			
			
		}
		
		return fields.concat(fieldsToAdd);
	}
	
	static function getInterfaceTypParamsFrom(array:Array<{ t : haxe.macro.Ref<haxe.macro.ClassType>, params : Array<haxe.macro.Type> }>, interfaceName:String):Array<Type> {
		for ( i in 0...array.length) {
			if (array[i].t.toString() == interfaceName) return array[i].params;
		}
		return null;
	}
	
	static function getModuleStateTypes(cls:ClassType):Array<ComplexType> {
		
		while ( cls != null) {
			var params =  cls.superClass != null && cls.superClass.t.get().module == "haxevx.vuex.core.VModule" ?  cls.superClass.params : getInterfaceTypParamsFrom(cls.interfaces, "haxevx.vuex.core.IModule");
			if ( params != null ) {
				
				return [TypeTools.toComplexType(params[0]), TypeTools.toComplexType(params[1])];
			}
			cls = cls.superClass.t.get();
		}
		
		return null;
	}
	
	
	/**
	 * Generate locally accessible VModule Haxe getters from static functions in the form of `Get_getterFieldrName(state:T)` (representing Vuex-style store getters) for a given VModule extended class
	 * @return
	 */
	macro public static function buildVModuleGetters():Array<Field> {
		var fields = Context.getBuildFields();
		
		var localClasse = Context.getLocalClass().get();
		if (localClasse.module == "haxevx.vuex.core.VModule") {
			return fields;
		}

		var isBase:Bool = localClasse.superClass == null || localClasse.superClass.t.get().module == "haxevx.vuex.core.VModule";

		var noneT:ComplexType = MacroStringTools.toComplex("haxevx.vuex.core.NoneT");
		

		var stateTypes:Array<ComplexType> = getModuleStateTypes(Context.getLocalClass().get());
		
	
		var contextPos:Position = Context.currentPos();
		// todo: ensure state data type from VModule<T> is matching all getter parameters!
		var fieldsToAdd:Array<Field> = [];
		
		var alreadyDeclaredGetters:StringMap<Bool> = new StringMap<Bool>();
		
		for (field in fields) {
			if (field.access.indexOf(Access.AStatic) >= 0) {
				continue;
			}
			switch( field.kind ) {
				case FieldType.FProp("get", "never", _, _):
					alreadyDeclaredGetters.set(field.name, true);
				case FieldType.FProp("default", "never", _, _):
					//TODO: be able to switch
					//alreadyDeclaredGetters.set(field.name, true);
				default:
					
			}
		}
		
		var getterAssignments:Array<Expr> = [];
		
		
		// TODO: :mutator for IMutator, :action for IAction,  :getter
		
		
		for (field in fields) {
			if (field.access.indexOf(Access.AStatic) < 0) {
				continue;
			}
			
			switch( field.kind ) {
				
				case FieldType.FFun(f):
				
					if (field.name.indexOf("Get_") == 0) {
						var fieldName:String = field.name;
						var addFieldName:String = field.name.substr(4);
						if (f.args.length == 0) {
							Context.error("Static store getters needs at least 1 parameter for store state", field.pos);
						}
						// TODO: check parameter types for static method "Get_"
						
						
					 
						if (!alreadyDeclaredGetters.get(addFieldName) ) {
							fieldsToAdd.push( {
								name:addFieldName,
								access: [Access.APublic],
								kind: FieldType.FProp("get", "never", f.ret),
								pos:contextPos
							});
						}
						else {
							
						}
						
						// TODO: if IStoreGetters, switch it out to default
						
						
						fieldsToAdd.push( {
							name:"get_" + addFieldName,
							kind: FieldType.FFun({
								args:[],
								ret:f.ret,
								expr: macro return untyped this._stg[_ +$v{addFieldName}] //$i{fieldName}(state)
							}),
							pos:contextPos
						});
						
						getterAssignments.push( macro untyped d.$addFieldName = cls.$fieldName );
						
					}
				default:
					// TODO:
					if (hasMetaTag(field.meta, ":mutator")) {
						
					}
					else if (hasMetaTag(field.meta, ":action")) {
						
					}
					else if (hasMetaTag(field.meta, ":getter")) {
						
					}
					
			}
			
			
		}
		
		var strType:ComplexType = MacroStringTools.toComplex("String");
		
		if (isBase) {
			fieldsToAdd.push({
				name:"_",
				kind:FieldType.FProp("default", "never", strType ),
				access: [Access.APublic],
				pos:contextPos
			});
			
		}
		
		
			
		var initBlock:Array<Expr> = [];
		if (!isBase) {
			initBlock.push( macro super._Init(ns) );
		}
		if (isBase) initBlock.push( macro untyped this._ = ns );
		if (hasMetaTag(localClasse.meta.get(), ":namespaced")) {
			initBlock.push( macro {
				untyped this.namespaced = true;
				var useNS:String = "";
			});
		}
		else {
			initBlock.push( macro {
				
				var useNS:String = ns;
			});
		}
		
		var cls1 = Context.getLocalClass().toString();
		
		initBlock.push(macro {
			
			var cls:Dynamic = untyped $p{cls1.split('.')};
			var clsP:Dynamic = cls.prototype;
			var key:String;
			
		});
		
		if (getterAssignments.length != 0) {
			if ( isBase) initBlock.push( macro { 
				var d = {};
				untyped this.getters = d;
			} );
			else initBlock.push( macro var d  = untyped this.getters  );
			
			for ( i in 0...getterAssignments.length) {
				initBlock.push ( getterAssignments[i] );
			}
		}
		
		fieldsToAdd.push({
			name:"_Init",
			kind: FieldType.FFun({
				args:[{name:"ns", type:strType }],
				ret:null,
				expr: macro $b{initBlock}
			}),
			access: isBase ?  [Access.APublic] : [Access.APublic, Access.AOverride],
			pos:contextPos
		});
		
		return fields.concat(fieldsToAdd);
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