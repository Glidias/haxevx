package haxevx.vuex.examples.shoppingcart.components;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VxComponent;
import haxevx.vuex.examples.shoppingcart.store.AppStore;

/**
 * components/Cart.vue port
 * 
 * @author Glidias
 */
@:rtti
class CartVue extends VxComponent<AppStore, NoneT, NoneT>
{

	public function new() 
	{
		
	}
	
	
	override public function Template():String {
		return '<div class="cart">
				<h2>Your Cart</h2>
				<p v-show="!products.length"><i>Please add some products to cart.</i></p>
				<ul>
				  <li v-for="p in products">
					{{ p.title }} - {{ p.price | currency }} x {{ p.quantity }}
				  </li>
				</ul>
				<p>Total: {{ total | currency }}</p>
				<p><button :disabled="!products.length" @click="checkout(products)">Checkout</button></p>
				<p v-show="checkoutStatus">Checkout {{ checkoutStatus }}.</p>
			  </div>';
	}
	
}