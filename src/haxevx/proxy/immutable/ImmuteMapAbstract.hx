package haxevx.proxy.immutable;

import haxevx.proxy.immutable.Immutable;

/**
 * TODO ImmutableMap
 * - For ImmutableMap, allow defining extra properties outside of underlying Immutable Type Param.
 * @compare   ImmuteRecordAbstract
 * 
 * TODO STANDARD:
 *  @see ImmuteProxyGen
 * 
 * @author Glidias
 */
@:build(haxevx.proxy.immutable.ImmuteProxyGen.build())
abstract ImmuteMapAbstract(ImmutableMap<ImmuteClassDef>)
{

	public inline function new(values:ImmuteClassDef):Void {
		
		this = Immutable.fromJS(values);
	}
	
	// Own domain-specific methods examples
	
	public inline function setCoolCopy(str:String):ImmuteMapAbstract {
		return setCopy(str + "....");  // the HaxeDevelop type hinting for macro generated properties should be more readily available.bah!
	}
	
	public function copyTestGet():String {
		return copy + " >>>>";
	}
	
	public inline function copyTestInlineGet():String {
		return copy + "--->>>>";
	}
	

	

}