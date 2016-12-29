package haxevx.vuex.examples.shoppingcart.modules;
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
	
	// eg. A single store/module getter implementation defined as a paragraph of 3 declarations.
	//  Admittingly, rather verbose to ensure compile type strict typing and code-hinting.
	
	// Consider using macro generation compile with static function Get_allProducts(state)... to define getter implementations
	public var allProducts(get, null):Array<ProductInStore>;	// 1. helper haxe getter property for module reference instance
	function get_allProducts():Array<ProductInStore> 		// 2. Haxe+JS proxy function to link to VueJS getter function via simple return statement
	{
		return getAllProducts(state);
	}
	static function getAllProducts(state:ProductListModel):Array<ProductInStore> {  // 3. Static getter function to be registered under Vuex store under current class's namespace
		return state.all;
	}  

	// (For the Haxe+JS proxy getter function, at runtime initialization, it uses runtime function body string sniffing to determine linked static getter function via return StaticClassPath.staticGetterName)
	//  For the Static getter function, You aren't restricted to only returning static getter method references in this class. 
	// Referencing any other class's static getter method is also possible.
		// eg. return getAllProducts -versus- return SomeClass.genericStaticGetter(state).
		
	
	// Actions
	@action static var action:ProductListDispatcher;
	
	
	// Mutations
	@mutator static var mutator:ProductListMutator; 
	
}

@:rtti
class ProductListDispatcher {
	
	@mutator static var mutator:ProductListMutator;
	static var shop:Shop = Shop.getInstance();
	
	public function getAllProducts():IVxStoreContext<ProductListModel>->Void {  
		return function(context:IVxStoreContext<ProductListModel>) {
			shop.getProducts( function(products) {
				mutator.receiveProducts(products);
			});
		}
	}
}

@:rtti
class ProductListMutator extends AppMutator<ProductListModel> {
	override public function receiveProducts<P:Array<ProductInStore>>(payload:P):ProductListModel->P->Void {
		return function(state:ProductListModel, payload:P):Void {
			state.all = payload;
		};
	}
	
	override public function addToCart<P:ProductIdentifier>(payload:P):ProductListModel->P->Void {
		return function(state:ProductListModel, payload:P):Void {
			var filtered = state.all.filter( function(p) { return p.id == payload.id;  } );
			if (filtered.length > 0) {
				filtered[0].inventory--;
				
			}
		};
	}
	
}

@:rtti
class ProductListModel {  //eg. class style store module state
	
	// ensure class's reactive states have all their properties initialized beforehand (even null references "=null"), in order to be reactive to VueJS.
	public var all:Array<ProductInStore> = [];
	
	public function new() {
		
	}
}
