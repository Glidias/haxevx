# haxevx

## HaxeVX - Haxe-powered VueJS/Vuex development

### Type-safe coding to target Vuex/VueJS environments using Haxe compile-time Macros and Classes. ~~~runtime Reflection/Metadata and RTTI (runtime-type information)~~~.

With HaxeVx, you get the benefit of massive access-control/type-hinting/type-checking/compile-time safety, etc. inherant within Haxe when developing VueJS/Vuex applications. Compile-time mixins/macros/checks are provided specifically for your Haxe classes to ensure they conform to the necessary VueJS conventions.

For what features are available, documentations can be found in wiki:
https://github.com/Glidias/haxevx/wiki

Examples (based off Vuex repository examples) can be found [here](https://github.com/Glidias/haxevx/tree/master/src/haxevx/vuex/examples)
	
Currently, the working Shopping Cart example (ported from the Vuex example) is available and shown by default in the bin folder. 

Roadmap can be found [here](https://github.com/Glidias/haxevx/issues/2)
	

____________


Vuex integration:
	
Even though Vuex boilerplate is avoided (via Haxe macro/reflection api), the current approach involves using class helper mutator/actions methods without managing/matching [constant] strings with Babel/ES6 helpers and such.

In short, this is a Vuex implementation that avoids having to handle any strings. Instead, call strictly-typed functions with specifically typed parameters/requirements. At runtime, HaxeVX will convert these method calls to string-based commits/dispatches accordingly with automatic namespacing depending on which class they originated/extended from.

Vue/Vuex:

HaxeVX for Vue currently works under the premise of having ~~~both~~~ compile-time checkings done within Haxe, ~~~and runtime initialization checkings of your app within Javascript as it converts it's HaxeVX core classes to native VueJS components~~~ (edit: this is no longer the case. Runtime reflection/initialization should be heavily minimised for VueX and is now completely removed in Vue). With Haxe's type-strict compiling (via only compile time macro checks), the chances of you running into runtime initialization/operation errors are minimized for both platforms.

As of now, this draft is working under Haxe 3.3.0.

_____

Deployment info:
	
The current package is under haxevx.* namespace. Examples folder can be omitted for deployment.

______

Main links:

VueJS - https://vuejs.org/
Vuex - https://vuex.vuejs.org/en
Haxe - http://haxe.org
