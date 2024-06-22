package kfunkin.objects;

import kfunkin.modding.ClassRegistry;
import kawaii.rendering.Context2D;

/**
 * Represents a lane in the playfield.
 */
class Lane {

    public var receptor: Receptor;
    public var playfield: Playfield;

    // Origin is top-center
    public var x: Float = 0;
    public var y: Float = 0;
    public var index: Int = 0;

    /**
     * Empty constructor.
     */
    public function new(playfield: Playfield) {
        this.playfield = playfield;
        this.index = playfield.lanes.length;

        receptor = ClassRegistry.createInstance(Receptor, [ this ]);
    }

    /**
     * Render method
     * @param c The context to render to.
     */
    public function render(c: Context2D) {
        receptor.render(c);
    }

	/**
	 * The update method.
	 * @param dt The delta time since the last frame in seconds.
	 */
	public function update(dt:Float) {
        receptor.y = y;
        receptor.x = x;
        receptor.update(dt);
    }

    /**
     * Dispose of the lane.
     */
    public function dispose() {
        receptor.dispose();
    }

}