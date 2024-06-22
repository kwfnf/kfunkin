package kfunkin.formats.fnf;

import kfunkin.formats.data.ChartMetadata;

/**
 * This is the format for Legacy and Current (V-Slice) charts.
 */
class FnfFormat extends BaseFormat {
	
	/**
	 * Empty constructor.
	 */
	public function new() {}

	/**
	 * This method should be implemented by the derived class. It should return a boolean value indicating if the format is supported by the derived class.
	 * @param folderPath The path to the folder containing the files to be identified.
	 * @param files The list of files to be identified.
	 * @return A boolean value indicating if the format is supported by the derived class.
	 */
	override public function identify(folderPath:String, files:Array<String>):Bool {
		return false;
	}

	/**
	 * This method should be implemented by the derived class. It should return the metadata of all difficulty levels of the song.
	 * @param folderPath The path to the folder containing the files to be identified.
	 */
	override public function metadata(folderPath:String):Array<ChartMetadata> {
		return [];
	}

	/**
	 * This method should be implemented by the derived class. It should populate a chart object with the data from the file.  
	 * @param chart The chart object to be populated.
	 * @param meta The metadata of the chart.
	 * @return A boolean value indicating if the chart was successfully loaded or not.
	 */
	override public function read(chart:Chart, meta:ChartMetadata):Bool {
		return false;
	}
}
