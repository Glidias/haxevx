package haxevx.vuex.core;

import haxevx.vuex.native.Vue;
import haxevx.vuex.native.Vuex;

/**
 * Just a cross-platform list of typedefs specifically to link to native-platform/framework related data types.
 * @author Glidias
 */

typedef NativeComponent = ComponentOptions;
typedef NativeStore<T> = StoreOptions<T>;
typedef NativeModule<T,R> = Module<T,R>;
typedef NativeGetters<T,R> = GetterTree<T,R>;