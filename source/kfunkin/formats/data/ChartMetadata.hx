package kfunkin.formats.data;

/**
 * This typedef represents the metadata of a chart, that is stored for indexing purposes.
 */
@:structInit
class ChartMetadata {
	public var songName:String;
	public var songAuthor:String;
	public var difficultyName:String;
	public var mapperName:String;
	public var format:ChartFormat;
	public var path:String;
}
