package kfunkin.modding;

import kfunkin.scenes.GameplayScene;
import kfunkin.scenes.SongSelectScene;

/**
 * This represents the registry of classes that may be overwriten by mods.
 */
class ClassRegistry {
	private static var classMap:Array<ClassRegistryItem<Class<Dynamic>>> = [];

	/**
	 * Register a class to the registry.
	 * @param cls The class to register.
	 */
	public static function createRegistry<T>(cls:Class<T>) {
		var reg = new ClassRegistryItem<T>(cls);
		classMap.push(cast reg); // Bit hacky but OK

		return reg;
	}

	/**
	 * Get a registry item by class type.
	 * @param GameplayScene The class to get the registry item for.
	 */
	public static function getRegistryByClassType<T>(cls:Class<T>):ClassRegistryItem<T> {
		for (reg in classMap) {
			if (reg.getClass() == cast cls) return cast reg;
		}
		return null;
	}

	/**
	 * Reset all the classes to their original state.
	 */
	public static function resetClasses() {
		for (reg in classMap) reg.resetClass();
	}

	/**
	 * Gets all the class registries
	 */
	public static function getRegistries():Array<ClassRegistryItem<Class<Dynamic>>> {
		return classMap;
	}
	
	/**
	 * Create instances of a class (using ClassRegistry, falls back to default if not found)
	 * @param cls The class to create an instance of.
	 * @param args The arguments to pass to the constructor.
	 */
	public static function createInstance(cls:Class<Dynamic>, ?args: Array<Dynamic>): Dynamic {
		var reg = getRegistryByClassType(cls);
		if (reg != null) return reg.createInstance(args != null ? args : []);
		return Type.createInstance(cls, args != null ? args : []);
	}

	/**
	 * Overwrite a class with a new class.
	 * @param from The class to overwrite.
	 * @param to The class to overwrite with.
	 */
	public static function overwriteClass(from:Class<Dynamic>, to:Class<Dynamic>) {
		var reg = getRegistryByClassType(from);
		if (reg != null) reg.setClass(to);
	}

}
