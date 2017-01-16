package haxevx.vuex.examples.shoppingcart.components;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VxComponent;
import haxevx.vuex.examples.shoppingcart.modules.Cart.CartDispatcher;
import haxevx.vuex.examples.shoppingcart.store.AppMutator;
import haxevx.vuex.examples.shoppingcart.store.AppStore;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes;

/**
 * components/Cart.vue port
 * 
 * @author Glidias
 */
using Lambda;
class CartVue extends VxComponent<AppStore, NoneT, NoneT>
{

	var __customTitle:String;
	
	public function new(customTitle:String = "My Cart") 
	{
		__customTitle = customTitle;
		
		// ensure you call call super() last...because _Init() must be called last!
		super();
		
		
		

	}
	
	@:mutator static var mutator:AppMutator<Dynamic>; 
	@:action static var action:CartDispatcher<Dynamic>; 
	

	// Computed
	
	var total(get, never):Float;
	function get_total():Float 
	{
		return products.fold( function(p:ProductInCart, total:Float)  {
			return total + p.price * p.quantity;
		}, 0);
	}
	
	var products(get, never):Array<ProductInCart>;
	public  inline function get_products():Array<ProductInCart> {
		return store.getters.cartProducts;
	}
	
	var checkoutStatus(get, never):String;
	public inline function get_checkoutStatus():String {
		return store.cart.checkoutStatus;
	}
	
	
	
	// Methods
	public function checkout (products:Array<ProductInCart>) {
		action._checkout(store, products);
    }
	
	
	override function Template():String {
		return '<div class="cart">
				<h2>$__customTitle</h2>
				<p v-show="!products.length"><i>Please add some products to cart.</i></p>
				<ul>
				  <li v-for="p in products">
					{{ p.title }} - {{ p.price  }}  (x{{ p.quantity }})
				  </li>
				</ul>
				<p>Total: {{ total  }}</p>
				<p><button :disabled="!products.length" @click="checkout(products)">Checkout</button></p>
				<p v-show="checkoutStatus">Checkout {{ checkoutStatus }}.</p>
			  </div>';
	}
	
	
	

	
}


