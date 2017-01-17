package haxevx.vuex.core;
import haxe.macro.ComplexTypeTools;
import haxe.ds.StringMap;
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
 * ...
 * @author Glidias
 */
class VxMacros
{
	// TODO:
	//  ensure supplied default types with given default values! Type checking for prop default metadata!!
	// prop validator support
	
	
	static inline var FLAG_PROP_DEFAULTVAL_CUSTOM:Int = 1;
	static inline var FLAG_PROPSETTING_CUSTOM:Int = 2;
	
	macro public static function buildComponent():Array<Field>  {
		var fields = Context.getBuildFields();
		
		
		var classModule:String = Context.getLocalClass().get().module;
		if (classModule == "haxevx.vuex.core.VxComponent"  || classModule == "haxevx.vuex.core.VComponent") return fields;
	
	
		var funcLookup:StringMap<Function> = new StringMap<Function>();
		var watchableFields:StringMap<ComplexType> = new StringMap<ComplexType>();
		var classTypeParams  = Context.getLocalClass().get().superClass.params;
		var typeParamData:Type;
		var typeParamProps:Type;
		var typeParamStore:Type = null;
		var retTypeStore:ComplexType = null;
	
		
		
		if (classTypeParams.length == 3) {  // assumed extending VxComponent
			typeParamStore = TypeTools.follow( classTypeParams[0] );
			typeParamData = classTypeParams[1];
			typeParamProps = classTypeParams[2];
			switch( typeParamStore) {
				case TInst(t, params):
					retTypeStore = MacroStringTools.toComplex( t.get().module);
					if (retTypeStore == null) {
						Context.fatalError("Could not resolve store data by path: " +  t.get().module, Context.getLocalClass().get().pos);
					}
					//trace( t.get(). );// .getParameters()[0];
					//trace();
				default: 
					Context.fatalError("Could not resolve store data type: " + typeParamStore, Context.getLocalClass().get().pos);
			}
		}
		else {  // assumed extending VComponent
			typeParamData = classTypeParams[0];
			typeParamProps = classTypeParams[1];
		}
		
		var fg;
		var requireProps:Bool = false;
		var requireData:Bool = false;
		//var fieldsToAdd:Array
		
		var propFieldsToAdd:StringMap<ClassField> = null;
		var dataFieldsToAdd:Array<ClassField> = null;
		
		var cls1 = Context.getLocalClass().toString();
		var initBlock:Array<Expr> = [];
		var injectBlock:Array<Expr> = [];
		var computedAssignments:Array<FieldExprPair> = [];
		var propAssignments:Array<FieldExprPair> = [];
		var propHash:StringMap<Bool> = new StringMap<Bool>();
		var methodAssignments:Array<FieldExprPair> = [];
		var watchAssignments:Array<FieldExprPair> = [];
		var setWatches:StringMap< Bool> = new StringMap<Bool>();
		//var data
		
		switch ( fg=TypeTools.follow(typeParamData) ) {
			case TInst(t, params):		
				requireData = t.get().name != "NoneT";
				if (requireData) dataFieldsToAdd = getClassFieldArrayToAdd( t.get().fields.get(), watchableFields );
			case Type.TAnonymous(a):
				requireData = true;
				dataFieldsToAdd  = getClassFieldArrayToAdd( a.get().fields, watchableFields );
				
			default:
				Context.fatalError("Type not supported for Data (class, interface or typedef only):" + fg, Context.currentPos() );
		}
		
		switch ( fg=TypeTools.follow(typeParamProps) ) {
			case Type.TInst(t, params):
				requireProps = t.get().name != "NoneT";
				
				if (requireProps) {
					propFieldsToAdd = classFieldArrayToStrMap( t.get().fields.get(), watchableFields );
				}
				
			case Type.TAnonymous(a):
				requireProps = true;
				propFieldsToAdd = classFieldArrayToStrMap(  a.get().fields, watchableFields);
			//case Type.TAbstract(t, params):
				//requireProps = true;
				
			default:
				Context.fatalError("Type not supported for Props (class, interface or  typedef only):" + fg, Context.currentPos() );
				
		}

		//Context.getClassPath();
		var noneTC:ComplexType =   MacroStringTools.toComplex("haxevx.vuex.core.NoneT");
		var noneT:Type = ComplexTypeTools.toType(noneTC);
		if (noneT == null) Context.error("Could not resolve macro NoneT", Context.currentPos() );
		
		
		
		for (field in fields) {
			switch (field.kind)
			{
				case FieldType.FFun(f):
					if (field.name.indexOf("get_") == 0) {
						funcLookup.set( field.name.substr(4), f);
					}
				case FieldType.FProp("get", "set", t):
					watchableFields.set(field.name, t);
				case FieldType.FProp("get", "never", t):
					watchableFields.set(field.name, t);
				default:
				//	trace(field.kind);
			}
		}
		
		var gotGetData:Bool = false;
		var constructorFieldExpr:Expr;
		var constructorFieldPos:Position;
		var metadataEntry:MetadataEntry;
		var propSettingFlags:Int = 0;
		var propSettingKVs:Array<FieldExprPair> = null;
		var propDefaultValueKVs:Array<FieldExprPair> = null;
		
		for ( i in 0...fields.length)
		{
			
			var field = fields[i];
			if (  field.access.indexOf( Access.AStatic) >= 0 ) {
				

				
				continue;
			}
			if (reservedCompFieldNames.exists(field.name)) {  //  todo note: this check can be foregoed for explicit Vue instances (ie. non components)
				Context.error("Field name: " + field.name + " is reserved for comp definition.", Context.currentPos());
			}
			if (field.name.charAt(0) == "_") {
				if (field.name.charAt(1) != "_") {
					Context.error("Field names cannot start with a single underscore.", field.pos);
					continue;
				}
				continue;
			}
			
			switch (field.kind)
			{
				
			
				case FProp(pget, pset, getType, _):
							
					if (field.name == "store") {
						continue;
					}
					
					//field.
					var name = field.name;// formatName(field.name);
					var indexer:Int;
					
					var gotSetter:Bool = false;
					// assume there is always a getter
					if (pget == "get" && ( pset == "never" || pset == "set") ) {
						if ( (indexer=field.access.indexOf( Access.APublic)) <0 ) {
							// ok, do nothing
						}
						else {
							Context.warning("Computed getter field: '" + field.name+"' should not be public.", field.pos) ;
							field.access = field.access.splice(indexer, 1);
						}
						gotSetter = pset == "set";
					}
					else {
						//trace("GG2:"+field.name);
						Context.warning("Computed field: '" + field.name+"' needs to adopt [(get)/(set/never)] convention..(ie. non physical)", field.pos );
					}
					
					if ( hasMetaTag(field.meta, "mapGetterProp") ) {
						trace("TODO: mapGetterProp implementation");
						break;
					}
					
					// Add fields  as type matches getter function return type
					var func:Function = funcLookup.get(name);
					
					if (func != null) {
						if ( !isEqualComplexTypes(func.ret, getType)  ) { 
							Context.error("Field types for computed property must match getter method: "+name, field.pos);
						}
						
						field = fields[i] =  {
						  name:  name,
						  access: [Access.APrivate],
						  kind: FieldType.FProp("default", (gotSetter ? "set" : "never"), func.ret),   // let haxe use default set_method call instead, might as well...
						  pos: field.pos,
						  doc: field.doc,
						  meta: field.meta
						};
						if (field.meta == null) field.meta = new Metadata();
						
						
						if (!gotSetter) {
							var fName:String = "get_"+field.name;
							computedAssignments.push({field:field.name, expr:macro clsP.$fName } );
						}
						else {
							var fName:String = "get_" + field.name;
							var fName2:String = "set_" + field.name;
							computedAssignments.push( { field:field.name, expr: macro ${ {expr:EObjectDecl([{field:"get", expr:macro clsP.$fName}, {field:"set", expr:macro clsP.$fName2}]), pos:field.pos} }  } );
						}
					
					}
				case FieldType.FVar(t, e):
					//field.meta.
					if (!hasMetaTag(field.meta, "mapGetterProp")) Context.error("Components not allowed to declare member variables", field.pos)
					else {
						trace("TODO: mapGetterProp implementation");
					}
					
					
				//	TypeTools.
					//TPType
					//Context.error("Variable declarations not allowed for Component", field.pos);
				case FieldType.FFun(f):
					#if !fastcompile 
						ExprTools.iter( f.expr, checkIllegalAccess); 
					#end
					if (field.name == "_new" || field.name == "new") {
						// constructor found
						constructorFieldExpr = f.expr;
						constructorFieldPos = field.pos;
						continue;
					}
					if (field.name == "Data") {
						gotGetData = true;
					}
					
					if ( illegalReferences.exists(field.name) ) {
						
						if (field.name == "Components") {
							f.expr = ExprTools.map(f.expr, checkReturnStrMap);
						}
						else if (field.name == "GetDefaultPropSettings") {
							propSettingFlags |= FLAG_PROPSETTING_CUSTOM;
							switch( f.expr.expr) {
								case ExprDef.EBlock([{expr:EReturn({expr:EObjectDecl(kvs), pos:_} ), pos:_}]):
									propSettingKVs = kvs;
								default:
									
							}
						}
						else if (field.name == "GetDefaultPropValues") {
							propSettingFlags |= FLAG_PROP_DEFAULTVAL_CUSTOM;
							switch( f.expr.expr) {
								case ExprDef.EBlock([{expr:EReturn({expr:EObjectDecl(kvs), pos:_} ), pos:_}]):
									propDefaultValueKVs = kvs;
								default:
									
							}
						}
						addMethodHookToInitBlock(field.name, initBlock);
						
						
					}
					else if ( (metadataEntry = getMetaTagEntry(field.meta, ":watch")) != null) {
						
						if (field.access.indexOf(Access.APublic) >= 0) {
							Context.error("Watcher fields must be private", field.pos);
						}
						
						var mFieldName:String = metadataEntry.params != null  && metadataEntry.params.length != 0 ?  getMetaStrValueFromExpr(metadataEntry.params[0], metadataEntry.params.length == 1 ? field.name.split("_").pop() : null) : field.name.split("_").pop();
						
						
						if (mFieldName == null || !watchableFields.exists(mFieldName)) {
							
							Context.fatalError("Could not find watchable field (data/computed/props): " + mFieldName, field.pos);
						}
						
						if (setWatches.exists(mFieldName)) {
							Context.fatalError("Duplicate watch field target detected: " + mFieldName, field.pos);
						}
						
						
						if (f.args.length == 0 || f.args.length > 2) {
							Context.fatalError("Watcher methods need 1 or 2 arguments: " + field.name, field.pos);
						}
						
						if (f.args.length == 2 && !isEqualComplexTypes(f.args[0].type, f.args[1].type) ) {
							Context.fatalError("Watcher method parameter types must match: " + field.name, field.pos);
						}
						
						if ( !isEqualComplexTypes(f.args[0].type, watchableFields.get(mFieldName)) ) {
							Context.fatalError("Watcher method parameter type(s) must match against target field: "+f.args[0].type + " vs " +watchableFields.get(mFieldName), field.pos);
						}
					
						
						var existingObjDeclArr:Array<FieldExprPair> =  metadataEntry.params != null  && metadataEntry.params.length != 0  ? metadataEntry.params.length > 1 ?  getMetaObjArrFromExpr(metadataEntry.params[1]) :  getMetaObjArrFromExpr(metadataEntry.params[0]) : null;
						
						var methodName:String = field.name;
						
						if (existingObjDeclArr != null) {
							existingObjDeclArr.push( {field:"handler", expr:macro clsP.$methodName } );
							
							watchAssignments.push({field:mFieldName, expr:macro ${ {expr:EObjectDecl(existingObjDeclArr), pos:field.pos } } } );
						}
						else {
							watchAssignments.push({field:mFieldName, expr:macro clsP.$methodName } );
						}
						
						setWatches.set(mFieldName, true);
						
							
						// dup below
						if (field.name.charAt(0) != "_") {
							var fName:String = field.name;
							methodAssignments.push({field:field.name, expr:macro clsP.$fName } );
						}
					}
					else if (field.name.charAt(0) != "_") {
						var fName:String = field.name;
						methodAssignments.push({field:field.name, expr:macro clsP.$fName } );
					}
				default:
					//trace(field.name, field.kind);
				
			}
		}
		
		
		if (requireData && !gotGetData) {
			Context.fatalError("Component class with Data Type D requires Data() implementation", Context.getLocalClass().get().pos);
		}
		
		if (dataFieldsToAdd != null) {
			for (f in dataFieldsToAdd) {
				switch (f.kind) {
					
					case FieldKind.FVar(read, write):  // component always has full private read/write access to it's own data
						var p = Context.currentPos();
						if (read == VarAccess.AccCall || write == VarAccess.AccCall) {
							// suppress?
							//Context.warning("Field access not supported for data: "+read + ", "+write);
							// ^^ may allow access through .data accessor, even though it's reccomended practice to use plain data Objects for Vue
							continue;
						}
						fields.push({
							name: f.name,
							doc: f.doc,
							access: [Access.APrivate],
							pos: p ,
							kind:  FieldType.FProp("null", "null",  TypeTools.toComplexType( f.type) ),
							meta: [ {name:"_data", pos:p } ] // only add relavant metatag _data
						});
					default:
						// suppress?
						//Context.warning("Field type not supported for data: "+f.kind,f.pos);
						// ^^ may allow access through .data accessor, even though it's reccomended practice to use plain data Objects for Vue
				}
				
			}
		}
		
		// @mapGetterProp
		

	
		if (propFieldsToAdd != null) {

			
			for (f in propFieldsToAdd) {
					switch (f.kind) {
					
					case FieldKind.FVar(read, write):  // component always has only private read-only access to it's own props
						
						if (read == VarAccess.AccCall || write == VarAccess.AccCall) {
							// suppress?
							Context.fatalError("Field type for props cannot have get/set implementations ", f.pos);
							continue;
						}
						
						var p = Context.currentPos();
						propAssignments.push({field:f.name, expr:getPropMetadata(f.meta.get(), f.type, f.pos, p )});
						propHash.set(f.name, true);
						fields.push({
							name: f.name,
							doc: f.doc,
							access: [Access.APrivate],
							pos: p ,
							kind:  FieldType.FProp("null", "never",  TypeTools.toComplexType( f.type) )
						});
					default:
						// suppress?
						 Context.warning("Field type not supported for props: "+f.kind,f.pos);
				}
			}
		}
		
		
		// Set up _Init() generated macro
		var pos:Position = Context.currentPos();

		var isOverriding:Bool = Context.getLocalClass().get().superClass != null;
		
		
		// Call Init from constructor if required
		if (!isOverriding) {
			// inject _Init() call into constructor
			if (constructorFieldExpr != null) {
				switch( constructorFieldExpr.expr) {
					case EBlock(exprs):
						exprs.push(macro _Init());
					default:
						Context.error("Failed to resolve constructor field expr type: " + constructorFieldExpr.expr, constructorFieldPos);
				}
			}
			else {  // add public constructor with _Init() call
				fields.push(  { name: "new", kind:FieldType.FFun({args:[], ret:null, expr:macro _Init() }) , pos:pos } );
			
			}
		}
		
		if (computedAssignments.length != 0) {
			initBlock.push( macro  untyped this.computed = ${ {expr:EObjectDecl(computedAssignments), pos:pos} } );
		}
		if (methodAssignments.length != 0) {
			initBlock.push( macro  untyped this.methods = ${ {expr:EObjectDecl(methodAssignments), pos:pos} } );
		}
		if (propAssignments.length != 0) {
			initBlock.push( macro  untyped this.props = ${ {expr:EObjectDecl(propAssignments), pos:pos} } );
			if ((propSettingFlags & FLAG_PROPSETTING_CUSTOM) != 0) {
				// todo: does it return plain object as only statement? if so, can inline assignments
				if (propSettingKVs != null) {
					for (kv in propSettingKVs) {
						var k:String = kv.field;
						var v:Expr = kv.expr;
						
						if (!propHash.exists(k) ) {
							Context.warning("Unknown prop for VcPropSetting setting key: "+k, v.pos);
						}
						
						switch(v.expr) {
							case ExprDef.EObjectDecl(sFields): 
								for (vs in sFields) {
									var vsk:String = vs.field;
									var vsv:Expr = vs.expr;
									
									initBlock.push( macro untyped this.props.$k.$vsk = ${vsv}   );
								}
							case ExprDef.EConst(CIdent("null")):
								Context.warning("Null supplied for VcPropSetting. Will be ignored.", v.pos);
								//initBlock.push(macro untyped this.props.$k = $v);
							default:
						}
					}
				}
				else initBlock.push( macro haxevx.vuex.core.VxMacros.VxMacroUtil.dynamicSetPropSettingInto( (untyped this.props), GetDefaultPropSettings() )   );
			}
			if ((propSettingFlags & FLAG_PROP_DEFAULTVAL_CUSTOM) != 0) {
				if (propDefaultValueKVs != null) {
					for (kv in propDefaultValueKVs) {
						var k:String = kv.field;
						var v:Expr = kv.expr;
						initBlock.push( macro untyped this.props.$k["default"] = ${v} );
					}
				}
				else initBlock.push( macro haxevx.vuex.core.VxMacros.VxMacroUtil.dynamicSetPropValueInto( (untyped this.props), "default", GetDefaultPropValues() )   );
			}
		}
		if (watchAssignments.length != 0) {
			initBlock.push( macro  untyped this.watch = ${ {expr:EObjectDecl(watchAssignments), pos:pos} } );
		}
		

		
		var theInitExpr:Expr = macro {
			var cls:Dynamic = untyped $p{cls1.split('.')};
			var clsP:Dynamic = cls.prototype;
			$b{initBlock};
		};
		
		fields.push({
			name: "_Init",
			access: isOverriding ? [Access.APrivate, Access.AOverride] :  [Access.APrivate],
			pos: Context.currentPos() ,
			kind:  FieldType.FFun({ret:null, args:[], expr:theInitExpr } )
		});
		
		return fields;
	}
	
