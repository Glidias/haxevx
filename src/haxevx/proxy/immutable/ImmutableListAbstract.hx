package haxevx.proxy.immutable;
import haxevx.proxy.immutable.ImmutableList.ImmutableListIterator;

/**
 * An abstract wrapper over immutable list to support array-like functionalitities
 * @author Glidias
 */
abstract ImmutableListAbstract<T>(ImmutableList<T>)
{
	public inline function new(values:Array<T>):Void {
		
		this = Immutable.fromJS(values);
		
	}
	
	public inline function get(index:Int):T { return this.get(index); } 
	public inline function set(index:Int, value:T):T { return this.set(index,value); } 
	public inline function has(index:Int):Bool  {return this.has(index); } 
	public inline function count():Int { return this.count(); }
	
	inline function get_length():Int 
	{
		return count();
	}
	public var length(get, never):Int;
	
	@:arrayAccess
	 inline function arrayGet(key:Int) {
	  return this.get(key);
	}
	
}