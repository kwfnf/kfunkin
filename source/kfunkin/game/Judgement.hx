package kfunkin.game;

/**
 * Represents all the possible judgements that can be given to a note.
 */
enum abstract Judgement(Int) from Int to Int {
    var SICK = 0;
    var GOOD = 1;
    var BAD = 2;
    var SHIT = 3;
    var MISS = 4;
}