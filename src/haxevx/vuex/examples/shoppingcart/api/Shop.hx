package haxevx.vuex.examples.shoppingcart.api;
import haxe.Timer;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes;

/**
 * api/shop.js port
 * Mocking client-server processing
 * @author Glidias
 */
class Shop
{

	var _products:Array<ProductInStore> = [ 
		{"id": 1, "title": "iPad 4 Mini", "price": 500.01, "inventory": 2},
		  {"id": 2, "title": "H&M T-Shirt White", "price": 10.99, "inventory": 10},
		  {"id": 3, "title": "Charli XCX - Sucker CD", "price": 19.99, "inventory": 5}
	];
	
	// oh well, a singleton is convenient...
	static var INSTANCE:Shop;
	
	 function new() {
		
	}

	 // oh well, until we have an @inject implementation? For demo purposes this would do..
	public static function getInstance():Shop
	{
		return INSTANCE != null ? INSTANCE : (INSTANCE = new Shop());
	}
	
	
	
	public function getProducts(cb:Array<ProductInStore>->Void):Void {
		Timer.delay( function() { cb(_products); } , 100);
	}
	
	public function buyProducts(products:Array<ProductInCart>, cb:Void->Void, errorCb:Void->Void):Void {
		Timer.delay( function() { Math.random() > 0.5 ? cb() : errorCb(); } , 100);
	}
	
}