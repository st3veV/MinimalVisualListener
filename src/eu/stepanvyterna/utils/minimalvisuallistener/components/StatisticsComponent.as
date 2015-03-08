/**
 * Created by Steve on 7.3.2015.
 */
package eu.stepanvyterna.utils.minimalvisuallistener.components
{
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.Meter;
	import com.bit101.components.VBox;

	import flash.display.DisplayObjectContainer;

	public class StatisticsComponent extends VBox
	{
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

		public function StatisticsComponent( parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0 )
		{
			super( parent, xpos, ypos );
			init();
		}

		private function init():void
		{
			var line:HBox;

			line = new HBox( this );
			line.width = width;
			new Label( line, 0, 0, "Total Tests: " );
			totalTests = new Label( line, 0, 0, "0" );

			line = new HBox( this );
			line.width = width;
			new Label( line, 0, 0, "Remaining Tests: " );
			remainingTests = new Label( line, 0, 0, "0" );

			line = new HBox( this );
			line.width = width;
			new Label( line, 0, 0, "Passed Tests: " );
			passedTests = new Label( line, 0, 0, "0" );

			line = new HBox( this );
			line.width = width;
			new Label( line, 0, 0, "Failed Tests: " );
			failedTests = new Label( line, 0, 0, "0" );

			line = new HBox( this );
			line.width = width;
			new Label( line, 0, 0, "Ignored Tests: " );
			ignoredTests = new Label( line, 0, 0, "0" );

			meter = new Meter( this, 0, 0, "0/0" );
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

	}
}
