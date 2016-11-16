package haxevx.vuex.core;

/**
 * Base generic class for Vue Component instance helpers under VueX.
 * 
 * This is where the view mediation (or template/virtual dom rendering) resides per view component.
 * @author Glidias
 */
/**
 * S (store state's data type),  Data (component state's data type, if any), P (component properties data type)
 * If not applicable, use NoneT marker.
 * 
 */
class VxComponent<S:IVxContext, D, P> extends VComponent<D,P>
{
	var store(get, null):S;
	inline function get_store():S 
	{
		return untyped __js__("this.$store");
	}
	
}