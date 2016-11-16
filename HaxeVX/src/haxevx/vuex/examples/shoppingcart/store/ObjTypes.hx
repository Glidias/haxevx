package haxevx.vuex.examples.shoppingcart.store;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes.Product;

/**
 * Generic object/payload data types
 * @author Glidias
 */

 // Objects
 
typedef Product = {
	 id:String, 
	 price:String,
	title:String
 }
 
typedef ProductInCart = {
	> Product,
	quantity:Int,

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
	id:String
}

