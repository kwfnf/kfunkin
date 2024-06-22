package kfunkin.formats.osu;

import kfunkin.formats.data.ChartEventType;
import kfunkin.formats.data.ChartFormat;
import haxe.io.Path;
import sys.FileSystem;
import kfunkin.formats.data.ChartMetadata;

/**
 * This is the format for osu beatmap files (.osu), specifically for 4-key mania maps.
 */
class OsuFormat extends BaseFormat {
	/**
	 * Empty constructor.
	 */
	public function new() {
		format = ChartFormat.OSU;
	}

	/**
	 * This method should be implemented by the derived class. It should return a boolean value indicating if the format is supported by the derived class.
	 * @param folderPath The path to the folder containing the files to be identified.
	 * @param files The list of files to be identified.
	 * @return A boolean value indicating if the format is supported by the derived class.
	 */
	override public function identify(folderPath:String, files:Array<String>):Bool {
		for (file in files) {
			if (file.indexOf(".osu") != -1) return true;
		}
		return false;
	}

	/**
	 * This method should be implemented by the derived class. It should return the metadata of all difficulty levels of the song.
	 * @param folderPath The path to the folder containing the files to be identified.
	 */
	override public function metadata(folderPath:String):Array<ChartMetadata> {
		var files = FileSystem.readDirectory(folderPath);
		var difficulties = files.filter((f) -> f.indexOf(".osu") != -1);

		var metas = [];
		for (difficulty in difficulties) {
			var chart = parseOsuFile(Path.join([folderPath, difficulty]));
			if (chart == null) continue;

			metas.push(chart);
		}

		return metas;
	}

	/**
	 * Parses an osu file and returns the metadata of the chart.
	 */
	public function parseOsuFile(file:String):ChartMetadata {
		var reader = new OsuBeatmapReader();
		reader.parse(file, true);

		if (reader.General.get("Mode") != 3) return null;
		if (reader.Difficulty.get("CircleSize") != 4) return null;

		var meta:ChartMetadata = {
			songName: reader.Metadata.get("Title"),
			songAuthor: reader.Metadata.get("Artist"),
			difficultyName: reader.Metadata.get("Version"),
			mapperName: reader.Metadata.get("Creator"),
			format: ChartFormat.OSU,
			path: file,
		}

		return meta;
	}

	/**
	 * This method should be implemented by the derived class. It should populate a chart object with the data from the file.  
	 * @param chart The chart object to be populated.
	 * @param meta The metadata of the chart.
	 * @return A boolean value indicating if the chart was successfully loaded or not.
	 */
	override public function read(chart:Chart, meta:ChartMetadata):Bool {
		// Get info
		var path = meta.path;
		var dir = Path.directory(path);

		// Read
		var reader = new OsuBeatmapReader();
		reader.parse(meta.path, false);

		// Load audio
		var audioName = reader.General.get("AudioFilename");
		var audioPath = Path.join([dir, audioName]);
		chart.registerAudioPath(AudioBankType.AUDIO, audioPath);

		// Populate notes
		for (object in reader.HitObjects) {
			var lane = Std.int((object.x * 4) / 512);

			if ((object.type & 1 << 0) != 0) chart.addSingleNote(object.time, lane, false);
			if ((object.type & 1 << 7) != 0) chart.addSustainNote(object.time, lane, false, object.endTime - object.time);
		}

		// Add timing points
		for (object in reader.TimingPoints) {
			if (!object.uninherited) continue;
			chart.addEvent(object.time, ChartEventType.TIMING_POINT, (1000 / object.msPerBeat) * 60);
		}

		return true;
	}
}
