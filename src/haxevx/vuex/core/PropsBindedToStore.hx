package haxevx.vuex.core;

/**
 * A marker+base class to indicate properties that support functional default-value bindings to store data.
 * 
 * Generally though, it's still better practice to manually pass properties down to components than bind defaults directly to store, 
 * to avoid tighly coupling internal component logic with application logic. However, being able to access global store within your properties
 * and auto-bind them with a default implementation can be a good way to avoid repetitively boilerplating default/common app bindings being passed down. 
 * Be warned that default property bindings can be accidentally overwritten with matching attributes names in your component nodes  if you're using String based templates or untyped property
 * definitions!
 * 
 * To define a store binding, extend this class and define a pseudo/actual getter in the following format:
 * 
 * example for readonly property (always stuck to default binding implementation):
 * 
	public var products(default, null):Array<ProductInStore>;  
	function get_products():Array<ProductInStore>
	{
		return store.products.allProducts;
	}
	
	// or:   public var products(get, null):Array<ProductInStore>;  // use, "get" for standard actual Haxe functional getter vs "default". 
	// NOTE: "get" will invoke the extra function call whenever you access the property (also more field memory usage to support dummy redirects), and isn't as performant as the "default" approach,
	// However, "get" provides compile-time type-checking (for matching types) while "default" will only provide runtime initialization type-checking.
	// The same performance tradeoffs will apply when defining "computed" getter properties/methods under VxComponents , whether "default" vs "get" is used.
	
	One way is to differentiate between strict compile-time type checking vs actual deployment, is to use with conditional compiling with some flag..:
	eg.
	
	public var products(#if compile_strict get #else default #end, null):Array<ProductInStore>;  
	function get_products():Array<ProductInStore>
	{
		return store.products.allProducts;
	}
	
	So that if you prefer to perform strict compile time checking first to ensure your computed getter types match with their handler functions,
	you can enable the flag "compile_strict" to invoke a "get" compiling check! Your 2nd compile may exclude this flag once the initial compile-time type checks are done.
	
	////////////////
	
	To define a property that is both read/write, ie. having  both a default implementation and something that can be overriden at runtime by overriding VxComponent.getProps(), 
    you can use the following format to support compile time typechecking with "compile_strict" flag: 	eg.
	
	@:isVar public var products(#if compile_strict get #else default #end, null, set):Array<ProductInStore>;  
	function get_products()
	{
		return store.products.allProducts;
	}
	inline function set_products(val:Array<ProductInStore>)
	{
		return (products = val);
	}

	However, the approach above is bad because you may overwrite properties within the component code itself.. which is against VueJS rules. 
	(VueJS dev mode will provide runtime warnings if you mutate component props while the component is already running!).
	
	One way of avoiding the above case , is always stick to (default, null) or (get, null), as mentioned before,
	and only provide a means of supplying property values as constructor parameters, for those parameters that can be overriden at runtime. 
	This provides full property access-safety at the expense of typical constructor boilerplate.
	
	eg.
	
	class MyProductsStoreProps extends PropsBindedToStore<AppStore> {
	
		@:isVar public var products(#if compile_strict get #else default #end, null):Array<ProductInStore>;  
		function get_products():Array<ProductInStore
		{
			return store.products.allProducts;
		}
		
		public function new(products:Array<ProductInStore>=null) 
		{
			if (products != null) this.products = products;
		}
	
	}
	
	For further full access safety, it is highly reccomended that you redirect all prop binding methods to a seperate helper class method to limit property access scope
	to only the supplied global store parameter only. This is because it's generally buggy to accidentally access any other local properties within the current scope for default bindings to store, 
	(those properties might not be initialized yet during resolution of bindings), thus, only the global store should be accessed to determine the value of the binding.
	
	eg.  redirect to HelperMethods, outside of existing MyProductsStoreProps class
	
	function get_products():Array<ProductInStore>
	{
		return HelperMethods.Products(store);
	}
	
	// to..
	
	class HelperMethods { // class containing helper methods  to limit access scope to only available parameters within methods and other similar inline methods
	
		public static inline function Products(store:AppStore):Array<ProductInStore> {
			return store.products.allProducts;
		}
	}
	
	// By convention (disclaimer:: my personal taste), such helper classes have their method names capitalized to emphasise that they are inlining methods and/or exist within the context of 
	the specialized helper Class. You can safety use other methods within the Helper class within the current processing method.
	
	Note that keeping the methods inline ensures code runtime-optimized to avoids additional function calls, though you may choose to not inline certain helper methods at your own discretion, if you
	think it might bloat the codebase unnecessarily.
	
	
 * 
 * 
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