package kfunkin.objects.notes;

import kawaii.Application;
import kfunkin.formats.data.ChartNote;
import kfunkin.formats.data.ChartNoteType;
import kawaii.rendering.Context2D;

/**
 * The base class for all notes, should be extended by all note types.
 */
class NoteBase {
    
    public var type = ChartNoteType.NONE;

    private var app: Application;
    public function new() {
        app = Application.getInstance();
    }

    public function onDraw(c: Context2D, lane: Lane, time: Float, note: ChartNote): Void {}
    public function onDirectHit(lane: Lane, time: Float, note: ChartNote): Void {}
    public function onJudgementEnter(lane: Lane, time: Float, note: ChartNote): Void {}
    public function onJudgementExit(lane: Lane, time: Float, note: ChartNote): Void {}
    public function onOverReceptor(lane: Lane, time: Float, note: ChartNote): Void {}
    public function onDispose() {}

}