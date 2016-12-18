package haxevx.proxy.immutable;
import haxevx.proxy.immutable.Immutable;

/**
 * Strictly-typed immutable record proxy example using Abstracts in Haxe
 * @author Glidias
 */
@:build(haxevx.proxy.immutable.ImmuteProxyGen.build())
abstract ImmuteRecordAbstract(ImmutableRecord<ImmutableTypeDef>)
{
	static var RECORD:Class<ImmutableRecord<ImmutableTypeDef>> = Immutable.Record({
		copy:"Default Text",
	});
	
	public inline function new(values:ImmutableTypeDef):Void {
		
		this = Type.createInstance(RECORD, [values]);
		
		
	}
	
	// Own domain-specific methods examples
	public function copyTestGet():String {
		return copy + " >>>>";
	}
	
	public inline function copyTestInlineGet():String {
		return copy + "--->>>>";
	}
	

	

}