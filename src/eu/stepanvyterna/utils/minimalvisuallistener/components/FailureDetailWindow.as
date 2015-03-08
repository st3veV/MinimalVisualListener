/**
 * FailureDetailWindow.as
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
	import com.bit101.components.Label;
	import com.bit101.components.TextArea;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;

	import eu.stepanvyterna.utils.minimalvisuallistener.settings.Theme;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	import org.flexunit.runner.notification.Failure;

	public class FailureDetailWindow extends Window
	{
		private var text:TextArea;
		private var header:Label;

		public function FailureDetailWindow( parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, title:String = "" )
		{
			super( parent, xpos, ypos, title );

			this.hasCloseButton = true;
			this.draggable = true;
		}


		override protected function addChildren():void
		{
			super.addChildren();

			var layout:VBox = new VBox( this );
			header = new Label( layout, 0, 0, "" );
			header.textField.textColor = Theme.COLOR_FAIL;
			text = new TextArea( layout, 0, 0, "" );
			text.selectable = true;
			text.editable = false;
		}

		override public function draw():void
		{
			super.draw();
			header.width = width;
			text.setSize( width, height - titleBar.height - text.y );
		}

		public function setFailure( failure:Failure ):void
		{
			header.text = failure.message;
			text.text = failure.stackTrace;
			invalidate();
		}

		override protected function onClose( event:MouseEvent ):void
		{
			super.onClose( event );
			parent.removeChild( this );
		}
	}
}
