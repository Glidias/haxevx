package haxevx.proxy.immutable;

/**
 * Testing ImmutableJS map/record externs with Haxe abstract classes and compile-time strict-typing and typehinting
 * @author Glidias
 */
class ImmDoodleMain
{

	public function new() 
	{
			
	//  Record implementation using dynamic constructor
		var imm = new ImmuteRecordAbstract(untyped { }  );  // bleh, untyped to forego compulsory parameters in typedef??
		//imm.copy = "AAA";  // Compiler will report "This operation is unsupported"
		var newImmRecord = imm.setCopy("blahblah Awrwa").setCopy("blahblah BBB").setCopy("vaxvxvx");
		trace("AValid?:" + imm.copy);
		trace("Valid?:" + newImmRecord.copyTestGet());
		
	// Map implementation using fromJS setup
		var imm2 = new ImmuteMapAbstract( new ImmuteClassDef()  );  // testing Map to proxy to class definition plain data
		var newImm = imm2.setCopy("ignore this").setCoolCopy("BB");
		newImm = newImm.setCopy2("BBBBAA");
		
		trace(imm2.copy + ", " + newImm.copy + " >>>"+newImm.copy2);
	}
	
}