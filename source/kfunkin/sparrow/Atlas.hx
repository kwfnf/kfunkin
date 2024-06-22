package kfunkin.sparrow;

import kawaii.resources.Cache;
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;
import kawaii.Application;
import kawaii.resources.ResourceBase;
import kawaii.resources.ResourceImage;

/**
 * Represents a Texture atlas in  Sparrow Atlas format (.xml file + .png file)
 */
class Atlas extends ResourceBase {

	public var texture: ResourceImage;
	public var subTextures: Array<SubTexture> = [];
	public var subTextureNames: Map<String, Int> = []; // name -> index

	/**
	 * Creates a new Atlas object.
	 * @param tex The texture that contains the subtextures.
	 * @param subTextures A list of SubTextures that make up the atlas.
	 */
	public function new(tex: ResourceImage, subTextures: Array<SubTexture>) {
		this.texture = tex;
		this.subTextures = subTextures;

		for (i in 0...subTextures.length) {
			subTextureNames[subTextures[i].name] = i;
		}
		
		super(this.texture.getIndex());
	}

	/**
	 * Returns a subtexture with a certain name. If it's not found, you will get null.
	 * @param name The name of the subtexture.
	 * @return The subtexture.
	 */
	public function getSubTexture(name: String): SubTexture {
		var index = subTextureNames[name];
		if (index == null) return null;
		return subTextures[index];
	}

	/**
	 * Get the textures with a certain prefix
	 * @param prefix The prefix to search for
	 */
	public function getTexturesWithPrefix(prefix: String): Array<SubTexture> {
		var textures = [];
		for (subTexture in subTextures) {
			if (subTexture.name.indexOf(prefix) == 0) textures.push(subTexture);
		}
		return textures;
	}

	/**
	 * Disposes the atlas texture.
	 */
	override function doDispose() {
		texture.release();
	}

	/**
	 * Construct an atlas from a texture and a XML file.
	 * @param xmlPath The path to the XML file.
	 */
	public static function fromXml(xmlPath: String) : Atlas {
		var app = Application.getInstance();
		var cache = app.resources;

		var atlas = cache.getResourceUnsafe(xmlPath);
		if (atlas != null) {
			atlas.acquire();
			return cast (atlas, Atlas);
		}

		var root = Path.directory(Sys.programPath());
		var res = Path.join([ root, 'resources', xmlPath ]);
		
		if (!FileSystem.exists(res)) {
			trace("Could not load atlas XML: " + res);
			return null;
		}

		var xml = Xml.parse(File.getContent(res)).firstElement();

		var imgPath = xml.get('imagePath');
		if (!FileSystem.exists(Path.join([ root, 'resources', imgPath ]))) {
			trace("Could not load atlas image: " + imgPath);
			return null;
		}

		var tex = app.resources.acquireImage(imgPath);
	
		if (tex == null) {
			trace("Could not load atlas image: " + imgPath);
			return null;
		}

		var subTextures: Array<SubTexture> = [];
		for (subTextureNode in xml.elements()) {
            if (subTextureNode.nodeName == "SubTexture") {
                subTextures.push(SubTexture.fromXml(subTextureNode));
            }
        }

		var atlas = new Atlas(tex, subTextures);
		atlas.unsafeResetReferences();
		atlas.setParentCache(cache, xmlPath);
		atlas.acquire();
		cache.addResourceUnsafe(xmlPath, atlas);

		return atlas;
	}

}
