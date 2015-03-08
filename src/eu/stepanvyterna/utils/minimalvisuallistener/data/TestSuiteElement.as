/**
 * TestSuiteElement.as
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

package eu.stepanvyterna.utils.minimalvisuallistener.data
{
	import org.flexunit.runner.IDescription;

	public class TestSuiteElement
	{
		private var _testElements:Vector.<TestElement>;
		private var _name:String;
		private var _dirty:Boolean = true;

		public function TestSuiteElement( name:String )
		{
			_name = name;
			_testElements = new Vector.<TestElement>();
		}

		public function addTestElement( test:TestElement ):void
		{
			_testElements.push( test );
			test.suite = this;
		}

		public function getStats():TestSuiteElementStats
		{
			var stats:TestSuiteElementStats = new TestSuiteElementStats();
			for ( var i:int = 0; i < _testElements.length; i++ )
			{
				var element:TestElement = _testElements[ i ];
				if ( element.executed )
				{
					if ( element.ignored )
					{
						stats.ignored++;
					}
					else
					{
						if ( element.passed )
						{
							stats.passed++;
						}
						else
						{
							stats.failed++;
						}
					}
				}
			}
			stats.total = _testElements.length;
			return stats;
		}

		public function get name():String
		{
			return _name;
		}

		public function get isEmpty():Boolean
		{
			return (_testElements.length == 0);
		}

		public function getTestElement( description:IDescription ):TestElement
		{
			for each ( var element:TestElement in _testElements )
			{
				if ( element.name == description.displayName )
				{
					return element;
				}
			}
			return null;
		}

		public function get dirty():Boolean
		{
			return _dirty;
		}

		public function set dirty( value:Boolean ):void
		{
			_dirty = value;
		}

		public function get testElements():Vector.<TestElement>
		{
			return _testElements;
		}
	}
}
