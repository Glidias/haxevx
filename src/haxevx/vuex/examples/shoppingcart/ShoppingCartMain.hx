package haxevx.vuex.examples.shoppingcart;
import haxevx.vuex.core.VxBoot;
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
	//	ReflectUtil.NAMESPACE = ReflectUtil.getPackagePathForInstance(this);
		
		VxBoot.startStore( new AppStore() );
		VxBoot.startVueWithRootComponent("#app", new App() );

		// if not using VueX and App is a self-contained Vue instance (which isn't in this case, however), can forego VxBoot and simply call:
		//new Vue( new App() );
	}
	
}