package kfunkin.modding;

/**
 * Represents the data of a Mod
 */
class ModData {
	public var name:String;
	public var author:String;
	public var version:String = "1.0.0";

	public function new(name:String, author:String) {
		this.name = name;
		this.author = author;
	}
}
