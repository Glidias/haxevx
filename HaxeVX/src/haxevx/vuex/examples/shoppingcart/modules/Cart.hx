package haxevx.vuex.examples.shoppingcart.modules;
import haxevx.vuex.core.IVxContext;
import haxevx.vuex.core.IVxStoreContext;
import haxevx.vuex.core.VModule;
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
	@mutator var action:CartDispatcher<CartState>;
	
	// Mutators
	@mutator var mutator:CartMutator<CartState>;
}

typedef CartState =  {	//eg. typedef style store module state
	var added:Array<ProductInCart>;
	var checkoutStatus:String;
	var lastCheckout:String;
}

class CartDispatcher<S:CartState> {
	
	@mutator var mutator:CartMutator<S>;
	
	 public function checkout<P:Array<ProductInCart>>(payload:P):IVxStoreContext<S>->P->Void {  //
		return function(context:IVxStoreContext<S>, payload:P):Void {
			var savedCartItems:Array<ProductInCart> = context.state.added.concat([]);  
			mutator.checkoutRequest();
			
		}
		
		 /*
		const savedCartItems = [...state.added]
		commit(types.CHECKOUT_REQUEST)
		shop.buyProducts(
		  products,
		  () => commit(types.CHECKOUT_SUCCESS),
		  () => commit(types.CHECKOUT_FAILURE, { savedCartItems })
		)
		*/
	 }
}

class CartMutator<S:CartState> extends AppMutator<Dynamic> {
	override public function addToCart<P:ProductIdentifier>(payload:P):S->P->Void {
		
		return function(state:S, payload:P):Void {
			state.lastCheckout = null;
			
			//todo
			/*var record = state.added.find( p => p.id === payload.id)
			if (!record) {
			  state.added.push({
				id,
				quantity: 1
			  })
			} else {
			  record.quantity++
			}
			*/
		}
	}
		
	override public function checkoutRequest():S->Void {
		return function(state:S):Void {
			state.added = [];
			state.checkoutStatus = null;
		}
	}
	
	override public function checkoutSuccess():S->Void {
		return function(state:S):Void {
			state.added = [];
			state.checkoutStatus = 'successful';
		}
	}
	
	override public function checkoutFailure<P:ProductHistory>(payload:P):S->P->Void {
		return function(state:S, payload:P):Void {
			state.added = payload.savedCartItems;
			state.checkoutStatus  =  'failed';
		}
	}
	

}