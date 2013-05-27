package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

#if flash
import prime.avm2.media.Sound;
import prime.avm2.net.NetConnection;
import prime.avm2.net.NetStream;
import prime.avm2.net.stream.NetStreamInfo;
import prime.avm2.net.stream.NetStreamInfoCode;
import prime.avm2.net.stream.NetStreamInfoLevel;
#end
import prime.core.traits.IFreezable;
import prime.fsm.states.MediaStates;
import prime.media.AudioStream;
import prime.media.BaseMediaStream;
import prime.media.IMediaStream;
import prime.media.SoundMixer;
import prime.media.VideoStream;


/**
* Auto generated MassiveUnit Test Class 
*/
class AllClassesTest 
{
	
	
	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function setup():Void
	{
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	
	@Test
	public function testExample():Void
	{
		Assert.isTrue(true);
	}
}