	// THis is rather hackish and may not be future-proof.
	// is this the "right" way to compare  pattern enums? oh well..
	static inline function isEqualComplexTypes(a:ComplexType, b:ComplexType):Bool {
		return ComplexTypeTools.toType(a) + "" == ComplexTypeTools.toType(b) + "";
	}
	
	
	
	static function getMetaStrValueFromExpr(xpression:Expr, defaultedValue:String):String {
		if (xpression == null) return defaultedValue;
		
		switch( xpression.expr) {
			case EConst(CString(s)):
				return s;
			case EObjectDecl(fields):
				
				 return getMetaStrValueFromExpr(findValueByName(fields, "name"), defaultedValue);  // a bit lazy here, will capture recursive values
			default:
				//trace(xpression.expr);
			
		}
		
		return null;
	}
	
	static function getMetaObjArrFromExpr(xpression:Expr):Array<FieldExprPair> {

		switch( xpression.expr) {
		
			case EObjectDecl(fields):
				return fields.concat([]);  // a bit lazy here, will capture recursive values
			default:
				return null;
			
		}
		
		return null;
	}
	
	
	static function findValueByName(arr:Array<FieldExprPair>, name:String):Expr {
		for ( f in arr) {
			if (f.field == name) {
				return f.expr;
			}
		}
		return null;
	}

	
	
