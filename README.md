# haxevx

## HaxeVX - Haxe-powered VueJS/Vuex development (WIP Draft Stage ) 
### Type-safe coding to target Vuex/VueJS environments using Haxe RTTI (runtime-type information) and Reflection/Metadata

Still in early draft stage, but some ideas i've been tossing around with regards to developing in Haxe to target/construct a VueJS/VueX 2.0 application. With it, you get the benefit of massive type-hinting/type-checking/safety, etc. inherant within Haxe.

Even though Vuex boilerplate is avoided (via Haxe reflection api), since there's a way to declare and use mutator/actions methods without managing/matching strings with Babel/ES6 helpers and such, the caveat is that in order to have full-on editor type hinting/completion, and a combination of compile-time & runtime initialization type-safety when deploying from Haxe to Vuex , some extra boilerplate (typical within Haxe or any strict/static-typed languages) is still required. In some cases, it may be less code than the BabelJS style of coding, and in some cases, more code due to the need for type completion/validation (eg. Even though there's no magic "mapGetters/mapActions/mapMutators" helper methods, there are other means I'm toying around with, such as static mutator/action/getter class field reference calls, etc.) to perform necessary actions through the global Store. 

In short, this is HaxeVx, a Vuex implementation that avoids having to handle any strings. Instead, call strictly-typed functions with specific parameters/requirements. HaxeVX will convert these method calls to string-based commits/dispatches accordingly with automatic namespacing.

As of now, this draft is working under Haxe 3.3.0.

The premise for my case is to not rely directly on VueJS (or any native-related) externs, which in the long run can be hard to maintain. Instead, code as you'd normally would in Haxe with the best strict-typing features possible) via Generics and what would work best natively within Haxe, and then use Haxe RTTI (and function body {code} snooping) to reflect the necessary information from Haxe classes/instances to native VueJS components/stores/modules, etc, which will eventually help set up your app on the native platform. Currently, i'm targeting Vue 2,Vuex2 as the primary target platform. With it, method/getter/action/mutator and property type declarations/definitions can easily be implied from the Haxe RTTI codebase itself with the right tooling,

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
	
