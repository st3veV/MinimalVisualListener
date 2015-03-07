/**
 * Created by Steve on 7.3.2015.
 */
package eu.stepanvyterna.utils.minimalvisuallistener.components
{
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.Meter;
	import com.bit101.components.VBox;

	import flash.display.DisplayObject;

	public class StatisticsComponent
	{
		private var _container:VBox;
		private var totalTests:Label;
		private var remainingTests:Label;
		private var passedTests:Label;
		private var failedTests:Label;
		private var ignoredTests:Label;
		private var meter:Meter;
		private var passed:int = 0;
		private var failed:int = 0;
		private var total:int = 0;
		private var ignored:int = 0;
		private var _width:Number;
		private var _height:Number;

		public function StatisticsComponent( width:Number, height:Number )
		{
			_width = width;
			_height = height;
			_container = new VBox();
			_container.alignment = VBox.LEFT;
			init();
		}

		private function init():void
		{
			var line:HBox;

			line = new HBox( _container );
			line.width = _container.width;
			new Label( line, 0, 0, "Total Tests: " );
			totalTests = new Label( line, 0, 0, "0" );

			line = new HBox( _container );
			line.width = _container.width;
			new Label( line, 0, 0, "Remaining Tests: " );
			remainingTests = new Label( line, 0, 0, "0" );

			line = new HBox( _container );
			line.width = _container.width;
			new Label( line, 0, 0, "Passed Tests: " );
			passedTests = new Label( line, 0, 0, "0" );

			line = new HBox( _container );
			line.width = _container.width;
			new Label( line, 0, 0, "Failed Tests: " );
			failedTests = new Label( line, 0, 0, "0" );

			line = new HBox( _container );
			line.width = _container.width;
			new Label( line, 0, 0, "Ignored Tests: " );
			ignoredTests = new Label( line, 0, 0, "0" );

			meter = new Meter( _container, 0, 0, "0/0" );
		}

		public function setTestCount( count:int ):void
		{
			total = count;
			totalTests.text = "" + count;
			updateMeter();
			updateRemaining();
		}

		public function testPassed():void
		{
			passed++;
			passedTests.text = passed + "";
			updateMeter();
			updateRemaining();
		}

		public function testFailed():void
		{
			failed++;
			failedTests.text = failed + "";
			updateRemaining();
		}

		public function testIgnored():void
		{
			ignored++;
			ignoredTests.text = ignored + "";
			updateRemaining();
			updateMeter();
		}

		private function updateMeter():void
		{
			meter.minimum = 0;
			meter.maximum = total - ignored;
			meter.label = passed + "/" + (total - ignored);
			meter.value = passed;
		}

		private function updateRemaining():void
		{
			remainingTests.text = (total - ignored - passed - failed) + "";
		}

		public function get display():DisplayObject
		{
			return _container;
		}
	}
}
