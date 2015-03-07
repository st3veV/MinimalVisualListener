/**
 * Created by Steve on 7.3.2015.
 */
package eu.stepanvyterna.utils.minimalvisuallistener.data
{
	import eu.stepanvyterna.utils.minimalvisuallistener.utils.DescriptionParser;

	import org.flexunit.runner.IDescription;

	public class TestElement
	{
		private var _description:IDescription;
		private var _passed:Boolean = true;
		private var _ignored:Boolean = false;
		private var _executed:Boolean = false;
		private var _suite:TestSuiteElement;

		public function TestElement( description:IDescription )
		{
			_description = description;
		}

		public function get name():String
		{
			return _description.displayName;
		}

		public function get readableName():String
		{
			var s:String = DescriptionParser.getTestName( _description );
			return _description.displayName + ((s == _description.displayName) ? "" : " ( " + s + " )");
		}

		public function get passed():Boolean
		{
			return _passed;
		}

		public function set passed( value:Boolean ):void
		{
			_passed = value;
		}

		public function get ignored():Boolean
		{
			return _ignored;
		}

		public function set ignored( value:Boolean ):void
		{
			_ignored = value;
		}

		public function get executed():Boolean
		{
			return _executed;
		}

		public function set executed( value:Boolean ):void
		{
			_executed = value;
			_suite.dirty = true;
		}

		public function set suite( suite:TestSuiteElement ):void
		{
			_suite = suite;
		}
	}
}
