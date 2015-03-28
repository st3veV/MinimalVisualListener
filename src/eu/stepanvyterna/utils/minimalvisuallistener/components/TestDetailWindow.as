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

	public class TestDetailWindow extends Window
	{
		private static const VIEW_FAIL_DETAILS:String = "fail_details";
		private static const VIEW_LOG:String = "log";

		private var mainTextArea:TextArea;
		private var failDetailHeader:Label;
		private var subviewSelection:HBox;
		private var subviewLayout:VBox;
		private var element:TestElement;
		private var currentView:String = VIEW_FAIL_DETAILS;
		private var selectLogButton:PushButton;
		private var selectFailButton:PushButton;

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

			subviewSelection = new HBox( mainLayout );

			subviewLayout = new VBox( mainLayout );
			failDetailHeader = new Label( subviewLayout, 0, 0, "" );
			failDetailHeader.textField.textColor = Theme.COLOR_FAIL;
			mainTextArea = new TextArea( subviewLayout, 0, 0, "" );
			mainTextArea.selectable = true;
			mainTextArea.editable = false;
		}

		override public function draw():void
		{
			super.draw();
			subviewSelection.draw();

			if (subviewSelection.numChildren > 0)
			{
				selectLogButton.selected = currentView == VIEW_LOG;
				selectFailButton.selected = currentView == VIEW_FAIL_DETAILS;
			}

			switch ( currentView )
			{
				case VIEW_FAIL_DETAILS:
				{
					if (!failDetailHeader.parent)
					{
						subviewLayout.addChildAt( failDetailHeader, 0 );
					}
					subviewLayout.draw();
					failDetailHeader.width = width;
					break;
				}
				case VIEW_LOG:
				{
					if (failDetailHeader.parent)
					{
						failDetailHeader.parent.removeChild( failDetailHeader );
					}
					subviewLayout.draw();
					break;
				}
			}
			subviewLayout.draw();

			mainTextArea.setSize( width, height - titleBar.height - mainTextArea.y - subviewSelection.height - subviewSelection.spacing );
			mainTextArea.draw();
		}

		public function setTestElement( element:TestElement ):void
		{
			this.element = element;
			if (element.failure && !element.ignored)
			{
				selectFailButton = new PushButton( subviewSelection, 0, 0, "Fail Details", onShowFailDetails );
				selectFailButton.toggle = true;
				selectFailButton.selected = true;

				selectLogButton = new PushButton( subviewSelection, 0, 0, "Log", onShowLog );
				selectLogButton.toggle = true;
				selectLogButton.selected = false;

				failDetailHeader.text = element.failure.message.split( "\n" ).join( " " );
				failDetailHeader.textField.multiline = false;
				mainTextArea.text = element.failure.stackTrace;

				currentView = VIEW_FAIL_DETAILS;
			}

			if (!mainTextArea.text && element.log)
			{
				mainTextArea.text = element.log;

				currentView = VIEW_LOG;
			}
			invalidate();
		}

		private function onShowLog( event:MouseEvent ):void
		{
			currentView = VIEW_LOG;
			mainTextArea.text = element.log;
			invalidate();
		}

		private function onShowFailDetails( event:MouseEvent ):void
		{
			currentView = VIEW_FAIL_DETAILS;
			mainTextArea.text = element.failure.stackTrace;
			invalidate();
		}

		override protected function onClose( event:MouseEvent ):void
		{
			super.onClose( event );
			parent.removeChild( this );
		}
	}
}
