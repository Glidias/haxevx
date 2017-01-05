package haxevx.vuex.native;
import haxe.Constraints.Function;
import js.Error;
import js.html.HtmlElement;
import haxe.extern.Rest;
import haxevx.vuex.native.Vue.FunctionalComponentOptions;
import js.Promise;

/**
 * Porting of https://github.com/vuejs/vue/tree/dev/types typescript definitions
 * wip
 * 
 * @author Glidias
 */

 
/**
 * Port of vue.d.ts
 */

 
// This is a base pseudo-vue class that excludes _vData:D and constructor, and is used for vue component/extension definitions in particular. 
// Vue instance api calls are restricted to private scope for such definitions.
@:native("Object")
@:build( haxevx.vuex.native.NativeMacro.saveVueBaseFields() )
extern class VueBase {	// a base of private fields
	@:native("$el") private var _vEl(default, never) :HtmlElement;
    @:native("$options") private var _vOptions(default, never):ComponentOptions; //ComponentOptions<this>
    @:native("$root")private  var _vRoot(default, never):Vue;
    @:native("$children") private var _vChildren(default, never):Array<Vue>;
	@:native("$refs") private var _vRefs(default, never):Dynamic;
	@:native("$slots") private var _vSlots(default, never):Dynamic;
	@:native("$scopedSlots") private var _vScopedSlots(default, never):Dynamic; // Dynamic<ScopedSlot|ScopedSlotRetString>;
    @:native("$isServer") private var _vIsServer(default, never):Bool;
  
	@:overload(function(?elementOrSelector:String):Vue {})
	@:native("$mount") private function _vMount(?elementOrSelector:HtmlElement, ?hydrating:Bool):Vue;
	@:native("$forceUpdate") private function _vForceUpdate():Void;
	@:native("$destroy") private function _vDestroy():Void;
	@:native("$set") private function _vSet<T>(object: Dynamic, key: String, value: T): T;
	@:native("$delete") private function _vDelete(object: Dynamic, key: String): Void;
	@:overload(function(expOrFn:Function, callback:WatchHandler, ?options:WatchOptions):Void->Void {})
	@:native("$watch") private function _vWatch(expOrFn:String, callback:WatchHandler, ?options:WatchOptions):Void->Void;
	@:native("$on") private function _vOn(event:String, callback:Function):Vue;
	@:native("$once") private function _vOnce(event:String, callback:Function):Vue;
	@:native("$off") private function _vOff(event:String, callback:Function):Vue;
	
	@:native("$emit") private function _vEmit(event:String, r:Rest<Dynamic>):Vue;
	
	@:overload(function<T>(): Promise<T> {} )
	@:native("$nextTick") private function  _vNextTick(callback:Void->Void):Void;
		
	@:overload(function():VNode {})
	@:overload(function(tag:Component, ?children:VNodeChildren):VNode {})
	@:overload(function(tag:Component, ?data:VNodeData, ?children:VNodeChildren):VNode {})
	@:overload(function(tag:AsyncComponent, ?children:VNodeChildren):VNode {})
	@:overload(function(tag:AsyncComponent, ?data:VNodeData, ?children:VNodeChildren):VNode {})
	@:overload(function(tag:String,  ?children:VNodeChildren):VNode {})
	@:native("$createElement") private function _vCreateElement(tag:String, ?data:VNodeData, ?children:VNodeChildren):VNode;
}

// The native class alias for Vue to support it's constructor and defining your own class-specific _vData:D type and includes basic Vue api fields with public access.
@:native("Vue")
@:build( haxevx.vuex.native.NativeMacro.mixin() )
extern class VueInstance  { 
	public function new(options:ComponentOptions);
}


typedef CreateElement = Dynamic->?Dynamic->?Dynamic->VNode;
/*  // for reference in typescript as below
 * 
export type CreateElement = {
  // empty node
  (): VNode;

  // element or component name
  (tag: string, children: VNodeChildren): VNode;
  (tag: string, data?: VNodeData, children?: VNodeChildren): VNode;

  // component constructor or options
  (tag: Component, children: VNodeChildren): VNode;
  (tag: Component, data?: VNodeData, children?: VNodeChildren): VNode;

  // async component
  (tag: AsyncComponent, children: VNodeChildren): VNode;
  (tag: AsyncComponent, data?: VNodeData, children?: VNodeChildren): VNode;
}
*/

