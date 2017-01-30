package haxevx.vuex.core;

/**
 * @author Glidias
 */
@:autoBuild(haxevx.vuex.core.VuexMacros.buildVModuleGetters())
interface IModule<S, RS>
{
	private var state:S;
	
}