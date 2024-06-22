package kfunkin.scenes;

import kfunkin.formats.data.ChartMetadata;
import kawaii.input.InputMouseButton;
import kawaii.resources.ResourceFont;
import kawaii.input.InputKey;
import kawaii.rendering.Context2D;
import kawaii.objects.Scene;

/**
 * The song select scene, where the player can select a song to play
 */
class SongSelectScene extends Scene {
	// config
	public var CARD_HEIGHT:Int = 84;
	public var CARD_PADDING:Int = 10;
	public var SCROLL_WIDTH:Int = 16;

	// vars
	private var scrollOffsetY:Float = 0.0;
	private var selectedSongIndex:Int = -1;
	private var targetScrollOffsetY:Float = 0.0;
	private var results(get, never): Array<ChartMetadata>;

	// resources
	private var font_regular:ResourceFont;
	private var font_bold:ResourceFont;

	// Search
	private var query: String = "";
	private var queryResults: Array<ChartMetadata> = [];

	/**
	 * Load the scene
	 */
	override function load(params:Dynamic) {
		font_regular = app.resources.acquireFont('RedHatDisplayRegular.ttf');
		font_bold = app.resources.acquireFont('RedHatDisplayBlack.ttf');
		reloadSearchResults();
	}

	/**
	 * Unload the scene
	 */
	override function unload() {
		font_regular.release();
		font_bold.release();
	}

	/**
	 * Draw the scene
	 * @param c  The 2D context to draw to
	 */
	override function draw(c:Context2D) {
		c.setColor(0x097CB6);
		c.fillRect(0, 0, app.window.getWidth(), app.window.getHeight());

		c.setColor(0x70000000);
		c.fillRect(0, 0, app.window.getWidth(), app.window.getHeight());

		c.setColor(0xFFFFFFFF);

		var min = getMinVisibleSongIndex();
		var max = getMaxVisibleSongIndex();

		var x = CARD_PADDING;
		var w = app.window.getWidth() - CARD_PADDING * 2 - SCROLL_WIDTH;

		drawScrollbar(c);

		for (i in min - 4...max + 4) {
			if (drawCard(c, i, x, w)) break; // context, index, x pos, width
		}

		if (query.length > 0) {
			drawSearchQuery(c);
		}
	}

	/**
	 * Draw the search query
	 * @param c The 2D context to draw to
	 */
	private function drawSearchQuery(c:Context2D) {
		c.setFont(font_regular);
		c.setColor(0x80000000);
		c.fillRoundRect(CARD_PADDING, CARD_PADDING, app.window.getWidth() - CARD_PADDING * 2 - SCROLL_WIDTH, 24, 10);
		c.setFontSize(16);
		c.setColor(0xFFFFFF);
		c.drawText('Search: ${query}', CARD_PADDING + 4, CARD_PADDING + 4);
	}

	/**
	 * Select a chart
	 * @param chart The chart to select
	 */
	private function selectChart(chart:ChartMetadata) {
		app.scenes.setCurrentScene('Gameplay', chart);
	}

	/**
	 * Draw a song card
	 * @param c The 2D context to draw to
	 * @param i The index of the chart
	 * @param x The X coordinate of the card
	 * @param w The width of the card
	 * @return True if the card was clicked
	 */
	private function drawCard(c:Context2D, i:Int, x:Float, w:Float):Bool {
		var chart = results[i];
		if (chart == null) return false;
	
		var y = getSongCardY(i);
		
		drawCardBackground(c, x, y, w);
		drawCardSelectionHighlight(c, i, x, y, w);
	
		c.pushClip(x + CARD_PADDING, y, w - CARD_PADDING * 2, CARD_HEIGHT);
		drawCardMainText(c, chart, x, y, w);
		drawCardAdditionalDetails(c, chart, x, y);
		c.popClip();
	
		return handleMouseInteraction(x, y, w, i);
	}
	
	/**
	 * Draw the background of a card
	 * @param c The 2D context to draw to
	 * @param x The X coordinate of the card
	 * @param y The Y coordinate of the card
	 * @param w The width of the card
	 */
	private function drawCardBackground(c:Context2D, x:Float, y:Float, w:Float):Void {
		c.setColor(0x80000000);
		c.fillRoundRect(x, y, w, CARD_HEIGHT, 10);
	}
	
	/**
	 * Draw the selection highlight of a card
	 * @param c The 2D context to draw to
	 * @param i The index of the card
	 * @param x The X coordinate of the card
	 * @param y The Y coordinate of the card
	 * @param w The width of the card
	 */
	private function drawCardSelectionHighlight(c:Context2D, i:Int, x:Float, y:Float, w:Float):Void {
		c.setColor(0xFFFFFF);
		if (i == selectedSongIndex) {
			c.setThickness(4);
			c.drawRoundRect(x - 2, y - 2, w + 4, CARD_HEIGHT + 4, 10);
		}
	}
	
