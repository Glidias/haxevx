package haxevx.vuex.examples.shoppingcart.components;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VxComponent;
import haxevx.vuex.examples.shoppingcart.store.AppStore;

/**
 * Root application component implementation
 * @author Glidias
 */
@:rtti
class App extends VxComponent<AppStore, NoneT, NoneT>
{

	public function new() 
	{

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