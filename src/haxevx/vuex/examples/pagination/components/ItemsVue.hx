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
			__injectTemplate = getDefaultTemplate();
		}
		super();
	}
	
	function getDefaultTemplate():String {
		return '
			<ul class="items">
				<li v-for="item in paginatedItems" :data-id="item.id">
					<h3>{{ item.title }}</h3>
					<img :src="item.image != null ? item.image.src : item.image"></img>
					<div class="tags">{{ item.tags }}</div>
				</li>
			</ul>
		';
	}
	
	var paginatedItems(get, never):Array<MyItem>;
	
	function get_paginatedItems():Array<MyItem> {
		// return computed list of paginated items based on curPageIndex
		return  _vData.getMyPaginatedList();
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

