package;


import haxevx.proxy.egoutput.ListItem;
import haxevx.vuex.examples.shoppingcart.ShoppingCartMain;


/**
 * ...
 * @author Glidias
 */
class Main 
{

	
	static function main() 
	{
		new ShoppingCartMain();


			var listItem:ListItem = new ListItem();
			listItem.title = "AAB";
			listItem.copy = "bbb";
			listItem.secondaryItem = new ListItem();
			listItem.secondaryItem.copy = "aavvvvvv";
	
	}
	
	
	
}