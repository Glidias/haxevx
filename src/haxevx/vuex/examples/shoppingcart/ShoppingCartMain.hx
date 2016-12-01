package haxevx.vuex.examples.shoppingcart;
import haxevx.vuex.core.VxBoot;
import haxevx.vuex.examples.shoppingcart.api.Shop;
import haxevx.vuex.examples.shoppingcart.components.App;
import haxevx.vuex.examples.shoppingcart.store.AppStore;

/**
 * Port of https://github.com/vuejs/vuex/tree/dev/examples/shopping-cart to HaxeVX
 * @author Glidias
 */
class ShoppingCartMain
{
	public function new() 
	{
		
		VxBoot.start( new App(),  new AppStore());
		
		
	}
	
}