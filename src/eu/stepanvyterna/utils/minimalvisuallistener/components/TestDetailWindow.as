/**
 * TestDetailWindow.as
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
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;

	import eu.stepanvyterna.utils.minimalvisuallistener.data.TestElement;

	import eu.stepanvyterna.utils.minimalvisuallistener.settings.Theme;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	import org.flexunit.runner.notification.Failure;

	public class TestDetailWindow extends Window
	{
		private static const VIEW_FAIL_DETAILS:String = "fail_details";
		private static const VIEW_LOG:String = "log";

		private var _text:TextArea;
		private var _failDetailHeader:Label;
		private var _subviewSelection:HBox;
		private var _subviewLayout:VBox;
		private var _element:TestElement;
		private var _currentView:String = VIEW_FAIL_DETAILS;
		private var _selectLogButton:PushButton;
		private var _selectFailButton:PushButton;

		public function TestDetailWindow( parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, title:String = "" )
		{
			super( parent, xpos, ypos, title );

			this.hasCloseButton = true;
			this.draggable = true;
		}


		override protected function addChildren():void
		{
			super.addChildren();

			var mainLayout:VBox = new VBox( this );
			mainLayout.alignment = VBox.CENTER;

			_subviewSelection = new HBox( mainLayout );

			_subviewLayout = new VBox( mainLayout );
			_failDetailHeader = new Label( _subviewLayout, 0, 0, "" );
			_failDetailHeader.textField.textColor = Theme.COLOR_FAIL;
			_text = new TextArea( _subviewLayout, 0, 0, "" );
			_text.selectable = true;
			_text.editable = false;
		}

		override public function draw():void
		{
			super.draw();
			_subviewSelection.draw();

			if ( _subviewSelection.numChildren > 0 )
			{
				_selectLogButton.selected = _currentView == VIEW_LOG;
				_selectFailButton.selected = _currentView == VIEW_FAIL_DETAILS;
			}

			switch ( _currentView )
			{
				case VIEW_FAIL_DETAILS:
				{
					if ( !_failDetailHeader.parent )
					{
						_subviewLayout.addChildAt( _failDetailHeader, 0 );
					}
					_subviewLayout.draw();
					_failDetailHeader.width = width;
					break;
				}
				case VIEW_LOG:
				{
					if ( _failDetailHeader.parent )
					{
						_failDetailHeader.parent.removeChild( _failDetailHeader );
					}
					_subviewLayout.draw();
					break;
				}
			}
			_subviewLayout.draw();

			_text.setSize( width,
			               height - titleBar.height - _text.y - _subviewSelection.height - _subviewSelection.spacing
			);
			_text.draw();
		}

		public function setTestElement( element:TestElement ):void
		{
			_element = element;
			if ( _element.failure && !_element.ignored )
			{
				_selectFailButton = new PushButton( _subviewSelection, 0, 0, "Fail Details", onShowFailDetails );
				_selectFailButton.toggle = true;
				_selectFailButton.selected = true;

				_selectLogButton = new PushButton( _subviewSelection, 0, 0, "Log", onShowLog );
				_selectLogButton.toggle = true;
				_selectLogButton.selected = false;

				_failDetailHeader.text = _element.failure.message;
				_text.text = _element.failure.stackTrace;

				_currentView = VIEW_FAIL_DETAILS;
			}

			if ( !_text.text && _element.log )
			{
				_text.text = _element.log;

				_currentView = VIEW_LOG;
			}
			invalidate();
		}

		private function onShowLog( event:MouseEvent ):void
		{
			_currentView = VIEW_LOG;
			_text.text = _element.log;
			invalidate();
		}

		private function onShowFailDetails( event:MouseEvent ):void
		{
			_currentView = VIEW_FAIL_DETAILS;
			_text.text = _element.failure.stackTrace;
			invalidate();
		}

		override protected function onClose( event:MouseEvent ):void
		{
			super.onClose( event );
			parent.removeChild( this );
		}
	}
}
