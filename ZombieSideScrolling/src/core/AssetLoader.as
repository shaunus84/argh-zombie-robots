package core {
	import events.ZombieEvents;

	import starling.display.Sprite;

	import treefortress.spriter.SpriterClip;
	import treefortress.spriter.SpriterLoader;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;

	/**
	 * @author shaun.mitchell
	 */
	public class AssetLoader extends Sprite {
		private static var _instance : AssetLoader = null;
		private var textures : Array = new Array();
		private var _currentNumAssetsRemaining : int;
		public static var _scaling : Number;
		private static var spriterLoader : SpriterLoader = new SpriterLoader();
		private var spritesToLoad : Array = new Array();

		public function AssetLoader(enforcer : SingletonEnforcer) : void {
		}

		public function getSprite(spriteID : String) : SpriterClip {
			return spriterLoader.getSpriterClip(spriteID);
		}

		public function getTexture(textureID : String) : Bitmap {
			if (textures[textureID]) {
				return textures[textureID];
			} else {
				throw new Error("Texture " + textureID + " does not exist in AssetLoader");
			}
		}

		public static function getInstance() : AssetLoader {
			if (_instance == null) {
				_instance = new AssetLoader(new SingletonEnforcer());
			}

			return _instance;
		}

		public function loadAssets(list : XMLList) : void {
			_currentNumAssetsRemaining = list.length();

			for (var i : int = 0; i < list.length(); i++) {
				if (list[i].@type == "sprite") {
					DEFINE::LOCAL {
						spritesToLoad.push(File.documentsDirectory.resolvePath("as3-workspace/argh-zombie-robots/ZombieSideScrolling/" + list[i].@file).url);
					}

					DEFINE::PACKAGE {
						spritesToLoad.push(File.applicationDirectory.resolvePath(list[i].@file).url);

					}
				} else if (list[i].@type == "texture") {
					loadImage(list[i].@file, list[i].@id);
				} else {
					throw new Error("unrecognised type in assets XML");
				}
			}

			loadSprites();
		}

		private function loadSprites() : void {
			// listen for sprite loading to complete
			spriterLoader.completed.add(function(loader : SpriterLoader) : void {
				dispatchEvent(new ZombieEvents(ZombieEvents.ALL_ASSETS_LOADED));

				spriterLoader.completed.remove(function(loader : SpriterLoader) : void {
					dispatchEvent(new ZombieEvents(ZombieEvents.ALL_ASSETS_LOADED));
				});
			});
			spriterLoader.load(spritesToLoad, _scaling);
		}

		private function loadImage(fileName : String, id : String) : void {
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e : Event) : void {
				var bit : Bitmap = new Bitmap();
				bit.bitmapData = Bitmap(LoaderInfo(e.target).content).bitmapData;

				textures[id] = bit;

				_currentNumAssetsRemaining--;

				if (_currentNumAssetsRemaining == 0) {
					dispatchEvent(new ZombieEvents(ZombieEvents.ALL_ASSETS_LOADED));
				}
				
				LoaderInfo(e.currentTarget).removeEventListener(e.type, arguments.callee);
			});

			DEFINE::LOCAL {
				loader.load(new URLRequest(File.documentsDirectory.resolvePath("as3-workspace/argh-zombie-robots/ZombieSideScrolling/" + fileName).url));
			}

			DEFINE::PACKAGE {
				loader.load(new URLRequest(File.applicationDirectory.resolvePath(fileName).url));
			}
		}
	}
}

internal class SingletonEnforcer {
}

