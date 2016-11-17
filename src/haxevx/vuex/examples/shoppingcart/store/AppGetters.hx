package haxevx.vuex.examples.shoppingcart.store;
import haxevx.vuex.core.VModule;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes; 
import haxevx.vuex.examples.shoppingcart.store.AppStore.AppState;

/**
 * port of store/getters.js
 * @author Glidias
 */
@:rtti
class AppGetters extends VModule<AppState>
{
	public var cartProducts(get, null):Array<ProductInCart>;
	function get_cartProducts():Array<ProductInCart> 
	{
		return getCartProducts(state);
	}
	public static function getCartProducts<S:AppState>(state:S):Array<ProductInCart> {
		var exceptions:Array<String> = null;
		var resultOfMap =  state.cart.added.map( function( cp:ProductInCart) {
			var chk = state.products.all.filter( function(p:ProductInStore) {
				return p.id == cp.id;
			});
			
			if (chk.length > 0) {
				var product = chk[0];
				return {
					id: product.id,
					title: product.title,
					price: product.price,
					quantity: cp.quantity
				};
			}
			else {
				
				if (exceptions == null) {
					exceptions = [];
				}
				exceptions.push(Std.string(cp.id));
				return null;
			}
		});
		if (exceptions!= null) {
			throw "Null id link reference map exception detected!: " + exceptions;
		}
		return resultOfMap;
	}
	

	
}