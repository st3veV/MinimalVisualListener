/**
 * RobotlegsLogTarget.as
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

package eu.stepanvyterna.utils.minimalvisuallistener.logtargets
{
	import eu.stepanvyterna.utils.minimalvisuallistener.MinimalVisualListener;

	import robotlegs.bender.extensions.enhancedLogging.impl.LogMessageParser;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogTarget;
	import robotlegs.bender.framework.api.LogLevel;

	public class RobotlegsLogTarget implements ILogTarget
	{
		private var _messageParser:LogMessageParser = new LogMessageParser();
		private var _visualListener:MinimalVisualListener;
		private var _context:IContext;

		public function RobotlegsLogTarget( context:IContext, visualListener:MinimalVisualListener )
		{
			_visualListener = visualListener;
			_context = context;
		}

		public function log( source:Object, level:uint, timestamp:int, message:String, params:Array = null ):void
		{
			_visualListener.log(
					timestamp // (START + timestamp)
					+ ' ' + LogLevel.NAME[ level ]
					+ ' ' + _context
					+ ' ' + source
					+ ' ' + _messageParser.parseMessage( message, params )
			);
		}
	}
}
