package kfunkin.objects;

import kfunkin.sparrow.SubTexture;
import kfunkin.sparrow.Atlas;
import kawaii.rendering.Context2D;

/**
 * Represents the receptor object.
 */
class Receptor {

    private var atlas: Atlas;
    private var receptor: SubTexture;

    public var x: Float = 0;
    public var y: Float = 0;

    private var lane: Lane;
    
    /**
     * Empty constructor.
     */
    public function new(lane: Lane) {
        this.lane = lane;

        var direction = Globals.DIRECTIONS[lane.index];
        atlas = Atlas.fromXml('gameplay/strum.xml');
        receptor = atlas.getSubTexture('static${direction}0001');
    }

    /**
     * Render method
     * @param c The context to render to.
     */
    public function render(c: Context2D) {
        var scale = Globals.SCALE;

        var originalDrawX = receptor.getDestXOffset(x);
        var originalDrawY = receptor.getDestYOffset(y);
        var originalWidth = receptor.getDestWidth();
        var originalHeight = receptor.getDestHeight();

        var scaledWidth = originalWidth * scale;
        var scaledHeight = originalHeight * scale;

        var drawX = originalDrawX - (scaledWidth - originalWidth) / 2;
        var drawY = originalDrawY - (scaledHeight - originalHeight) / 2;

        c.drawImageRect(
            atlas.texture,
            receptor.getSrcX(),
            receptor.getSrcY(),
            receptor.getSrcWidth(),
            receptor.getSrcHeight(),
            drawX,
            drawY,
            scaledWidth,
            scaledHeight
        );
    }

    /**
     * The update method.
     * @param dt The delta time.
     */
    public function update(dt: Float) {}

    /**
     * Dispose of the receptor.
     */
    public function dispose() {
        atlas.release();
    }

}