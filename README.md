# haxevx

## HaxeVX - Haxe-powered VueJS/Vuex development

### Type-safe coding to target Vuex/VueJS environments using Haxe compile-time Macros and runtime Reflection/Metadata and RTTI (runtime-type information) .

Still in early draft stage, but some ideas i've been tossing around with regards to developing in Haxe to target/construct a VueJS/VueX 2.0 application. With it, you get the benefit of massive type-hinting/type-checking/compile-time safety, etc. inherant within Haxe. 

Examples (based off Vuex repository examples) can be found [here](https://github.com/Glidias/haxevx/tree/master/src/haxevx/vuex/examples)
	
Currently, a working Shopping Cart example from Vuex is ported over to HaxeVX.

Even though Vuex boilerplate is avoided (via Haxe reflection api), the current approach involves using class helper mutator/actions methods without managing/matching [constant] strings with Babel/ES6 helpers and such. A macro-based mapGetters/mapMutations/mapActions compile-time implementation via field metadata tags will be implemented as well to seamlessly link your Vue components properties to any relevant matching store/module's resources without having to manually inject mutator/action/getter helper class instances.

In short, this is a Vuex implementation that avoids having to handle any strings. Instead, call strictly-typed functions with specifically typed parameters/requirements. At runtime, HaxeVX will convert these method calls to string-based commits/dispatches accordingly with automatic namespacing depending on which class they originated/extended from.

HaxeVX for Vue currently works under the premise of having both compile-time checkings done within Haxe, and runtime initialization checkings of your app within Javascript as it converts it's HaxeVX core classes to native VueJS components and Vuex Store (if using Vuex). WIth Haxe's type-strict compiling (and compile time macro checks) done successfully (to ensure everything is linked up correctly), the chances of you running into runtime initialization/operation errors are minimized.

Additionally, HaxeVX for Vue contains a Component build macro that mixes-in Vue component props and data fields directly into the Vue component class, ensuring that props and data fields (that share namespace within the Vue component)  do not conflict at compile-time. Other compile-tme checks are built into the macro to ensure your property declarations within the Vue component class conforms to VuejS standards.

As of now, this draft is working under Haxe 3.3.0.

The premise for my case is to not rely directly on VueJS (or any native-related) externs, which in the long run can be hard to maintain. Instead, code as you'd normally would in Haxe with the best strict-typing features possible) via Generics and what would work best natively within Haxe, and then use Haxe class/metadata Reflection/RTTI (or function body {code} snooping) to reflect the necessary information from the Haxe classes/instances to native VueJS components/stores/getters/modules, etc. Currently, i'm targeting Vue 2,Vuex2 as the primary target platform. With it, method/getter/action/mutator and property type declarations/definitions can easily be implied from the Haxe codebase itself. (Note, see information on Phase 2 for a Lite version approach instead...)

JSX integration within HaxeVX is also part of the roadmap, since Vue2 supports render() methods to construct virtual dom directly instead of relying just on string-based templatess


_____

Deployment info:
	
The current package is under haxevx.* namespace. Examples folder can be omitted for deployment.

_____

Phase 2 (Lite version to replace existing one):
	
Recently, i've discovered more about the power behind Haxe ~~~abstracts?~~~ and macros, and how they can be used instead of Haxe-oriented base classes, RTTI, and metadata, which can bloat your codebase (and adds framework classes with an additional runtime-initialization conversion process) which isn't suitable for small projects. I intend to redo a lightweight version of HaxeVX for VueJS  (and hopefully for Vuex as well) depending ONLY on ~~~pure Haxe abstracts and~~~ compile-time macros to link directly to VueJS externs. This gives you class-like functionality ~~~with Haxe abstracts~~~ and all the typical strict-typing/compile-time checkings done when coding VueJS components. This means no additional boiler-framework code will be required beyond your implementation code. (Note: abstracts vs classes is still under consideration, as there some advantages/disadvantages between using either of them for Vue.)

______

Main links:

VueJS - https://vuejs.org/
Vuex - https://vuex.vuejs.org/en
Haxe - http://haxe.org
	
Related Links:
	
Haxe vs Typescript -  https://blog.onthewings.net/2015/08/05/typescript-vs-haxe/
