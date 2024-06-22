package kfunkin.formats.data;

/**
 * Represents the type of a chart note.
 */
enum abstract ChartNoteType(Int) from Int to Int {
    var NONE = -1;
    var SINGLE = 0;
    var SUSTAIN = 1;
    var SUSTAIN_END = 2;
}