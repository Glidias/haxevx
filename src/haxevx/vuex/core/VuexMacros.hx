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
import haxevx.vuex.native.CommitOptions;
import haxevx.vuex.native.DispatchOptions;


/**
 * Haxe Macros for Vuex
 * @author Glidias
 */
class VuexMacros
{
	
	#if macro
	
	static var DISPATCH_STRINGS:StringMap<StringMap<Bool>> = new StringMap<StringMap<Bool>>();
	static var MODULE_TYPE_PARAMS:StringMap<Array<ComplexType>> = new StringMap<Array<ComplexType>>();

	/**
	 * Generate public inlined "$store.commit" methods for mutator class which consists of private function handlers.
	 * @return
	 */
	macro public static function buildMutator():Array<Field>  {
		return buildActionCalls("_", Context.getBuildFields(), "commit", false);
	}
		
	/**
	 * Generate public inlined "$store.dispatch" methods for action (aka action-dispatcher) classes which consists of private function handlers.
	 * @return
	 */
	macro public static function buildActions():Array<Field>  {
		
		return buildActionCalls("_", Context.getBuildFields(), "dispatch", true);
	}
	static private function hasMetaTag(metaData:Metadata, tag:String):Bool {
		for ( m in metaData) {
			if (m.name == tag) return true;
		}
		return false;
	}
	
