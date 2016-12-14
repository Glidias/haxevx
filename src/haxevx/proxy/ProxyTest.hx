package haxevx.proxy;
import haxe.ds.StringMap;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxevx.proxy.ProxyRecord;


/**
 * ...
 * @author Glidias
 */
/*

*/
class ProxyTest extends ProxyRecord 
{

	var yetAnotherProperty(get, set):Int;	
	public var myProp(get, set):String;
	public var anotherProp(get, set):String;
	
	public function new() 
	{
	
		yetAnotherProperty = 4;
		yetAnotherProperty += 4;
		myProp = "2vav";
		
	}
	
	
}

