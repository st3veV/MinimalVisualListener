/**
 * Created by Steve on 7.3.2015.
 */
package eu.stepanvyterna.utils.minimalvisuallistener.data
{
	public class TestSuiteElementStats
	{
		public var total:int = 0;
		public var passed:int = 0;
		public var failed:int = 0;
		public var ignored:int = 0;

		public function toString():String
		{
			return passed + ":" + ignored + ":" + failed + "/" + total
		}
	}
}
