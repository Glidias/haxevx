package haxevx.vuex.examples.pagination.model;
import haxevx.vuex.core.IBuildListed;

/**
 * A platform agnostic view data model to manage pagination of items and reflect the pagination states of those items. 
 * Items could be either an Array or raw Integer in order to reflect how many items to display.
 * 
 * For Javascript platform, this can be used without Vue....or mixed into a Vue as a reactive `D` data component. 
 * (See  information below)
 * ________
 * 
 * (How it works) Implementation into HaxeVx's Vue JS:
 * 
 * Because this class implements a IBuildListed marker interface to initiate a VxMacros.buildRegisterListed() macro, 
 * it's custom methods/getters/setters may also be included into any native Vue component definitions as well.
 * 
 * As of now, to also include data model's public methods and getter/setter implementations (as computed properties) into the HaxeVx's Vue component class itself as proxied properties,
 * the only way is to:
 * Have this data model class implements IBuildListed marker class (a requirement for initiate macro), and the Vue component class must also use metadata `@:vueIncludeDataMethods` to signify it
 * wants to include the data model's methods/getters/setters into the Vue component class itself. This will allow for vue-caching and easy templating by treating
 * the data model methods/getters as local Vue methods/getters as well, without having to manually re-write out the proxying accessors again in the Vue component class
 * to access _vData's underlying implementation.
 * 
 * To avoid code bloat/duplication, it will proxy in only the public methods and public getters/setters,  as proxied vue methods/accessors into the existing _vData. 
 * Anything declared as `private` within the given IBuildListed model class will not be included into the Vue component class, but will be kept fully encapsulated within _vData.
 * Note that any inlined methods within the class may still result in some form of code duplication due to the inlining behind the scenes. 
 * 
 * ____
 * 
 * (How it works) Implementation into native Vue JS
 * 
 * With both runtime metadata and reflection of class properties, a runtime conversion of the given model class to Vue component definition can be used.
 * Currently, no such implementaiton is being made as I prefer the compile-time typechecking you get when authoring Vue components in HaxeVx.
 * 
 * @author Glidias
 */
@:keep
@:expose("haxevx.awesome.model.PaginationOf")
class PaginationOf<T> implements IBuildListed
{
	// to be  supplied externally from outside, can be either an Array or Integer
	var dynItems:Dynamic;
	public var items(get, set):T;
	inline function get_items():T {
		return dynItems;
	}
	function set_items(val:T):T {
		dynItems = val;
		isArrayType = Std.is(dynItems, Array);
		if (!isArrayType && !Std.is(dynItems, Int)) {
			trace("PaginationOf unsupported warning: Items supplied is neither integer nor array type!: "+dynItems);
		}
		return val;
	}

	public var totalItems(get, never):Int;
	inline function get_totalItems():Int {
		return (isArrayType ? dynItems.length  : dynItems);
	}
	
	public var itemsPerPage:Int = 5;
	
	var isArrayType(default,null):Bool = false;
    var curPaginateViewIndex(default, null):Int = 0;  // the current item view index starting from first item listed
	
	// useful for setting setCurPageIndex based on selected item
	public static inline function getPageIndexOfItemIndex(itemIndex:Int, totalItemsPerPage:Int):Int {
		return Math.floor( itemIndex /  totalItemsPerPage ) ;
	}
	public static inline function getPageNumberOfItemIndex(itemIndex:Int, totalItemsPerPage:Int):Int {
		return getPageIndexOfItemIndex(itemIndex, totalItemsPerPage)  +1;
	}
	
	public static inline function getStartItemIndexOfPageIndex(pageIndex:Int, totalItemsPerPage:Int):Int {
		return pageIndex * totalItemsPerPage - 1;
	}
	
	public static inline function getLastItemIndexOfPageIndex(pageIndex:Int, totalItemsPerPage:Int):Int {
		return getStartItemIndexOfPageIndex(pageIndex,totalItemsPerPage) + totalItemsPerPage -1;
	}
	
