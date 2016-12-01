package haxevx.vuex.native;

/**
 * Porting of https://github.com/vuejs/vue/tree/dev/types
 * wip
 * 
 * @author Glidias
 */
@:native("Vue") extern class Vue
{

	public function new(options:ComponentOptions) 
	{
		
	}
	
	// we only bother with static definitions for now (should be good enough)
	
	// instance $ char definitions have problems in haxe because $ is reserved.
	/*
	  static extend(options: ComponentOptions<Vue> | FunctionalComponentOptions): typeof Vue;
	  static nextTick(callback: () => void, context?: any[]): void;
	  static nextTick(): Promise<void>
	  static set<T>(object: Object, key: string, value: T): T;
	  static set<T>(array: T[], key: number, value: T): T;
	  static delete(object: Object, key: string): void;

	  static directive(
		id: string,
		definition?: DirectiveOptions | DirectiveFunction
	  ): DirectiveOptions;
	  static filter(id: string, definition?: Function): Function;
	  */
	  public static function component(id:String, definition:Component):Vue; // static component(id: string, definition?: Component | AsyncComponent): typeof Vue;
		/*
	  static use<T>(plugin: PluginObject<T> | PluginFunction<T>, options?: T): void;
	  static mixin(mixin: typeof Vue | ComponentOptions<Vue>): void;
	  static compile(template: string): {
		render(createElement: typeof Vue.prototype.$createElement): VNode;
		staticRenderFns: (() => VNode)[];
	  };
	  */
	
}

extern class VNode
{
	
}


extern typedef CreateElement = Dynamic->?Dynamic->?Dynamic->Void;

typedef Component = Dynamic;

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