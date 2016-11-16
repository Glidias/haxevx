package haxevx.vuex.examples.shoppingcart.store;
import haxevx.vuex.core.VModule;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes; 
import haxevx.vuex.examples.shoppingcart.store.AppStore.AppState;

/**
 * port of store/getters.js
 * @author Glidias
 */
@:rtti
class AppGetters<S:AppState> extends VModule<S>
{
	public var cartProducts(get, null):Array<ProductInCart>;
	function get_cartProducts():Array<ProductInCart> 
	{
		return getCartProducts(state);
	}
	public static function getCartProducts<S:AppState>(state:S):Array<ProductInCart> {
		state.cart.added.map( function( cp) {
			var chk = state.products.all.filter( function(p) {
				return p.id == cp.id;
			});
			
			if (chk.length > 0) {
				var product = chk[0];
				return {
					title: product.title,
					price: product.price,
					quantity: cp.quantity
				};
			}
			else return null;
		});
		return null;
	}
	

	
}