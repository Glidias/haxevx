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
 
typedef ProductAdded = {	// products added to cart
	id:Int,
	quantity:Int
}
 
typedef ProductInCart = {  // computed display of products for cart
	> Product,
	quantity:Int
}

typedef ProductInStore = {	// products in store
	> Product,
	inventory:Int,
	
}
typedef ProductHistory = {
	savedCartItems:Array<ProductAdded>
}


// Payload
typedef ProductIdentifier = {
	id:Int
}

