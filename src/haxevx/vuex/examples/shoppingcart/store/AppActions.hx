package haxevx.vuex.examples.shoppingcart.store;
import haxevx.vuex.core.IAction;
import haxevx.vuex.core.IVxContext.IVxContext1;
import haxevx.vuex.core.NoneT;

import haxevx.vuex.examples.shoppingcart.store.AppStore.AppState;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes;

/**
 * port of store/actions.js
 * @author Glidias
 */
class AppActions<S:AppState> implements IAction<S,NoneT>
{
	@:mutator static var mutator:AppMutator<Dynamic>;
	
	// todo: to test auto-completion/checking of IVxContext1's S and RS respectively
	 function addToCart(context:IVxContext1<S>, payload:ProductInStore):Void { 
		if (payload.inventory > 0) {
			
			mutator._addToCart(context, {id:payload.id});			
		}
	}
	
}