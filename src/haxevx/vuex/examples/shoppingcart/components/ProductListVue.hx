package haxevx.vuex.examples.shoppingcart.components;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VxComponent;
import haxevx.vuex.examples.shoppingcart.modules.Products.ProductListDispatcher;
import haxevx.vuex.examples.shoppingcart.store.AppActions;
import haxevx.vuex.examples.shoppingcart.store.AppStore;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes;
/**
 * components/ProductList.vue port
 * 
 * @author Glidias
 */
class ProductListVue extends VxComponent<AppStore, NoneT, NoneT>
{

	public function new() 
	{
		super();
	}
	

	@:action static var dispatcher:ProductListDispatcher;
	@:action static var actionDispatcher:AppActions<Dynamic>;
	
	
	// Computed
	var products(get, never):Array<ProductInStore>;
	public function get_products():Array<ProductInStore> {
		return store.products.allProducts;
	}
	
	
	// Methods
	function addToCart(p:ProductInStore):Void {
		actionDispatcher._addToCart(store, p);
	}
	
	
	
	// Hooks

	
	override public function Created():Void {	
		dispatcher._getAllProducts(store);
	}

	
	override public function Template():String {
		return 
		'<ul>
			<li v-for="p in products">
			  {{ p.title }} - {{ p.price }} - ({{p.inventory}})
			  <br>
			  <button
				:disabled="!p.inventory"
				@click="addToCart(p)">
				Add to cart
			  </button>
			</li>
		</ul>';
	}
	
}


