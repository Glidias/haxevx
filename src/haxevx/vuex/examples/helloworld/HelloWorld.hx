package haxevx.vuex.examples.helloworld;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VComponent;
import haxevx.vuex.native.Vue.CreateElement;
import haxevx.vuex.native.Vue.VNode;

/**
 * ...
 * @author Glidias
 */
class HelloWorld extends VComponent<HelloWorldData, NoneT>
{
	var __el:String;

	public function new(el:String) 
	{
		__el = el;
		super();
		
	}
	
	override function Render(c:CreateElement):VNode {
		return c("div", null , _vData.message);
	}
	
	override function El():String {
		return __el;
	}
	
	override function Data():HelloWorldData {
		return new HelloWorldData("Hello world in HaxeVx");
	}
	
	
}

class HelloWorldData {
	public function new(msg:String) {
		this.message = msg;
	}
	public var message:String;
}