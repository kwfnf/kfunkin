package kfunkin.objects.notes;

import nanovg.Nvg;
import nanovg.Nvg.NvgContextPtr;
import kawaii.rendering.Context2D;
import kfunkin.formats.data.ChartNote;
import kawaii.resources.ResourceImage;
import kfunkin.formats.data.ChartNoteType;

class NoteSustain extends NoteSingle {

    private var sustainTex: ResourceImage;
    private var vg: NvgContextPtr;

    private static final sustainOffsets = [2, 105, 209, 313];
    private static final sustainPieceWidth = 50;
    private static final sustainPieceHeight = 87;
    private static final sustainTailHeight = 64;
    private static final sustainPieceSecondaryOffset = 52;

    /**
     * Creates a new sustain note.
     */
    public function new() {
        super();
        type = ChartNoteType.SUSTAIN;
        vg = app.renderer.getVG();
        sustainTex = app.resources.acquireImage('gameplay/sustain.png');
    }

    /**
     * Draws a vertically tiled image.
     * @param img The image.
     * @param srcX The source X.
     * @param srcY The source Y.
     * @param srcW The source width.
     * @param srcH The source height.
     * @param dstX The destination X.
     * @param dstY The destination Y.
     * @param dstW The destination width.
     * @param tH The tile height.
     */
    private function drawImageTiled(img: ResourceImage, srcX: Float, srcY: Float, srcW: Float, srcH: Float, dstX: Float, dstY: Float, dstW: Float, tH: Float) {
        Nvg.save(vg);
        Nvg.rect(vg, dstX, dstY, dstW, tH);
        Nvg.scissor(vg, dstX, dstY, dstW, tH);

        var sx = dstW / srcW;
        var pattern = Nvg.imagePattern(vg, dstX - srcX * sx, dstY - srcY, img.getWidth() * sx, srcH, 0.0, img.getIndex(), 1.0);

        Nvg.beginPath(vg);
        Nvg.rect(vg, dstX, dstY, dstW, tH);
        Nvg.fillPaint(vg, pattern);
        Nvg.fill(vg);
        Nvg.restore(vg);
    }

    /**
     * Draw the sustain note.
     * @param c The 2D context.
     * @param lane The lane.
     * @param time The time.
     * @param note The note.
     */
    override function onDraw(c: Context2D, lane: Lane, time: Float, note: ChartNote) {
        var duration = note.endTime - note.time;
        var scale = Globals.SCALE;
        var length = duration * Globals.NOTE_SPEED - (sustainTailHeight * scale) + (getDrawH(time, lane, note) / 2);

        var dstX = getDrawX(time, lane, note) + getDrawW(time, lane, note) / 2 - ((sustainPieceWidth * scale) / 2);
        var dstY = lane.y + (Globals.NOTE_SPEED * (note.time - time)) + (getDrawH(time, lane, note) / 2);

        var tailDstY = dstY + length - 1;
        if (tailDstY + sustainTailHeight < 0 || dstY > app.window.getHeight()) return;

        drawImageTiled(
            sustainTex,
            sustainOffsets[lane.index],
            0, 
            sustainPieceWidth, 
            sustainPieceHeight, 
            dstX, 
            dstY, 
            sustainPieceWidth * scale, 
            length
        );

        c.drawImageRect(
            sustainTex, 
            sustainOffsets[lane.index] + sustainPieceSecondaryOffset, 
            0, 
            sustainPieceWidth, 
            sustainTailHeight, 
            dstX, 
            tailDstY, 
            sustainPieceWidth * scale, 
            sustainTailHeight * scale
        );

        super.onDraw(c, lane, time, note);
    }

    /**
     * Dispose the sustain texture.
     */
    override function onDispose() {
        sustainTex.release();
        super.onDispose();
    }

}
