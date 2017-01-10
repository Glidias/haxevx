package haxevx.vuex.examples.shoppingcart.modules;
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
	public var checkoutStatus(get, null):String;
	function get_checkoutStatus():String 
	{
		return getCheckoutStatus(state);
	}
    static function getCheckoutStatus(state:CartState):String {
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
class CartDispatcher<S:CartState> {
	
	@mutator static var mutator:CartMutator;
	
	static var shop:Shop = Shop.getInstance();
	
	
	 public function checkout<P:Array<ProductAdded>>(payload:P):IVxStoreContext<S>->P->Void {  //
		return function(context:IVxStoreContext<S>, payload:P):Void {
			var savedCartItems:Array<ProductAdded> = context.state.added.concat([]);  
			mutator.checkoutRequest();
			shop.buyProducts( payload, function() { 
				mutator.checkoutSuccess();
			},
			function() {
				mutator.checkoutFailure({savedCartItems:savedCartItems});
			});
		}
	}
}

class CartMutator extends AppMutator<CartState> {
	override public function addToCart<P:ProductIdentifier>(payload:P):CartState->P->Void {
		
		return function(state:CartState, payload:P):Void {
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
	}
		
	override public function checkoutRequest():CartState-> Void {
		return function(state:CartState):Void {
			state.added = [];
			state.checkoutStatus = null;
		}
	}
	
	override public function checkoutSuccess():CartState->Void {
		return function(state:CartState):Void {
			 state.checkoutStatus = 'successful';
		}
	}
	
	override public function checkoutFailure<P:ProductHistory>(payload:P):CartState->P->Void {
		return function(state:CartState, payload:P):Void {
			state.added = payload.savedCartItems;
			state.checkoutStatus  =  'failed';
		}
	}
	

}