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
		//state = new AppState();  // manual instantiation is optional if constructor has no parameters & RTTI is available
		// getters = new Getters(); // manual instantiation is optional if constructor has no parameters & RTTI is available
		
		strict = true; // for demo purposes, use compile time flags to determine whether this should be false or true.
	}

}

class AppState { 
	
	// CAN'T BE HELPED. Need to explicitly declare matching module states within AppState if it needs to be referenced.
	// Only runtime-init checking of matching module state types with above Appstore @module fields will be done.
	public var cart(default, null):CartState;
	public var products(default, null):ProductListModel;
	
	public function new() {
		
	}
	
}