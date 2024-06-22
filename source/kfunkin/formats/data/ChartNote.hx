package kfunkin.formats.data;

/**
 * Represents a note in a chart.
 */
@:structInit
class ChartNote {

    // Note data
    public var time: Float;
    public var type: Int;
    public var lane: Int;
    public var endTime: Float = 0;
    public var opponent: Bool = false;

    // Note state
    public var doRender: Bool = true;
    public var doEvents: Bool = true;
    public var _firedJudgementEnter: Bool = false;
    public var _firedJudgementExit: Bool = false;
    public var _firedJudgementOver: Bool = false;

}