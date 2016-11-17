# haxevx

## HaxeVX - Haxe-powered VueJS/Vuex development (WIP Draft Stage ) 

### Type-safe coding to target Vuex/VueJS environments using Haxe Reflection/Metadata and RTTI (runtime-type information) .

Still in early draft stage, but some ideas i've been tossing around with regards to developing in Haxe to target/construct a VueJS/VueX 2.0 application. With it, you get the benefit of massive type-hinting/type-checking/safety, etc. inherant within Haxe. Examples (based off Vuex repository examples) can be found [here](https://github.com/Glidias/haxevx/tree/master/src/haxevx/vuex/examples)
	


Even though Vuex boilerplate is avoided (via Haxe reflection api), this is a proposed a way to declare and use mutator/actions methods without managing/matching [constant] strings with Babel/ES6 helpers and such, the caveat is that in order to have full-on editor type hinting/completion, and a combination of compile-time & runtime initialization type-safety when deploying from Haxe to Vuex , some extra boilerplate (typical within Haxe or any strict/static-typed languages) is still required.

In short, this is HaxeVx, a Vuex implementation that avoids having to handle any strings. Instead, call strictly-typed functions with specifically typed parameters/requirements. HaxeVX will convert these method calls to string-based commits/dispatches accordingly with automatic namespacing for Vuex or any other related Flux-oriented frameworks.

As of now, this draft is working under Haxe 3.3.0.

The premise for my case is to not rely directly on VueJS (or any native-related) externs, which in the long run can be hard to maintain. Instead, code as you'd normally would in Haxe with the best strict-typing features possible) via Generics and what would work best natively within Haxe, and then use Haxe class/metadata Reflection/RTTI (or function body {code} snooping) to reflect the necessary information from the Haxe classes/instances to native VueJS components/stores/getters/modules, etc. Currently, i'm targeting Vue 2,Vuex2 as the primary target platform. With it, method/getter/action/mutator and property type declarations/definitions can easily be implied from the Haxe codebase itself. What RTTI is required as part of the translation is still under consideration (since RTTI can add to filesize which isn't too ideal).

With some modifications to the codebase, it's possible to also convert an existing codebase to other similar JS frameworks. (React, etc.), or maybe even some non-JS framework. (Another reason to not rely on explicit externs).

JSX integration within HaxeVX is also part of the roadmap, since Vue2 supports render() methods to construct virtual dom directly instead of relying just on string-based templates.

_____

Deployment info:
	
The current package is under haxevx.* namespace. Examples folder can be omitted for deployment.

_____

Main links:

VueJS - https://vuejs.org/
Vuex - https://vuex.vuejs.org/en
Haxe - http://haxe.org
	
Related Links:
	
Haxe vs Typescript -  https://blog.onthewings.net/2015/08/05/typescript-vs-haxe/
