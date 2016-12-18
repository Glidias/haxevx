package haxevx.proxy.immutable;

/**
 * ...
 * @author Glidias
 */

@:native("Immutable") extern class Immutable
{

	public static function Record<T>(objDef:T):Class<ImmutableRecord<T>>;
	
	
	public static function fromJS<T>(objDef:T):ImmutableMap<T>;
}