// This native class for Vue with untyped public var_vData:Dynamic included in (for simplicity, as defining <D> is rather verbose,
// and all Vue instance api fields with public access.
@:native("Vue")
@:build( haxevx.vuex.native.NativeMacro.mixin() )
extern class Vue		// For simplicity, Native Vue will consider _vData as Dynamic, 
{
	public function new(options:ComponentOptions);
	
	@:native("$data") public var _vData:Dynamic;

	public static var config:VueConfig;

	@:overload(function(options:FunctionalComponentOptions):Vue {})
	public static function extend(options:ComponentOptions):Vue;
	
	@:overload(function<T>(): Promise<T> {} )
	public static function nextTick(callback:Void->Void, ?context: Array<Dynamic>): Void;
	
	@:overload(function<T>(array:Array<T>, key: Float, value: T): T {} )
	public static function set<T>(object: Dynamic, key: String, value: T): T;
	
	public static function  delete(object: Dynamic, key: String): Void;
	
	@:overload(function(id:String, ?definition:DirectiveFunction):DirectiveOptions{})
	public static function directive(id:String, ?definition:DirectiveOptions):DirectiveOptions;
	public static function filter(id: String, ?definition: Function): Function;  
	  
	 @:overload(function(id:String, definition: AsyncComponent): Vue {} )
	 @:overload(function(id:String, definition: AsyncComponentRetVoid): Vue {} )
	 public static function component(id:String, ?definition:Component):Vue; 
	 
	 public static function use(extension:Dynamic):Void; 
	
	 @:overload(function(mixin:ComponentOptions):Void {})  // ComponentOptions<Vue>
	 public static function mixin(mixin:Vue): Void;
	 
	 public static function compile(template:String):{
		render:CreateElement->VNode,
		staticRenderFns: Array<Void->VNode>
	 };
	  

}

typedef VueConfig = {
	var silent:Bool;
	var optionMergeStrategies: Dynamic;
	var devtools: Bool;
	function errorHandler(err:Error, vm: Vue): Void;
	var keyCodes:Dynamic<UInt>;
};
	
//@:overload(tu[<T>(): Promise<T> {} )

typedef AsyncComponent = (Component->Void) -> (Dynamic) -> Promise<Component>;
typedef AsyncComponentRetVoid = (Component->Void) -> (Dynamic) -> Void;
/*
export type AsyncComponent = (
  resolve: (component: Component) => void,
  reject: (reason?: any) => void
) => Promise<Component> | Component | void;
*/

typedef FunctionalComponentOptions =  {
  @:optional var props:Array<String>; // props?: string[] | { [key: string]: PropOptions | Constructor | Constructor[] };
  var functional:Bool; 
//  render(this: never, createElement: CreateElement, context: RenderContext): VNode;
  @:optional var name: String;
}



typedef Component = Dynamic;  // typeof Vue | ComponentOptions<Vue> | FunctionalComponentOptions;

/**
 * Port of options.d.ts
 */

