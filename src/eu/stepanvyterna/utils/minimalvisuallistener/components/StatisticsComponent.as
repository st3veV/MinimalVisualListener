/**
 * StatisticsComponent.as
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2015 Stepan Vyterna
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package eu.stepanvyterna.utils.minimalvisuallistener.components
{
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.Meter;
	import com.bit101.components.VBox;

	import eu.stepanvyterna.utils.minimalvisuallistener.settings.Theme;

	import flash.display.DisplayObjectContainer;

	public class StatisticsComponent extends VBox
	{
		private var totalTestsLabel:Label;
		private var remainingTestsLabel:Label;
		private var passedTestsLabel:Label;
		private var failedTestsLabel:Label;
		private var ignoredTestsLabel:Label;
		private var meter:Meter;
		private var numPassed:int = 0;
		private var numFailed:int = 0;
		private var numTotal:int = 0;
		private var numIgnored:int = 0;

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
			totalTestsLabel = new Label( line, 0, 0, "0" );

			line = new HBox( this );
			line.width = width;
			new Label( line, 0, 0, "Remaining Tests: " );
			remainingTestsLabel = new Label( line, 0, 0, "0" );

			line = new HBox( this );
			line.width = width;
			new Label( line, 0, 0, "Passed Tests: " );
			passedTestsLabel = new Label( line, 0, 0, "0" );
			passedTestsLabel.textField.textColor = Theme.COLOR_PASS;

			line = new HBox( this );
			line.width = width;
			new Label( line, 0, 0, "Failed Tests: " );
			failedTestsLabel = new Label( line, 0, 0, "0" );
			failedTestsLabel.textField.textColor = Theme.COLOR_FAIL;

			line = new HBox( this );
			line.width = width;
			new Label( line, 0, 0, "Ignored Tests: " );
			ignoredTestsLabel = new Label( line, 0, 0, "0" );
			ignoredTestsLabel.textField.textColor = Theme.COLOR_IGNORE;

			meter = new Meter( this, 0, 0, "0/0" );
		}

		public function setTestCount( count:int ):void
		{
			numTotal = count;
			totalTestsLabel.text = String( count );
			updateMeter();
			updateRemaining();
		}

		public function testPassed():void
		{
			numPassed++;
			passedTestsLabel.text = String( numPassed );
			updateMeter();
			updateRemaining();
		}

		public function testFailed():void
		{
			numFailed++;
			failedTestsLabel.text = String( numFailed );
			updateRemaining();
		}

		public function testIgnored():void
		{
			numIgnored++;
			ignoredTestsLabel.text = String( numIgnored );
			updateRemaining();
			updateMeter();
		}

		private function updateMeter():void
		{
			meter.minimum = 0;
			meter.maximum = numTotal - numIgnored;
			meter.label = numPassed + "/" + (numTotal - numIgnored);
			meter.value = numPassed;
		}

		private function updateRemaining():void
		{
			remainingTestsLabel.text = String( numTotal - numIgnored - numPassed - numFailed );
		}

	}
}
