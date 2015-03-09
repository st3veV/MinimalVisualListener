/**
 * TestResultListItem.as
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
	import com.bit101.components.Component;
	import com.bit101.components.HBox;
	import com.bit101.components.IndicatorLight;
	import com.bit101.components.Label;
	import com.bit101.components.ListItem;

	import eu.stepanvyterna.utils.minimalvisuallistener.data.TestElement;
	import eu.stepanvyterna.utils.minimalvisuallistener.settings.Theme;

	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;

	public class TestResultListItem extends ListItem
	{
		private static const LIST_SCROLLBAR_WIDTH:Number = 10;

		private var passedLight:IndicatorLight;
		private var label:Label;
		private var layout:HBox;
		private var failLabel:Label;
		private var executionTime:Label;

		public function TestResultListItem( parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, data:Object = null )
		{
			super( parent, xpos, ypos, data );
		}


		override protected function addChildren():void
		{
			layout = new HBox( this );
			layout.height = height;
			layout.width = width;
			layout.alignment = HBox.MIDDLE;
			layout.mouseChildren = false;
			layout.mouseEnabled = false;

			var blocker:Shape = new Shape();
			blocker.graphics.beginFill( 0, 0 );
			blocker.graphics.drawRect( 0, 0, 5, 5 );
			blocker.graphics.endFill();
			layout.addChild( blocker );
			passedLight = new IndicatorLight( layout, 0, 0 );
			label = new Label( layout );

			layout.draw();
		}

		override public function draw():void
		{
//			super.draw();
			dispatchEvent( new Event( Component.DRAW ) );

			graphics.clear();

			if ( _selected )
			{
				graphics.beginFill( _selectedColor );
			}
			else if ( _mouseOver )
			{
				graphics.beginFill( _rolloverColor );
			}
			else
			{
				graphics.beginFill( _defaultColor );
			}
			graphics.drawRect( 0, 0, width, height );
			graphics.endFill();

			if ( !_data )
			{
				return;
			}

			var testElement:TestElement = _data as TestElement;
			if ( testElement )
			{
				if ( !testElement.executed )
				{
					passedLight.color = 0x666666;
				}
				else
				{
					if ( testElement.ignored )
					{
						passedLight.color = Theme.COLOR_IGNORE;
					}
					else if ( testElement.passed )
					{
						passedLight.color = Theme.COLOR_PASS;
					}
					else
					{
						passedLight.color = Theme.COLOR_FAIL;
					}
				}
				passedLight.isLit = true;
				passedLight.draw();
				label.text = testElement.readableName;
				if ( !testElement.passed && testElement.failure )
				{
					if ( !failLabel )
					{
						failLabel = new Label( layout, 0, 0, testElement.failure.message );
						failLabel.textField.multiline = false;
						failLabel.textField.textColor = Theme.COLOR_FAIL;
					}
				}
				if ( testElement.executed && !executionTime )
				{
					executionTime = new Label( this, 0, 0, String( testElement.executionTime ) );
					executionTime.draw();
					executionTime.move( width - executionTime.width - LIST_SCROLLBAR_WIDTH, (height - executionTime.height) * .5 );
				}
			}
		}
	}
}
