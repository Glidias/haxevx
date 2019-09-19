package haxevx.vuex.examples.shoppingcart.store;
import haxevx.vuex.core.IStoreGetters;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VModule;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes; 
import haxevx.vuex.examples.shoppingcart.store.AppStore.AppState;

/**
 * port of store/getters.js
 * @author Glidias
 */
class AppGetters implements IStoreGetters<AppState> //extends VModule<AppState, NoneT>
{

	public function new() {	}
	

	public static function Get_cartProducts(state:AppState):Array<ProductInCart> {
	
		var exceptions:Array<String> = null;

		var resultOfMap =  state.cart.added.map( function( cp:ProductAdded) {
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