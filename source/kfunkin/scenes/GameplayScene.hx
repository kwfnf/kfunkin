package kfunkin.scenes;

import kawaii.resources.ResourceFont;
import kfunkin.modding.ClassRegistry;
import kfunkin.objects.Playfield;
import kfunkin.formats.data.ChartMetadata;
import kawaii.rendering.Context2D;
import kawaii.objects.Scene;

/**
 * The gameplay scene of the game.
 */
class GameplayScene extends Scene {

	public var chart: Chart;
	public var playfields: Array<Playfield> = [];

	private var font_regular:ResourceFont;
	private var font_bold:ResourceFont;

	/**
	 * Loads the scene.
	 * @param params The Chart metadata to load.
	 */
	override function load(params:Dynamic) {
		// Load chart
		var chartMetadata = cast (params, ChartMetadata);
		chart = Indexer.loadFromMetadata(chartMetadata);
		chart.load(app);

		// Add playfields
		createPlayfields(1);

		// Load fonts
		font_regular = app.resources.acquireFont('RedHatDisplayRegular.ttf');
		font_bold = app.resources.acquireFont('RedHatDisplayBlack.ttf');

		// Play audio
		chart.audioBank.playAllAudio();
		app.audio.soloud.setVolume(chart.audioBank.getAudio(AudioBankType.AUDIO).handle, .15);
	}

	/**
	 * Creates x amount of playfields.
	 * @param amount The amount of playfields to create.
	 */
	public function createPlayfields(amount: Int) {
		for (_ in 0...amount) playfields.push(ClassRegistry.createInstance(Playfield, [ chart ]));
	}

	/**
	 * Draws the scene.
	 * @param c The 2D context to draw to.
	 */
	override function draw(c:Context2D) {
		c.setColor(0x097CB6);
		c.fillRect(0, 0, app.window.getWidth(), app.window.getHeight());

		for (p in playfields) p.render(c);

		c.setColor(0xFFFFFF);
		c.setFont(font_bold);
		c.setFontSize(32);
		c.drawText("Kawaii Funkin", 10, 10);

		c.setFont(font_regular);
		c.setFontSize(16);
		var text = [
			'fps: ${app.fps}',
			'renderer: ${app.renderer.getRendererName()}'
		];

		for (judgementIndex in 0...Globals.JUDGEMENT_NAMES.length) text.push('${Globals.JUDGEMENT_NAMES[judgementIndex].toLowerCase()}: ${playfields[0].state.getJudgement(judgementIndex)}');
		
		for (i in 0...text.length) c.drawText(text[i], 10, 40 + (i * 20));
	}

	/**
	 * Updates the scene.
	 * @param dt The delta time.
	 */
	override function update(dt:Float) {
		// TODO: support multiple playfields
		var playfieldIndex = 0;
		for (p in playfields) {
			p.x = (app.window.getWidth() / 2) - (p.width / 2);
			playfieldIndex++;
			p.update(dt);
		}
	}

	/**
	 * Unloads the scene.
	 */
	override function unload() {
		chart.dispose();
		for (p in playfields) p.dispose();
	}

}
