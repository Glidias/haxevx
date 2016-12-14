package haxevx.proxy;
import haxe.macro.Context;
import haxe.macro.Expr;

// This is just a Proxy example...
// https://gist.github.com/elsassph/319e1eade1978f08e221
// modified to run under custom Proxied implementation with map set()/get() methods
// Likely, different application needs will use different setups
class ProxyGenerator
{
	macro public static function build():Array<Field> 
	{
		
		var fields = Context.getBuildFields();
		var append = [];
		
		for (field in fields)
		{
			switch (field.kind)
			{
				case FProp(_, pset, _, _):
					var name = field.name;// formatName(field.name);
					
					// assume there is always a getter
					append.push({
						name: 'get_' + name,
						access: [Access.APrivate, Access.AInline],
						kind: FieldType.FFun({ 
							args: [], 
							expr: macro return get($v{name}), 
							ret: null 
						}),
						pos: Context.currentPos()
					});
					
					// only generate setters if the property is writable
					if (pset != 'null' && pset != 'never')
					{
						append.push({
							name: 'set_' + name,
							access: [Access.APrivate, Access.AInline],
							kind: FieldType.FFun({ 
								args: [{ name:'value', type:null } ], 
								expr: macro return set($v{name}, value), 
								ret: null 
							}),
							pos: Context.currentPos()
						});
						
						/*
						append.push({
							name: 'set' + formatName(field.name),
							access: [Access.APublic, Access.AInline],
							kind: FieldType.FFun({ 
								args: [{ name:'value', type:null } ], 
								expr: macro return set($v{name}, value), 
								ret: null 
							}),
							pos: Context.currentPos()
						});
						*/
					}
					
				default:
			}
		}
		
		return fields.concat(append);
	}
	
	static function formatName(name:String) 
	{
		return name.charAt(0).toUpperCase() + name.substr(1);
	}
}