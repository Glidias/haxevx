package haxevx.vuex.examples.shoppingcart.components;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VComponent;
import haxevx.vuex.core.VxComponent;
import haxevx.vuex.examples.shoppingcart.store.AppStore;

/**
 * components/App.vue port
 * 
 * Root application vue component implementation
 * @author Glidias
 */
@:rtti
class App extends VxComponent<AppStore, NoneT, NoneT>
{

	public function new() 
	{
		
	}
	
	override function Components():Dynamic<VComponent<Dynamic,Dynamic>> {
		return {
			"product-list": new ProductListVue(),
			"cart": new CartVue()
		};
	}
	
	
	
	override public function Template():String {
		return '<div id="app">
				<h1>Shopping Cart Example</h1>
				<hr>
				<h2>Products</h2>
				<product-list></product-list>
				<hr>
				<cart></cart>
			  </div>';
	}
	
}