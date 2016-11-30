package haxevx.vuex.examples.shoppingcart.components;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VxComponent;
import haxevx.vuex.examples.shoppingcart.modules.Products.ProductListDispatcher;
import haxevx.vuex.examples.shoppingcart.modules.Products.ProductListMutator;
import haxevx.vuex.examples.shoppingcart.store.AppStore;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes;
import haxevx.vuex.core.PropsBindedToStore;

/**
 * components/ProductList.vue port
 * 
 * @author Glidias
 */
@:rtti
class ProductListVue extends VxComponent<AppStore, NoneT, ProductListProps>
{

	public function new() 
	{
		
	}
	
	@mutator static var mutator:ProductListMutator;
	@action static var dispatcher:ProductListDispatcher;
	
	
	// Computed
	/*  // depreciated moved to ProductListProps store binding (see below)...
	 * haxevx.vuex.examples.shoppingcart.components.ProductListProps
	 * haxevx.vuex.core.PropsBindedToStore
	var products(get, null):Array<ProductInStore>;
	function get_products():Array<ProductInStore>
	{
		return store.products.allProducts;
	}
	*/
	
	
	// Methods
	function addToCart(p:ProductInStore):Void {
		mutator.addToCart(p);
		
	}
	

	
	// Hooks

	
	override public function Created():Void {
		dispatcher.getAllProducts();
	}
	
	
	override public function Template():String {
		return 
		'<ul>
			<li v-for="p in products">
			  {{ p.title }} - {{ p.price | currency }}
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

@:rtti
class ProductListProps extends PropsBindedToStore<AppStore> {
	
	public var products(default, null):Array<ProductInStore>;
	function get_products():Array<ProductInStore>
	{
		return store.products.allProducts;
	}
	
	
	

	
}