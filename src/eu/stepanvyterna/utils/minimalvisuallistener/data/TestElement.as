/**
 * TestElement.as
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
	import eu.stepanvyterna.utils.minimalvisuallistener.utils.DescriptionParser;

	import org.flexunit.runner.IDescription;
	import org.flexunit.runner.notification.Failure;

	public class TestElement
	{
		private const LOG_LINE_SEPARATOR:String = "\n";

		private var _description:IDescription;
		private var _passed:Boolean = true;
		private var _ignored:Boolean = false;
		private var _executed:Boolean = false;
		private var _parentSuite:TestSuiteElement;
		private var _failure:Failure;
		private var _log:String;

		public function TestElement( description:IDescription )
		{
			_description = description;
		}

		public function get name():String
		{
			return _description.displayName;
		}

		public function get readableName():String
		{
			var s:String = DescriptionParser.getTestName( _description );
			return _description.displayName + ((s == _description.displayName) ? "" : " ( " + s + " )");
		}

		public function get passed():Boolean
		{
			return _passed;
		}

		public function set passed( value:Boolean ):void
		{
			_passed = value;
		}

		public function get ignored():Boolean
		{
			return _ignored;
		}

		public function set ignored( value:Boolean ):void
		{
			_ignored = value;
		}

		public function get executed():Boolean
		{
			return _executed;
		}

		public function set executed( value:Boolean ):void
		{
			_executed = value;
			_parentSuite.dirty = true;
		}

		public function set parentSuite( suite:TestSuiteElement ):void
		{
			_parentSuite = suite;
		}

		public function get failure():Failure
		{
			return _failure;
		}

		public function set failure( value:Failure ):void
		{
			_failure = value;
		}

		public function addLogMessage( message:String ):void
		{
			if ( !_log )
			{
				_log = message;
			}
			else
			{
				_log += LOG_LINE_SEPARATOR + message;
			}
		}

		public function get log():String
		{
			return _log;
		}
	}
}
