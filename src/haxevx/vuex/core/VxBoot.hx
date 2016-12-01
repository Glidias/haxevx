package haxevx.vuex.core;
import haxevx.vuex.native.Vue;

/**
 * Standard Boot utility to initialize Haxe codebase to convert it to native VueJS/Vuex App!
 * @author Glidias
 */
class VxBoot
{

	public static function start(rootVue:VComponent<Dynamic, Dynamic>, store:VxStore<Dynamic, Dynamic> = null, otherComponents:Array<VComponent<Dynamic,Dynamic>> = null):Vue {
		
		if (store != null) {
			//store._toNative();
		}
		if (otherComponents != null) { 
			// otherComponents
			
		}
		var vm =  new Vue( rootVue._toNative() );
		return vm;
	}
	
}