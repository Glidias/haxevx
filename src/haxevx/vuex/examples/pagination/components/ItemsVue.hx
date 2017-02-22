package haxevx.vuex.examples.pagination.components;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VComponent;
import haxevx.vuex.examples.pagination.components.ItemsVue.MyItem;
import haxevx.vuex.examples.pagination.model.PaginationOf;


/**
 * WIP
 * Example specific vue component to compose a paginated list of items
 * 
 * <Component :curPageIndex={this.$data.somePageIndex} />
 * 
 * @author Glidias
 */
@:expose("haxevx.awesome.vue.ItemsVue")
@:vueIncludeDataMethods
class ItemsVue extends VComponent<PaginationOf<Array<MyItem>>, NoneT>
{
	var __injectTemplate:String;
	var __injectData:PaginationOf<Array<MyItem>>;

	public function new(injectTemplate:String=null, injectData:PaginationOf<Array<MyItem>>=null) 
	{
		__injectData = injectData;
		
		__injectTemplate = injectTemplate;
		if (injectTemplate == null) {
			__injectTemplate = getExampleTemplate();
		}
		super();
	}
	
	// without back ticks, Haxe truly sucks when it comes to string-based templating within .hx files!!
	// Use of "${"   and  "}"  is done  to escape v-bindings of attributes within single quoted template....
	//  ...and tab-spacings between them are used for "slightly-better" clarity.
	public static function getExampleTemplate():String {
		return '
			<div class="itemlist-holder">
				<ul class="items" :style="${"	{'transform':'translateX('+(-clampDownPaginateViewIndex*100/itemsPerPage)+'%)'}		"}">
					<li v-for="item in items">
						Item goes here
					</li>
				</ul>
			</div>
		';
	}

	override public function Template():String {
		return __injectTemplate;
	}
	

	
	override public function Data():PaginationOf<Array<MyItem>> {
			// this is a bit hackish, need to look into replacing __ through vOptions , while maintianining strict typing
		return untyped _vOptions.__injectData != null ? _vOptions.__injectData : new PaginationOf(0, 5);
	}
	
}


typedef MyItem =  {	
	
	// based of Shopify Product, only a subset of needed properties...  https://help.shopify.com/api/reference/product
	var id:Int;
	var title:String;
	var tags:String;
	@:optional var image:{src:String};
}

