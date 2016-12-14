package haxevx.proxy;
import haxevx.proxy.ProxyGenerator;

@:remove
@:autoBuild(haxevx.proxy.ProxyGenerator.build())
interface Proxied { 
	
	function set(prop:String, val:Dynamic):Dynamic;
	function get(prop:String):Dynamic;

}