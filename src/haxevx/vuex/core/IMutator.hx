package haxevx.vuex.core;

/**
 * Just a marker class to initiaite build macro for mutator classes
 * @author Glidias
 */
@:autoBuild(haxevx.vuex.core.VuexMacros.buildMutator())
@:remove
interface IMutator 
{
  
}