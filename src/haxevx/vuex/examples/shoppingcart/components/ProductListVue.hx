package haxevx.vuex.examples.shoppingcart.components;
import haxevx.vuex.examples.shoppingcart.modules.Products;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VxComponent;
import haxevx.vuex.examples.shoppingcart.modules.Products.ProductListDispatcher;
import haxevx.vuex.examples.shoppingcart.modules.Products.ProductListMutator;
import haxevx.vuex.examples.shoppingcart.store.AppActions;
import haxevx.vuex.examples.shoppingcart.store.AppStore;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes;

/**
 * components/ProductList.vue port
 * 
 * @author Glidias
 */
@:rtti
class ProductListVue extends VxComponent<AppStore, NoneT, NoneT>
{

	public function new() 
	{
		
	}
	

	@action static var dispatcher:ProductListDispatcher;
	@action static var actionDispatcher:AppActions<Dynamic>;
	
	
	// Computed
	
	
	// Methods
	function addToCart(p:ProductInStore):Void {
		actionDispatcher.addToCart(p);
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
	
	
	
	@propBinding static inline function Get_products(store:AppStore):Array<ProductInStore> {
		return  store.products.allProducts;
	}
	
}


