package haxevx.vuex.core;

import haxevx.vuex.core.NativeTypes;
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
	
	// override this to determine starting default values for props if needed, 
	// else, P will be dynamicaly instantiated (from RTTI) if specified a given specific class outside of NoneT or Dynamic or Typedef
	// to determine any default values (if available)
	function getNewProps():P {
		return null;
	}
	
	// override this to determine starting values for any component data state, if needed 
	// else, D will be dynamicaly instantiated (from RTTI) if specified a given specific class outside of NoneT or Dynamic or Typedef.
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

	
	
	// internal method to convert VxComponent to native VueJS Component type or any native environment
    @:final public function _toNative():NativeComponent {
		// todo: create VUEJS component options from this component!
		
		
		return null;
	}
	
	

	
}