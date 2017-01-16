package haxevx.vuex.core;

/**
 * Marker class to indicate a module that proxies to a particular private state.
 * Also used for store getter classes that proxies to a particular private state.
 * 
 * @author Glidias
 */
@:autoBuild(haxevx.vuex.core.VuexMacros.buildVModuleGetters())
class VModule<T>
{
	 var state:T;

}