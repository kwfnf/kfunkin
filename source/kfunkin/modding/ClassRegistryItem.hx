package kfunkin.modding;

/**
 * Represents a class that can be overwritten
 */
class ClassRegistryItem<T> {
	private var defaultClass:Class<T>;
	private var currentClass:Class<T>;

	/**
	 * Creates a new instance of ClassRegistryItem with a default value.
	 * @param def The default value of the class
	 */
	public function new(def:Class<T>) {
		this.defaultClass = def;
		this.currentClass = def;
	}

	/**
	 * Gets the class of the item
	 * @return The class of the item
	 */
	public inline function getClass():Class<T> {
		return currentClass;
	}

	/**
	 * Sets the class of the item
	 * @param cls The class of the item
	 * @return The class of the item
	 */
	public inline function setClass(cls:Class<T>):Class<T> {
		return currentClass = cls;
	}

	/**
	 * Resets the class of the item to the default
	 */
	public inline function resetClass():Void {
		currentClass = defaultClass;
	}

	/**
	 * Creates a new instance of the class
	 * @param arguments The arguments to pass to the constructor
	 * @return The new instance of the class
	 */
	public inline function createInstance(?arguments:Array<Dynamic>):T {
		return Type.createInstance(currentClass, arguments != null ? arguments : []);
	}
}
