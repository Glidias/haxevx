package haxevx.vuex.examples.shoppingcart.store;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes.Product;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes.ProductInCart;

/**
 * Generic object/payload data types
 * @author Glidias
 */

 // Objects
 
typedef Product = {
	 id:Int, 
	 price:Float,
	title:String
 }
 
typedef ProductInCart = {
	> Product,
	id:Int,
	quantity:Int
}

typedef ProductInStore = {
	> Product,
	inventory:Int,
	
}
typedef ProductHistory = {
	savedCartItems:Array<ProductInCart>
}


// Payload
typedef ProductIdentifier = {
	id:Int
}

