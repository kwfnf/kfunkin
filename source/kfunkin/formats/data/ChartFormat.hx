package kfunkin.formats.data;

/**
 * This enum represents the different formats that a chart can be in.
 */
enum abstract ChartFormat(Int) from Int to Int {
	var NONE = 0;
	var FNF_VSLICE = 1;
	var FNF_LEGACY = 2;
	var OSU = 3;
}
