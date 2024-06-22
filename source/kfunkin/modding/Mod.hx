package kfunkin.modding;

/**
 * This should be derived by the Entrypoints of mods.
 */
class Mod {
	public var data:ModData;

	/**
	 * Create a new instance of the mod.
	 */
	public function new(modData:ModData) {
		this.data = modData;
		ModLoader.registerMod(this);
	}
}
