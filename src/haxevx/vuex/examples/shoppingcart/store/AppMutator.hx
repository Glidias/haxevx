package haxevx.vuex.examples.shoppingcart.store;
import haxevx.vuex.core.IMutator;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes;

/**
 * port of store/mutation-types.js
 * 
 * This implementation uses a barebones abstract+generic class approach to defining mutator types in VueX example.
 * Store module mutator classes can extend this class as AppMutator<TargetStateType>, and override the base methods to mutate state data types
 * specific to it's given module, or also define new mutators as fresh methods under that given extended mutator class's namespace.
 * 
 * @author Glidias
 */
@:rtti
class AppMutator<S> implements IMutator		// all mutators imply a "S" generic property indicating the state type it is interested in modifying.
{
	

	
	function addToCart(state:S, payload:ProductIdentifier):Void {	
		
	}
	
	function checkoutRequest(state:S):Void {
		
	}
	function checkoutSuccess(state:S):Void {
		
	}
	function checkoutFailure(state:S, payload:ProductHistory):Void {
		
	}
	
	function receiveProducts(state:S, payload:Array<ProductInStore>):Void {
		
	}
	

	


	
	
}