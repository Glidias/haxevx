# haxevx

## HaxeVX - Haxe-powered VueJS/Vuex development

Pre-release is available on Haxelib. 

	haxelib install haxevx
	
**Important Note:** If your Vue/Vuex externs are loaded into your project globally (ie. not using `require()` modules ), you need to compile your Haxe code with the flag `-D vue_global`, in order to reference them globally as well. 

### Type-safe coding to target Vuex/VueJS environments using Haxe compile-time Macros and Classes.

With HaxeVx, you get the benefit of massive access-control/type-hinting/type-checking/compile-time safety, etc. inherant within Haxe when developing your VueJS/Vuex stuff. Compile-time mixins/macros/checks are provided specifically for your Haxe classes to ensure they conform to the necessary VueJS conventions.
	
### Overview of features:

- Automatic mixing-in of typed Props and Data (classes/typedefs) fields into your Vue instance with full type-safety during development. eg. `class MyComponent extends VComponent<DataType, PropType>`. Unlike regular VueJS, mixed-in fields in HaxeVx can be accessed locally within your Vue instance class definition with full strict-typing. Thus, if Props+Data fields conflict in name-clashes, the compiler will know it 

- Unlike Typescript decorators that execute at run-time, all HaxeVx metadata (if any), in components, are compile-time-only metadata  used to facilitate pre-generation of initialization code. There is no further iteration processing done at runtime beyond calling a single automatically-called internal macro-generated function that exposes all pre-compiled component options to Vue already. So, based on the class you write (props/data-types/functions, etc.), the necessary Vue-related initialization options will automatically be pre-generated for you already.

- Fully strict typed access on `$data` reference as well.

- Comprehensive Vue-specific compile time type/reference/convention checking is involved in the macro compile process (eg. ensuring any watcher field links are spelled-correctly to an existing computed/data/prop field in the Vue instance, ensuring your Vue component prop fields are non-public, etc.).  Because of the static typed approach of Haxe-Vx, a lot fo things can be pre-checked at compile-time.

- Vuex: A library/scheme in Haxe specially tailored for Vuex as well, that provides fully type-safe commit/dispatch payloads without having to manage any strings/string-constants or namespacings. This results in fewer errors and reduced boilerplate in linking up your actions/mutations/getters.


Here is a guide/spec of features that are supported in HaxeVx for Vue.
https://github.com/Glidias/haxevx/wiki/Vue---HaxeVX-Draft-version-guide
	
A Vuex example (ie. the port of Vuex' Shopping Cart Example), can be found here:
	
https://github.com/Glidias/haxevx/tree/master/src/haxevx/vuex/examples/shoppingcart
	
	
____________

Roadmap can be found [here](https://github.com/Glidias/haxevx/issues/2)
	
_______

Versioning:
	
This was developed under Haxe version 3.3.0.

_____

Deployment info:
	
The current package is under haxevx.* namespace. Examples folder can be omitted for deployment.

______

Main links:

VueJS - https://vuejs.org/
Vuex - https://vuex.vuejs.org/en
Haxe - http://haxe.org
