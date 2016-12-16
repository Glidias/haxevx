package haxevx.proxy.egoutput;
import haxe.ds.StringMap;
import haxevx.proxy.ProxyRecord;
import haxevx.proxy.egoutput.ImmutableRoot;

/**
 * Proposal of generated class item (mock example) that proxies to a particular immutable state map collection "_m_"
 * (or any other external framework collection map class).
 * 
 * @author Glidias
 */
class ListItem implements ImmutableRoot implements ImmutableSetIn
{

	// eg. primitive properties generated from macro
	
	public var title(get, set):String;
	public inline function get_title():String {
		return get("title");
	}
	public inline function set_title(value:String):String {
		set("title", value);
		return value;
	}
	
	public var copy(get, set):String;
	public inline function get_copy():String {
		return get("copy");
	}
	public inline function set_copy(value:String):String {
		set("copy", value);
		return value;
	}
	
	// eg. obj properties generated from macro  (setting up of sub-object cursors)
	
	public var secondaryItem(get, set):ListItem;
	public inline function get_secondaryItem():ListItem {
		_secondaryItem._root_ = _root_ != null ? _root_ : this;
		_secondaryItem._path_ = _path_ != null ? _path_.concat(["secondaryItem"]) : ["secondaryItem"];
		return _secondaryItem;
	}
	public inline function set_secondaryItem(value:ListItem):ListItem {
		_secondaryItem = value;
		set("secondaryItem", (value != null ? value._m_ : null) );
		return value;
	}
	var _secondaryItem:ListItem;
	
	
	// Custom methods that a user may wish to add
	public function getCombinedText():String {
		return title + " :: " +copy;
	}
	
		
	public function new() 
	{
		
	}
	
	
	// BOILERPLATE 
	
	// the immutable collection or some other collection type to proxy to. It is reccomended to initialize the collection so that
	// each Class wrapper proxies only to 1 exclusivley self-owned instance of it. 
	// It's possible to set the _m_ (aka. _map_ ) property internally to null or something else, but this should NOT be done!
	//  As you can see, the _m_ property (and other internally generated proeprties) are 'uglily' named with 2 enclosing underscores 
	// to discourage end-users from touching it!
	var _m_(default, null):StringMap<Dynamic> = new StringMap<Dynamic>();
	
	// what will be generated  by macro through interface
	
	public function set(prop:String, val:Dynamic):Void {
		if (_root_ != null) {	// need to set value from root state atom and designated path
			_root_.setIn(_path_.concat([prop]), val);
		}
		else {  // this is the root, so can just set up it's property like a root state atom
			_m_.set(prop, val);  // note: will need to reset to new _m_ reference from immutable data structure (ie. _m_ = _m_.set(prop,value) )
		}
	}
	public inline function get(prop:String):Dynamic {
		return _m_.get(prop);
	}

	
	/* INTERFACE haxevx.proxy.egoutput.ImmutableRoot */
	
	public function setIn(path:Array<String>, value:Dynamic):Void 
	{
		// just an example, can't do it unless you're using an immutable data strcture class
		//_m_ =_m_.setIn(path, value);
		
		var parentRef:Dynamic = this;
		var ref:Dynamic;
		
		// update any nested item references along chain monkey-patch
		for (i in 0...path.length) {
			ref = untyped parentRef[ "_" + path[i]];
			if (ref == null) {  // assuming that under _underscored references only refer to obj properties, 
				// might either yield leaf value (to  result in null) or nesting object that requires updating,
				// , bleh, problematic.. 
				
				// predictive check to detect for outdated null-pointer paths
				 if (i < path.length - 1) trace("EXCEPTION :: Unxpected null reference path detected..exiting..");
				return;			
			}
			ref._m_ = parentRef._m_.get(path[i]);  // syncronise outdated reference along path
			parentRef = ref;
			
		}
		
		// instead of the above hackish patch approach, why not handle setting nested properties manually from the bottom up withint he regular set(property, value) method.
		// eg. From bottom up instance 
		/*
		this._m_ = this._m_.set(property, value);
		if (root != null) {  // use a kind of this.setFrom(path, parentStack, property, value);  bottom up approach to update references across all parents upwards.
			var i = path.length;
			var cVal = this._m_;
			while( --i > -1 ) {
				var parenter = parentStack[i];
				parenter._m_ = cVal = parenter._m_.set(path[i], cVal);
			}
		}
		*/  // This means there's no need to use Immutable.setIn method anymore
	}
	
	
	/* INTERFACE haxevx.proxy.egoutput.ImmutableSetIn */
	public var _root_:ImmutableRoot;
	public var _path_:Array<String>;
	
}