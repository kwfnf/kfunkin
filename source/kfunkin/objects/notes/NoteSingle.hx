package kfunkin.objects.notes;

import kfunkin.Globals;
import kawaii.rendering.Context2D;
import kfunkin.formats.data.ChartNoteType;
import kfunkin.formats.data.ChartNote;
import kfunkin.sparrow.SubTexture;
import kfunkin.sparrow.Atlas;

class NoteSingle extends NoteBase {

    private var noteAtlas: Atlas;
    private var subTextures: Array<SubTexture> = [];

    /**
     * Load the note type
     */
    public function new() {
        super();
        type = ChartNoteType.SINGLE;
        noteAtlas = Atlas.fromXml('gameplay/notes.xml');

        for (dirIndex in 0...Globals.DIRECTIONS.length) {
            var dir = Globals.DIRECTIONS[dirIndex];
            subTextures[dirIndex] = noteAtlas.getSubTexture('note${dir}0001');
        }
    }

    override function onJudgementExit(lane:Lane, time:Float, note:ChartNote) {
        lane.playfield.state.addMiss();
        note.doEvents = false;
    }

    /**
     * Get the note X
     */
    public function getX(time: Float, lane:Lane, note: ChartNote):Float {
        return lane.x;
    }

    /**
     * Get the note Y
     */
    public function getY(time:Float, lane:Lane, note: ChartNote):Float {
        return lane.y + (Globals.NOTE_SPEED * (note.time - time));
    }

    /**
     * Get note scale
     */
    public function getScale(time:Float, lane:Lane, note: ChartNote):Float {
        return Globals.SCALE;
    }

    /**
     * Draw the note
     * @param c The context to draw on
     * @param lane The lane to draw in
     * @param time The time to draw at
     */
    override function onDraw(c:Context2D, lane:Lane, time:Float, note: ChartNote) {
        var subTex = subTextures[lane.index];
        var scale = getScale(time, lane, note);

        var originalWidth = subTex.getDestWidth();
        var originalHeight = subTex.getDestHeight();

        var scaledWidth = originalWidth * scale;
        var scaledHeight = originalHeight * scale;

        var drawX = subTex.getDestXOffset(getX(time, lane, note)) - (scaledWidth - originalWidth) / 2;
        var drawY = subTex.getDestYOffset(getY(time, lane, note)) - (scaledHeight - originalHeight) / 2;

        if (drawY > app.window.getHeight() || drawY + scaledHeight < 0) return;

        c.drawImageRect(
            noteAtlas.texture,
            subTex.getSrcX(),
            subTex.getSrcY(),
            subTex.getSrcWidth(),
            subTex.getSrcHeight(),
            drawX,
            drawY,
            scaledWidth,
            scaledHeight
        );
    }

    /**
     * Get the draw X coordinate
     */
    public function getDrawX(time:Float, lane:Lane, note: ChartNote):Float {
        var subTex = subTextures[lane.index];
        var scale = getScale(time, lane, note);
        var originalDrawX = subTex.getDestXOffset(getX(time, lane, note));
        var originalWidth = subTex.getDestWidth();
        var scaledWidth = originalWidth * scale;
        return originalDrawX - (scaledWidth - originalWidth) / 2;
    }

    /**
     * Get the draw W coordinate
     */
    public function getDrawW(time:Float, lane:Lane, note: ChartNote):Float {
        var subTex = subTextures[lane.index];
        var scale = getScale(time, lane, note);
        var originalWidth = subTex.getDestWidth();
        return originalWidth * scale;
    }

    /**
     * Get the draw Y coordinate
     */
    public function getDrawY(time:Float, lane:Lane, note: ChartNote):Float {
        var subTex = subTextures[lane.index];
        var scale = getScale(time, lane, note);
        var originalDrawY = subTex.getDestYOffset(getY(time, lane, note));
        var originalHeight = subTex.getDestHeight();
        var scaledHeight = originalHeight * scale;
        return originalDrawY - (scaledHeight - originalHeight) / 2;
    }

    /**
     * Get the draw H coordinate
     */
    public function getDrawH(time:Float, lane:Lane, note: ChartNote):Float {
        var subTex = subTextures[lane.index];
        var scale = getScale(time, lane, note);
        var originalHeight = subTex.getDestHeight();
        return originalHeight * scale;
    }
    
    /**
     * Dispose the note
     */
    override function onDispose() {
        noteAtlas.dispose();
    }

}