/**
 * Created by Steve on 7.3.2015.
 */
package eu.stepanvyterna.utils.minimalvisuallistener.data
{
	import org.flexunit.runner.IDescription;

	public class TestSuiteElement
	{
		private var _testElements:Vector.<TestElement>;
		private var _name:String;
		private var _dirty:Boolean = true;

		public function TestSuiteElement( name:String )
		{
			_name = name;
			_testElements = new Vector.<TestElement>();
		}

		public function addTestElement( test:TestElement ):void
		{
			_testElements.push( test );
			test.suite = this;
		}

		public function getStats():TestSuiteElementStats
		{
			var stats:TestSuiteElementStats = new TestSuiteElementStats();
			for ( var i:int = 0; i < _testElements.length; i++ )
			{
				var element:TestElement = _testElements[ i ];
				if ( element.executed )
				{
					if ( element.ignored )
					{
						stats.ignored++;
					}
					else
					{
						if ( element.passed )
						{
							stats.passed++;
						}
						else
						{
							stats.failed++;
						}
					}
				}
			}
			stats.total = _testElements.length;
			return stats;
		}

		public function get name():String
		{
			return _name;
		}

		public function get isEmpty():Boolean
		{
			return (_testElements.length == 0);
		}

		public function getTestElement( description:IDescription ):TestElement
		{
			for each ( var element:TestElement in _testElements )
			{
				if ( element.name == description.displayName )
				{
					return element;
				}
			}
			return null;
		}

		public function get dirty():Boolean
		{
			return _dirty;
		}

		public function set dirty( value:Boolean ):void
		{
			_dirty = value;
		}

		public function get testElements():Vector.<TestElement>
		{
			return _testElements;
		}
	}
}