	/**
	 * Draw the main (scrolling) text of the card (song name and author)
	 * @param c The 2D context to draw to
	 * @param chart The chart metadata
	 * @param x The X coordinate of the card
	 * @param y The Y coordinate of the card
	 * @param w The width of the card
	 */
	private function drawCardMainText(c:Context2D, chart:ChartMetadata, x:Float, y:Float, w:Float):Void {
		var text = '${chart.songAuthor} - ${chart.songName}';
		var textX = x + 10;
		var gap = 50;
	
		c.setFont(font_bold);
		c.setFontSize(24);
		var textWidth = c.measureText(text);
	
		if (textWidth > w - 20) {
			var time = Sys.time();
			var textOffset = (time * 100) % (textWidth + gap);
			c.drawText(text, textX - textOffset, y + 10);
			c.drawText(text, textX - textOffset + textWidth + gap, y + 10);
		} else {
			c.drawText(text, textX, y + 10);
		}
	}
	
	/**
	 * Draw the additional details of the card (difficulty and mapper name)
	 * @param c The 2D context to draw to
	 * @param chart The chart metadata
	 * @param x The X coordinate of the card
	 * @param y The Y coordinate of the card
	 */
	private function drawCardAdditionalDetails(c:Context2D, chart:ChartMetadata, x:Float, y:Float):Void {
		c.setFont(font_regular);
		c.setFontSize(16);
	
		c.setColor(0xFFFF00);
		c.drawText(chart.difficultyName, x + 10, y + 40);
	
		c.setColor(0x747474);
		c.drawText('Mapped by ${chart.mapperName}', x + 10, y + 60);
	}
	
