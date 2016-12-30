package haxevx.vuex.examples.shoppingcart.store;
import haxevx.vuex.core.IVxStoreContext;
import haxevx.vuex.examples.shoppingcart.store.AppStore.AppState;
import haxevx.vuex.examples.shoppingcart.store.ObjTypes;

/**
 * port of store/actions.js
 * @author Glidias
 */
@:rtti
class AppActions<S:AppState>
{
	@mutator static var mutator:AppMutator<Dynamic>;
	
	 public function addToCart<P:ProductInStore>(payload:P):IVxStoreContext<S>->P->Void {  //
		return function(context:IVxStoreContext<S>, payload:P):Void {
			if (payload.inventory > 0) {
				
				
				mutator.addToCart({id:payload.id});
				
			}
		}
		
	 }
	
}