	macro public static function addPrefixStateUnderscore():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		fields.push({
			name:"_",
			kind:FieldType.FProp("default", "never", MacroStringTools.toComplex("String") ),
			access: [Access.APublic],
			pos:Context.getLocalClass().get().pos
		});
		return fields;
	}
	
	/**
	 * Build the IStoreGetters/IGetters mixin implementation
	 * @param	isStoreGetters	Whether is root store getters
	 * @return
	 */
	macro public static function buildIGetters(isStoreGetters:Bool=false):Array<Field> {
		var fields = Context.getBuildFields();
		
		var localClasse = Context.getLocalClass().get();
		if ( MODULE_CLASSES.exists(localClasse.module) ) {
			return fields;
		}
		
		
		

		var isBase:Bool = localClasse.superClass == null ||  MODULE_CLASSES.exists( localClasse.superClass.t.get().module);

		var noneT:ComplexType = NONE_T;
		var clsSuffix:String =  "_"+Context.getLocalClass().toString().split(".").join("_");

		var stateTypes:Array<ComplexType> = getModuleStateTypes(Context.getLocalClass().get());
			
		var cls1 = Context.getLocalClass().toString();
		MODULE_TYPE_PARAMS.set(cls1, stateTypes);
		
		var contextPos:Position = Context.currentPos();
		// todo: ensure state data type from VModule<T> is matching all getter parameters!
		var fieldsToAdd:Array<Field> = [];
		
		var alreadyDeclaredGetters:StringMap<Bool> = new StringMap<Bool>();
		var getterAssignments:Array<Expr> = [];
		
		for (field in fields) {
			if (field.access.indexOf(Access.AStatic) >= 0) {
				continue;
			}
			
			
			switch( field.kind ) {
				case FieldType.FProp("get", "never", _, _):
					if (!isStoreGetters) alreadyDeclaredGetters.set(field.name, true);
				case FieldType.FProp("default", "never", _, _):
					if (isStoreGetters) {
						alreadyDeclaredGetters.set(field.name, true);
					}
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
								kind: FieldType.FProp( isStoreGetters ? "default" : "get", "never", f.ret),
								pos:contextPos
							});
						}
						
						if (isStoreGetters) {
							getterAssignments.push( macro untyped d.$addFieldName = cls.$fieldName );
						}
						else {
							getterAssignments.push( macro untyped d[ns + $v{addFieldName+clsSuffix}] = cls.$fieldName );
						}
						
						if (!isStoreGetters) {
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
						
					}
				default:
					
			}
			
			
		}
		
		var dynType:ComplexType = DYNAMIC_T;
		var strType:ComplexType = MacroStringTools.toComplex("String");
		
		var initBlock:Array<Expr> = [];
		if (!isBase) {
			if (isStoreGetters) initBlock.push( macro super._SetInto(d) );
			else  initBlock.push( macro super._SetInto(d, ns) );
		}
		
		var cls1 = Context.getLocalClass().toString();
		
		initBlock.push(macro {
			var cls:Dynamic = untyped $p{cls1.split('.')};
		});
		
		
		for ( i in 0...getterAssignments.length) {
			initBlock.push ( getterAssignments[i] );
		}
		
		
		fieldsToAdd.push({
			name:"_SetInto",
			kind: FieldType.FFun({
				args: isStoreGetters ? [{name:"d", type:dynType}] :  [{name:"d", type:dynType},{name:"ns", type:strType }],
				ret:null,
				expr: macro $b{initBlock}
			}),
			access: isBase ?  [Access.APublic] : [Access.APublic, Access.AOverride],
			pos:contextPos
		});
		
		
		return fields.concat(fieldsToAdd);
	}
	
	static function getInterfaceTypParamsFrom(array:Array<{ t : haxe.macro.Ref<haxe.macro.ClassType>, params : Array<haxe.macro.Type> }>):Array<Type> {
		for ( i in 0...array.length) {
			if ( MODULE_INTERFACES.exists( array[i].t.toString() )  ) return array[i].params;
		}
		return null;
	}
	
	static var MODULE_CLASSES:StringMap<Bool> = [
		"haxevx.vuex.core.VModule" => true,
		"haxevx.vuex.core.VxStore" => true,
	];
	
	static var ILLEGAL_MODULE_FIELDNAMES:StringMap<Bool> = [
		"mutations" => true,
		"modules" => true,
		"actions" =>true,
	];
	
	static var MODULE_INTERFACES:StringMap<Bool> = [
		"haxevx.vuex.core.IModule" => true,
		"haxevx.vuex.core.IStore" => true,
		"haxevx.vuex.core.IStoreGetters" => true,
		"haxevx.vuex.core.IGetters" => true,
		
		"haxevx.vuex.core.IMutator" => true,
		"haxevx.vuex.core.IAction" => true,
	];
	
	
	static function getModuleStateTypes(cls:ClassType):Array<ComplexType> {
		
		while ( cls != null) {
		
			var params =  cls.superClass != null && MODULE_CLASSES.exists(cls.superClass.t.get().module) ?  cls.superClass.params : getInterfaceTypParamsFrom(cls.interfaces);
			if ( params != null ) {
				//trace( TypeTools.follow(params[0]) );
				//trace(params);
				return params.length >= 2 ? [TypeTools.toComplexType(params[0]), TypeTools.toComplexType(params[1])] : [TypeTools.toComplexType(params[0]),NONE_T ];
			}
			cls = cls.superClass.t.get();
		}
		
		return null;
	}
	
	 static function getComplexTypeFromField(field:Field):ComplexType {
	
		switch(field.kind) {
			case FieldType.FVar(t, _):
				return t;
			case FieldType.FProp(_, set, t):
				return t;
			default:
				Context.error("Failed to resolve auto-instantiatable getComplexTypeFromField:" + field.name, field.pos);
		}

		return  null;
	}
	
	public static function autoInstantiateNewExprOf(field:Field):Expr {
		var iName2:String;
		var iPack2:Array<String>;
		switch(field.kind) {
			case FieldType.FVar(TPath({name:iName, pack:iPack}), _):
				iName2 = iName;
				iPack2 = iPack;
			case FieldType.FProp(_, set, TPath({name:iName, pack:iPack})):
				iName2 = iName;
				iPack2 = iPack;
			default:
				Context.error("Failed to resolve auto-instantiatable module type:" + field.name, field.pos);
		}

		return  { expr:ExprDef.ENew({name:iName2 , pack:iPack2}, []), pos:field.pos };
	}
	
	static function singletonSetNewExprOf(field:Field):Expr {
		#if  !(production || skip_singleton_check )
			return macro haxevx.vuex.core.Singletons.setAsSingleton($e{autoInstantiateNewExprOf(field)});
		#else
			return autoInstantiateNewExprOf(field);
		#end
	}
	
	static var NONE_T:ComplexType = MacroStringTools.toComplex( "haxevx.vuex.core.NoneT" );
	static var ANY_T:ComplexType = MacroStringTools.toComplex( "Dynamic" );
	static var DYNAMIC_T:ComplexType = MacroStringTools.toComplex( "Dynamic" );
	/**
	 * Generic method to generate store/module parameters
	 * @param isRoot	Flag to indicate root store
	 * @return
	 */
	macro public static function buildVModuleGetters(isRoot:Bool=false):Array<Field> {
		var fields = Context.getBuildFields();
		
		var localClasse = Context.getLocalClass().get();
		if ( MODULE_CLASSES.exists(localClasse.module) ) {
			return fields;
		}
		
		

		var isBase:Bool = localClasse.superClass == null ||  MODULE_CLASSES.exists( localClasse.superClass.t.get().module);

		var noneT:ComplexType = NONE_T;//  MacroStringTools.toComplex(NONE_T);
		
		
		var stateTypes:Array<ComplexType> = getModuleStateTypes(Context.getLocalClass().get());
		var moduleStateTypeMatch:Array<ComplexType> = [ANY_T, stateTypes[1]];
		var cls1 = Context.getLocalClass().toString();
		
		MODULE_TYPE_PARAMS.set(cls1, stateTypes);
		
	
		var contextPos:Position = Context.currentPos();

		var fieldsToAdd:Array<Field> = [];
		
		var alreadyDeclaredGetters:StringMap<Bool> = new StringMap<Bool>();
		
		for (field in fields) {
			if (ILLEGAL_MODULE_FIELDNAMES.exists(field.name)) {
				Context.error("Illegal fieldname used: " + field.name, field.pos);
			}
			if (field.access.indexOf(Access.AStatic) >= 0) {
				continue;
			}
			switch( field.kind ) {
				case FieldType.FProp("get", "never", _, _):
					if (!isRoot) alreadyDeclaredGetters.set(field.name, true);
					else Context.error("Root getters should be using read (default)", field.pos);
				case FieldType.FProp("default", "never", _, _):
					if (isRoot) alreadyDeclaredGetters.set(field.name, true);
					else Context.error("Module getters should be using read (get)", field.pos);
				default:
					
			}
		}
		
		var getterAssignments:Array<Expr> = [];
		var moduleAssignments:Array<Expr> = [];
		var mutationAssignments:Array<Expr> = [];
		var actionAssignments:Array<Expr> = [];
		var constructorFieldExpr:Expr;
		var constructorFieldPos:Position;
		
		var rootGettersField:Field = null;


		
		for (field in fields) {
			if (field.access.indexOf(Access.AStatic) < 0) {
				
				switch(field.kind) {
					case FieldType.FFun(f):
						if (field.name == "_new" || field.name == "new") {
							// constructor found
							constructorFieldExpr = f.expr;
							constructorFieldPos = field.pos;
							continue;
						}
					default:
						if ( field.name == "getters") {
							if (isRoot) {
								switch(field.kind) {
									case FieldType.FProp("default", "never", _, _):
										
									default:
										Context.error("Getters field type for store should be getters(default,never)", field.pos);
								}
								/*
								if (!isMatchingStateTypePairs(getStateTypesOf(getComplexTypeFromField(field)), stateTypes) ) {
									Context.warning("State type mismatch:", field.pos);
								}
								*/
							
								rootGettersField = field;
							}
							else {
									Context.error("getters field not allowed in modules", field.pos);
							}
							
						}
						else if (hasMetaTag(field.meta, ":module")) {
					
							var fieldName:String = field.name;
							/*
							if (!isMatchingStateTypePairs(getStateTypesOf(getComplexTypeFromField(field)), moduleStateTypeMatch) ) {
								Context.warning("State type mismatch:"+stateTypes, field.pos);
							}
							*/
							
							if (!hasMetaTag(field.meta, ":manual")) {
					
								
								
								moduleAssignments.push( macro {
									
									if (this.$fieldName  == null) {
										this.$fieldName = $e{autoInstantiateNewExprOf(field)}
										
								   }
								});
							}
							moduleAssignments.push( macro {
								
								if (this.$fieldName != null) {
									untyped d.$fieldName  = this.$fieldName;
									this.$fieldName._Init(ns + $v{fieldName+"/"}  );  	
								}
								
							});
						}
						else if (hasMetaTag(field.meta, ":getter")) {
							/*
							if (!isMatchingStateTypePairs(getStateTypesOf(getComplexTypeFromField(field)), stateTypes) ) {
								Context.warning("State type mismatch:"+stateTypes, field.pos);
							}
							*/
							getterAssignments.push( macro  $e{autoInstantiateNewExprOf(field)}._SetInto(untyped d, untyped useNS) );
						}
						
				}
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
						

						
						
						fieldsToAdd.push( {
							name:"get_" + addFieldName,
							kind: FieldType.FFun({
								args:[],
								ret:f.ret,
								expr: macro return untyped this._stg[_ +$v{addFieldName}] //$i{fieldName}(state)
							}),
							pos:contextPos
						});
						
						getterAssignments.push( macro untyped d[useNS+$v{addFieldName}] = cls.$fieldName );
						
					}
				default:
				
					
					if (hasMetaTag(field.meta, ":mutator")) {
						var stateTypesExpr = getStateTypesOf(getComplexTypeFromField(field));
						//trace(stateTypesExpr[0]);
						//trace( ComplexTypeTools.toType( stateTypesExpr[0]  ));
						
						//trace(getStateTypesOf(getComplexTypeFromField(field)));
						//if (!isMatchingStateTypePairs(getStateTypesOf(getComplexTypeFromField(field)), moduleStateTypeMatch) ) {
						//	Context.warning("State type mismatch:"+stateTypes, field.pos);
						//}
					
						if (hasMetaTag(field.meta, ":useNamespacing")) {
							mutationAssignments.push( macro  $e{singletonSetNewExprOf(field)}._SetInto(untyped d, untyped ns ) );
						}
						else {
							mutationAssignments.push( macro  $e{singletonSetNewExprOf(field)}._SetInto(untyped d, "") );
						}
					}
					else if (hasMetaTag(field.meta, ":action")) {
						//if (!isMatchingStateTypePairs(getStateTypesOf(getComplexTypeFromField(field)), moduleStateTypeMatch) ) {
						//	Context.warning("State type mismatch:"+stateTypes, field.pos);
						//}
						if (hasMetaTag(field.meta, ":useNamespacing")) actionAssignments.push( macro  $e{singletonSetNewExprOf(field)}._SetInto(untyped d, untyped ns ) );
						else {
							actionAssignments.push( macro  $e{singletonSetNewExprOf(field)}._SetInto(untyped d, "") );
						}
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
		if (isBase) {
			initBlock.push( macro if (this.state != null) untyped this.state._ = ns else untyped this.state = {_:ns} );
			
		}
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
		
	
		
		
		
		initBlock.push(macro {
			
			var cls:Dynamic = untyped $p{cls1.split('.')};
			var clsP:Dynamic = cls.prototype;
			var key:String;
			var d:String;
			
		});
		

		
		if (getterAssignments.length != 0 || rootGettersField != null) {
			if ( isBase) initBlock.push( macro { 
				untyped d = {};
				untyped this.getters = d;
			
			} );
			else initBlock.push( macro var d  = untyped this.getters  );
			
			
			if (rootGettersField != null) {
				var fieldName = rootGettersField.name;
				
				initBlock.push( macro  $e{autoInstantiateNewExprOf(rootGettersField)}._SetInto(untyped d) );
			}

			for ( i in 0...getterAssignments.length) {
				initBlock.push ( getterAssignments[i] );
			}
		}
		

	
		// TODO: check mutation/module type assignments with state
		if (mutationAssignments.length != 0) {
			if ( isBase) initBlock.push( macro { 
				untyped d = {};
				untyped this.mutations = d;
			} );
			else initBlock.push( macro untyped d  = untyped this.mutations  );
			for ( i in 0...mutationAssignments.length) {
				initBlock.push ( mutationAssignments[i] );
			}
		}

		if (actionAssignments.length != 0) {
			if ( isBase) initBlock.push( macro { 
				untyped d = {};
				untyped this.actions = d;
			} );
			else initBlock.push( macro untyped d  = untyped this.actions  );
			for ( i in 0...actionAssignments.length) {
				initBlock.push ( actionAssignments[i] );
			}
		}
	
		if (moduleAssignments.length != 0) {
			
			// TODO: check module type assignments with state
			if ( isBase) initBlock.push( macro { 
				untyped d = {};
				untyped this.modules = d;
			} );
			else initBlock.push( macro untyped d  = untyped this.modules  );
			for ( i in 0...moduleAssignments.length) {
				initBlock.push ( moduleAssignments[i] );
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
		
		if (isBase) {
			fieldsToAdd.push({
				name:"_InjNative",
				kind: FieldType.FFun({
					args:[{name:"g", type:MacroStringTools.toComplex("Dynamic") }],
					ret:null,
					expr: macro {
						untyped this._stg = g;
					}
				}),
				access: [Access.APublic, Access.AInline],
				pos:contextPos
			});
			
			// Call Init from constructor if required

			// inject _Init() call into constructor
			if (isRoot) {
				if (constructorFieldExpr != null) {
					switch( constructorFieldExpr.expr) {
						case EBlock(exprs):
							exprs.push(macro _Init(""));
						default:
							Context.error("Failed to resolve constructor field expr type: " + constructorFieldExpr.expr, constructorFieldPos);
					}
				}
				else {  // add public constructor with _Init() call
					fields.push(  { name: "new", kind:FieldType.FFun({args:[], ret:null, expr:macro _Init("") }) , pos:contextPos } );
				
				}
			}
		
		}
		
		
		
		return fields.concat(fieldsToAdd);
	}
	
	static function isMatchingStateTypePairs(pair1:Array<ComplexType>, pair2:Array<ComplexType>):Bool {
	
		return ( ( isEqualComplexTypes(pair1[0], ANY_T) || isEqualComplexTypes(pair2[0], ANY_T)) || isEqualComplexTypes(pair1[0], pair2[0]) ) 
		&& (   ( isEqualComplexTypes(pair1[1], ANY_T) || isEqualComplexTypes(pair2[1], ANY_T))  || isEqualComplexTypes(pair1[1], pair2[1])  );
	
	}
	
	static function getClassNameOf(clsType:ClassType):String {
		var str:String = clsType.module;
		var className:String = clsType.name;
		var moduleStack:Array<String> = str.split(".");
		
		if (className != moduleStack[moduleStack.length-1]) {
			moduleStack.pop();
			moduleStack.push(className);
		}
		return  moduleStack.join(".");
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

		static function getClassNamespaceOf(clsType:ClassType):String {
		var str:String = clsType.module;
		var className:String = clsType.name;
		var moduleStack:Array<String> = str.split(".");
		
		if (className != moduleStack[moduleStack.length-1]) {
			moduleStack.pop();
			moduleStack.push(className);
		}
		return  moduleStack.join("_") + "|";
	}
	
	static function getStateTypesOf(complexType:ComplexType):Array<ComplexType> {
		var type:String = getClassNameFromType(complexType) ;
		
		var result =  MODULE_TYPE_PARAMS.get(type);
		if (result == null) {
			if ( result == null) trace("Exception:: Failed to get result for type:" + type + " attempting recovery.." );
			result = getModuleStateTypes(getClassTypeFromType(complexType));
			MODULE_TYPE_PARAMS.set(getClassNameFromType(complexType), result);
		}
	
		return result;
	}
	
	
	
	static function getClassNameFromType(complexType:ComplexType):String {
		var type:Type = ComplexTypeTools.toType(complexType);
		switch(type) {
			case TInst(t, params):
				return t.toString();
			default:
				Context.error("getClassNameFromType :: failed to resolve type", Context.currentPos());
		}
		return null;
	}
	
	static function getClassTypeFromType(complexType:ComplexType):ClassType {
		var type:Type = ComplexTypeTools.toType(complexType);
		switch(type) {
			case TInst(t, params):
				return t.get();
			default:
				Context.error("getClassTypeFromType :: failed to resolve type", Context.currentPos());
		}
		return null;
	}
	
	static function getClassNamespaceFor(clsType:ClassType, fieldName:String):String {
		var type:String;
		
		var t:ClassType = clsType;
		while ( t != null) {
			type = getClassNameOf(t);
			var theMap:StringMap<Bool> = DISPATCH_STRINGS.get(type);
			if (theMap == null){
				trace("getClassNamespaceFor :: Exception ERROR couldn't find theMap");
				Context.error("getClassNamespaceFor :: Exception ERROR couldn't find theMap", Context.currentPos());
			}
			if ( theMap.get(fieldName) ){
				
				return  type.split(".").join("_") + "|";
			}
			t =t.superClass.t.get();
		}
		
		return null;
	}

	

	
	static function ensureNoReturn(e:Expr):Void {
		  switch(e.expr) {
			case ExprDef.EReturn({expr:_, pos:pos }):
				Context.fatalError("If got 'return', need to supply return data type explicitly for action/mutator function", pos);
			case _:	 
		}
	}
	
	 static function buildActionCalls(prefix:String, fields:Array<Field>, commitString:String, isActionContext:Bool):Array<Field>  {

		var fieldsToAdd:Array<Field> = [];
		var contextPos:Position = Context.currentPos();

		
		var classeNamespace:String = getClassNamespace();

		var isBase:Bool = Context.getLocalClass().get().superClass == null;
		var actionAssignments:Array<Expr> = [];
		var gotConstructor:Bool = false;
		var constructorFieldExpr:Expr;
		var constructorFieldPos:Position;
		
		var singletonFields:Array<Field> = [];
		
		var cls1 = Context.getLocalClass().toString();
		var theMap:StringMap<Bool> = DISPATCH_STRINGS.exists(cls1) ? DISPATCH_STRINGS.get(cls1) : null;
		if (theMap == null) {
			theMap = new StringMap<Bool>();
			DISPATCH_STRINGS.set(cls1, theMap);
		}
		var stateTypes:Array<ComplexType> = getModuleStateTypes(Context.getLocalClass().get());
		MODULE_TYPE_PARAMS.set(cls1, stateTypes);
		
		for (field in fields ){
			if (field.access.indexOf(Access.AStatic) >= 0) {
				if (hasMetaTag(field.meta, ":mutator") || hasMetaTag(field.meta, ":action"))  {
					singletonFields.push(field);
				}
				continue;
			}
			
			switch(field.kind) {
				case FieldType.FFun(f):
					
					if (field.name == "_new" || field.name == "new") {
						// constructor found
						constructorFieldExpr = f.expr;
						gotConstructor = true;
						
						constructorFieldPos = field.pos;
						if (field.name == "_new") {
							field.name = "new";
							field.access = [Access.APublic];
							//field.access = [Access.APublic];
						}
						continue;
					}
				
					if (field.access.indexOf(Access.APublic) >= 0) {
						Context.error("Functions in mutator/action classes cannot be public: "+field.name, field.pos);
					}
					
				
				
						var namespacedValue:String = (field.access.indexOf(Access.AOverride) >= 0 ? getClassNamespaceFor( Context.getLocalClass().get().superClass.t.get(), field.name)  : classeNamespace) + field.name;
					var fieldName:String = field.name;
					actionAssignments.push( macro { untyped d[ns + $v{namespacedValue}] = clsP.$fieldName; }  );
					
					if (field.access.indexOf(Access.AOverride) >= 0) {  // deemed to inherit namespace
						continue;
					}
					
					
					
					if (f.args.length == 0) {
						Context.error("Functions in mutator/action classes need at least 1 parameter for state/context: "+field.name, field.pos);
						
					}
					if (f.args.length > 2) {
						Context.error("Functions in mutator/action classes can have max 2 parameters at the most: "+field.name, field.pos);	
					}
					
					namespacedValue = classeNamespace + field.name;
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
		
					var contextType:ComplexType = ComplexType.TPath({pack:["haxevx", "vuex", "core"], name:"IVxContext", params:[] });
					var contextArg:FunctionArg = {
						name: "context",
						type:  contextType
						
					};
					
					// commit/dispatch options + namespacings
					var contextType:ComplexType = ComplexType.TPath({pack:["haxevx", "vuex", "core"], name:"IVxContext", params:[] });
					var contextArg:FunctionArg = {
						name: "context",
						type:  contextType
						
					};
										
					var optionsArg:FunctionArg = {
						name: "opts",
						type:  isActionContext ? ComplexType.TPath({pack:["haxevx","vuex","native"], name:"DispatchOptions" })  :  ComplexType.TPath({pack:["haxevx","vuex","native"], name:"CommitOptions" }),
						opt: true
					};
					
					var useNamespacingArg:FunctionArg = {
						name: "useNamespacing",
						type:  MacroStringTools.toComplex("Bool"),
						//opt: true,
						value: macro $v{false}
					};
					
					var namespaceArg:FunctionArg = {
						name: "ns",
						type:  MacroStringTools.toComplex("String"),
						//opt: true,
						value: macro $v{""}
					};
					
					// todo: ensure IVxContext should be args[0]. IVxContext type param  should resolve to target store's state data type.
				
					var commitString2:String =  commitString + "2";
					if ( gotRetType && !isActionContext) {
						Context.warning("Mutation context handlers should not have return value!", field.pos);
					}
					
		
					// commit/dispatch options + namespacings
					if (gotRetType) {
						funcExpr = payload != null ?   macro { return haxevx.vuex.core.Boiler.$commitString2(context, $v{namespacedValue}, payload, opts, useNamespacing, ns);  }  
						: macro { return haxevx.vuex.core.Boiler.$commitString2(context, $v{namespacedValue}, null, opts, useNamespacing, ns);  } ;
					}
					else {
						funcExpr = payload != null ?   macro {  haxevx.vuex.core.Boiler.$commitString(context, $v{namespacedValue}, payload, opts, useNamespacing, ns);  }
						:  macro {  haxevx.vuex.core.Boiler.$commitString(context, $v{namespacedValue}, null, opts, useNamespacing, ns);  } ; 
					}


					
	
					
					theMap.set(field.name, true);
					
					///*
					fieldsToAdd.push( {
						name: prefix + field.name,
						access: [Access.APublic, Access.AInline],
						kind: FieldType.FFun({ params:f.params, ret:f.ret, args: payload != null ? [contextArg, payload, optionsArg, useNamespacingArg, namespaceArg] : [contextArg, optionsArg, useNamespacingArg, namespaceArg], expr:funcExpr  }),
						pos: contextPos,
						meta:  [{name:"ignore", pos:contextPos}] // todo: likely temp for now...
					});
					//*/
					
				default: 
					Context.error("Only private handler functions are allowed in mutator classes: "+field.name, field.pos);
			}
		}
		
		var dynType:ComplexType = DYNAMIC_T;
		var strType:ComplexType = MacroStringTools.toComplex("String");
		
		var initBlock:Array<Expr> = [];
		/*
		if (!isBase) {
			initBlock.push( macro super._SetInto(d, ns) );
		}
		*/
		

		
		initBlock.push(macro {
			var cls:Dynamic = untyped $p{cls1.split('.')};
			var clsP:Dynamic = cls.prototype;
		});
		
		
		for ( i in 0...actionAssignments.length) {
			initBlock.push ( actionAssignments[i] );
		}
		

	
		if (singletonFields.length > 0) {
			if (isActionContext) {
				#if  !(production || skip_singleton_check )
				for (f in singletonFields) {
					
					initBlock.push( macro haxevx.vuex.core.Singletons.addLookup( haxevx.vuex.core.Singletons.getClassNameOfInstance($e{autoInstantiateNewExprOf(f)}), $v{cls1} ) );
				}
				#end
			}
			else {
				Context.error("Singleton mutator/action fields not allowed in Mutator classes", singletonFields[0].pos);
			}
		}
	
		
		fieldsToAdd.push({
			name:"_SetInto",
			kind: FieldType.FFun({
				args:   [{name:"d", type:dynType},{name:"ns", type:strType }],
				ret:null,
				expr: macro $b{initBlock}
			}),
			access: isBase ?  [Access.APublic] : [Access.APublic, Access.AOverride],
			pos:contextPos
		});
		
		if (!gotConstructor) {
				fields.push(  { access:[Access.APublic], name: "new",  kind:FieldType.FFun({args:[], ret:null, expr:(!isBase ? macro { super(); } : macro null) }) , pos:Context.getLocalClass().get().pos } );
		}
	
		return fields.concat(fieldsToAdd);

	}
	// THis is rather hackish and may not be future-proof.
	// is this the "right" way to compare  pattern enums? oh well..
	static inline function isEqualComplexTypes(a:ComplexType, b:ComplexType):Bool {
		return ComplexTypeTools.toType(a) + "" == ComplexTypeTools.toType(b) + "";
	}
	
	#end
	
	/*
	public static macro function commit(context:ExprOf<IVxContext>, type:ExprOf<String>, ?payload:ExprOf<Dynamic>, ?opts:ExprOf<CommitOptions>, useNamespacing:ExprOf<Bool>, ns:ExprOf<String>):Expr {

		return macro { haxevx.vuex.core.Boiler.commit( ${context}, ${type}, ${payload}, ${opts}, ${useNamespacing}, ${ns} ); };
	}
	
	public static macro function dispatch(context:ExprOf<IVxContext>, type:ExprOf<String>, ?payload:ExprOf<Dynamic>, ?opts:ExprOf<DispatchOptions>, useNamespacing:ExprOf<Bool>, ns:ExprOf<String>):Expr {
	
		
		return macro { haxevx.vuex.core.Boiler.dispatch( ${context}, ${type}, ${payload}, ${opts}, ${useNamespacing}, ${ns} ); };
	}
	public static macro function dispatch2(context:ExprOf<IVxContext>, type:ExprOf<String>, ?payload:ExprOf<Dynamic>, ?opts:ExprOf<DispatchOptions>, useNamespacing:ExprOf<Bool>, ns:ExprOf<String>):Expr {
	
		return macro { return haxevx.vuex.core.Boiler.dispatch2( ${context}, ${type}, ${payload}, ${opts}, ${useNamespacing}, ${ns} ); };
	}
	*/
	
	
}





