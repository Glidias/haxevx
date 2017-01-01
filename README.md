# haxevx

## HaxeVX - Haxe-powered VueJS/Vuex development

### Type-safe coding to target Vuex/VueJS environments using Haxe compile-time Macros and Classes. ~~~runtime Reflection/Metadata and RTTI (runtime-type information)~~~.

Still in early draft stage, but some ideas i've been tossing around with regards to developing in Haxe to target/construct a VueJS/VueX 2.0 application. With it, you get the benefit of massive type-hinting/type-checking/compile-time safety, etc. inherant within Haxe. 

Examples (based off Vuex repository examples) can be found [here](https://github.com/Glidias/haxevx/tree/master/src/haxevx/vuex/examples)
	
Currently, the working Shopping Cart example (ported from the Vuex example) is available and shown by default in the bin folder. 

Roadmap can be found [here](https://github.com/Glidias/haxevx/issues/2)
	
Documentations can be found in wiki:
https://github.com/Glidias/haxevx/wiki
	
____________


Vuex integration:
	
Even though Vuex boilerplate is avoided (via Haxe macro/reflection api), the current approach involves using class helper mutator/actions methods without managing/matching [constant] strings with Babel/ES6 helpers and such.

In short, this is a Vuex implementation that avoids having to handle any strings. Instead, call strictly-typed functions with specifically typed parameters/requirements. At runtime, HaxeVX will convert these method calls to string-based commits/dispatches accordingly with automatic namespacing depending on which class they originated/extended from.

Vue/Vuex:

HaxeVX for Vue currently works under the premise of having ~~~both~~~ compile-time checkings done within Haxe, ~~~and runtime initialization checkings of your app within Javascript as it converts it's HaxeVX core classes to native VueJS components~~~ (edit: this is no longer the intention. Runtime reflection/initialization should be heavily minimised for VueX and completely removed in Vue). With Haxe's type-strict compiling (via compile time macro checks), the chances of you running into runtime initialization/operation errors are minimized for both platforms.

As of now, this draft is working under Haxe 3.3.0.

_____

Deployment info:
	
The current package is under haxevx.* namespace. Examples folder can be omitted for deployment.

______

Main links:

VueJS - https://vuejs.org/
Vuex - https://vuex.vuejs.org/en
Haxe - http://haxe.org
	
Related Links:
	
Haxe vs Typescript -  https://blog.onthewings.net/2015/08/05/typescript-vs-haxe/
