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
class App extends VxComponent<AppStore, NoneT, NoneT>
{

	public function new() 
	{
		super();
	}
	
	static inline var ProductList:String = "product-list";
	static inline var Cart:String = "cart";
	
	override function Components():Dynamic<VComponent<Dynamic,Dynamic>> {
		return [
			ProductList => new ProductListVue(),
			Cart => new CartVue("My Haxe Cart")
		];
	}
	
	override public function Template():String {
		return '<div id="app">
				<h1>Shopping Cart Example</h1>
				<hr>
				<h2>Products</h2>
				<$ProductList></$ProductList>
				<hr>
				<$Cart></$Cart>
			  </div>';
	}
	
}