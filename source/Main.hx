import kawaii.rendering.RendererBackend;
import kawaii.input.InputKey;
import kfunkin.modding.ModLoader;
import kfunkin.Indexer;
import kfunkin.formats.fnf.FnfFormat;
import kfunkin.formats.osu.OsuFormat;
import kawaii.ApplicationConfig;
import kawaii.Application;
import sys.FileSystem;
import haxe.io.Path;

/**
 * This is the entrypoint, please keep it as minimal as possible.
 */
class Main {
	public static var app:Application;

	public static function main() {
		// Configure application
		var config = new ApplicationConfig();
		config.setTitle("Kawaii Funkin'");
		config.update(update);
		config.resizeable();
		config.renderer(RendererBackend.DX11);
		config.vsync();
		//config.fixedFps(960);

		// Create application
		app = new Application(config);

		// Load mods
		ModLoader.init();

		// Load song select menu
		app.scenes.setCurrentScene("SongSelect");

		// Start application
		app.run();
	}

	public static function update(dt:Float) {
		if (app.input.isKeyPressed(InputKey.F5)) {
			trace('Reloading!');
			ModLoader.loadAll();
			app.scenes.setCurrentScene("SongSelect");
		}
	}
}
