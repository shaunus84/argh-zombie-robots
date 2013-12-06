package com.culpritgames.zombies
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import com.culpritgames.zombies.core.AssetLoader;
	import com.culpritgames.zombies.core.QuadTree;
	import com.culpritgames.zombies.entities.EntityFactory;
	import com.culpritgames.zombies.entities.IEntity;
	import com.culpritgames.zombies.events.ZombieEvents;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ZombieSideScrolling extends starling.display.Sprite
	{
		private var _entities:Vector.<IEntity> = new Vector.<IEntity>();
		private var _levelXML:XML;
		private var _quadtree:QuadTree = new QuadTree(0, new Rectangle(0, 0, 640, 480));

		public function ZombieSideScrolling()
		{
			AssetLoader._scaling = 0.5;
			DEFINE::LOCAL
			{
				loadLevel("workspace/ZombieSideScrolling/assets/config/level1.xml");
			}

			DEFINE::PACKAGE
			{
				loadLevel("assets/config/level1.xml");
			}

			Starling.current.stage.addEventListener(starling.events.Event.ENTER_FRAME, update);
		}

		private function loadLevel(levelFile:String):void
		{
			DEFINE::LOCAL
			{
				var file:File = File.documentsDirectory.resolvePath(levelFile);
			}

			DEFINE::PACKAGE
			{
				var file:File = File.applicationDirectory.resolvePath(levelFile);
			}

			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			var text:String = fs.readUTFBytes(file.size);

			_levelXML = XML(text);

			AssetLoader.getInstance().addEventListener(ZombieEvents.ALL_ASSETS_LOADED, onAssetsLoaded);
			AssetLoader.getInstance().loadAssets(_levelXML.assets.asset);
		}

		private function onAssetsLoaded(e:ZombieEvents):void
		{
			var image:Image = Image.fromBitmap(AssetLoader.getInstance().getTexture("backdrop"));
			// Starling.current.stage.addChild(image);

			var entities:XMLList = _levelXML.entities.entity;

			for (var i:int = 0; i < entities.length(); i++)
			{
				var entity:IEntity = EntityFactory.getInstance().createNew(entities[i].@type);
				var pos:Array = String(entities[i].@startPos).split(',');
				entity.create(entities[i].@spriteName, entities[i].@startAnim, new Point(Number(pos[0]), Number(pos[1])), Number(entities[i].@scaling), Number(entities[i].@moveSpeed));
				_entities.push(entity);
			}

			Starling.current.showStats = true;
		}

		private function update(event:starling.events.Event):void
		{
			_quadtree.clear();
			if (_entities && _entities.length > 0)
			{
				for (var i:int = 0; i < _entities.length; i++)
				{
					_quadtree.insert(_entities[i]);
				}
			}

			sortChildrenByY();

			if (_entities && _entities.length > 0)
			{
				for (var j:int = 0; j < _entities.length; j++)
				{
					_entities[j].update();
				}
			}
		}

		function sortChildrenByY():void
		{
			if (_entities && _entities.length > 0)
			{
				var objs:Vector.<IEntity>;
				for (var i:int = 0; i < _entities.length; i++)
				{
					objs = new Vector.<IEntity>();
					_quadtree.retrieve(objs, _entities[i]);

					var j:int;
					var childList:Array = new Array();
					j = objs.length;
					while (j--)
					{
						childList[j] = objs[j];
					}
					childList.sortOn("y", Array.NUMERIC);
					j = objs.length;
					for (var k:int = objs.length - 1; k >= 0; k--)
					{
						Starling.current.stage.setChildIndex(IEntity(childList[k]).spriterClip, k);
					}
				}
			}
		}
	}
}
