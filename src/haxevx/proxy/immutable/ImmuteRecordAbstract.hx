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
	
	// Immutable property declarations for class macro  
	// (notice property declaration is readOnly).
	// An immutable. "setCopy" method will be generated and shoudl be used exclusively instead.
	// wip: Is there anyway to generate such properties from supplied ImmutableTypeDef instead????
	//public var copy(get, never):String;
	
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