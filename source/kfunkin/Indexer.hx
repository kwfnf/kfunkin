package kfunkin;

/**
 * This class is the indexer, the indexer should be able to index charts and cache them in a database.
 */
import kfunkin.modding.ClassRegistry;
import kfunkin.formats.data.ChartFormat;
import haxe.Unserializer;
import sys.io.File;
import haxe.Serializer;
import kfunkin.formats.data.ChartMetadata;
import kawaii.util.HiResTime;
import sys.thread.Thread;
import sys.FileSystem;
import haxe.io.Path;
import kfunkin.formats.BaseFormat;

class Indexer {
	private static var formats:Array<BaseFormat> = [];
	private static var paths:Array<String> = [];

	public static var charts:Array<ChartMetadata> = [];
	public static var indexedPaths:Array<String> = [];

	public static var currentlyIndexing:Bool = false;
	public static var totalDirectories:Int = 0;
	public static var indexedDirectories:Int = 0;

	/**
	 * Registers a format to the indexer.
	 * @param cl  The class of the format to register.
	 */
	public static function registerFormat(cl:Class<BaseFormat>):Void {
		formats.push(Type.createInstance(cl, []));
	}

	/**
	 * Adds a path to the indexer.
	 * @param path  The path to add.
	 */
	public static function registerPath(path:String):Void {
		if (!FileSystem.exists(path)) {
			trace('Attempted to index non-existant directory at "$path"');
			return;
		}
		paths.push(path);
	}

	/**
	 * Adds a local path to the indexer.
	 * @param path  The path to add.
	 */
	public static function registerLocalPath(path:String):Void {
		var root = Path.directory(Sys.programPath());
		var path = Path.join([root, path]);

		registerPath(path);
	}

	/**
	 * Adds a local path to the indexer (and creates the path if it doesn't exist).
	 * @param path  The path to add.
	 */
	public static function registerAndAssertLocalPath(path:String):Void {
		var root = Path.directory(Sys.programPath());
		var path = Path.join([root, path]);
		if (!FileSystem.exists(path)) FileSystem.createDirectory(path);

		registerPath(path);
	}

	/**
	 * Starts the indexer in the background.
	 */
	public static function startBackgroundTask() {
		if (currentlyIndexing) return trace('Indexer is already indexing, operation aborted.');
		Thread.create(indexNow);
	}

	/**
	 * Indexes all the paths.
	 */
	public static function indexNow() {
		if (currentlyIndexing) return trace('Indexer is already indexing, operation aborted.');

		// Set defaults
		currentlyIndexing = true;
		totalDirectories = 0;
		indexedDirectories = 0;

		// Load from cache
		var gameDir = Path.directory(Sys.programPath());
		var cachePath = Path.join([gameDir, 'ChartCache.dat']);
		if (FileSystem.exists(cachePath)) {
			var serialized = File.getContent(cachePath);
			var data = Unserializer.run(serialized);
			charts = data.c;
			indexedPaths = data.p;
		}

		// Get all directories for indexing
		var directories = [];
		for (path in paths) {
			var subPaths = FileSystem.readDirectory(path);
			trace('Path "$path" contains ${subPaths.length} entries.');
			for (subPath in subPaths) {
				directories.push(Path.join([path, subPath]));
			}
		}

		totalDirectories = directories.length;
		trace('Indexing $totalDirectories directories, from ${paths.length} paths.');

		// Go thru them
		for (dir in directories) {
			if (indexedPaths.indexOf(dir) != -1) {
				indexedDirectories++;
				continue;
			}

			trace('${indexedDirectories + 1}/$totalDirectories: Indexing "$dir"...');
			indexDirectory(Path.join([dir, '']));
			indexedPaths.push(dir);
			indexedDirectories++;
		}

		currentlyIndexing = false;
		trace('Indexing complete, indexed ${charts.length} charts.');

		var serialized = Serializer.run({c: charts, p: indexedPaths});
		var gameDir = Path.directory(Sys.programPath());
		File.saveContent(Path.join([gameDir, 'ChartCache.dat']), serialized);
	}

	/**
	 * Indexes a directory.
	 * @param path  The path to index.
	 */
	public static function indexDirectory(path:String) {
		if (!FileSystem.isDirectory(path)) return;

		var files = FileSystem.readDirectory(path);
		for (format in formats) {
			if (!format.identify(path, files)) continue;

			charts = charts.concat(format.metadata(path));
			break;
		}
	}

	/**
	 * Find a format based on the enum
	 * @param e The enum to load the format from
	 */
	public static function loadFormatFromEnum(e: ChartFormat) {
		for (format in formats) {
			if (format.format == e) return format;
		}
		return null;
	}

	/**
	 * Loads a chart from metadata.
	 * @param meta The metadata to load from.
	 */
	public static function loadFromMetadata(meta: ChartMetadata) : Chart {
		var format = loadFormatFromEnum(meta.format);
		if (format == null) return null;

		var chart = ClassRegistry.createInstance(Chart);

		var status = format.read(chart, meta);
		if (status == false) return null;

		return chart;
	}

	/**
	 * Clears all registered formats and paths.
	 */
	public static function clear() {
		formats = [];
		paths = [];
	}
}
