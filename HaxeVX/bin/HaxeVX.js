(function () { "use strict";
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var Main = function() { }
Main.main = function() {
	new haxevx.vuex.examples.shoppingcart.ShoppingCartMain();
}
var haxevx = {}
haxevx.vuex = {}
haxevx.vuex.core = {}
haxevx.vuex.core.IVxContext = function() { }
haxevx.vuex.core.IVxStoreContext = function() { }
haxevx.vuex.core.IVxStoreContext.__interfaces__ = [haxevx.vuex.core.IVxContext];
haxevx.vuex.core.NoneT = function() { }
haxevx.vuex.core.VComponent = function() { }
haxevx.vuex.core.VComponent.prototype = {
	_toNative: function() {
		return null;
	}
	,Template: function() {
		return null;
	}
	,Render: function() {
		return null;
	}
	,Created: function() {
	}
	,getNewData: function() {
		return null;
	}
	,getNewProps: function() {
		return null;
	}
	,get_data: function() {
		return this.$data;
	}
	,get_props: function() {
		return this;
	}
}
haxevx.vuex.core.VModule = function() { }
haxevx.vuex.core.VxComponent = function() { }
haxevx.vuex.core.VxComponent.__super__ = haxevx.vuex.core.VComponent;
haxevx.vuex.core.VxComponent.prototype = $extend(haxevx.vuex.core.VComponent.prototype,{
	get_store: function() {
		return this.$store;
	}
});
haxevx.vuex.core.VxStore = function() {
	this.strict = false;
};
haxevx.vuex.core.VxStore.__interfaces__ = [haxevx.vuex.core.IVxStoreContext];
haxevx.vuex.core.VxStore.prototype = {
	_toNativeModule: function() {
		return null;
	}
	,_toNative: function() {
		return null;
	}
	,commit: function(type,payload) {
	}
	,dispatch: function(type,payload) {
	}
}
haxevx.vuex.examples = {}
haxevx.vuex.examples.shoppingcart = {}
haxevx.vuex.examples.shoppingcart.ShoppingCartMain = function() {
	var store = new haxevx.vuex.examples.shoppingcart.store.AppStore();
	var rootComponent = new haxevx.vuex.examples.shoppingcart.components.App();
};
haxevx.vuex.examples.shoppingcart.components = {}
haxevx.vuex.examples.shoppingcart.components.App = function() {
};
haxevx.vuex.examples.shoppingcart.components.App.__super__ = haxevx.vuex.core.VxComponent;
haxevx.vuex.examples.shoppingcart.components.App.prototype = $extend(haxevx.vuex.core.VxComponent.prototype,{
	Template: function() {
		return "<div id=\"app\">\r\n\t\t\t\t<h1>Shopping Cart Example</h1>\r\n\t\t\t\t<hr>\r\n\t\t\t\t<h2>Products</h2>\r\n\t\t\t\t<product-list></product-list>\r\n\t\t\t\t<hr>\r\n\t\t\t\t<cart></cart>\r\n\t\t\t  </div>";
	}
});
haxevx.vuex.examples.shoppingcart.modules = {}
haxevx.vuex.examples.shoppingcart.modules.Cart = function() {
	this.state = { added : [], checkoutStatus : null, lastCheckout : null};
};
haxevx.vuex.examples.shoppingcart.modules.Cart.getCheckoutStatus = function(state) {
	return state.checkoutStatus;
}
haxevx.vuex.examples.shoppingcart.modules.Cart.__super__ = haxevx.vuex.core.VModule;
haxevx.vuex.examples.shoppingcart.modules.Cart.prototype = $extend(haxevx.vuex.core.VModule.prototype,{
	get_checkoutStatus: function() {
		return haxevx.vuex.examples.shoppingcart.modules.Cart.getCheckoutStatus(this.state);
	}
});
haxevx.vuex.examples.shoppingcart.modules.CartDispatcher = function() { }
haxevx.vuex.examples.shoppingcart.modules.CartDispatcher.prototype = {
	checkout: function(payload) {
		var _g = this;
		return function(context,payload1) {
			var savedCartItems = context.state.added.concat([]);
			_g.mutator.checkoutRequest();
		};
	}
}
haxevx.vuex.examples.shoppingcart.store = {}
haxevx.vuex.examples.shoppingcart.store.AppMutator = function() { }
haxevx.vuex.examples.shoppingcart.store.AppMutator.prototype = {
	receiveProducts: function(payload) {
		return null;
	}
	,checkoutFailure: function(payload) {
		return null;
	}
	,checkoutSuccess: function() {
		return null;
	}
	,checkoutRequest: function() {
		return null;
	}
	,addToCart: function(payload) {
		return null;
	}
}
haxevx.vuex.examples.shoppingcart.modules.CartMutator = function() { }
haxevx.vuex.examples.shoppingcart.modules.CartMutator.__super__ = haxevx.vuex.examples.shoppingcart.store.AppMutator;
haxevx.vuex.examples.shoppingcart.modules.CartMutator.prototype = $extend(haxevx.vuex.examples.shoppingcart.store.AppMutator.prototype,{
	checkoutFailure: function(payload) {
		return function(state,payload1) {
			state.added = payload1.savedCartItems;
			state.checkoutStatus = "failed";
		};
	}
	,checkoutSuccess: function() {
		return function(state) {
			state.added = [];
			state.checkoutStatus = "successful";
		};
	}
	,checkoutRequest: function() {
		return function(state) {
			state.added = [];
			state.checkoutStatus = null;
		};
	}
	,addToCart: function(payload) {
		return function(state,payload1) {
			state.lastCheckout = null;
		};
	}
});
haxevx.vuex.examples.shoppingcart.modules.ProductList = function() {
	this.state = new haxevx.vuex.examples.shoppingcart.modules.ProductListModel();
};
haxevx.vuex.examples.shoppingcart.modules.ProductList.getAllProducts = function(state) {
	return state.all;
}
haxevx.vuex.examples.shoppingcart.modules.ProductList.__super__ = haxevx.vuex.core.VModule;
haxevx.vuex.examples.shoppingcart.modules.ProductList.prototype = $extend(haxevx.vuex.core.VModule.prototype,{
	get_allProducts: function() {
		return haxevx.vuex.examples.shoppingcart.modules.ProductList.getAllProducts(this.state);
	}
});
haxevx.vuex.examples.shoppingcart.modules.ProductListModel = function() {
	this.all = [];
};
haxevx.vuex.examples.shoppingcart.modules.ProductListMutator = function() { }
haxevx.vuex.examples.shoppingcart.modules.ProductListMutator.__super__ = haxevx.vuex.examples.shoppingcart.store.AppMutator;
haxevx.vuex.examples.shoppingcart.modules.ProductListMutator.prototype = $extend(haxevx.vuex.examples.shoppingcart.store.AppMutator.prototype,{
	addToCart: function(payload) {
		return function(state,payload1) {
			var filtered = state.all.filter(function(p) {
				return p.id == payload1.id;
			});
			if(filtered.length > 0) filtered[0].inventory--;
		};
	}
	,receiveProducts: function(payload) {
		return function(state,payload1) {
			state.all = payload1;
		};
	}
});
haxevx.vuex.examples.shoppingcart.store.AppActions = function() { }
haxevx.vuex.examples.shoppingcart.store.AppActions.prototype = {
	checkout: function(product) {
		var _g = this;
		return function(context,payload) {
			if(product.inventory > 0) _g.mutator.addToCart({ id : product.id});
		};
	}
}
haxevx.vuex.examples.shoppingcart.store.AppGetters = function() { }
haxevx.vuex.examples.shoppingcart.store.AppGetters.getCartProducts = function(state) {
	state.cart.added.map(function(cp) {
		var chk = state.products.all.filter(function(p) {
			return p.id == cp.id;
		});
		if(chk.length > 0) {
			var product = chk[0];
			return { title : product.title, price : product.price, quantity : cp.quantity};
		} else return null;
	});
	return null;
}
haxevx.vuex.examples.shoppingcart.store.AppGetters.__super__ = haxevx.vuex.core.VModule;
haxevx.vuex.examples.shoppingcart.store.AppGetters.prototype = $extend(haxevx.vuex.core.VModule.prototype,{
	get_cartProducts: function() {
		return haxevx.vuex.examples.shoppingcart.store.AppGetters.getCartProducts(this.state);
	}
});
haxevx.vuex.examples.shoppingcart.store.AppStore = function() {
	this.state = new haxevx.vuex.examples.shoppingcart.store.AppState();
	this.strict = true;
};
haxevx.vuex.examples.shoppingcart.store.AppStore.__super__ = haxevx.vuex.core.VxStore;
haxevx.vuex.examples.shoppingcart.store.AppStore.prototype = $extend(haxevx.vuex.core.VxStore.prototype,{
});
haxevx.vuex.examples.shoppingcart.store.AppState = function() {
};
haxevx.vuex.examples.shoppingcart.components.App.__rtti = "<class path=\"haxevx.vuex.examples.shoppingcart.components.App\" params=\"\">\n\t<extends path=\"haxevx.vuex.core.VxComponent\">\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.store.AppStore\"/>\n\t\t<c path=\"haxevx.vuex.core.NoneT\"/>\n\t\t<c path=\"haxevx.vuex.core.NoneT\"/>\n\t</extends>\n\t<Template public=\"1\" set=\"method\" line=\"19\" override=\"1\"><f a=\"\"><c path=\"String\"/></f></Template>\n\t<new public=\"1\" set=\"method\" line=\"14\"><f a=\"\"><x path=\"Void\"/></f></new>\n\t<meta><m n=\":rtti\"/></meta>\n</class>";
haxevx.vuex.examples.shoppingcart.modules.Cart.__meta__ = { fields : { mutator : { mutator : null}, action : { mutator : null}}};
haxevx.vuex.examples.shoppingcart.modules.Cart.__rtti = "<class path=\"haxevx.vuex.examples.shoppingcart.modules.Cart\" params=\"\">\n\t<extends path=\"haxevx.vuex.core.VModule\"><t path=\"haxevx.vuex.examples.shoppingcart.modules.CartState\"/></extends>\n\t<getCheckoutStatus set=\"method\" line=\"32\" static=\"1\"><f a=\"state\">\n\t<t path=\"haxevx.vuex.examples.shoppingcart.modules.CartState\"/>\n\t<c path=\"String\"/>\n</f></getCheckoutStatus>\n\t<checkoutStatus public=\"1\" get=\"accessor\" set=\"null\"><c path=\"String\"/></checkoutStatus>\n\t<get_checkoutStatus set=\"method\" line=\"35\"><f a=\"\"><c path=\"String\"/></f></get_checkoutStatus>\n\t<action>\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.modules.CartDispatcher\"><t path=\"haxevx.vuex.examples.shoppingcart.modules.CartState\"/></c>\n\t\t<meta><m n=\"mutator\"/></meta>\n\t</action>\n\t<mutator>\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.modules.CartMutator\"><t path=\"haxevx.vuex.examples.shoppingcart.modules.CartState\"/></c>\n\t\t<meta><m n=\"mutator\"/></meta>\n\t</mutator>\n\t<new public=\"1\" set=\"method\" line=\"19\"><f a=\"\"><x path=\"Void\"/></f></new>\n\t<meta><m n=\":rtti\"/></meta>\n</class>";
haxevx.vuex.examples.shoppingcart.modules.CartDispatcher.__meta__ = { fields : { mutator : { mutator : null}}};
haxevx.vuex.examples.shoppingcart.store.AppMutator.__rtti = "<class path=\"haxevx.vuex.examples.shoppingcart.store.AppMutator\" params=\"S\">\n\t<addToCart public=\"1\" params=\"P\" set=\"method\" line=\"22\"><f a=\"payload\">\n\t<c path=\"addToCart.P\"/>\n\t<f a=\":\">\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.store.AppMutator.S\"/>\n\t\t<c path=\"addToCart.P\"/>\n\t\t<x path=\"Void\"/>\n\t</f>\n</f></addToCart>\n\t<checkoutRequest public=\"1\" set=\"method\" line=\"26\"><f a=\"\"><f a=\"\">\n\t<c path=\"haxevx.vuex.examples.shoppingcart.store.AppMutator.S\"/>\n\t<x path=\"Void\"/>\n</f></f></checkoutRequest>\n\t<checkoutSuccess public=\"1\" set=\"method\" line=\"29\"><f a=\"\"><f a=\"\">\n\t<c path=\"haxevx.vuex.examples.shoppingcart.store.AppMutator.S\"/>\n\t<x path=\"Void\"/>\n</f></f></checkoutSuccess>\n\t<checkoutFailure public=\"1\" params=\"P\" set=\"method\" line=\"32\"><f a=\"payload\">\n\t<c path=\"checkoutFailure.P\"/>\n\t<f a=\":\">\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.store.AppMutator.S\"/>\n\t\t<c path=\"checkoutFailure.P\"/>\n\t\t<x path=\"Void\"/>\n\t</f>\n</f></checkoutFailure>\n\t<receiveProducts public=\"1\" params=\"P\" set=\"method\" line=\"36\"><f a=\"payload\">\n\t<c path=\"receiveProducts.P\"/>\n\t<f a=\":\">\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.store.AppMutator.S\"/>\n\t\t<c path=\"receiveProducts.P\"/>\n\t\t<x path=\"Void\"/>\n\t</f>\n</f></receiveProducts>\n\t<meta><m n=\":rtti\"/></meta>\n</class>";
haxevx.vuex.examples.shoppingcart.modules.CartMutator.__rtti = "<class path=\"haxevx.vuex.examples.shoppingcart.modules.CartMutator\" params=\"S\" module=\"haxevx.vuex.examples.shoppingcart.modules.Cart\">\n\t<extends path=\"haxevx.vuex.examples.shoppingcart.store.AppMutator\"><d/></extends>\n\t<addToCart public=\"1\" params=\"P\" set=\"method\" line=\"78\" override=\"1\"><f a=\"payload\">\n\t<c path=\"addToCart.P\"/>\n\t<f a=\":\">\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.modules.CartMutator.S\"/>\n\t\t<c path=\"addToCart.P\"/>\n\t\t<x path=\"Void\"/>\n\t</f>\n</f></addToCart>\n\t<checkoutRequest public=\"1\" set=\"method\" line=\"97\" override=\"1\"><f a=\"\"><f a=\"\">\n\t<c path=\"haxevx.vuex.examples.shoppingcart.modules.CartMutator.S\"/>\n\t<x path=\"Void\"/>\n</f></f></checkoutRequest>\n\t<checkoutSuccess public=\"1\" set=\"method\" line=\"104\" override=\"1\"><f a=\"\"><f a=\"\">\n\t<c path=\"haxevx.vuex.examples.shoppingcart.modules.CartMutator.S\"/>\n\t<x path=\"Void\"/>\n</f></f></checkoutSuccess>\n\t<checkoutFailure public=\"1\" params=\"P\" set=\"method\" line=\"111\" override=\"1\"><f a=\"payload\">\n\t<c path=\"checkoutFailure.P\"/>\n\t<f a=\":\">\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.modules.CartMutator.S\"/>\n\t\t<c path=\"checkoutFailure.P\"/>\n\t\t<x path=\"Void\"/>\n\t</f>\n</f></checkoutFailure>\n</class>";
haxevx.vuex.examples.shoppingcart.modules.ProductList.__meta__ = { fields : { mutator : { mutator : null}}};
haxevx.vuex.examples.shoppingcart.modules.ProductList.__rtti = "<class path=\"haxevx.vuex.examples.shoppingcart.modules.ProductList\" params=\"\">\n\t<extends path=\"haxevx.vuex.core.VModule\"><c path=\"haxevx.vuex.examples.shoppingcart.modules.ProductListModel\"/></extends>\n\t<getAllProducts set=\"method\" line=\"29\" static=\"1\"><f a=\"state\">\n\t<c path=\"haxevx.vuex.examples.shoppingcart.modules.ProductListModel\"/>\n\t<c path=\"Array\"><d/></c>\n</f></getAllProducts>\n\t<allProducts public=\"1\" get=\"accessor\" set=\"null\"><c path=\"Array\"><d/></c></allProducts>\n\t<get_allProducts set=\"method\" line=\"25\"><f a=\"\"><c path=\"Array\"><d/></c></f></get_allProducts>\n\t<mutator>\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.modules.ProductListMutator\"><c path=\"haxevx.vuex.examples.shoppingcart.modules.ProductListModel\"/></c>\n\t\t<meta><m n=\"mutator\"/></meta>\n\t</mutator>\n\t<new public=\"1\" set=\"method\" line=\"15\"><f a=\"\"><x path=\"Void\"/></f></new>\n\t<meta><m n=\":rtti\"/></meta>\n</class>";
haxevx.vuex.examples.shoppingcart.modules.ProductListMutator.__rtti = "<class path=\"haxevx.vuex.examples.shoppingcart.modules.ProductListMutator\" params=\"S\" module=\"haxevx.vuex.examples.shoppingcart.modules.ProductList\">\n\t<extends path=\"haxevx.vuex.examples.shoppingcart.store.AppMutator\"><d/></extends>\n\t<receiveProducts public=\"1\" params=\"P\" set=\"method\" line=\"59\" override=\"1\"><f a=\"payload\">\n\t<c path=\"receiveProducts.P\"/>\n\t<f a=\":\">\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.modules.ProductListMutator.S\"/>\n\t\t<c path=\"receiveProducts.P\"/>\n\t\t<x path=\"Void\"/>\n\t</f>\n</f></receiveProducts>\n\t<addToCart public=\"1\" params=\"P\" set=\"method\" line=\"65\" override=\"1\"><f a=\"payload\">\n\t<c path=\"addToCart.P\"/>\n\t<f a=\":\">\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.modules.ProductListMutator.S\"/>\n\t\t<c path=\"addToCart.P\"/>\n\t\t<x path=\"Void\"/>\n\t</f>\n</f></addToCart>\n</class>";
haxevx.vuex.examples.shoppingcart.store.AppActions.__meta__ = { fields : { mutator : { mutator : null}}};
haxevx.vuex.examples.shoppingcart.store.AppActions.__rtti = "<class path=\"haxevx.vuex.examples.shoppingcart.store.AppActions\" params=\"S\">\n\t<mutator public=\"1\">\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.store.AppMutator\"><d/></c>\n\t\t<meta><m n=\"mutator\"/></meta>\n\t</mutator>\n\t<checkout public=\"1\" params=\"P\" set=\"method\" line=\"15\"><f a=\"product\">\n\t<c path=\"checkout.P\"/>\n\t<f a=\":\">\n\t\t<c path=\"haxevx.vuex.core.IVxStoreContext\"><c path=\"haxevx.vuex.examples.shoppingcart.store.AppActions.S\"/></c>\n\t\t<c path=\"checkout.P\"/>\n\t\t<x path=\"Void\"/>\n\t</f>\n</f></checkout>\n\t<meta><m n=\":rtti\"/></meta>\n</class>";
haxevx.vuex.examples.shoppingcart.store.AppGetters.__rtti = "<class path=\"haxevx.vuex.examples.shoppingcart.store.AppGetters\" params=\"S\">\n\t<extends path=\"haxevx.vuex.core.VModule\"><c path=\"haxevx.vuex.examples.shoppingcart.store.AppGetters.S\"/></extends>\n\t<getCartProducts public=\"1\" params=\"S\" set=\"method\" line=\"18\" static=\"1\"><f a=\"state\">\n\t<c path=\"getCartProducts.S\"/>\n\t<c path=\"Array\"><t path=\"haxevx.vuex.examples.shoppingcart.store.ProductInCart\"/></c>\n</f></getCartProducts>\n\t<cartProducts public=\"1\" get=\"accessor\" set=\"null\"><c path=\"Array\"><t path=\"haxevx.vuex.examples.shoppingcart.store.ProductInCart\"/></c></cartProducts>\n\t<get_cartProducts set=\"method\" line=\"14\"><f a=\"\"><c path=\"Array\"><t path=\"haxevx.vuex.examples.shoppingcart.store.ProductInCart\"/></c></f></get_cartProducts>\n\t<meta><m n=\":rtti\"/></meta>\n</class>";
haxevx.vuex.examples.shoppingcart.store.AppStore.__meta__ = { fields : { products : { module : null}, cart : { module : null}, getters : { getter : null}, actions : { action : null}}};
haxevx.vuex.examples.shoppingcart.store.AppStore.__rtti = "<class path=\"haxevx.vuex.examples.shoppingcart.store.AppStore\" params=\"\">\n\t<extends path=\"haxevx.vuex.core.VxStore\"><c path=\"haxevx.vuex.examples.shoppingcart.store.AppState\"/></extends>\n\t<actions public=\"1\">\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.store.AppActions\"><c path=\"haxevx.vuex.examples.shoppingcart.store.AppState\"/></c>\n\t\t<meta><m n=\"action\"/></meta>\n\t</actions>\n\t<getters public=\"1\">\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.store.AppGetters\"><c path=\"haxevx.vuex.examples.shoppingcart.store.AppState\"/></c>\n\t\t<meta><m n=\"getter\"/></meta>\n\t</getters>\n\t<cart public=\"1\">\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.modules.Cart\"/>\n\t\t<meta><m n=\"module\"/></meta>\n\t</cart>\n\t<products public=\"1\">\n\t\t<c path=\"haxevx.vuex.examples.shoppingcart.modules.ProductList\"/>\n\t\t<meta><m n=\"module\"/></meta>\n\t</products>\n\t<new public=\"1\" set=\"method\" line=\"25\"><f a=\"\"><x path=\"Void\"/></f></new>\n\t<meta><m n=\":rtti\"/></meta>\n</class>";
haxevx.vuex.examples.shoppingcart.store.AppState.__rtti = "<class path=\"haxevx.vuex.examples.shoppingcart.store.AppState\" params=\"\" module=\"haxevx.vuex.examples.shoppingcart.store.AppStore\">\n\t<cart public=\"1\" set=\"null\"><t path=\"haxevx.vuex.examples.shoppingcart.modules.CartState\"/></cart>\n\t<products public=\"1\" set=\"null\"><c path=\"haxevx.vuex.examples.shoppingcart.modules.ProductListModel\"/></products>\n\t<new public=\"1\" set=\"method\" line=\"41\"><f a=\"\"><x path=\"Void\"/></f></new>\n\t<meta><m n=\":rtti\"/></meta>\n</class>";
Main.main();
})();
