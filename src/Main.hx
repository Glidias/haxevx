package;

import haxe.rtti.Meta;
import haxevx.vuex.examples.shoppingcart.ShoppingCartMain;
import haxevx.vuex.util.ActionFactory;
import js.Lib;

/**
 * ...
 * @author Glidias
 */
class Main 
{
	static inline var ABC:String = "AAA";
	public var testMeta:Float;
	
	static function main() 
	{
		new ShoppingCartMain();
		ActionFactory;
		
	//	Type.getInstanceFields(ShoppingCartMain)[
		trace(  Meta.getFields( Main) );
	}
	
	
	
}