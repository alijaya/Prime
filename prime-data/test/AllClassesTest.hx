package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import prime.core.traits.IEditableValueObject;
import prime.core.traits.IEditEnabledValueObject;
import prime.core.traits.IMessagePackable;
import prime.core.traits.IValueObject;
import prime.core.validators.FloatRangeValidator;
import prime.core.validators.IntRangeValidator;
import prime.core.validators.IValueValidator;
import prime.core.validators.PercentIntRangeValidator;
import prime.core.validators.URIValidator;
import prime.core.validators.ValidatingValue;
import prime.tools.valueobjects.ChangeSet;
import prime.tools.valueobjects.ChangesUtil;
import prime.tools.valueobjects.ChangeVO;
import prime.tools.valueobjects.GroupChangeSet;
import prime.tools.valueobjects.ListChangeVO;
import prime.tools.valueobjects.ObjectChangeSet;
import prime.tools.valueobjects.ObjectPathVO;
import prime.tools.valueobjects.PropertyChangeVO;
import prime.tools.valueobjects.PropertyID;
import prime.tools.valueobjects.PropertyValueChangeVO;
import prime.tools.valueobjects.ValueObjectBase;
import prime.utils.BytesUtil;
import prime.utils.Csv;

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