typedef ComponentOptions =  {
	@:optional var data:Dynamic;
	@:optional var props:Dynamic; // Array<String>;
	@:optional var propsData:Dynamic;
	@:optional var computed:Dynamic<Void->Dynamic>;
	@:optional var methods:Dynamic;  // how to define arbituary function  type in Haxe?
	@:optional var watch:Dynamic;  // not sure how to do this
	
	@:optional var el:Dynamic;
	@:optional var template:String;
	@:optional var render:CreateElement->VNode;
	//staticRenderFns?: ((createElement: CreateElement) => VNode)[];

	@:optional var beforeCreate:Void->Void;
	@:optional var created:Void->Void;
	@:optional var beforeDestroy:Void->Void;
	@:optional var destroy:Void->Void;
	@:optional var beforeMount:Void->Void;
	@:optional var mounted:Void->Void;
	@:optional var beforeUpdate:Void->Void;
	@:optional var updated:Void->Void;
	@:optional var activated:Void->Void;
	@:optional var deactivated:Void->Void;
	@:optional var directives:Dynamic;  //directives?: { [key: string]: DirectiveOptions | DirectiveFunction };
	@:optional var components:Dynamic;  //	components?: { [key: string]: Component | AsyncComponent };
	@:optional var transitions:Dynamic;
	@:optional var filters:Dynamic;   //filters?: { [key: string]: Function };

	@:optional var parent: Vue;
	@:optional var mixins:Dynamic; // ComponentOptions; // mixins?: (ComponentOptions<Vue> | typeof Vue)[];
	@:optional var name:String;
	//@:optional var extends:Dynamic;// ComponentOptions<Vue> | typeof Vue; // TODO: urm can we alias this?? extends reserved Haxe keyword BAH!!
	@:optional var delimiters: Array<String>;
	
	
	/*  // Done as above...
	props?: string[] | { [key: string]: PropOptions | Constructor | Constructor[] };
	propsData?: Object;
	computed?: { [key: string]: ((this: V) => any) | ComputedOptions<V> };
	methods?: { [key: string]: (this: V, ...args: any[]) => any };
	watch?: { [key: string]: ({ handler: WatchHandler<V> } & WatchOptions) | WatchHandler<V> | string };

	el?: Element | String;
	template?: string;
	render?(this: V, createElement: CreateElement): VNode;
	staticRenderFns?: ((createElement: CreateElement) => VNode)[];

	beforeCreate?(this: V): void;
	created?(this: V): void;
	beforeDestroy?(this: V): void;
	destroyed?(this: V): void;
	beforeMount?(this: V): void;
	mounted?(this: V): void;
	beforeUpdate?(this: V): void;
	updated?(this: V): void;
	activated?(this: V): void;
	deactivated?(this: V): void;

	directives?: { [key: string]: DirectiveOptions | DirectiveFunction };
	components?: { [key: string]: Component | AsyncComponent };
	transitions?: { [key: string]: Object };
	filters?: { [key: string]: Function };

	parent?: Vue;
	mixins?: (ComponentOptions<Vue> | typeof Vue)[];
	name?: string;
	extends?: ComponentOptions<Vue> | typeof Vue;
	delimiters?: [string, string];
	*/
}

typedef WatchHandler = Dynamic->Dynamic->Void;
//(this: V, val: any, oldVal: any) => void;

// typescript version was interface with ?optional parameters
typedef WatchOptions =  {
	@:optional var deep: Bool;
	@:optional var immediate: Bool;
}

typedef DirectiveFunction =
HtmlElement ->
VNodeDirective -> 
VNode ->
VNode ->
Void;
/*
export type DirectiveFunction = (
  el: HTMLElement,
  binding: VNodeDirective,
  vnode: VNode,
  oldVnode: VNode
) => void;
*/

typedef DirectiveOptions = {
  @:optional var bind: DirectiveFunction;
  @:optional var inserted: DirectiveFunction;
  @:optional var update: DirectiveFunction;
  @:optional var componentUpdated: DirectiveFunction;
  @:optional var unbind: DirectiveFunction;
}


/**
 * Port of vnode.d.ts
 */

 
 // TODO VNodes
 
 
typedef ScopedSlot = Dynamic -> VNodeChildrenArrayContents;
typedef ScopedSlotRetString = Dynamic ->String;
//(props: any) => VNodeChildrenArrayContents | string;


// HMMM>.....
typedef VNodeChildren = Dynamic; // VNodeChildrenArrayContents | [ScopedSlot] | string;
typedef VNodeChildrenArrayContents = Dynamic;
/* 
extern interface VNodeChildrenArrayContents {  // lol, how to do this...does Haxe support this?
	// [x: number]: VNode | string | VNodeChildren;
}
*/



extern interface VNode
{
	
}

extern interface VNodeDirective
{
	
}


typedef VNodeData = Dynamic;
/* 
export interface VNodeData {
  key?: string | number;
  slot?: string;
  scopedSlots?: { [key: string]: ScopedSlot };
  ref?: string;
  tag?: string;
  staticClass?: string;
  class?: any;
  staticStyle?: { [key: string]: any };
  style?: Object[] | Object;
  props?: { [key: string]: any };
  attrs?: { [key: string]: any };
  domProps?: { [key: string]: any };
  hook?: { [key: string]: Function };
  on?: { [key: string]: Function | Function[] };
  nativeOn?: { [key: string]: Function | Function[] };
  transition?: Object;
  show?: boolean;
  inlineTemplate?: {
    render: Function;
    staticRenderFns: Function[];
  };
  directives?: VNodeDirective[];
  keepAlive?: boolean;
}
*/