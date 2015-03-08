/**
 * Created by Steve on 7.3.2015.
 */
package eu.stepanvyterna.utils.minimalvisuallistener
{
	import com.bit101.components.Window;

	import eu.stepanvyterna.utils.minimalvisuallistener.components.StatisticsComponent;
	import eu.stepanvyterna.utils.minimalvisuallistener.components.TestResultsComponent;
	import eu.stepanvyterna.utils.minimalvisuallistener.data.TestElement;
	import eu.stepanvyterna.utils.minimalvisuallistener.data.TestSuiteElement;

	import flash.display.Sprite;
	import flash.events.Event;

	import org.flexunit.runner.IDescription;
	import org.flexunit.runner.Result;
	import org.flexunit.runner.notification.Failure;
	import org.flexunit.runner.notification.IAsyncRunListener;
	import org.flexunit.runner.notification.IAsyncStartupRunListener;
	import org.flexunit.runner.notification.async.AsyncListenerWatcher;

	public class MinimalVisualListener extends Sprite implements IAsyncRunListener, IAsyncStartupRunListener
	{
		private var _width:Number;
		private var _height:Number;
		private var container:Window;
		private var _statisticsComponent:StatisticsComponent;
		private var _resultsComponent:TestResultsComponent;

		private var currentTest:TestElement;
		private var _testSuiteElements:Vector.<TestSuiteElement> = new Vector.<TestSuiteElement>();
		private var _ready:Boolean = false;

		public function MinimalVisualListener( width:Number, height:Number )
		{
			_width = width;
			_height = height;

			if ( stage )
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

			_statisticsComponent = new StatisticsComponent( container.content );
			_statisticsComponent.setSize( _width * .3, _height - container.titleBar.height );

			_resultsComponent = new TestResultsComponent( container.content, _width * .3 );
			_resultsComponent.setSize( _width * .7, _height - container.titleBar.height );

			_ready = true;
			dispatchEvent( new Event( AsyncListenerWatcher.LISTENER_READY ) );
		}

		public function testRunStarted( description:IDescription ):void
		{
			_statisticsComponent.setTestCount( description.testCount );

			getLowLevelTestSuites( description );
			_resultsComponent.initialize( _testSuiteElements );
		}

		public function testRunFinished( result:Result ):void
		{
			_resultsComponent.refresh();
		}

		public function testStarted( description:IDescription ):void
		{
			currentTest = findElementByDescription( description );
		}

		public function testFinished( description:IDescription ):void
		{
			if ( currentTest.passed )
			{
				_statisticsComponent.testPassed();
			}
			else
			{
				_statisticsComponent.testFailed();
			}
			currentTest.executed = true;
			_resultsComponent.refresh();
		}

		public function testFailure( failure:Failure ):void
		{
			currentTest.passed = false;
		}

		public function testAssumptionFailure( failure:Failure ):void
		{
		}

		public function testIgnored( description:IDescription ):void
		{
			currentTest = findElementByDescription( description );
			currentTest.ignored = true;
			currentTest.executed = true;

			_statisticsComponent.testIgnored();
			_resultsComponent.refresh();
		}

		public function testTimed( description:IDescription, runTime:Number ):void
		{
			_statisticsComponent.testPassed();
		}

		private function getLowLevelTestSuites( description:IDescription, parentSuite:TestSuiteElement = null ):void
		{
			var suite:TestSuiteElement;

			if ( description.isSuite )
			{
				suite = new TestSuiteElement( description.displayName );
				for each ( var desc:IDescription in description.children )
				{
					getLowLevelTestSuites( desc, suite );
				}
			}
			else
			{
				parentSuite.addTestElement( new TestElement( description ) );
			}
			if ( suite && !suite.isEmpty )
			{
				_testSuiteElements.push( suite );
			}
		}

		private function findElementByDescription( description:IDescription ):TestElement
		{
			var element:TestElement;
			for each ( var suiteElement:TestSuiteElement in _testSuiteElements )
			{
				element = suiteElement.getTestElement( description );
				if ( element )
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
