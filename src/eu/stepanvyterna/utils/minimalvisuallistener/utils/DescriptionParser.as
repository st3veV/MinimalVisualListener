/**
 * Created by Steve on 7.3.2015.
 */
package eu.stepanvyterna.utils.minimalvisuallistener.utils
{
	import flex.lang.reflect.metadata.MetaDataAnnotation;

	import org.flexunit.runner.IDescription;

	public class DescriptionParser
	{
		public function DescriptionParser()
		{
		}

		public static function getTestName( description:IDescription ):String
		{
			var metadata:Array = description.getAllMetadata();
			for each ( var annotation:MetaDataAnnotation in metadata )
			{
				if ( annotation.hasArgument( "description" ) )
				{
					return annotation.getArgument( "description" ).value;
				}
			}
			return description.displayName;
		}
	}
}
