package haxevx.proxy.immutable;

/**
 * ...
 * @author Glidias
 */
@:native("Immutable.List") extern class  ImmutableList<T>
{
	 public function new() {
		
		
	}
	
	public function get(index:Int):T;
	public function set(index:Int, value:T):T;// ImmutableRecord<T>;
	public function has(index:Int):Bool;
	public function count():Int;
	
}

class ImmutableListIterator<T> {
	
	var i:Int;
	private var imm:ImmutableList<T>;
	var len:Int;
	
	
	 public function new(list:ImmutableList<T>) {
		 imm = list;
		 i = 0;
		 len = list.count();
	}
	
	 public function hasNext() {
		return i < len;
	  }

	  public function next() {
		return imm.get(i++);
	}
}