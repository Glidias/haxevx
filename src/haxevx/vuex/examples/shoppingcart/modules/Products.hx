package haxevx.vuex.examples.shoppingcart.modules;
import haxevx.vuex.core.IAction;
import haxevx.vuex.core.IVxStoreContext;
import haxevx.vuex.core.VModule;
import haxevx.vuex.examples.shoppingcart.api.Shop;
import haxevx.vuex.examples.shoppingcart.store.AppMutator;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes;

/**
 * store/modules/products.js
 * port to Haxe
 * @author Glidias
 */
@:rtti
class Products extends VModule<ProductListModel>
{
	// Initial State
	public function new() 
	{
		state = new ProductListModel();
		
	}

	// Getters
	static function Get_allProducts(state:ProductListModel):Array<ProductInStore> { 
		return state.all;
	}  

	
	// Actions
	@action static var action:ProductListDispatcher;
	
	
	// Mutations
	@mutator static var mutator:ProductListMutator; 
	
}

@:rtti
class ProductListDispatcher implements IAction { 
	
	@mutator static var mutator:ProductListMutator;
	static var shop:Shop = Shop.getInstance();
	
	function getAllProducts(context:IVxStoreContext<ProductListModel>):Void {  
		shop.getProducts( function(products) {
			
			mutator._receiveProducts(context, products);
		});
		
	}
}

@:rtti
class ProductListMutator extends AppMutator<ProductListModel> {
	override function receiveProducts(state:ProductListModel, payload:Array<ProductInStore>):Void {
		
		state.all = payload;
		
	}
	
	override function addToCart(state:ProductListModel, payload:ProductIdentifier):Void {
		var filtered = state.all.filter( function(p) { return p.id == payload.id;  } );
		if (filtered.length > 0) {
			filtered[0].inventory--;
			
		}
	}
	
}


@:rtti
class ProductListModel {  //eg. class style store module state
	
	// ensure class's reactive states have all their properties initialized beforehand (even null references "=null"), in order to be reactive to VueJS.
	public var all:Array<ProductInStore> = [];
	
	public function new() {
		
	}
}
