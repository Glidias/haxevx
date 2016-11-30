package haxevx.vuex.core;

/**
 * A marker+base class to indicate properties that support functional default-value bindings to store data.
 * 
 * To define a store binding on the extended class without having to pass properties down, use the following format:
 * 
 * example:
 * 
	public var products(default, null):Array<ProductInStore>;
	function get_products():Array<ProductInStore>
	{
		return store.products.allProducts;
	}
 * 

 * Return data type between property name and get_property name must match, use get_{methodName} format to match related handler. 
 * Warning: This CANNOT be type-checked at runtime, only during runtime initialization with RTTI.  RTTI for extended class is required to perform this check.
 * Remember that "read" access for variable is set to "default", not "get", to ensure property is read directly. Important! This is different from standard haxe getter which defines computed getters on VxComponent instances!
 * 
 * Generally though, it's still better practice to manually pass properties down to components than bind defaults directly to store, to avoid tighly coupling internal component logic with application logic.
 * 
 * @author Glidias
 */
class PropsBindedToStore<S>
{

	var store(get, null):S;
	inline function get_store():S 
	{
		return untyped __js__("this.$store");
	}
}