# haxevx

## HaxeVX - Haxe-powered VueJS/Vuex development

### Type-safe coding to target Vuex/VueJS environments using Haxe compile-time Macros and runtime Reflection/Metadata and RTTI (runtime-type information) .

Still in early draft stage, but some ideas i've been tossing around with regards to developing in Haxe to target/construct a VueJS/VueX 2.0 application. With it, you get the benefit of massive type-hinting/type-checking/compile-time safety, etc. inherant within Haxe. 

Examples (based off Vuex repository examples) can be found [here](https://github.com/Glidias/haxevx/tree/master/src/haxevx/vuex/examples)
	
Currently, the working Shopping Cart example (ported from the Vuex example) is available and shown by default in the bin folder. 

Roadmap can be found [here](https://github.com/Glidias/haxevx/issues/2)
	
____________

Even though Vuex boilerplate is avoided (via Haxe reflection api), the current approach involves using class helper mutator/actions methods without managing/matching [constant] strings with Babel/ES6 helpers and such.

In short, this is a Vuex implementation that avoids having to handle any strings. Instead, call strictly-typed functions with specifically typed parameters/requirements. At runtime, HaxeVX will convert these method calls to string-based commits/dispatches accordingly with automatic namespacing depending on which class they originated/extended from.

HaxeVX for Vue currently works under the premise of having both compile-time checkings done within Haxe, and runtime initialization checkings of your app within Javascript as it converts it's HaxeVX core classes to native VueJS components and Vuex Store (if using Vuex). WIth Haxe's type-strict compiling (and compile time macro checks) done successfully (to ensure everything is linked up correctly), the chances of you running into runtime initialization/operation errors are minimized.

Additionally, HaxeVX for Vue contains a Component build macro that mixes-in Vue component props and data fields directly into the Vue component class, ensuring that props and data fields (that share namespace within the Vue component)  do not conflict at compile-time. Other compile-tme checks are built into the macro to ensure your property declarations within the Vue component class conforms to VuejS standards.

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
