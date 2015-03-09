/**
 * TestResultsComponent.as
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
	import com.bit101.components.Accordion;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.Panel;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.Style;
	import com.bit101.components.Window;

	import eu.stepanvyterna.utils.minimalvisuallistener.data.TestElement;
	import eu.stepanvyterna.utils.minimalvisuallistener.data.TestSuiteElement;
	import eu.stepanvyterna.utils.minimalvisuallistener.data.TestSuiteElementStats;
	import eu.stepanvyterna.utils.minimalvisuallistener.events.TestElementSelectionEvent;
	import eu.stepanvyterna.utils.minimalvisuallistener.settings.Theme;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	[Event(name="test_element_selected", type="eu.stepanvyterna.utils.minimalvisuallistener.events.TestElementSelectionEvent")]
	public class TestResultsComponent extends ScrollPane
	{

		private static const LABEL_NAME:String = "label";
		private static const STATS_NAME:String = "stats";
		private static const SCROLLBAR_WIDTH:Number = 10;
		private static const SCROLLBAR_HEIGHT:Number = 10;
		private static const WINDOW_HEADER_HEIGHT:Number = 20;
		private static const HEADER_STATS_RIGHT_OFFSET:Number = 5;
		private static const MIN_WINDOW_HEIGHT:Number = 50;

		private var passTextFormat:TextFormat = new TextFormat( Style.fontName, Style.fontSize, Theme.COLOR_PASS, true
		);   //Green text
		private var ignoreTextFormat:TextFormat = new TextFormat( Style.fontName, Style.fontSize, Theme.COLOR_IGNORE,
		                                                          true
		); //Orange text
		private var failTextFormat:TextFormat = new TextFormat( Style.fontName, Style.fontSize, Theme.COLOR_FAIL, true
		);   //Red text

		private var tests:Accordion;
		private var _testSuites:Vector.<TestSuiteElement>;
		private var lists:Vector.<List> = new Vector.<List>();


		public function TestResultsComponent( parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0 )
		{
			super( parent, xpos, ypos );
			init();
		}

		private function init():void
		{
			tests = new Accordion( this.content );
			tests.setSize( width - SCROLLBAR_WIDTH, height - SCROLLBAR_HEIGHT );
			tests.draw();
		}

		override public function setSize( w:Number, h:Number ):void
		{
			super.setSize( w, h );
			if ( tests )
			{
				tests.setSize( w - SCROLLBAR_WIDTH, h - SCROLLBAR_HEIGHT );
				tests.draw();
			}
		}

		public function initialize( testSuites:Vector.<TestSuiteElement> ):void
		{
			_testSuites = testSuites;

			var i:int;
			var win:Window;
			for ( i = 0; i < 2; i++ ) // replacing existing windows generated by Accordion
			{
				win = tests.getWindowAt( i );
				win.title = _testSuites[ i ].name;
				win.draw();
				adjustHeader( win.titleBar );
				generateTestContent( _testSuites[ i ], win );
			}
			for ( ; i < _testSuites.length; i++ )
			{
				tests.addWindow( _testSuites[ i ].name );
				win = tests.getWindowAt( i );
				win.draw();
				adjustHeader( win.titleBar );
				generateTestContent( _testSuites[ i ], win );
			}

			if ( _height - SCROLLBAR_HEIGHT < i * WINDOW_HEADER_HEIGHT + MIN_WINDOW_HEIGHT )
			{
				tests.height = i * WINDOW_HEADER_HEIGHT + MIN_WINDOW_HEIGHT;
				tests.width = width - SCROLLBAR_WIDTH;
			}
			else
			{
				tests.height = height;
				tests.width = width;
				this._vScrollbar.parent.removeChild( _vScrollbar );
			}
			this._hScrollbar.parent.removeChild( _hScrollbar );
			this._corner.parent.removeChild( _corner );

			for ( var j:int = 0; j < lists.length; j++ )
			{
				const list:List = lists[ j ];
				list.height = tests.height - i * WINDOW_HEADER_HEIGHT;
				list.width = tests.width;
				list.draw();
			}

			refresh();
		}

		private function generateTestContent( testSuiteElement:TestSuiteElement, window:Window ):void
		{
			var items:Array = [];
			for ( var i:int = 0; i < testSuiteElement.testElements.length; i++ )
			{
				var testElement:TestElement = testSuiteElement.testElements[ i ];
				items.push( testElement );
			}
			const list:List = new List( window, 0, 0, items );
			list.listItemClass = TestResultListItem;
			list.addEventListener( Event.SELECT, onListSelection );
			lists.push( list )
		}

		private function onListSelection( event:Event ):void
		{
			var list:List = List( event.target );
			var selectedItem:TestElement = list.selectedItem as TestElement;
			if ( selectedItem )
			{
				dispatchEvent( new TestElementSelectionEvent( TestElementSelectionEvent.TEST_ELEMENT_SELECTED,
				                                              selectedItem
				               )
				);
			}
			if ( list.selectedIndex != -1 )
			{
				list.selectedIndex = -1;
			}
		}


		public function refresh():void
		{
			draw();
			invalidate();
		}


		override public function draw():void
		{
			super.draw();

			if ( !_testSuites )
			{
				return;
			}

			this._mask.height = height;
			if ( this._vScrollbar.parent )
			{
				this._vScrollbar.height = height;
			}
			else
			{
				tests.width = width;
				this._mask.width = width;
			}

			tests.draw();


			var stats:TestSuiteElementStats;
			var win:Window;
			var suiteElement:TestSuiteElement;
			for ( var i:int = 0; i < _testSuites.length; i++ )
			{
				suiteElement = _testSuites[ i ];
				if ( suiteElement.dirty )
				{
					win = tests.getWindowAt( i );
					stats = suiteElement.getStats();
					win.titleBar.draw();
					adjustHeader( win.titleBar, stats );
					suiteElement.dirty = false;
					lists[ i ].draw();
				}
			}
		}

		private function adjustHeader( header:Panel, stats:TestSuiteElementStats = null ):void
		{
			var statsLabel:Label;
			var label:Label;
			if ( (label = header.content.getChildByName( LABEL_NAME ) as Label) != null )
			{
				statsLabel = header.content.getChildByName( STATS_NAME ) as Label;
			}
			else
			{
				var i:int = 0;
				while ( label == null )
				{
					label = header.content.getChildAt( i++ ) as Label;
				}
				label.name = LABEL_NAME;
				statsLabel = new Label( header.content, 0, 1, "0:0:0/0" );
				statsLabel.name = STATS_NAME;
				statsLabel.textField.x = tests.width - statsLabel.textField.width - HEADER_STATS_RIGHT_OFFSET;
			}
			if ( !stats )
			{
				return;
			}
			if ( stats.failed > 0 )
			{
				label.textField.textColor = Theme.COLOR_FAIL;
			}
			var txt:TextField = statsLabel.textField;
			statsLabel.text = stats.toString();
			statsLabel.draw();

			var fromIndex:int = 0;
			var toIndex:int = txt.text.indexOf( ":", fromIndex );
			txt.setTextFormat( passTextFormat, fromIndex, toIndex );
			fromIndex = toIndex + 1;
			toIndex = txt.text.indexOf( ":", fromIndex );
			txt.setTextFormat( ignoreTextFormat, fromIndex, toIndex );
			fromIndex = toIndex + 1;
			toIndex = txt.text.indexOf( "/", fromIndex );
			txt.setTextFormat( failTextFormat, fromIndex, toIndex );

			txt.x = tests.width - txt.width - HEADER_STATS_RIGHT_OFFSET;
		}
	}
}
