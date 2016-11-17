package haxevx.vuex.examples.shoppingcart.store;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VxStore;
import haxevx.vuex.examples.shoppingcart.modules.Cart;
import haxevx.vuex.examples.shoppingcart.modules.Products;

/**
 * port of store/index.js
 * 
 * @author Glidias
 */
@:rtti
class AppStore extends VxStore<AppState, AppGetters>  
{	
	// Actions
	@action static var actions:AppActions<AppState>;
	
	// Modules
	@module public var cart:Cart;
	@module public var products:Products;
	
	public function new() {
		state = new AppState();
		
		strict = true; // for demo purposes, use compile time flags to determine whether this should be false or true.
	}

}

@:rtti
class AppState { 
	
	// CAN'T BE HELPED. Need to explicitly declare matching module states within AppState if it needs to be referenced.
	// Only runtime-init checking of matching module state types with above Appstore @module fields will be done.
	public var cart(default, null):CartState;
	public var products(default, null):ProductListModel;
	
	public function new() {
		
	}
	
}