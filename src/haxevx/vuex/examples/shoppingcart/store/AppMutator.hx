package haxevx.vuex.examples.shoppingcart.store;
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
class AppMutator<S>		// all mutators imply a "S" generic property indicating the state type it is interested in modifying.
{
	
	// If a mutator function returns a specific mutator handler, it will be registered under the respective Vuex application store/module
	//   under the base class namespace by default. (ie. overriding a mutator method will use the namespace in the most original base class that declared that method).
	// At runtime JS, calling the mutator function will result in the global Vuex store dispatching a mutation event string under that given namespace to notify all 
	// relavant VueX mutation handlers.
	
	public function addToCart<P:ProductIdentifier>(payload:P):S->P->Void {	 // If a mutator function requires a payload, the parameter type constraint P is specified for it.
		return null;
	}
	
	public function checkoutRequest():S->Void {
		return null;
	}
	public function checkoutSuccess():S->Void {
		return null;
	}
	public function checkoutFailure<P:ProductHistory>(payload:P):S->P->Void {
		return null;
	}
	
	public function receiveProducts<P:Array<ProductInStore>>(payload:P):S->P->Void {
		return null;
	}
	
	
	// CAVEATS
	// 1. Module rootState overwrites.
	//   Haxe doesn't allow overriding + overloading of the method, only overriding. 
	//	Thus, if a module mutator needs to support root state, the method declaration must already support  a 3rd parameter to begin with
	// This isn't too ideal unless we come up with with some custom metadata approach to indicate overloading methods, albeit this will sacrifice compile time checking.


	
	
}