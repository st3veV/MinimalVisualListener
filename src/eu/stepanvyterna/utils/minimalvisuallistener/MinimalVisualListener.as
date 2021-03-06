/**
 * Pure AS3 implementation of FlexUnit Listener
 *
 * MinimalVisualListener.as
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

package eu.stepanvyterna.utils.minimalvisuallistener
{
	import com.bit101.components.Window;

	import eu.stepanvyterna.utils.minimalvisuallistener.components.StatisticsComponent;
	import eu.stepanvyterna.utils.minimalvisuallistener.components.TestDetailWindow;
	import eu.stepanvyterna.utils.minimalvisuallistener.components.TestResultsComponent;
	import eu.stepanvyterna.utils.minimalvisuallistener.data.TestElement;
	import eu.stepanvyterna.utils.minimalvisuallistener.data.TestSuiteElement;
	import eu.stepanvyterna.utils.minimalvisuallistener.events.TestElementSelectionEvent;

	import flash.display.Sprite;
	import flash.events.Event;

	import org.flexunit.runner.IDescription;
	import org.flexunit.runner.Result;
	import org.flexunit.runner.notification.Failure;
	import org.flexunit.runner.notification.IAsyncRunListener;
	import org.flexunit.runner.notification.IAsyncStartupRunListener;
	import org.flexunit.runner.notification.ITemporalRunListener;
	import org.flexunit.runner.notification.async.AsyncListenerWatcher;

	public class MinimalVisualListener extends Sprite implements IAsyncRunListener, IAsyncStartupRunListener, ITemporalRunListener
	{
		private var _width:Number;
		private var _height:Number;
		private var container:Window;
		private var statisticsComponent:StatisticsComponent;
		private var resultsComponent:TestResultsComponent;

		private var currentTest:TestElement;
		private var testSuiteElements:Vector.<TestSuiteElement> = new Vector.<TestSuiteElement>();
		private var _ready:Boolean = false;

		public function MinimalVisualListener( width:Number, height:Number )
		{
			_width = width;
			_height = height;

			if (stage)
			{
				init();
			}
			else
			{
				addEventListener( Event.ADDED_TO_STAGE, init );
			}
		}

		private function init( e:Event = null ):void
		{
			hasEventListener( Event.ADDED_TO_STAGE ) && removeEventListener( Event.ADDED_TO_STAGE, init );

			container = new Window( this, 0, 0, "MinimalTestRunner" );
			container.draggable = false;
			container.setSize( _width, _height );

			statisticsComponent = new StatisticsComponent( container.content );
			statisticsComponent.setSize( _width * .3, _height - container.titleBar.height );

			resultsComponent = new TestResultsComponent( container.content, _width * .3 );
			resultsComponent.setSize( _width * .7, _height - container.titleBar.height );
			resultsComponent.addEventListener( TestElementSelectionEvent.TEST_ELEMENT_SELECTED, onElementSelected );

			_ready = true;
			dispatchEvent( new Event( AsyncListenerWatcher.LISTENER_READY ) );
		}

		private function onElementSelected( event:TestElementSelectionEvent ):void
		{
			const percentSize:Number = .8;
			var window:TestDetailWindow = new TestDetailWindow( this, 0, 0, event.testElement.readableName );
			window.setSize( _width * percentSize, _height * percentSize );
			window.move( (_width - window.width) * .5, (_height - window.height) * .5 );
			window.setTestElement( event.testElement );
		}

		public function testRunStarted( description:IDescription ):void
		{
			statisticsComponent.setTestCount( description.testCount );

			getLowLevelTestSuites( description );
			resultsComponent.initialize( testSuiteElements );
		}

		public function testRunFinished( result:Result ):void
		{
			resultsComponent.refresh();
		}

		public function testStarted( description:IDescription ):void
		{
			currentTest = findElementByDescription( description );
			currentTest.addLogMessage( "--- Starting test: " + currentTest.readableName + " ---" );
		}

		public function testFinished( description:IDescription ):void
		{
			if (currentTest.passed)
			{
				statisticsComponent.testPassed();
			}
			else
			{
				statisticsComponent.testFailed();
			}
			currentTest.executed = true;
			currentTest.addLogMessage( "--- Test finished: " + currentTest.passed.toString().toUpperCase() + " ---" );
			resultsComponent.refresh();
		}

		public function testFailure( failure:Failure ):void
		{
			currentTest.passed = false;
			currentTest.failure = failure;
		}

		public function testAssumptionFailure( failure:Failure ):void
		{
		}

		public function testIgnored( description:IDescription ):void
		{
			currentTest = findElementByDescription( description );
			currentTest.ignored = true;
			currentTest.executed = true;
			currentTest.addLogMessage( "--- Ignoring: " + currentTest.readableName + " ---" )

			statisticsComponent.testIgnored();
			resultsComponent.refresh();
		}

		public function testTimed( description:IDescription, runTime:Number ):void
		{
			currentTest.executionTime = runTime;
		}

		public function log( message:String ):void
		{
			currentTest.addLogMessage( message );
		}

		private function getLowLevelTestSuites( description:IDescription, parentSuite:TestSuiteElement = null ):void
		{
			var suite:TestSuiteElement;

			if (description.isSuite)
			{
				suite = new TestSuiteElement( description.displayName );
				for each (var desc:IDescription in description.children)
				{
					getLowLevelTestSuites( desc, suite );
				}
			}
			else
			{
				parentSuite.addTestElement( new TestElement( description ) );
			}
			if (suite && !suite.isEmpty)
			{
				testSuiteElements.push( suite );
			}
		}

		private function findElementByDescription( description:IDescription ):TestElement
		{
			var element:TestElement;
			for each (var suiteElement:TestSuiteElement in testSuiteElements)
			{
				element = suiteElement.getTestElement( description );
				if (element)
				{
					return element;
				}
			}
			return null;
		}

		public function get ready():Boolean
		{
			return _ready;
		}

	}
}
