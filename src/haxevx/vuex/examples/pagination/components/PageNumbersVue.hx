package haxevx.vuex.examples.pagination.components;
import haxevx.vuex.core.NoneT;
import haxevx.vuex.core.VComponent;
import haxevx.vuex.examples.pagination.model.PaginationOf;


/**
 * WIP
 * @author Glidias
 */
@:expose("haxevx.awesome.vue.PageNumbersVue")
@:vueIncludeDataMethods
class PageNumbersVue extends VComponent<PaginationOf<Int>,NoneT>
{
	var __injectTemplate:String;
	var __injectData:PaginationOf<Int>;

	public function new(injectTemplate:String=null, injectData:PaginationOf<Int>=null) 
	{
		__injectData = injectData;
		
		__injectTemplate = injectTemplate;
		if (injectTemplate == null) {
			__injectTemplate = getExampleTemplate();
		}
		else if (__injectTemplate == "") {
			__injectTemplate = null;
		}
		super();
	}
	
	
	// without back ticks, Haxe truly sucks when it comes to string-based templating within .hx files!!
	public static function getExampleTemplate():String { 
		return '
			<div class="page-numbers">
				<a v-for="n in totalItems" :href="${"	'http://www.google.com/?page='+n	"}" style="display:inline-block;"></a>
			</div>
		';
		
	}
	
	override public function Template():String {
		return __injectTemplate;
	}
	
	override public function Data():PaginationOf<Int> {
		// this is a bit hackish, need to look into replacing __ through vOptions , while maintianining strict typing
		return untyped _vOptions.__injectData != null ? _vOptions.__injectData : new PaginationOf(0, 5);
	}
	
}
