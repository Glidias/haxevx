package haxevx.vuex.examples.shoppingcart.store;
import haxevx.vuex.core.VxStore;
import haxevx.vuex.examples.shoppingcart.modules.Cart;
import haxevx.vuex.examples.shoppingcart.modules.Products;

/**
 * port of store/index.js
 * 
 * @author Glidias
 */
class AppStore extends VxStore<AppState>  
{	
	// Actions
	 @:action static var action:AppActions<AppState>;
	
	// Mutators
	@:mutator static var mutator:AppMutator<AppState>;
	
	// Modules
	@:module public var cart:Cart;
	@:module public var products:Products;
	
	// Getters
	public var getters(default, never):AppGetters;
	
	
	public function new() {
		strict = true; 
	}

}

class AppState { 
	
	// CAN'T BE HELPED. Need to explicitly declare matching module states within store state manually. Macro will check if state matches.
	@:module public var cart(default, never):CartState;
	@:module public var products(default, never):ProductListModel;
	
	public function new() {
		
	}
	
}