	static  function getPropMetadata(metadata:Metadata, fldType:Type, fldPos:Position, p:Position):Expr {
		var list:Array<{field:String, expr:Expr}> = [];
		
		if (metadata != null) {
			for (m in metadata) {
				if (m.name == ":prop" && m.params!= null && m.params.length > 0 && m.params[0] != null)  {
					//{ pos:p, expr:m.params[0] };
					switch( m.params[0].expr) {
						case ExprDef.EObjectDecl(fields): 
							for (f in fields) {
								list.push( {field:f.field, expr:f.expr});
							}
						default:
							Context.fatalError("first parameter for metadata @prop must be Object or null!", fldPos);
					}
				}
			}
		}
		
		//
		var typeStr:String =  getTypeString(fldType, fldPos);
		
		if (typeStr != null ) {
			
			list.push({field:"type", expr:macro untyped __js__($v{typeStr}) });
		}
		
		return  {expr:ExprDef.EObjectDecl(list), pos:p};

	}
	
	static function getTypeString(type:Type, pos:Position):String {
		switch (type) {
			case Type.TDynamic(_):
					return null;
			case Type.TFun(_,_):
					return "Function";
			case TInst(t, _):
				//trace(tName);
				var tName:String = t.get().name;
				return tName != "String" && tName != "Array" ? "Object" : tName;
			//case Type.TType(t, params):
			case Type.TAnonymous(_):
				return "Object";
			case Type.TAbstract(t, _):
				var tName:String = t.get().name;
				return tName == "Float" || tName == "Int"  || tName == "UInt" ? "Number" : tName == "Bool" ? "Boolean" : "Object";
			default:
				Context.warning("todo: Not yet resolve given type atm: "+type, pos);
				return null;
		}
	}
	


	
	
