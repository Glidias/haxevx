package haxevx.vuex.core;
import haxe.EnumTools.EnumValueTools;
import haxe.Json;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.Function;
import haxe.ds.StringMap;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.FunctionArg;
import haxe.macro.Expr.Metadata;
import haxe.macro.Expr.MetadataEntry;
import haxe.macro.Expr.Position;
import haxe.macro.ExprTools;
import haxe.macro.MacroStringTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import haxe.rtti.CType.MetaData;


/**
 * ...
 * @author Glidias
 */
class VxMacros
{
	
	// DONE:
	//  Macro to check (get,never) convention (matching types) and convert it to raw property instead. A @_computed metadata.
	// Show warning against get_whatever not adropting getter pair with exact get/never (will autoconvert to get/never)
	// All props and data must exist outside of component (show error if otherwise)
		// Data and props will be both mixed into component (if duplicate properties between data and props, compiler will show it!). 
		// - Thus, data+props can be access locally within component class or through explicit .props or .data accessor.
		// - Data is included witin class with  full read/write access privately
	   // - Props is included within class as readonly property signature privately.
	// If got @_data found, ensure getData() is implemented by class!
	// prop will include merge info in @prop metadata 
	//  static @propBinding support for VxStore  or within PropsOfVxStore
	
	// TODO:
	//  - var @mapGetterProp support for VxStore 
	// ....
	//  ensure supplied default types with given default values! Type checking for prop default metadata!!
	// prop validator support
	
	macro public static function buildComponent():Array<Field>  {
		var fields = Context.getBuildFields();
		
		var classModule:String = Context.getLocalClass().get().module;
		if (classModule == "haxevx.vuex.core.VxComponent"  || classModule == "haxevx.vuex.core.VComponent") return fields;
	
	
		var funcLookup:StringMap<Function> = new StringMap<Function>();
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
	
		var propStoreBindings:StringMap<PropBinding> =  new StringMap<PropBinding>();
		//var data
		
		switch ( fg=TypeTools.follow(typeParamData) ) {
			case TInst(t, params):		
				requireData = t.get().name != "NoneT";
				if (requireData) dataFieldsToAdd = t.get().fields.get();
			case Type.TAnonymous(a):
				requireData = true;
				dataFieldsToAdd =a.get().fields;
				
			default:
				Context.fatalError("Type not supported for Data (class, interface or typedef only):" + fg, Context.currentPos() );
		}
		
		switch ( fg=TypeTools.follow(typeParamProps) ) {
			case Type.TInst(t, params):
				requireProps = t.get().name != "NoneT";
				
				if (requireProps) {
					propFieldsToAdd = classFieldArrayToStrMap( t.get().fields.get() );
					var tryStatics = t.get().statics.get();
					if (tryStatics.length != 0) {
						//propStoreBindings =;
						// not future proof? ClassType+""
						addPropBindingClassField(propStoreBindings, getStaticFunctionMap(tryStatics), retTypeStore, t+"");
					}

				}
				
			case Type.TAnonymous(a):
				requireProps = true;
				propFieldsToAdd = classFieldArrayToStrMap(  a.get().fields );
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
				default:
				//	trace(field.kind);
			}
		}
		
		var gotGetData:Bool = false;
		
