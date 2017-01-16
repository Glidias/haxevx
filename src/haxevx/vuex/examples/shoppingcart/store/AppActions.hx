package haxevx.vuex.examples.shoppingcart.store;
import haxevx.vuex.core.IAction;

import haxevx.vuex.core.IVxStoreContext;
import haxevx.vuex.examples.shoppingcart.store.AppStore.AppState;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes;

/**
 * port of store/actions.js
 * @author Glidias
 */
@:rtti
class AppActions<S:AppState> implements IAction
{
	@mutator static var mutator:AppMutator<Dynamic>;
	
	 function addToCart(context:IVxStoreContext<S>, payload:ProductInStore):Void { 
		if (payload.inventory > 0) {
			
			mutator._addToCart(context, {id:payload.id});			
		}
	}
	
}