	static function createStringSetFromArray(arr:Array<String>):StringMap<Bool> {
		var strMap:StringMap<Bool> = new StringMap<Bool>(); 
		for (str in arr) {
			strMap.set(str, true);
		}
		return strMap;
	}

	// override this register components locally
	 static var illegalReferences:StringMap<Bool> = {
		var strMap:StringMap<Bool> = createStringSetFromArray([
			"Created", "BeforeCreate", "BeforeDestroy", "Destroy", "BeforeMount", 
			"Mounted", "BeforeUpdate", "Updated", "Activated", "Deactivated",
			"El", "Data", "PropsData", "Render", "Template", "Components", "GetDefaultPropSettings", "GetDefaultPropValues"
		]);
		strMap;
	};
	
	
	
	static var reservedCompFieldNames:StringMap<Bool> = {
		var strMap:StringMap<Bool> = createStringSetFromArray([
			"created", "beforeCreate", "beforeDestroy", "destroy", "beforeMount", 
			"mounted", "beforeUpdate", "updated", "activated", "deactivated",
			"el", "data", "propsData", "render", "template", "components"
		]);
		strMap;
	};
	
	 static function checkIllegalAccess(e:Expr):Void {
	
		var errMsg:String = "Vue param keyword access is reserved: ";
		 switch(e.expr) {
			case ExprDef.EField((macro this), f):
				if (illegalReferences.exists(f)) Context.fatalError(errMsg + f, e.pos);
			case ExprDef.EConst(CIdent(f)): 
				if (illegalReferences.exists(f)) Context.fatalError(errMsg + f, e.pos);	
			case _:
				 ExprTools.iter(e, checkIllegalAccess);		
				 
		}
	}
	
	
	static function checkReturnStrMap(e:Expr):Expr {
	
		var errMsg:String = "Vue param keyword access is reserved: ";
		 switch(e.expr) {
			case ExprDef.EReturn({expr:EArrayDecl(values), pos:pos }):
				return convertStrMapToObjectSetup(values);
			
			case _:
				//trace(e.expr);
				return e;
				// ExprTools.iter(e, checkIllegalAccess);			 
		}
	}
	