	/**
	 * Handle mouse interaction with a card
	 * @param x The X coordinate of the card
	 * @param y The Y coordinate of the card
	 * @param w The width of the card
	 * @param i The index of the card
	 * @return True if the card was clicked
	 */
	private function handleMouseInteraction(x:Float, y:Float, w:Float, i:Int):Bool {
		var mx = app.input.getMouseX();
		var my = app.input.getMouseY();
	
		if (mx > x && mx < x + w && my > y && my < y + CARD_HEIGHT) {
			if (app.input.isMousePressed(InputMouseButton.LEFT)) {
				selectChart(results[i]);
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Draw the scrollbar
	 */
	private function drawScrollbar(c:Context2D) {
		c.setColor(0x70000000);
		c.fillRect(app.window.getWidth() - SCROLL_WIDTH, 0, SCROLL_WIDTH, app.window.getHeight());

		c.setColor(0x80FFFFFF);
		c.fillRoundRect(app.window.getWidth() - SCROLL_WIDTH, getScrollBarY(), SCROLL_WIDTH, getScrollBarHeight(), 5);
	}

	/**
	 * Get the height of the scroll bar piece
	 */
	private function getScrollBarHeight():Float {
		var totalHeight = results.length * (CARD_HEIGHT + CARD_PADDING);
		var visibleHeight = app.window.getHeight();
		return Math.max(20, visibleHeight / totalHeight * visibleHeight);
	}

	/**
	 * Get the Y coordinate of the scroll bar
	 */
	private function getScrollBarY():Float {
		var totalHeight = results.length * (CARD_HEIGHT + CARD_PADDING);
		var visibleHeight = app.window.getHeight();
		var scrollBarHeight = getScrollBarHeight();
		var scrollBarY = scrollOffsetY / totalHeight * (visibleHeight - scrollBarHeight);
		return Math.min(visibleHeight - scrollBarHeight, scrollBarY);
	}

	/**
	 * Update the scene
	 * @param dt  Delta time (in seconds since last update)
	 */
	override function update(dt:Float) {
		targetScrollOffsetY -= app.input.getMouseScrollY() * 50;

		if (app.input.isKeyPressed(InputKey.UP)) selectUp();
		if (app.input.isKeyPressed(InputKey.DOWN)) selectDown();
		if (app.input.isKeyPressed(InputKey.PAGEUP)) selectUp(10);
		if (app.input.isKeyPressed(InputKey.PAGEDOWN)) selectDown(10);

		if (app.input.isKeyPressed(InputKey.ENTER)) {
			if (selectedSongIndex >= 0 && selectedSongIndex < results.length) {
				if (results[selectedSongIndex] != null) selectChart(results[selectedSongIndex]);
			}
		}

		limitScrollOffset();
		updateSearchQuery();
		scrollOffsetY += (targetScrollOffsetY - scrollOffsetY) * 20 * dt;
	}

	/**
	 * Update the search query
	 */
	private function updateSearchQuery() {
		var pressed = app.input.getAllPressedKeys();
		var hasChanged = false;
		for (key in 0...pressed.length) {
			if (!pressed[key]) continue;

			var key = app.input.keyToChar(key);
			if (key.length > 1) continue;

			query += key;
			hasChanged = true;
		}

		if (app.input.isKeyPressed(InputKey.SPACE)) {
			query += ' ';
			hasChanged = true;
		}

		if (app.input.isKeyPressed(InputKey.BACKSPACE) && query.length > 0) {
			query = query.substr(0, query.length - 1);
			hasChanged = true;
		}

		if (hasChanged) reloadSearchResults();
	}

	/**
	 * Reload the search results
	 */
	private function reloadSearchResults() {
		queryResults.resize(0);
		
		for (chart in Indexer.charts) {
			if (chart == null) continue;
			var doInclude = false;
			var queryLower = query.toLowerCase();

			if (chart.songName.toLowerCase().indexOf(queryLower) >= 0) doInclude = true;
			if (chart.songAuthor.toLowerCase().indexOf(queryLower) >= 0) doInclude = true;
			if (chart.mapperName.toLowerCase().indexOf(queryLower) >= 0) doInclude = true;
			if (chart.difficultyName.toLowerCase().indexOf(queryLower) >= 0) doInclude = true;

			if (doInclude) queryResults.push(chart);
		}
	}

	/**
	 * Limit the scroll offset so that it doesn't go out of bounds
	 */
	private function limitScrollOffset() {
		var min = 0;
		var max = (results.length - 1) * (CARD_HEIGHT + CARD_PADDING) - app.window.getHeight() + CARD_HEIGHT + CARD_PADDING * 2 + (query.length > 0 ? CARD_PADDING * 2 + 24 : 0);

		if (selectedSongIndex < 0) selectedSongIndex = 0;
		if (selectedSongIndex >= results.length) selectedSongIndex = results.length - 1;

		if (targetScrollOffsetY < min) targetScrollOffsetY = min;
		if (targetScrollOffsetY > max) targetScrollOffsetY = max;
	}

	/**
	 * Gets the minimium index of the songs that are currently visible
	 */
	private function getMinVisibleSongIndex():Int {
		return Std.int(scrollOffsetY / (CARD_HEIGHT + CARD_PADDING));
	}

	/**
	 * Gets the maximum index of the songs that are currently visible
	 */
	private function getMaxVisibleSongIndex():Int {
		return getMinVisibleSongIndex() + Std.int(app.window.getHeight() / (CARD_HEIGHT + CARD_PADDING));
	}

	/**
	 *  Get Y coordinate of a song card
	 * @param index  The index of the song
	 * @return  The Y coordinate of the song card
	 */
	private function getSongCardY(index:Int):Float {
		return index * (CARD_HEIGHT + CARD_PADDING) - scrollOffsetY + CARD_PADDING + (query.length > 0 ? (CARD_PADDING * 2) + 24 : 0);
	}

	/**
	 * Selection go up
	 * @param by  How many songs to go up
	 */
	private function selectUp(by:Int = 1) {
		selectedSongIndex -= by;
		checkSelectionBoxReset(-by);
	}

	/**
	 * Selection go down
	 * @param by  How many songs to go down
	 */
	private function selectDown(by:Int = 1) {
		selectedSongIndex += by;
		checkSelectionBoxReset(by);
	}

	/**
	 * Check if the selection box for songs need to be reset
	 */
	private function checkSelectionBoxReset(cardMoveAmount:Int) {
		var min = getMinVisibleSongIndex();
		var max = getMaxVisibleSongIndex();

		var selectionPosY = getSongCardY(selectedSongIndex - cardMoveAmount - 1);
		if (selectionPosY < (-app.window.getHeight() + CARD_HEIGHT + CARD_PADDING) || selectionPosY > app.window.getHeight() * 2 - CARD_HEIGHT - CARD_PADDING) {
			if (selectedSongIndex < min) selectedSongIndex = min;
			if (selectedSongIndex > max) selectedSongIndex = max;
		} else {
			if (selectedSongIndex < min) scrollToIndex(selectedSongIndex);
			if (selectedSongIndex > max) scrollToIndex(selectedSongIndex - (max - min));
		}
	}

	/**
	 * Scroll to a specific index
	 */
	private function scrollToIndex(index:Int) {
		targetScrollOffsetY = index * (CARD_HEIGHT + CARD_PADDING);
	}

	/**
	 * Getter for chart results
	 * @return Array<ChartMetadata>
	 */
	inline function get_results():Array<ChartMetadata> {
		return query.length > 1 ? queryResults : Indexer.charts;
	}

}
