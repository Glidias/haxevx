package haxevx.proxy.immutable;

import haxe.macro.ComplexTypeTools;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.MacroStringTools;
import haxe.macro.Type.ClassKind;
import haxe.macro.TypeTools;
import haxe.macro.Type;

// This is just a Proxy example...
// https://gist.github.com/elsassph/319e1eade1978f08e221
// modified to run under custom Proxied implementation with Abstract Immutable Map/Record set()/get() methods
// It assumes the Abstract will proxy to an immutable extern, that accepts a type parameter representing the plain data type to proxy to.
// @see haxevx.proxy.immutable.ImmuteMapAbstract
class ImmuteProxyGen
{
	macro public static function build():Array<Field> 
	{

		var fields = Context.getBuildFields();
		var localClass = Context.getLocalClass();
		var className:String = localClass.get().module ;
		var retMe = MacroStringTools.toComplex(className);
		
		// this sniffing is rather dangerous with 'magic' indexed access, will it work all the time??
		var sniffDataType = TypeTools.followWithAbstracts(ComplexTypeTools.toType(retMe)).getParameters()[1][0];


		var fieldsToAdd:Array<String> = [];
		var fieldTypesToAdd:Array<ComplexType> = [];
		var rrr = TypeTools.follow(sniffDataType);
		switch(  rrr) {
			case Type.TAnonymous(a):
				for (f in a.get().fields) {
					fieldsToAdd.push(f.name);
					fieldTypesToAdd.push(TypeTools.toComplexType(f.type));
				}
			case Type.TInst(a, params):

				for (f in a.get().fields.get() ) {
					fieldsToAdd.push(f.name);
					fieldTypesToAdd.push(TypeTools.toComplexType(f.type));
				}
			default:
				trace("TODO: need to support:" + rrr);
		}
		
		for (i in 0...fieldsToAdd.length) {
				var name:String = fieldsToAdd[i];
				var fieldType:ComplexType = fieldTypesToAdd[i];
			
				var getterFunc:Function = { 
					args: [], 
					expr: macro return get($v{name}), 
					ret: fieldType 
				};
				
				fields.push( {
				  name:  name,
				  access: [Access.APublic],
				  kind: FieldType.FProp("get", "never", getterFunc.ret), 
				  pos: Context.currentPos(),
				});
				
				
				fields.push({
					name: 'get_' + name,
					access: [Access.APrivate, Access.AInline],
					kind: FieldType.FFun(getterFunc),
					pos: Context.currentPos()
				});
				
					
			
				
				fields.push({
					name: 'set' + formatName(name),
					access: [Access.APublic, Access.AInline],
					kind: FieldType.FFun({ 
						args: [{ name:'value', type:fieldType  } ], 
						expr: macro return set($v{name}, value), 
						ret:  null 
					}),
					pos: Context.currentPos()
				});
				
			
			
				
				
				
		}
		
		

		fields.push( {
			name: 'get',
			access: [Access.APublic, Access.AInline],
			kind: FieldType.FFun({ 
				args: [{ name:'prop', type:null } ], 
				expr: macro return  this.get(prop), 
				ret: null 
			}),
			pos: Context.currentPos()
			
		});
		
		///*
		fields.push( {
			name: 'set',
			access: [Access.APublic, Access.AInline],
			kind: FieldType.FFun({ 
				args: [{ name:'prop', type: (macro:String)  }, { name:'val', type: (macro:Dynamic) } ], 
				expr: macro return  this.set(prop, val), 
				ret:  retMe //TypeTools.toComplexType(Context.getLocalType()) 
			}),
			pos: Context.currentPos()
			
		});
		//*/
		

		return fields;
	}
	
	static inline function formatName(name:String) 
	{
		return name.charAt(0).toUpperCase() + name.substr(1);
	}
	

	

}