	public static inline function getLenIndexOfPageIndex(pageIndex:Int, totalItemsPerPage:Int):Int {
		return  getStartItemIndexOfPageIndex(pageIndex, totalItemsPerPage) + totalItemsPerPage;
	}
	
	
	public static function getPaginatedList<T>(curPageIndex:Int, refArray:Array<T>, itemsPerPage:Int):Array<T> {
		var newArr:Array<T> = [];
		for (i in getStartItemIndexOfPageIndex(curPageIndex, itemsPerPage)...getLenIndexOfPageIndex(curPageIndex, itemsPerPage)) {
			newArr.push(refArray[i]);
		}
		return newArr;
	}
	
	public function getMyPaginatedList<U>(curPageIndex:Int):Array<U> {
		var newArr:Array<U>;
		if (!isArrayType) {
			throw("dynItems Needs to be array type for this function to work!");
			/*		// consider mock array?
			newArr = [];
			newArr.length = itemsPerPage;
			*/
		}
		var refArr:Array<U> = dynItems;
		return getPaginatedList(curPageIndex, refArr, itemsPerPage);
		
	}

	public function new(items:T, itemsPerPage:Int=0) 
	{
		setup(items, itemsPerPage);
	}
	
	// setup and validation
	
	public function setup(items:T, itemsPerPage:Int=0):Void {
		this.items = items;
		if (this.itemsPerPage != 0) this.itemsPerPage  = itemsPerPage;
		validate();
	}
	
	@:watch(totalItems) public function notifyTotalItemsChange(val:Int):Void {
		validate();
	}
	
	@:watch(itemsPerPage) public function notifyItemsPerPageChange(val:Int):Void {
		validate();
	}
	
	public function validate():Void {
		var totalPages = this.totalPages;
		
		if (totalPages == 0) this.curPaginateViewIndex = 0;
		else {
			var chkPageIndex = this.curPageIndex;
            if (chkPageIndex >= totalPages && totalPages > 0  ) {
                this.setCurPageIndex(totalPages- 1);
            }
		}
	}
	
	// ------ methods and accessors
	
	public function traceStuff() {
        trace(traceString);
    }
	
	public var traceString(get, never):String;
	function get_traceString():String {
		return this.curPaginateViewIndex + " / " + this.totalItems + "," +this.itemsPerPage + " :" + this.curPageIndex + ">> " + this.totalPages;
	}
	
	public var totalPages(get, never):Int;
	inline function get_totalPages():Int { 
        return Std.int(Math.ceil( this.totalItems / this.itemsPerPage ));
    }
	
	public var hasNextPage(get, never):Bool;
	inline function get_hasNextPage():Bool {   
        return this.curPageIndex < this.totalPages - 1;
    }
	
	public var hasPrevPage(get, never):Bool;
	inline function get_hasPrevPage():Bool {  
         return this.curPageIndex > 0;
    }
	
	public var curPageIndex(get, never):Int ;
	inline function get_curPageIndex():Int {   
        return Std.int( Math.floor(this.curPaginateViewIndex / this.itemsPerPage) );
    }
	

	public inline function setCurPageIndex(index:Int):Void {
        this.curPaginateViewIndex =    index * this.itemsPerPage;
    }


	public function gotoNextPage():Bool {  
         if (!this.hasNextPage) return false;
        this.curPaginateViewIndex  = (this.curPageIndex + 1) * this.itemsPerPage;
        return true;
    }
	
	public function gotoPrevPage ():Bool {  
         if (!this.hasPrevPage) return false;
        this.curPaginateViewIndex  = (this.curPageIndex - 1) * this.itemsPerPage + (this.itemsPerPage-1);
        return true;
    }
	
	var clampDownPaginateViewIndex(get,never):Int;
    function get_clampDownPaginateViewIndex () { 
        var totalPages = this.totalPages;
        var curPageIndex = this.curPageIndex;
       return totalPages  <=1  || curPageIndex != totalPages - 1  ?   curPageIndex * this.itemsPerPage :  this.totalItems - this.itemsPerPage;
     
    }
	
    inline function getClampDownScrollFloatingIndex()  {
        return this.clampDownPaginateViewIndex /  this.itemsPerPage;
    }
	
}