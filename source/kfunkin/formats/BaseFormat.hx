package kfunkin.formats;

import kfunkin.formats.data.ChartFormat;
import kfunkin.formats.data.ChartMetadata;

/**
 * This class is derivable by other classes that will implement the format of the data to be read or written.  
 * A format should convert any provided data into the format that  Kawaii Engine requires.
 */
class BaseFormat {

	public var format = ChartFormat.NONE;

	/**
	 * This method should be implemented by the derived class. It should return a boolean value indicating if the format is supported by the derived class.
	 * @param folderPath The path to the folder containing the files to be identified.
	 * @param files The list of files to be identified.
	 * @return A boolean value indicating if the format is supported by the derived class.
	 */
	public function identify(folderPath:String, files:Array<String>):Bool {
		return false;
	}

	/**
	 * This method should be implemented by the derived class. It should return the metadata of all difficulty levels of the song.
	 * @param folderPath The path to the folder containing the files to be identified.
	 */
	public function metadata(folderPath:String):Array<ChartMetadata> {
		return [];
	}

	/**
	 * This method should be implemented by the derived class. It should populate a chart object with the data from the file.  
	 * @param chart The chart object to be populated.
	 * @param meta The metadata of the chart.
	 * @return A boolean value indicating if the chart was successfully loaded or not.
	 */
	public function read(chart:Chart, meta:ChartMetadata):Bool {
		return false;
	}
}