		for ( i in 0...fields.length)
		{
			var field = fields[i];
			if (  field.access.indexOf( Access.AStatic) >= 0 ) {
				if ( hasMetaTag( field.meta, "propBinding") ) {
					// not future proof getLocalClass()+"" approach
					addPropBindingBuildField(propStoreBindings, field, retTypeStore, Context.getLocalClass()+"");
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
					// assume there is always a getter
					if (pget == "get" && pset == "never") {
						if ( (indexer=field.access.indexOf( Access.APublic)) <0 ) {
							// ok, do nothing
						}
						else {
							Context.warning("Computed getter field: '" + field.name+"' should not be public.", field.pos) ;
							field.access = field.access.splice(indexer, 1);
						}
					}
					else {
						//trace("GG2:"+field.name);
						Context.warning("Computed getter field: '" + field.name+"' needs to adopt (get/never) convention..", field.pos );
					}
					
					if (hasMetaTag(field.meta, "mapGetterProp") ) {
						trace("TODO: mapGetterProp implementation");
						break;
					}
					
					// Add fields  as type matches getter function return type
					var func:Function = funcLookup.get(name);
					
					
					if (func != null) {
						if ( func.ret+"" != getType+"") {  // is this the "right" way to compare  pattern enums? oh well..
							Context.error("Field types for computed property must match getter method: "+name, field.pos);
						}
						
						field = fields[i] =  {
						  name:  name,
						  access: [Access.APrivate],
						  kind: FieldType.FProp("default", "never", func.ret), 
						  pos: field.pos,
						  doc: field.doc,
						  meta: field.meta
						};
						if (field.meta == null) field.meta = new Metadata();
						field.meta.push({name: "_computed",  pos:field.pos});
					
					}
					else {
						Context.error("Could not find getter function for: "+name, field.pos);
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
					if (field.name == "GetData") {
						gotGetData = true;
					}
				default:
					//trace(field.name, field.kind);
				
			}
		}
		
		
		if (requireData && !gotGetData) {
			Context.fatalError("Component class with Data Type requires getData() implementation", Context.getLocalClass().get().pos);
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
		
		if (propStoreBindings !=  null) {
			for (propName in propStoreBindings.keys()) {
				var f = propStoreBindings.get(propName);
				var p = Context.currentPos();
				//fields.push()
				
				if (propFieldsToAdd==null || !propFieldsToAdd.exists(propName)) {  // will create new prop directly with default store binding
				
					fields.push({
						name: propName,
						access: [Access.APrivate],
						pos: p ,
						kind:  FieldType.FProp("null", "never",   f.ret ),
				meta: [ {name:"_prop", pos:p, params:[  getPropMetadata(null,  ComplexTypeTools.toType( f.ret), f.methodPos, p) , macro $v{true} ] } ] // only add relavant metatag _prop and relavant metadata
					});
					
				}
				else {  //validate against existing property declaration
					if ( !isEqualComplexTypes(f.ret, TypeTools.toComplexType( propFieldsToAdd.get(propName).type) ) ) {
						Context.fatalError("@propBinding method needs matching return type with prop ", f.methodPos );
					}
					
				}
				
				fields.push(f.field);
			}
		
		}
	
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

						fields.push({
							name: f.name,
							doc: f.doc,
							access: [Access.APrivate],
							pos: p ,
							kind:  FieldType.FProp("null", "never",  TypeTools.toComplexType( f.type) ),
						meta: [ {name:"_prop", pos:p, params:[  getPropMetadata(f.meta.get(), f.type, f.pos, p),  macro $v{propStoreBindings != null && propStoreBindings.exists(f.name)} ] } ] // only add relavant metatag _prop and relavant metadata
						});
					default:
						// suppress?
						 Context.warning("Field type not supported for props: "+f.kind,f.pos);
				}
			}
			
			
		}
	
		
		
		
		return fields;
	}
	
	// THis is rather hackish and may not be future-proof
	static inline function isEqualComplexTypes(a:ComplexType, b:ComplexType):Bool {
		return ComplexTypeTools.toType(a) + "" == ComplexTypeTools.toType(b) + "";
	}
	
	
	static  function getPropMetadata(metadata:Metadata, fldType:Type, fldPos:Position, p:Position):Expr {
		var list:Array<{field:String, expr:Expr}> = [];
		
		if (metadata != null) {
			for (m in metadata) {
				if (m.name == "prop" && m.params!= null && m.params.length > 0 && m.params[0] != null)  {
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
		if (typeStr != null) {
			list.push({field:"type", expr:macro $v{typeStr} });
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

	static function classFieldArrayToStrMap(arr:Array<ClassField>):StringMap<ClassField> {
		var strMap:StringMap<ClassField> = new StringMap<ClassField>();
		for (f in arr) {
			strMap.set(f.name, f);
		}
		return strMap;
	}
	
	static private function addPropBindingBuildField(fieldsToAdd:StringMap<PropBinding>, f:Field, typeStore:ComplexType, module:String ):Void {
		if (f.name.indexOf("Get_") != 0) {
			Context.fatalError("@propBinding method name should start with 'Get_'", f.pos);
			
		}
		var propName:String =  f.name.substr(4);
				
		switch( f.kind ) {
			case FieldType.FFun(k):
				var c;
				var ret = k.ret;
				var args = k.args;
				
				
				if (args.length != 1) {
					Context.fatalError("@propBinding method should accept 1 parameter as store: "+c, f.pos);
				}
		
				//	!EnumValueTools.equals(retTypeStore, args[0]   //this won't work...hmm
			//	trace( typeStore,  args[0].type);
			
				if (  !isEqualComplexTypes( typeStore, args[0].type)  ) {
					//trace(retTypeStore);
					//trace(args[0]);
					//if 
				
					Context.fatalError("@propBinding method parameter type doesn't match with store", f.pos);
				}
				
				//haxevx.vuex.examples.shoppingcart.components.CartVueProps.Get_products(store);
				//var funcRefName:String = module != "" ?  module+"."+f.name : "";

				fieldsToAdd.set(propName, { field: {
					name: "get_"+propName,
					access: [Access.APrivate],
					pos: Context.currentPos(),
					kind:  FieldType.FFun({
						args:[], 
					
						//"return " + module+f.name+"(store);"
						// haxe hack for javascript only .. may not be future proof. Also, inlining is lost!!
						
				expr: macro  { return untyped $i{module.split(".").join("_") + "." + f.name}(store);  } ,
						ret: ret
						})
				}, ret:ret, methodPos:f.pos});
				
				
	
				
				
				/*
				
				*/
			default:
				Context.fatalError("@propBinding requires static function! " + f.kind, f.pos);
		}
		
	}
	
	static private function addPropBindingClassField(fieldsToAdd:StringMap<PropBinding>, staticFuncMap:StringMap<ClassField>, typeStore:ComplexType, module:String ):Void {
		//if (module != "") module += ".";
		
		for (f in staticFuncMap) {
			if (hasMetaTag(f.meta.get(), "propBinding")) {
				if (f.name.indexOf("Get_") != 0) {
					Context.fatalError("@propBinding method name should start with 'Get_'", f.pos);
					
				}
				
				var propName:String =  f.name.substr(4);
				
				switch( f.kind ) {
					case FieldKind.FMethod(k):
						var c;
						switch( c= TypeTools.toComplexType(f.type) ) {
							case ComplexType.TFunction(args, ret):
								
								if (args.length != 1) {
									Context.fatalError("@propBinding method should accept 1 parameter as store: "+c, f.pos);
								}
						
								//	!EnumValueTools.equals(retTypeStore, args[0]   //this won't work...hmm
								if ( !isEqualComplexTypes( typeStore, args[0]) ) {
									//trace(retTypeStore);
									//trace(args[0]);
									Context.fatalError("@propBinding method parameter type doesn't match with store", f.pos);
								}
								
								//haxevx.vuex.examples.shoppingcart.components.CartVueProps.Get_products(store);
								//var funcRefName:String = module != "" ?  module+"."+f.name : "";

								fieldsToAdd.set(propName, { field: {
									name: "get_"+propName,
									access: [Access.APrivate],
									pos: Context.currentPos(),
									kind:  FieldType.FFun({
										args:[], 
									
										//"return " + module+f.name+"(store);"
										// haxe hack for javascript only .. may not be future proof
										
								expr: macro  { return untyped $i{module.split(".").join("_") + "." + f.name}(store);  } ,
										ret: ret
										})
								}, ret:ret, methodPos:f.pos});
								
								
							default:
								Context.fatalError("Couldn't resolve complex type error: "+c, f.pos);
						}
					
						
						
						/*
						
						*/
					default:
						Context.fatalError("@propBinding requires static function! " + f.kind, f.pos);
				}
			}
		}
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
	
	
	
}

typedef PropBinding = {
	var field:Field;
	var ret:ComplexType;
	var methodPos:Position;
}

