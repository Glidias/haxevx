package haxevx.proxy.immutable;

/**
 * Testing ImmutableJS map/record externs with Haxe abstract classes
 * @author Glidias
 */
class ImmDoodleMain
{

	public function new() 
	{
			
	//  Record implementation using dynamic constructor
		var imm = new ImmuteRecordAbstract(untyped { }  );  // bleh, untyped to forego compulsory parameters in typedef??
		//imm.copy = "AAA";  // Compiler will report "This operation is unsupported"
		var newImmRecord = imm.setCopy("Awrwa").setCopy("BBB").setCopy("vaxvxvx");
		trace("AValid?:" + imm.copy);
		trace("Valid?:" + newImmRecord.copyTestGet());
		
	// Map implementation using fromJS setup
		var imm2 = new ImmuteMapAbstract({ copy:null }  );
		var newImm = imm2.setCoolCopy("BB");
		trace(imm2.copy + ", " + newImm.copy);
	
	}
	
}