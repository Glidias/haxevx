package haxevx.vuex.examples.shoppingcart;
import haxe.Json;
import haxevx.vuex.core.VxBoot;
import haxevx.vuex.examples.shoppingcart.api.Shop;
import haxevx.vuex.examples.shoppingcart.components.App;
import haxevx.vuex.examples.shoppingcart.store.AppStore;
import haxevx.vuex.util.ReflectUtil;

/**
 * Port of https://github.com/vuejs/vuex/tree/dev/examples/shopping-cart to HaxeVX
 * @author Glidias
 */
class ShoppingCartMain
{
	public function new() 
	{
		ReflectUtil.NAMESPACE = ReflectUtil.getPackagePathForInstance(this);
		
		var params = VxBoot.startParams( new App(),  new AppStore());
	
	}
	
}