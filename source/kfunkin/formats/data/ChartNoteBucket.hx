package kfunkin.formats.data;

/**
 * Represents a bucket of notes in a chart. This is used to store notes in a chart in a way that is easy to access and modify.  
 * For now this is just a dumb abstraction layer on top of Array's, but in the future certain operations may get added to this.
 * I really don't want to change a bunch of stuff in the future, so I'm adding this now.
 */
class ChartNoteBucket {

    private var _notes: Array<ChartNote> = [];
    private var _time: Float; // in ms

    /**
     * Creates a new note bucket.
     * @param time The time of the bucket.
     */
    public function new(time: Float) {
        _time = time;
    }

    /**
     * Adds a note to the bucket.
     * @param note The note to add.
     */
    public inline function add(note: ChartNote): Void {
        _notes.push(note);
    }

    /**
     * Removes a note from the bucket.
     * @param note The note to remove.
     */
    public inline function remove(note: ChartNote): Void {
        _notes.remove(note);   
    }

    /**
     * Gets the notes in the bucket.
     * @return The notes in the bucket.
     */
    public inline function getNotes(): Array<ChartNote> {
        return _notes;
    }

    /**
     * Gets the note at the specified index.
     * @param index The index of the note to get.
     * @return The note at the specified index.
     */
    public inline function getNoteAt(index: Int): ChartNote {
        return _notes[index];
    }

    /**
     * Gets the number of notes in the bucket.
     * @return The number of notes in the bucket.
     */
    public inline function getNoteCount(): Int {
        return _notes.length;
    }

    /**
     * Gets the time of the bucket.
     */
    public inline function getBucketTime(): Float {
        return _time;
    }

    /**
     * Add a note
     */
    public inline function addNote(millis: Float, type: ChartNoteType, lane: Int, opponent: Bool, duration: Int = 0): Void {
        add({ time: millis, type: type, lane: lane, opponent: opponent, endTime: millis + duration });
    }
    
}