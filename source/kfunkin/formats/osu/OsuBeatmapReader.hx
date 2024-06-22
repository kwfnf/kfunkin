package kfunkin.formats.osu;

import sys.io.File;
import sys.FileSystem;

using StringTools;

/**
 * Reader for osu! beatmaps (.osu)
 */
class OsuBeatmapReader {
	/**
	 * All the data from the beatmap file
	 */
	public var General:Map<String, Dynamic> = new Map();

	public var Metadata:Map<String, Dynamic> = new Map();
	public var Difficulty:Map<String, Dynamic> = new Map();
	
	public var TimingPoints:Array<{
		time:Float,
		msPerBeat:Float,
		meter:Int,
		sampleSet:Int,
		sampleIndex:Int,
		volume:Int,
		uninherited:Bool,
		kiaiMode:Bool
	}> = [];

	public var HitObjects:Array<{
		x:Int,
		y:Int,
		time:Int,
		type:Int,
		hitSound:Int,
		endTime:Int,
		extras:Map<String, Dynamic>
	}> = [];

	/**
	 * Empty constructor
	 */
	public function new() {}

	/**
	 * Parse the beatmap file
	 * @param path The path to the beatmap file
	 * @param minimal  If true, it will skip the Timing points and Hit objects sections
	 */
	public function parse(path:String, minimal:Bool = false) {
		if (!FileSystem.exists(path)) return;

		var content = File.getContent(path);
		var lines = content.split("\n");

		var section = "";

		for (line in lines) {
			line = line.trim();
			if (line == "") continue;

			if (line.charAt(0) == "[") {
				section = line;
				continue;
			}

			switch (section) {
				case "[General]":
					parseKeyValue(line, General);
				case "[Metadata]":
					parseKeyValue(line, Metadata);
				case "[Difficulty]":
					parseKeyValue(line, Difficulty);
				case "[TimingPoints]":
					if (!minimal) parseTimingPoint(line);
				case "[HitObjects]":
					if (!minimal) parseHitObject(line);
			}
		}
	}

	/**
	 * Parse a key-value line
	 * @param line Line to parse
	 * @param map Map to store the key-value pair
	 */
	private function parseKeyValue(line:String, map:Map<String, Dynamic>) {
		var parts = line.split(":");
		if (parts.length < 2) return;

		var key = parts[0].trim();
		var value = parts.slice(1).join(":").trim();
		map.set(key, castValue(value));
	}

	/**
	 * Cast a string value to a dynamic value
	 * @param value String value to cast
	 * @return The casted value
	 */
	private function castValue(value:String):Dynamic {
		if (value == "true") return true;
		if (value == "false") return false;

		var float = Std.parseFloat(value);
		if (!Math.isNaN(float)) return value;

		var int = Std.parseInt(value);
		if (int != null) return int;

		return value;
	}

	/**
	 * Parse a timing point line
	 * @param line Line to parse
	 */
	private function parseTimingPoint(line:String) {
		var parts = line.split(",");
		if (parts.length < 8) return;

		TimingPoints.push({
			time: Std.parseFloat(parts[0]),
			msPerBeat: Std.parseFloat(parts[1]),
			meter: Std.parseInt(parts[2]),
			sampleSet: Std.parseInt(parts[3]),
			sampleIndex: Std.parseInt(parts[4]),
			volume: Std.parseInt(parts[5]),
			uninherited: Std.parseInt(parts[6]) == 1,
			kiaiMode: Std.parseInt(parts[7]) == 1
		});
	}

	/**
	 * Parse a hit object line
	 * @param line Line to parse
	 */
	private function parseHitObject(line:String) {
		var parts = line.split(",");
		if (parts.length < 5) return;

		var extras:Map<String, Dynamic> = new Map();
		if (parts.length > 5) {
			var extraParts = parts[5].split(":");
			for (extraPart in extraParts) {
				var extra = extraPart.split(":");
				if (extra.length == 2) {
					extras.set(extra[0], castValue(extra[1]));
				}
			}
		}

		HitObjects.push({
			x: Std.parseInt(parts[0]),
			y: Std.parseInt(parts[1]),
			time: Std.parseInt(parts[2]),
			type: Std.parseInt(parts[3]),
			hitSound: Std.parseInt(parts[4]),
			endTime: parts.length > 5? Std.parseInt(parts[5]) : -1,
			extras: extras
		});
	}
}
