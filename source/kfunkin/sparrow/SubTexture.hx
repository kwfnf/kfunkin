package kfunkin.sparrow;

/*
	! SOURCE: Starling Framework Docs
	! URL: http://doc.starling-framework.org/current/starling/textures/TextureAtlas.html
	
	A texture atlas is a collection of many smaller textures in one big image. This class is used to access textures from such an atlas.

	Using a texture atlas for your textures solves two problems:

	Whenever you switch between textures, the batching of image objects is disrupted.
	Any Stage3D texture has to have side lengths that are powers of two. Starling hides this limitation from you, but at the cost of additional graphics memory.

	By using a texture atlas, you avoid both texture switches and the power-of-two limitation. All textures are within one big "super-texture", and Starling takes care that the correct part of this texture is displayed.

	There are several ways to create a texture atlas. One is to use the atlas generator script that is bundled with Starling's sibling, the Sparrow framework. It was only tested in Mac OS X, though. A great multi-platform alternative is the commercial tool Texture Packer.

	Whatever tool you use, Starling expects the following file format:

		 <TextureAtlas imagePath='atlas.png'>
		   <SubTexture name='texture_1' x='0'  y='0' width='50' height='50'/>
		   <SubTexture name='texture_2' x='50' y='0' width='20' height='30'/> 
		 </TextureAtlas>
	  

	Texture Frame

	If your images have transparent areas at their edges, you can make use of the frame property of the Texture class. Trim the texture by removing the transparent edges and specify the original texture size like this:

		 <SubTexture name='trimmed' x='0' y='0' height='10' width='10'
			 frameX='-10' frameY='-10' frameWidth='30' frameHeight='30'/>
	  

	Texture Rotation

	Some atlas generators can optionally rotate individual textures to optimize the texture distribution. This is supported via the boolean attribute "rotated". If it is set to true for a certain subtexture, this means that the texture on the atlas has been rotated by 90 degrees, clockwise. Starling will undo that rotation by rotating it counter-clockwise.

	In this case, the positional coordinates (x, y, width, height) are expected to point at the subtexture as it is present on the atlas (in its rotated form), while the "frame" properties must describe the texture in its upright form.
*/
 
/**
 * Represents a SubTexture in a Texture atlas
 */
class SubTexture {
	public var name:String;
	public var x:Null<Int>;
	public var y:Null<Int>;
	public var width:Null<Int>;
	public var height:Null<Int>;
	public var frameX:Null<Int>;
	public var frameY:Null<Int>;
	public var frameWidth:Null<Int>;
	public var frameHeight:Null<Int>;

	/**
	 * Creates a SubTexture from an XML node
	 * @param xml The XML node to create the SubTexture from
	 */
	public static function fromXml(xml:Xml) {
		var name = xml.get("name");
		var x = Std.parseInt(xml.get("x"));
		var y = Std.parseInt(xml.get("y"));
		var width = Std.parseInt(xml.get("width"));
		var height = Std.parseInt(xml.get("height"));
		var frameX = Std.parseInt(xml.get("frameX"));
		var frameY = Std.parseInt(xml.get("frameY"));
		var frameWidth = Std.parseInt(xml.get("frameWidth"));
		var frameHeight = Std.parseInt(xml.get("frameHeight"));

		return new SubTexture(name, x, y, width, height, frameX, frameY, frameWidth, frameHeight);
	}

	/**
	 * Creates a new SubTexture
	 * @param name The name of the SubTexture
	 * @param x The x position of the SubTexture in the atlas
	 * @param y The y position of the SubTexture in the atlas
	 * @param width The width of the SubTexture
	 * @param height The height of the SubTexture
	 * @param frameX The frame x position of the SubTexture
	 * @param frameY The frame y position of the SubTexture
	 * @param frameWidth The frame width of the SubTexture
	 * @param frameHeight The frame height of the SubTexture
	 */
	public function new(name:String, x:Null<Int>, y:Null<Int>, width:Null<Int>, height:Null<Int>, frameX:Null<Int>, frameY:Null<Int>, frameWidth:Null<Int>, frameHeight:Null<Int>) {
		this.name = name;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.frameX = frameX != null ? frameX : 0;
		this.frameY = frameY != null ? frameY : 0;
		this.frameWidth = frameWidth != null ? frameWidth : width;
		this.frameHeight = frameHeight != null ? frameHeight : height;
	}

	/**
	 * Gets the source x position of the SubTexture
	 */
	public inline function getSrcX():Null<Int> {
		return x;
	}

	/**
	 * Gets the source y position of the SubTexture
	 * @return Null<Int>
	 */
	public inline function getSrcY():Null<Int> {
		return y;
	}

	/**
	 * Gets the source width of the SubTexture
	 * @return Null<Int>
	 */
	public inline function getSrcWidth():Null<Int> {
		return width;
	}

	/**
	 * Gets the source height of the SubTexture
	 * @return Null<Int>
	 */
	public inline function getSrcHeight():Null<Int> {
		return height;
	}

	/**
	 * Gets the destination x position of the SubTexture
	 * @return Null<Int>
	 */
	public inline function getDestXOffset(v: Float = 0):Null<Float> {
		return frameX + v;
	}

	/**
	 * Gets the destination y position of the SubTexture
	 * @return Null<Int>
	 */
	public inline function getDestYOffset(v: Float = 0):Null<Float> {
		return frameY + v;
	}

	/**
	 * Gets the destination width of the SubTexture
	 * @return Null<Int>
	 */
	public inline function getDestWidth():Null<Int> {
		return frameWidth;
	}

	/**
	 * Gets the destination height of the SubTexture
	 * @return Null<Int>
	 */
	public inline function getDestHeight():Null<Int> {
		return frameHeight;
	}
}