	static function convertStrMapToObjectSetup(values:Array<Expr>):Expr {
		//var blockExpr:ExprDef.EBlock
		var statement:Expr =  macro var macroGeneratedObj = {};
		var initBlock:Array<Expr> = [];
		var fields:Array<{field:String, exprDef:ExprDef}> = [];
			//${ {expr:EObjectDecl(computedAssignments), pos:pos} }
		for (i in 0...values.length) {
			switch( values[i].expr ) {
				case EBinop(OpArrow, {expr:key, pos:keyPos }, {expr:value, pos:_}):
				//	trace(  Context.getPosInfos(keyPos) );
		
					switch( key) {
						case EConst(CString(keyStr)):
							fields.push({field:keyStr, exprDef:value } );
						default:
							Context.fatalError("Only accept string keys for String Map!", values[i].pos );
					}
				default:
					Context.fatalError("Couldn't resolve string map keys to ObjDecl! Please use OpArrow for String map!", values[i].pos );
					
			}	
		}
		
		var assignments = [for (f in fields) {
			var field_name:String = f.field;
			var val:Expr = {expr:f.exprDef, pos:Context.currentPos()};
			macro  haxevx.vuex.core.VxMacros.VxMacroUtil.dynamicSet(_m_, '$field_name', ${val}); // _m_.awfawff =  ${val};    
		}];
		
		var retExpr:Expr = macro {
			var _m_:Dynamic<VComponent<Dynamic,Dynamic>> = {};
			$b{assignments};
			return _m_;
		};
		return retExpr;
	}
	
