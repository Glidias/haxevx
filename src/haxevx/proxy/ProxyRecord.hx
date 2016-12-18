package haxevx.proxy;
import haxe.ds.StringMap;
import haxevx.proxy.Proxied;

/**
 * A  base class example proposal (to be extended from or used as an example for composition) 
 * to allow proxy-linking of Haxe class' strictly typed properties to specific frame-work specific collection data structures.
 * Whether to wrap or extend some sort of Collection, Immutable structure, etc. 
 * is to be decided based on application needs (likely to wrap a collection via composition).
 * 
 * @see Proxied
 * 
 * @author Glidias
 */
class ProxyRecord  {

	var map:StringMap<Dynamic> = new StringMap<Dynamic>();
	
	public function set(prop:String, val:Dynamic):Dynamic {
		map.set(prop, val);
		return val;
	}
	public function get(prop:String):Dynamic {
		return map.get(prop);
	}
}