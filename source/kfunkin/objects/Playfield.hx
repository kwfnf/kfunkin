package kfunkin.objects;

import kfunkin.formats.data.ChartNote;
import kfunkin.game.GameState;
import kawaii.Application;
import kfunkin.formats.data.ChartNoteType;
import kfunkin.objects.notes.NoteSingle;
import kfunkin.objects.notes.NoteBase;
import kfunkin.modding.ClassRegistry;
import kawaii.rendering.Context2D;

/**
 * Represents a fully playable playfield.
 */
class Playfield {

    public var lanes: Array<Lane> = [];
    public var noteTypes: Array<NoteBase> = [];
    public var chart: Chart;
    public var app: Application;
    public var state: GameState;
    public var metronome: Metronome;

    // Origin is top-center
    public var x: Float = 0;
    public var y: Float = 16;
    public var width: Float = 480;

    /**
     * Empty constructor.
     */
    public function new(chart: Chart, lanes: Int = -1) {
        this.chart = chart;
        this.app = Application.getInstance();
        this.state = new GameState();
        this.metronome = new Metronome(chart);

        createLanes(lanes < 0 ? Globals.DIRECTIONS.length : lanes);
        for (noteType in CompileTime.getAllClasses('kfunkin.objects.notes')) registerNoteType(ClassRegistry.createInstance(noteType));
    }

    /**
     * Registers a note type.
     */
    public function registerNoteType(noteType: NoteBase) {
        trace('Registering note type: ' + noteType);
        noteTypes[noteType.type] = noteType;
    }

    /**
     * Creates the lanes.
     * @param lanes The number of lanes to create.
     */
    public function createLanes(lanes: Int) {
        for (_ in 0...lanes) this.lanes.push(ClassRegistry.createInstance(Lane, [ this ]));
    }

    /**
     * Render method
     * @param c The context to render to.
     */
    public function render(c: Context2D) {
        var time = chart.getAudioTime();

        // Lanes
        for (lane in lanes) lane.render(c);

        // Notes
        for (note in chart.noteBuckets.getCurrentlyRelevantNotes(time)) {
            if (!note.doRender) continue;
            var noteType = noteTypes[note.type];
            var lane = lanes[note.lane];
            noteType.onDraw(c, lane, time, note);
        }
    }

	/**
	 * The update method.
	 * @param dt The delta time since the last frame in seconds.
	 */
	public function update(dt:Float) {
        // positions
        var laneIndex = 0;
        for (lane in lanes) {
            updateLanePosition(lane, laneIndex);
            lane.update(dt);
            laneIndex++;
        }

        // notes
        var time = chart.getAudioTime();
        for (note in chart.noteBuckets.getCurrentlyRelevantNotes(time)) updateNote(note, lanes[note.lane], time);

        // metronome
        metronome.update(time);
    }

    /**
     * Update a note
     */
    public function updateNote(note: ChartNote, lane: Lane, time: Float) {
        if (!note.doEvents) return;
        var noteType = noteTypes[note.type];
        var diff = time - note.time;

        if (!note._firedJudgementEnter && diff >= -Globals.JUDGEMENT_WINDOW) {
            note._firedJudgementEnter = true;
            noteType.onJudgementEnter(lane, time, note);
            return;
        }

        if (!note._firedJudgementExit && diff >= Globals.JUDGEMENT_WINDOW) {
            note._firedJudgementExit = true;
            noteType.onJudgementExit(lane, time, note);
            return;
        }

        if (!note._firedJudgementOver && diff >= 0) {
            note._firedJudgementOver = true;
            noteType.onOverReceptor(lane, time, note);
            return;
        }

    }

    /**
     * Updates the position of a lane.
     * @param lane The lane to update.
     * @param index The index of the lane.
     */
    public function updateLanePosition(lane: Lane, index: Int) {
        lane.y = y;
        lane.x = x + (width / lanes.length) * index;
        lane.index = index;
    }

    /**
     * Disposes of the playfield.
     */
    public function dispose() {
        for (lane in lanes) lane.dispose();
        for (noteType in noteTypes) noteType.onDispose();
        metronome.dispose();
    }

}