	// for data
	static function getClassFieldArrayToAdd(arr:Array<ClassField>, watchableFields:StringMap<ComplexType>):Array<ClassField> {
		var refArr:Array<ClassField> = [];
		for (f in arr) {
			switch( f.kind) {
			
				case FVar(VarAccess.AccNormal, _):
					watchableFields.set(f.name, TypeTools.toComplexType(f.type));
					if (f.name.charAt(0) == "_") {	
						continue;
					}
					refArr.push(f);
					
				default:
					
			}
		}
		return refArr;
	}

	
	// for props
	static function classFieldArrayToStrMap(arr:Array<ClassField>, watchableFields:StringMap<ComplexType>):StringMap<ClassField> {
		var strMap:StringMap<ClassField> = new StringMap<ClassField>();
		for (f in arr) {
			
	
			watchableFields.set(f.name, TypeTools.toComplexType(f.type));
			if (f.name.charAt(0) == "_") {
			
				Context.error('Prop field: "$f.name" cannot start with underscore', f.pos);
				
				continue;
			}
			strMap.set(f.name, f);
		}
		return strMap;
	}
	

	
	
	static private function getStaticFunctionMap(staticFields:Array<ClassField>):StringMap<ClassField>
	{	
		var map:StringMap<ClassField> = new StringMap<ClassField>();
		for (f in staticFields) {
			switch(f.kind) {
				case FieldKind.FMethod(_):
					map.set(f.name, f);
				default:
			}
		}
		return map;
	}
	static private function hasMetaTag(metaData:Metadata, tag:String):Bool {
		for ( m in metaData) {
			if (m.name == tag) return true;
		}
		return false;
	}
	
	
	static private function getMetaTagEntry(metaData:Metadata, tag:String):MetadataEntry {
		for ( m in metaData) {
			if (m.name == tag) return m;
		}
		return null;
	}
	
	
	
