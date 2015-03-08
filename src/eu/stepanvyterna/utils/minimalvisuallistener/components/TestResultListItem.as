/**
 * Created by Steve on 7.3.2015.
 */
package eu.stepanvyterna.utils.minimalvisuallistener.components
{
	import com.bit101.components.Component;
	import com.bit101.components.HBox;
	import com.bit101.components.IndicatorLight;
	import com.bit101.components.Label;
	import com.bit101.components.ListItem;

	import eu.stepanvyterna.utils.minimalvisuallistener.data.TestElement;

	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;

	public class TestResultListItem extends ListItem
	{

		private var passedLight:IndicatorLight;
		private var label:Label;

		public function TestResultListItem( parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, data:Object = null )
		{
			super( parent, xpos, ypos, data );
		}


		override protected function addChildren():void
		{
			var layout:HBox = new HBox( this );
			layout.height = height;
			layout.width = width;
			layout.alignment = HBox.MIDDLE;

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
						passedLight.color = TestResultsComponent.COLOR_IGNORE;
					}
					else if ( testElement.passed )
					{
						passedLight.color = TestResultsComponent.COLOR_PASS;
					}
					else
					{
						passedLight.color = TestResultsComponent.COLOR_FAIL;
					}
				}
				passedLight.isLit = true;
				passedLight.draw();
				label.text = testElement.readableName;
			}
		}
	}
}
