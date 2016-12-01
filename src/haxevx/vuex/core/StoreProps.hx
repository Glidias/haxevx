package haxevx.vuex.core;


/**
 * Optional class to compose into an existing property class to facilitate bind it to store
 * @author Glidias
 */
class StoreProps<T>
{

	// unavoidable boilerplate to cheat the system, and no good typing here
	var store(get, null):T;
	inline function get_store():T 
	{
		return untyped __js__("this.$store");
	}
	
}