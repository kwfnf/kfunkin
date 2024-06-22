package kfunkin.modding;

import kfunkin.formats.osu.OsuFormat;
import kfunkin.formats.fnf.FnfFormat;
import kawaii.objects.Scene;
import kawaii.Application;
import sys.FileSystem;
import haxe.io.Path;

/**
 * This class is used to load mods into the game.
 */
class ModLoader {
	public static var mods:Array<Mod> = [];

	/**
	 * Registers a mod with the mod loader.
	 * @param mod The mod to register.
	 */
	public static function registerMod(mod:Mod) {
		trace('Mod registered ${mod.data.name} by ${mod.data.author}');
		mods.push(mod);
	}

	/**
	 * Load mods from the mods folder.
	 */
	public static function loadAllMods() {
		#if !scriptable
		trace('"-Dscriptable" is not defined, mods will not be loaded.');
		return;
		#end

		var root = Path.directory(Sys.programPath());
		var modsFolder = Path.join([root, "mods"]);
		if (!FileSystem.exists(modsFolder)) FileSystem.createDirectory(modsFolder);

		var modFiles = FileSystem.readDirectory(modsFolder);
		for (modFile in modFiles) {
			if (StringTools.endsWith(modFile, ".cppia")) loadMod(Path.join([root, "mods", modFile]));
		}
	}

	/**
	 * Load a mod from a file.
	 * @param path The path to the mod file.
	 */
	public static function loadMod(path:String) {
		#if scriptable
		trace('Loading mod from "$path"');
		cpp.cppia.Host.runFile(path);
		#end
	}

	/**
	 * Initialize the mod manager
	 */
	public static function init() {
		// Load all scenes into the registry
		for (scene in CompileTime.getAllClasses('kfunkin')) {
			ClassRegistry.createRegistry(scene);
		}

		// Log everything we have in the registry
		for (item in ClassRegistry.getRegistries()) {
			trace('Registry class ${Type.getClassName(item.getClass())}');
		}

		loadAll();
	}

	/**
	 * Reloads all mods
	 */
	public static function loadAll() {
		// Load into an empty scene to ensure resources get disposed
		var app = Application.getInstance();
		app.scenes.dispose();

		// Clear all mods and reset the class registry
		mods = [];
		ClassRegistry.resetClasses();
		Indexer.clear();

		// Load all mods
		loadAllMods();

		// Re-create scenes
		for (scene in CompileTime.getAllClasses('kfunkin.scenes')) {
			var className = Type.getClassName(scene).split('.').pop();
			var sceneName = className.split('Scene')[0];
			app.scenes.addScene(sceneName, ClassRegistry.getRegistryByClassType(scene).createInstance());
			trace('Scene created ${sceneName}');
		}

		// Re-load the formats
		Indexer.registerFormat(OsuFormat);
		Indexer.registerFormat(FnfFormat);
		Indexer.registerAndAssertLocalPath('charts');

		// If possible, locate an osu! installation and add its songs folder to the indexer
		var appdataLocal = Sys.getEnv('LOCALAPPDATA');
		var osuFolder = Path.join([appdataLocal, 'osu!', 'Songs']);
		if (FileSystem.exists(osuFolder)) {
			trace('Found osu! songs folder at "$osuFolder", it will be indexed.');
			Indexer.registerPath(osuFolder);
		}

		// Start background task(s)
		Indexer.startBackgroundTask();
	}
}
