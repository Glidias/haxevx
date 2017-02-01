package haxevx.vuex.core;
import haxevx.vuex.core.IVxContext.IVxContext1;

/**
 * Vuex store context. If under a different module, state often results in a different value.
 * @author Glidias
 */
@:autoBuild(haxevx.vuex.core.VuexMacros.buildVModuleGetters(true))
@:remove
interface IVxStoreContext<S> extends IVxContext1<S>
{


}