	static private function hasMetaTags(metaData:Metadata, tags:StringMap<Bool>):Bool {
		for ( m in metaData) {
			if (tags.exists(m.name)) return true;
		}
		return false;
	}
	
	
	
	
	static private function addMethodHookToObjDeclArr(f:String, arr:Array<FieldExprPair>):Void {
				
		
		switch(f) {
			case "Created": arr.push( {field:"created", expr:macro clsP.$f } );
			case "BeforeCreate":  arr.push( {field:"beforeCreated", expr:macro clsP.$f } );
			case "BeforeDestroy": arr.push( {field:"beforeDestroy", expr:macro clsP.$f } );
			case "Destroy":  arr.push( {field:"beforeDestroy", expr:macro clsP.$f } );
			case "BeforeMount":  arr.push( {field:"beforeMount", expr:macro clsP.$f } );
			case "Mounted":   arr.push( {field:"mounted", expr:macro clsP.$f } );
			case "BeforeUpdate":  arr.push( {field:"beforeUpdate", expr:macro clsP.$f } );
			case "Updated":   arr.push( {field:"updated", expr:macro clsP.$f } );
			case "Activated":   arr.push( {field:"activated", expr:macro clsP.$f } );
			case "Deactivated":  arr.push( {field:"deactivated", expr:macro clsP.$f } );
			case "PropsData":  arr.push( {field:"propsData", expr:macro clsP.$f } );
			
			case "Data": arr.push( {field:"data", expr:macro clsP.$f } );
			
			case "Render": arr.push( {field:"render", expr:macro clsP.$f } );
			case "Template": arr.push( {field:"template", expr:macro clsP.$f } );
			case "El": arr.push( {field:"el", expr:macro clsP.$f() } );
			case "Components": arr.push( {field:"components", expr:macro clsP.$f() } );
			default:
		}
		
		
	}
	
		
	static private function addMethodHookToInitBlock(f:String, arr:Array<Expr>):Void {
				
		switch(f) {
			case "Created": arr.push( macro untyped this.created = clsP.$f );
			case "BeforeCreate":  arr.push( macro untyped this.beforeCreate =  clsP.$f );
			case "BeforeDestroy": arr.push( macro untyped this.beforeDestroy = clsP.$f );
			case "Destroy":	arr.push( macro untyped this.destroy = clsP.$f );
			case "BeforeMount":	arr.push( macro untyped this.beforeMount = clsP.$f );
			case "Mounted": 	arr.push( macro untyped this.mounted = clsP.$f );
			case "BeforeUpdate": arr.push( macro untyped this.beforeUpdate = clsP.$f );
			case "Updated": arr.push( macro untyped this.updated = clsP.$f );
			case "Activated": arr.push( macro untyped this.activated = clsP.$f );
			case "Deactivated":  arr.push( macro untyped this.deactivated = clsP.$f );
			case "PropsData":   arr.push( macro untyped this.propsData = PropsData() );
			
			case "Data":	arr.push( macro untyped this.data = clsP.$f );
			case "Render":	arr.push( macro untyped this.render = clsP.$f );
			
			case "Template": arr.push( macro untyped this.template = this.$f() );
			case "El":  arr.push( macro untyped this.el = this.$f() );
			case "Components": arr.push( macro untyped this.components = this.$f() );
			default:
		}
		
		
	}
	
	
	
	
}

