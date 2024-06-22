package kfunkin.formats.data;

/**
 * Represents any event that can occur in a chart.
 */
@:structInit
class ChartEvent {
    public var type: ChartEventType;
    public var time: Float;
    public var data: Dynamic;
}