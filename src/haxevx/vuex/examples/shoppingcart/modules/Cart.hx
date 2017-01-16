package haxevx.vuex.examples.shoppingcart.modules;
import haxevx.vuex.core.IAction;
import haxevx.vuex.core.IVxStoreContext;
import haxevx.vuex.core.VModule;
import haxevx.vuex.examples.shoppingcart.api.Shop;
import haxevx.vuex.examples.shoppingcart.store.AppMutator;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes;

/**
 * 
 * store/modules/cart.js
 * port to Haxe
 * 
 * @author Glidias
 */
@:rtti
class Cart extends VModule<CartState>
{
	
	public function new() 
	{
		// Initial State
		state = {
			added: [],
			checkoutStatus:null,
			lastCheckout:null  // why initials tate did not include hthis?
		}
		
	}
	
	
	// Getters
	public var checkoutStatus(get, never):String;
    static function Get_checkoutStatus(state:CartState):String {
		return state.checkoutStatus;
	}
	
	// Actions
	@action static var action:CartDispatcher<CartState>;
	
	// Mutators
	@mutator static var mutator:CartMutator;
}

typedef CartState =  {	//eg. typedef style store module state
	var added:Array<ProductAdded>;
	var checkoutStatus:String;
	var lastCheckout:String;
}

@:rtti
class CartDispatcher<S:CartState> implements IAction {
	
	@mutator static var mutator:CartMutator;
	
	static var shop:Shop = Shop.getInstance();
	
	
	function checkout(context:IVxStoreContext<S>, payload:Array<ProductAdded>):Void {  //
		var savedCartItems:Array<ProductAdded> = context.state.added.concat([]);  
		mutator._checkoutRequest(context);
		shop.buyProducts( payload, function() { 
			mutator._checkoutSuccess(context);
		},
		function() {
			mutator._checkoutFailure(context, {savedCartItems:savedCartItems});
		});
	}
}


class CartMutator extends AppMutator<CartState>  {

	override function addToCart(state:CartState, payload:ProductIdentifier):Void {
		
			
			state.lastCheckout = null;
			var chk = state.added.filter( function(p) {
				return p.id == payload.id;
			});
			
			if (chk.length == 0) {
				state.added.push({
					id:payload.id,
					quantity:1
				});
			}
			else {
				var record = chk[0];  // increment resolved record quantity
				record.quantity++;
			}
	
	}
		
	override function checkoutRequest(state:CartState):Void {
		
		state.added = [];
		state.checkoutStatus = null;
		
	}
	
	override function checkoutSuccess(state:CartState):Void {
		state.checkoutStatus = 'successful';
	}
	
	override function checkoutFailure(state:CartState, payload:ProductHistory):Void {
		
		state.added = payload.savedCartItems;
		state.checkoutStatus  =  'failed';
		
	}
	

}