(function (console) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Lambda = function() { };
Lambda.__name__ = true;
Lambda.fold = function(it,f,first) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		first = f(x,first);
	}
	return first;
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	new haxevx_vuex_examples_shoppingcart_ShoppingCartMain();
};
Math.__name__ = true;
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		return null;
	}
};
Reflect.setField = function(o,field,value) {
	o[field] = value;
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var haxe_Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe_Timer.__name__ = true;
haxe_Timer.delay = function(f,time_ms) {
	var t = new haxe_Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
};
haxe_Timer.prototype = {
	stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
};
var haxevx_vuex_core_IAction = function() { };
haxevx_vuex_core_IAction.__name__ = true;
var haxevx_vuex_core_IModule = function() { };
haxevx_vuex_core_IModule.__name__ = true;
var haxevx_vuex_core_IMutator = function() { };
haxevx_vuex_core_IMutator.__name__ = true;
var haxevx_vuex_core_IPayload = function() { };
haxevx_vuex_core_IPayload.__name__ = true;
var haxevx_vuex_core_IPrefixedState = function() { };
haxevx_vuex_core_IPrefixedState.__name__ = true;
var haxevx_vuex_core_IStoreGetters = function() { };
haxevx_vuex_core_IStoreGetters.__name__ = true;
var haxevx_vuex_core_IVxContext = function() { };
haxevx_vuex_core_IVxContext.__name__ = true;
var haxevx_vuex_core_IVxContext1 = function() { };
haxevx_vuex_core_IVxContext1.__name__ = true;
var haxevx_vuex_core_IVxContext2 = function() { };
haxevx_vuex_core_IVxContext2.__name__ = true;
var haxevx_vuex_core_IVxContext3 = function() { };
haxevx_vuex_core_IVxContext3.__name__ = true;
var haxevx_vuex_core_IVxContext4 = function() { };
haxevx_vuex_core_IVxContext4.__name__ = true;
var haxevx_vuex_core_IVxStoreContext = function() { };
haxevx_vuex_core_IVxStoreContext.__name__ = true;
var haxevx_vuex_core_NoneT = function() { };
haxevx_vuex_core_NoneT.__name__ = true;
haxevx_vuex_core_NoneT.prototype = {
	toString: function() {
		return "NoneT";
	}
};
var haxevx_vuex_core_VComponent = function() {
	this._Init();
};
haxevx_vuex_core_VComponent.__name__ = true;
haxevx_vuex_core_VComponent.__super__ = Object;
haxevx_vuex_core_VComponent.prototype = $extend(Object.prototype,{
	_Init: function() {
	}
	,get__props: function() {
		return this;
	}
	,get__vData: function() {
		return this.$data;
	}
	,PropsData: function() {
		return null;
	}
	,Data: function() {
		return null;
	}
	,Created: function() {
	}
	,BeforeCreate: function() {
	}
	,BeforeDestroy: function() {
	}
	,Destroy: function() {
	}
	,BeforeMount: function() {
	}
	,Mounted: function() {
	}
	,BeforeUpdate: function() {
	}
	,Updated: function() {
	}
	,Activated: function() {
	}
	,Deactivated: function() {
	}
	,El: function() {
		return null;
	}
	,Render: function(c) {
		return null;
	}
	,Template: function() {
		return null;
	}
	,Components: function() {
		return null;
	}
	,GetDefaultPropSettings: function() {
		return null;
	}
	,GetDefaultPropValues: function() {
		return null;
	}
});
var haxevx_vuex_core_VModule = function() { };
haxevx_vuex_core_VModule.__name__ = true;
haxevx_vuex_core_VModule.__interfaces__ = [haxevx_vuex_core_IModule];
var haxevx_vuex_core_VxBoot = function() {
};
haxevx_vuex_core_VxBoot.__name__ = true;
haxevx_vuex_core_VxBoot.notifyStarted = function() {
};
haxevx_vuex_core_VxBoot.getRenderComponentMethod = function(nativeComp) {
	return function(h) {
		return h(nativeComp,null,null);
	};
};
haxevx_vuex_core_VxBoot.prototype = {
	startStore: function(storeParams) {
		if(this.STORE != null) throw new js__$Boot_HaxeError("Vuex store already started! Only 1 store is allowed");
		var metaFields;
		var md;
		var noNamespaceGetterProps;
		var store = new Vuex.Store(storeParams);
		if(storeParams.getters != null) {
			var o;
			var storeGetters = store.getters;
			if(storeParams.modules != null) {
				var moduleNameStack = [];
				var _g = 0;
				var _g1 = Reflect.fields(o = storeParams.modules);
				while(_g < _g1.length) {
					var p = _g1[_g];
					++_g;
					moduleNameStack.push(p);
					var m = Reflect.field(o,p);
					md = Reflect.field(storeParams,p);
					store[p] = md;
					if(m.getters != null) md._stg = storeGetters;
					moduleNameStack.pop();
				}
			}
		}
		this.STORE = store;
		return store;
	}
	,startVueWithRootComponent: function(el,rootComponent) {
		var bootVueParams = { };
		bootVueParams.el = el;
		if(this.STORE != null) bootVueParams.store = this.STORE;
		bootVueParams.render = haxevx_vuex_core_VxBoot.getRenderComponentMethod(rootComponent);
		var vm = new Vue(bootVueParams);
		haxevx_vuex_core_VxBoot.notifyStarted();
		return vm;
	}
};
var haxevx_vuex_core_VxComponent = function() {
	haxevx_vuex_core_VComponent.call(this);
};
haxevx_vuex_core_VxComponent.__name__ = true;
haxevx_vuex_core_VxComponent.__super__ = haxevx_vuex_core_VComponent;
haxevx_vuex_core_VxComponent.prototype = $extend(haxevx_vuex_core_VComponent.prototype,{
	get_store: function() {
		return this.$store;
	}
});
var haxevx_vuex_core_VxMacroUtil = function() { };
haxevx_vuex_core_VxMacroUtil.__name__ = true;
haxevx_vuex_core_VxMacroUtil.dynamicSet = function(dyn,key,value) {
	dyn[key] = value;
};
haxevx_vuex_core_VxMacroUtil.dynamicSetPropValueInto = function(into,propSettingField,from) {
	var _g = 0;
	var _g1 = Reflect.fields(from);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		var curSetting = Reflect.field(into,f);
		if(curSetting == null) {
			curSetting = { };
			into[f] = curSetting;
		}
		Reflect.setField(curSetting,propSettingField,Reflect.field(from,f));
	}
};
haxevx_vuex_core_VxMacroUtil.dynamicSetPropSettingInto = function(into,from) {
	var _g = 0;
	var _g1 = Reflect.fields(from);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		var setting = Reflect.field(from,f);
		var curSetting = Reflect.field(into,f);
		if(curSetting != null) {
			var _g2 = 0;
			var _g3 = Reflect.fields(setting);
			while(_g2 < _g3.length) {
				var d = _g3[_g2];
				++_g2;
				Reflect.setField(curSetting,d,Reflect.field(setting,d));
			}
		} else into[f] = setting;
	}
};
var haxevx_vuex_core_VxStore = function() {
	this.strict = false;
};
haxevx_vuex_core_VxStore.__name__ = true;
haxevx_vuex_core_VxStore.prototype = {
	dispatch: function(type,payload,opts) {
		return null;
	}
	,commit: function(type,payload,opts) {
	}
};
var haxevx_vuex_examples_shoppingcart_ShoppingCartMain = function() {
	var boot = new haxevx_vuex_core_VxBoot();
	boot.startStore(new haxevx_vuex_examples_shoppingcart_store_AppStore());
	boot.startVueWithRootComponent("#app",new haxevx_vuex_examples_shoppingcart_components_App());
};
haxevx_vuex_examples_shoppingcart_ShoppingCartMain.__name__ = true;
var haxevx_vuex_examples_shoppingcart_api_Shop = function() {
	this._products = [{ 'id' : 1, 'title' : "iPad 4 Mini", 'price' : 500.01, 'inventory' : 2},{ 'id' : 2, 'title' : "H&M T-Shirt White", 'price' : 10.99, 'inventory' : 10},{ 'id' : 3, 'title' : "Charli XCX - Sucker CD", 'price' : 19.99, 'inventory' : 5}];
};
haxevx_vuex_examples_shoppingcart_api_Shop.__name__ = true;
haxevx_vuex_examples_shoppingcart_api_Shop.getInstance = function() {
	if(haxevx_vuex_examples_shoppingcart_api_Shop.INSTANCE != null) return haxevx_vuex_examples_shoppingcart_api_Shop.INSTANCE; else return haxevx_vuex_examples_shoppingcart_api_Shop.INSTANCE = new haxevx_vuex_examples_shoppingcart_api_Shop();
};
haxevx_vuex_examples_shoppingcart_api_Shop.prototype = {
	getProducts: function(cb) {
		var _g = this;
		haxe_Timer.delay(function() {
			cb(_g._products);
		},100);
	}
	,buyProducts: function(products,cb,errorCb) {
		haxe_Timer.delay(function() {
			if(Math.random() > 0.5) cb(); else errorCb();
		},100);
	}
};
var haxevx_vuex_examples_shoppingcart_components_App = function() {
	haxevx_vuex_core_VxComponent.call(this);
};
haxevx_vuex_examples_shoppingcart_components_App.__name__ = true;
haxevx_vuex_examples_shoppingcart_components_App.__super__ = haxevx_vuex_core_VxComponent;
haxevx_vuex_examples_shoppingcart_components_App.prototype = $extend(haxevx_vuex_core_VxComponent.prototype,{
	Components: function() {
		var _m_ = { };
		haxevx_vuex_core_VxMacroUtil.dynamicSet(_m_,"" + "product-list",new haxevx_vuex_examples_shoppingcart_components_ProductListVue());
		haxevx_vuex_core_VxMacroUtil.dynamicSet(_m_,"" + "cart",new haxevx_vuex_examples_shoppingcart_components_CartVue("My Haxe Cart"));
		return _m_;
	}
	,Template: function() {
		return "<div id=\"app\">\r\n\t\t\t\t<h1>Shopping Cart Example</h1>\r\n\t\t\t\t<hr>\r\n\t\t\t\t<h2>Products</h2>\r\n\t\t\t\t<" + "product-list" + "></" + "product-list" + ">\r\n\t\t\t\t<hr>\r\n\t\t\t\t<" + "cart" + "></" + "cart" + ">\r\n\t\t\t  </div>";
	}
	,_Init: function() {
		var cls = haxevx_vuex_examples_shoppingcart_components_App;
		var clsP = cls.prototype;
		this.components = this.Components();
		this.template = this.Template();
	}
});
var haxevx_vuex_examples_shoppingcart_components_CartVue = function(customTitle) {
	if(customTitle == null) customTitle = "My Cart";
	this.__customTitle = customTitle;
	haxevx_vuex_core_VxComponent.call(this);
};
haxevx_vuex_examples_shoppingcart_components_CartVue.__name__ = true;
haxevx_vuex_examples_shoppingcart_components_CartVue.__super__ = haxevx_vuex_core_VxComponent;
haxevx_vuex_examples_shoppingcart_components_CartVue.prototype = $extend(haxevx_vuex_core_VxComponent.prototype,{
	get_total: function() {
		return Lambda.fold(this.products,function(p,total) {
			return total + p.price * p.quantity;
		},0);
	}
	,get_products: function() {
		return this.$store.getters.cartProducts;
	}
	,get_checkoutStatus: function() {
		return this.$store.cart.get_checkoutStatus();
	}
	,checkout: function(products) {
		this.$store.dispatch("haxevx_vuex_examples_shoppingcart_modules_CartDispatcher|checkout",products);
	}
	,Template: function() {
		return "<div class=\"cart\">\r\n\t\t\t\t<h2>" + this.__customTitle + "</h2>\r\n\t\t\t\t<p v-show=\"!products.length\"><i>Please add some products to cart.</i></p>\r\n\t\t\t\t<ul>\r\n\t\t\t\t  <li v-for=\"p in products\">\r\n\t\t\t\t\t{{ p.title }} - {{ p.price  }}  (x{{ p.quantity }})\r\n\t\t\t\t  </li>\r\n\t\t\t\t</ul>\r\n\t\t\t\t<p>Total: {{ total  }}</p>\r\n\t\t\t\t<p><button :disabled=\"!products.length\" @click=\"checkout(products)\">Checkout</button></p>\r\n\t\t\t\t<p v-show=\"checkoutStatus\">Checkout {{ checkoutStatus }}.</p>\r\n\t\t\t  </div>";
	}
	,_Init: function() {
		var cls = haxevx_vuex_examples_shoppingcart_components_CartVue;
		var clsP = cls.prototype;
		this.template = this.Template();
		this.computed = { total : clsP.get_total, products : clsP.get_products, checkoutStatus : clsP.get_checkoutStatus};
		this.methods = { get_total : clsP.get_total, get_products : clsP.get_products, get_checkoutStatus : clsP.get_checkoutStatus, checkout : clsP.checkout};
	}
});
var haxevx_vuex_examples_shoppingcart_components_ProductListVue = function() {
	haxevx_vuex_core_VxComponent.call(this);
};
haxevx_vuex_examples_shoppingcart_components_ProductListVue.__name__ = true;
haxevx_vuex_examples_shoppingcart_components_ProductListVue.__super__ = haxevx_vuex_core_VxComponent;
haxevx_vuex_examples_shoppingcart_components_ProductListVue.prototype = $extend(haxevx_vuex_core_VxComponent.prototype,{
	get_products: function() {
		return this.$store.products.get_allProducts();
	}
	,addToCart: function(p) {
		this.$store.dispatch("haxevx_vuex_examples_shoppingcart_store_AppActions|addToCart",p);
	}
	,Created: function() {
		this.$store.dispatch("haxevx_vuex_examples_shoppingcart_modules_ProductListDispatcher|getAllProducts");
	}
	,Template: function() {
		return "<ul>\r\n\t\t\t<li v-for=\"p in products\">\r\n\t\t\t  {{ p.title }} - {{ p.price }} - ({{p.inventory}})\r\n\t\t\t  <br>\r\n\t\t\t  <button\r\n\t\t\t\t:disabled=\"!p.inventory\"\r\n\t\t\t\t@click=\"addToCart(p)\">\r\n\t\t\t\tAdd to cart\r\n\t\t\t  </button>\r\n\t\t\t</li>\r\n\t\t</ul>";
	}
	,_Init: function() {
		var cls = haxevx_vuex_examples_shoppingcart_components_ProductListVue;
		var clsP = cls.prototype;
		this.created = clsP.Created;
		this.template = this.Template();
		this.computed = { products : clsP.get_products};
		this.methods = { get_products : clsP.get_products, addToCart : clsP.addToCart};
	}
});
var haxevx_vuex_examples_shoppingcart_modules_Cart = function() {
	this.state = { added : [], checkoutStatus : null, lastCheckout : null};
};
haxevx_vuex_examples_shoppingcart_modules_Cart.__name__ = true;
haxevx_vuex_examples_shoppingcart_modules_Cart.__interfaces__ = [haxevx_vuex_core_IModule];
haxevx_vuex_examples_shoppingcart_modules_Cart.Get_checkoutStatus = function(state) {
	return state.checkoutStatus;
};
haxevx_vuex_examples_shoppingcart_modules_Cart.prototype = {
	get_checkoutStatus: function() {
		return this._stg[this._ + "checkoutStatus"];
	}
	,_Init: function(ns) {
		this._ = ns;
		if(this.state != null) this.state._ = ns; else this.state = { _ : ns};
		var useNS = ns;
		var cls = haxevx_vuex_examples_shoppingcart_modules_Cart;
		var clsP = cls.prototype;
		var key;
		var d;
		d = { };
		this.getters = d;
		d[useNS + "checkoutStatus"] = cls.Get_checkoutStatus;
		d = { };
		this.mutations = d;
		new haxevx_vuex_examples_shoppingcart_modules_CartMutator()._SetInto(d,"");
		d = { };
		this.actions = d;
		new haxevx_vuex_examples_shoppingcart_modules_CartDispatcher()._SetInto(d,"");
	}
	,_InjNative: function(g) {
		this._stg = g;
	}
};
var haxevx_vuex_examples_shoppingcart_modules_CartDispatcher = function() {
	null;
};
haxevx_vuex_examples_shoppingcart_modules_CartDispatcher.__name__ = true;
haxevx_vuex_examples_shoppingcart_modules_CartDispatcher.prototype = {
	checkout: function(context,payload) {
		var savedCartItems = context.state.added.concat([]);
		context.commit("haxevx_vuex_examples_shoppingcart_store_AppMutator|checkoutRequest");
		haxevx_vuex_examples_shoppingcart_modules_CartDispatcher.shop.buyProducts(payload,function() {
			context.commit("haxevx_vuex_examples_shoppingcart_store_AppMutator|checkoutSuccess");
		},function() {
			context.commit("haxevx_vuex_examples_shoppingcart_store_AppMutator|checkoutFailure",{ savedCartItems : savedCartItems});
		});
	}
	,_SetInto: function(d,ns) {
		var cls = haxevx_vuex_examples_shoppingcart_modules_CartDispatcher;
		var clsP = cls.prototype;
		d[ns + "haxevx_vuex_examples_shoppingcart_modules_CartDispatcher|checkout"] = clsP.checkout;
	}
};
var haxevx_vuex_examples_shoppingcart_store_AppMutator = function() {
	null;
};
haxevx_vuex_examples_shoppingcart_store_AppMutator.__name__ = true;
haxevx_vuex_examples_shoppingcart_store_AppMutator.prototype = {
	addToCart: function(state,payload) {
	}
	,checkoutRequest: function(state) {
	}
	,checkoutSuccess: function(state) {
	}
	,checkoutFailure: function(state,payload) {
	}
	,receiveProducts: function(state,payload) {
	}
	,_SetInto: function(d,ns) {
		var cls = haxevx_vuex_examples_shoppingcart_store_AppMutator;
		var clsP = cls.prototype;
		d[ns + "haxevx_vuex_examples_shoppingcart_store_AppMutator|addToCart"] = clsP.addToCart;
		d[ns + "haxevx_vuex_examples_shoppingcart_store_AppMutator|checkoutRequest"] = clsP.checkoutRequest;
		d[ns + "haxevx_vuex_examples_shoppingcart_store_AppMutator|checkoutSuccess"] = clsP.checkoutSuccess;
		d[ns + "haxevx_vuex_examples_shoppingcart_store_AppMutator|checkoutFailure"] = clsP.checkoutFailure;
		d[ns + "haxevx_vuex_examples_shoppingcart_store_AppMutator|receiveProducts"] = clsP.receiveProducts;
	}
};
var haxevx_vuex_examples_shoppingcart_modules_CartMutator = function() {
	haxevx_vuex_examples_shoppingcart_store_AppMutator.call(this);
};
haxevx_vuex_examples_shoppingcart_modules_CartMutator.__name__ = true;
haxevx_vuex_examples_shoppingcart_modules_CartMutator.__super__ = haxevx_vuex_examples_shoppingcart_store_AppMutator;
haxevx_vuex_examples_shoppingcart_modules_CartMutator.prototype = $extend(haxevx_vuex_examples_shoppingcart_store_AppMutator.prototype,{
	addToCart: function(state,payload) {
		state.lastCheckout = null;
		var chk = state.added.filter(function(p) {
			return p.id == payload.id;
		});
		if(chk.length == 0) state.added.push({ id : payload.id, quantity : 1}); else {
			var record = chk[0];
			record.quantity++;
		}
	}
	,checkoutRequest: function(state) {
		state.added = [];
		state.checkoutStatus = null;
	}
	,checkoutSuccess: function(state) {
		state.checkoutStatus = "successful";
	}
	,checkoutFailure: function(state,payload) {
		state.added = payload.savedCartItems;
		state.checkoutStatus = "failed";
	}
	,_SetInto: function(d,ns) {
		var cls = haxevx_vuex_examples_shoppingcart_modules_CartMutator;
		var clsP = cls.prototype;
		d[ns + "haxevx_vuex_examples_shoppingcart_store_AppMutator|addToCart"] = clsP.addToCart;
		d[ns + "haxevx_vuex_examples_shoppingcart_store_AppMutator|checkoutRequest"] = clsP.checkoutRequest;
		d[ns + "haxevx_vuex_examples_shoppingcart_store_AppMutator|checkoutSuccess"] = clsP.checkoutSuccess;
		d[ns + "haxevx_vuex_examples_shoppingcart_store_AppMutator|checkoutFailure"] = clsP.checkoutFailure;
	}
});
var haxevx_vuex_examples_shoppingcart_modules_Products = function() {
	this.state = new haxevx_vuex_examples_shoppingcart_modules_ProductListModel();
};
haxevx_vuex_examples_shoppingcart_modules_Products.__name__ = true;
haxevx_vuex_examples_shoppingcart_modules_Products.Get_allProducts = function(state) {
	return state.all;
};
haxevx_vuex_examples_shoppingcart_modules_Products.__super__ = haxevx_vuex_core_VModule;
haxevx_vuex_examples_shoppingcart_modules_Products.prototype = $extend(haxevx_vuex_core_VModule.prototype,{
	get_allProducts: function() {
		return this._stg[this._ + "allProducts"];
	}
	,_Init: function(ns) {
		this._ = ns;
		if(this.state != null) this.state._ = ns; else this.state = { _ : ns};
		var useNS = ns;
		var cls = haxevx_vuex_examples_shoppingcart_modules_Products;
		var clsP = cls.prototype;
		var key;
		var d;
		d = { };
		this.getters = d;
		d[useNS + "allProducts"] = cls.Get_allProducts;
		d = { };
		this.mutations = d;
		new haxevx_vuex_examples_shoppingcart_modules_ProductListMutator()._SetInto(d,"");
		d = { };
		this.actions = d;
		new haxevx_vuex_examples_shoppingcart_modules_ProductListDispatcher()._SetInto(d,"");
	}
	,_InjNative: function(g) {
		this._stg = g;
	}
});
var haxevx_vuex_examples_shoppingcart_modules_ProductListDispatcher = function() {
	null;
};
haxevx_vuex_examples_shoppingcart_modules_ProductListDispatcher.__name__ = true;
haxevx_vuex_examples_shoppingcart_modules_ProductListDispatcher.prototype = {
	getAllProducts: function(context) {
		haxevx_vuex_examples_shoppingcart_modules_ProductListDispatcher.shop.getProducts(function(products) {
			context.commit("haxevx_vuex_examples_shoppingcart_store_AppMutator|receiveProducts",products);
		});
	}
	,_SetInto: function(d,ns) {
		var cls = haxevx_vuex_examples_shoppingcart_modules_ProductListDispatcher;
		var clsP = cls.prototype;
		d[ns + "haxevx_vuex_examples_shoppingcart_modules_ProductListDispatcher|getAllProducts"] = clsP.getAllProducts;
	}
};
var haxevx_vuex_examples_shoppingcart_modules_ProductListMutator = function() {
	haxevx_vuex_examples_shoppingcart_store_AppMutator.call(this);
};
haxevx_vuex_examples_shoppingcart_modules_ProductListMutator.__name__ = true;
haxevx_vuex_examples_shoppingcart_modules_ProductListMutator.__super__ = haxevx_vuex_examples_shoppingcart_store_AppMutator;
haxevx_vuex_examples_shoppingcart_modules_ProductListMutator.prototype = $extend(haxevx_vuex_examples_shoppingcart_store_AppMutator.prototype,{
	receiveProducts: function(state,payload) {
		state.all = payload;
	}
	,addToCart: function(state,payload) {
		var filtered = state.all.filter(function(p) {
			return p.id == payload.id;
		});
		if(filtered.length > 0) filtered[0].inventory--;
	}
	,_SetInto: function(d,ns) {
		var cls = haxevx_vuex_examples_shoppingcart_modules_ProductListMutator;
		var clsP = cls.prototype;
		d[ns + "haxevx_vuex_examples_shoppingcart_store_AppMutator|receiveProducts"] = clsP.receiveProducts;
		d[ns + "haxevx_vuex_examples_shoppingcart_store_AppMutator|addToCart"] = clsP.addToCart;
	}
});
var haxevx_vuex_examples_shoppingcart_modules_ProductListModel = function() {
	this.all = [];
};
haxevx_vuex_examples_shoppingcart_modules_ProductListModel.__name__ = true;
haxevx_vuex_examples_shoppingcart_modules_ProductListModel.__interfaces__ = [haxevx_vuex_core_IPrefixedState];
var haxevx_vuex_examples_shoppingcart_store_AppActions = function() {
	null;
};
haxevx_vuex_examples_shoppingcart_store_AppActions.__name__ = true;
haxevx_vuex_examples_shoppingcart_store_AppActions.prototype = {
	addToCart: function(context,payload) {
		if(payload.inventory > 0) context.commit("haxevx_vuex_examples_shoppingcart_store_AppMutator|addToCart",{ id : payload.id});
	}
	,_SetInto: function(d,ns) {
		var cls = haxevx_vuex_examples_shoppingcart_store_AppActions;
		var clsP = cls.prototype;
		d[ns + "haxevx_vuex_examples_shoppingcart_store_AppActions|addToCart"] = clsP.addToCart;
	}
};
var haxevx_vuex_examples_shoppingcart_store_AppGetters = function() {
};
haxevx_vuex_examples_shoppingcart_store_AppGetters.__name__ = true;
haxevx_vuex_examples_shoppingcart_store_AppGetters.Get_cartProducts = function(state) {
	var exceptions = null;
	var resultOfMap = state.cart.added.map(function(cp) {
		var chk = state.products.all.filter(function(p) {
			return p.id == cp.id;
		});
		if(chk.length > 0) {
			var product = chk[0];
			return { id : product.id, title : product.title, price : product.price, quantity : cp.quantity};
		} else {
			if(exceptions == null) exceptions = [];
			exceptions.push(cp.id == null?"null":"" + cp.id);
			return null;
		}
	});
	if(exceptions != null) throw new js__$Boot_HaxeError("Null id link reference map exception detected!: " + Std.string(exceptions));
	return resultOfMap;
};
haxevx_vuex_examples_shoppingcart_store_AppGetters.prototype = {
	_SetInto: function(d) {
		var cls = haxevx_vuex_examples_shoppingcart_store_AppGetters;
		d.cartProducts = cls.Get_cartProducts;
	}
};
var haxevx_vuex_examples_shoppingcart_store_AppStore = function() {
	haxevx_vuex_core_VxStore.call(this);
	this.strict = true;
	this._Init("");
};
haxevx_vuex_examples_shoppingcart_store_AppStore.__name__ = true;
haxevx_vuex_examples_shoppingcart_store_AppStore.__super__ = haxevx_vuex_core_VxStore;
haxevx_vuex_examples_shoppingcart_store_AppStore.prototype = $extend(haxevx_vuex_core_VxStore.prototype,{
	_Init: function(ns) {
		this._ = ns;
		if(this.state != null) this.state._ = ns; else this.state = { _ : ns};
		var useNS = ns;
		var cls = haxevx_vuex_examples_shoppingcart_store_AppStore;
		var clsP = cls.prototype;
		var key;
		var d;
		d = { };
		this.getters = d;
		new haxevx_vuex_examples_shoppingcart_store_AppGetters()._SetInto(d);
		d = { };
		this.mutations = d;
		new haxevx_vuex_examples_shoppingcart_store_AppMutator()._SetInto(d,"");
		d = { };
		this.actions = d;
		new haxevx_vuex_examples_shoppingcart_store_AppActions()._SetInto(d,"");
		d = { };
		this.modules = d;
		if(this.cart == null) this.cart = new haxevx_vuex_examples_shoppingcart_modules_Cart();
		if(this.cart != null) {
			d.cart = this.cart;
			this.cart._Init(ns + "cart/");
		}
		if(this.products == null) this.products = new haxevx_vuex_examples_shoppingcart_modules_Products();
		if(this.products != null) {
			d.products = this.products;
			this.products._Init(ns + "products/");
		}
	}
	,_InjNative: function(g) {
		this._stg = g;
	}
});
var haxevx_vuex_examples_shoppingcart_store_AppState = function() {
};
haxevx_vuex_examples_shoppingcart_store_AppState.__name__ = true;
var haxevx_vuex_native_ActionContext = function() { };
haxevx_vuex_native_ActionContext.__name__ = true;
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
String.__name__ = true;
Array.__name__ = true;
if(Array.prototype.map == null) Array.prototype.map = function(f) {
	var a = [];
	var _g1 = 0;
	var _g = this.length;
	while(_g1 < _g) {
		var i = _g1++;
		a[i] = f(this[i]);
	}
	return a;
};
if(Array.prototype.filter == null) Array.prototype.filter = function(f1) {
	var a1 = [];
	var _g11 = 0;
	var _g2 = this.length;
	while(_g11 < _g2) {
		var i1 = _g11++;
		var e = this[i1];
		if(f1(e)) a1.push(e);
	}
	return a1;
};
haxevx_vuex_examples_shoppingcart_components_App.ProductList = "product-list";
haxevx_vuex_examples_shoppingcart_components_App.Cart = "cart";
haxevx_vuex_examples_shoppingcart_modules_CartDispatcher.shop = haxevx_vuex_examples_shoppingcart_api_Shop.getInstance();
haxevx_vuex_examples_shoppingcart_modules_ProductListDispatcher.shop = haxevx_vuex_examples_shoppingcart_api_Shop.getInstance();
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}});