typedef FieldExprPair = {
	var field:String;
	var expr:Expr;
}

typedef PropBinding = {
	var field:Field;
	var ret:ComplexType;
	var methodPos:Position;
}



#end



class VxMacroUtil {
	public static inline function dynamicSet<T>(dyn:Dynamic<T>, key:String, value:T):Void {
		untyped dyn[key] = value;
	}
	
	public static function dynamicSetPropValueInto(into:Dynamic, propSettingField:String, from:Dynamic):Void {
		for (f in Reflect.fields(from)) {
			var curSetting:Dynamic = Reflect.field(into, f)  ;
			if (curSetting == null) {
				curSetting = {};
				Reflect.setField(into, f, curSetting);
			}
			Reflect.setField(curSetting, propSettingField,  Reflect.field(from, f));
		}
	}
	
	public static function dynamicSetPropSettingInto(into:Dynamic, from:Dynamic):Void {
		for (f in Reflect.fields(from)) {
			var setting:Dynamic = Reflect.field(from, f);
			var curSetting:Dynamic = Reflect.field(into, f)  ;
			if (curSetting != null) {
				for (d in Reflect.fields(setting)) {
					Reflect.setField(curSetting, d, Reflect.field(setting, d));
				}
			}
			else {
				Reflect.setField(into, f, setting);
			}
		}
	}
}