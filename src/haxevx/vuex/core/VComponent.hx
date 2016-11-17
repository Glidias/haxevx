package haxevx.vuex.core;

/**
 * ...
 * @author Glidias
 */
class VComponent<D, P>
{
	var props(get, null):P;
	inline function get_props():P 
	{
		return untyped this;
	}

	var data(get, null):D;
	inline function get_data():D 
	{
		return untyped __js__("this.$data");
	}
	
	// override this to determine starting default values for related data types if needed
	function getNewProps():P {
		return null;
	}
	
	function getNewData():D {
		return null;
	}
	
	// override this implementation for custom initialization actions if needed
	function Created():Void {
		
	}
	
	
	// override this implementation to use a custom render method instead to render Virtual DOM
	function Render():Dynamic {
		return null;
	}

	// override this implementation to use a custom template string reference or markup
	function Template():String {
		return null;
	}
	
	// override this register components locally
	function Components():Dynamic<VComponent<Dynamic,Dynamic>>  {
		return null;
	}

	
	
	// internal method to convert VxComponent to native VueJS Component or any native environment
    @:final public function _toNative():Dynamic {
		// todo: create VUEJS component from this component!
		return null;
	}
	
	

	
}