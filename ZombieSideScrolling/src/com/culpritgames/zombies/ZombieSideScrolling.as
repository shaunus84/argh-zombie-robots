package com.culpritgames.zombies
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import com.culpritgames.zombies.core.AssetLoader;
	import com.culpritgames.zombies.entities.EntityFactory;
	import com.culpritgames.zombies.entities.IEntity;
	import com.culpritgames.zombies.events.ZombieEvents;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;

	public class ZombieSideScrolling extends starling.display.Sprite
	{
		private var _entities:Vector.<IEntity> = new Vector.<IEntity>();
		private var _levelXML:XML;

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
			Starling.current.stage.addChild(image);

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
			sortChildrenByY(Starling.current.stage);
			if (_entities && _entities.length > 0)
			{
				for (var i:int = 0; i < _entities.length; i++)
				{
					_entities[i].update();
				}
			}
		}

		function sortChildrenByY(container:Stage):void
		{
			var i:int;
			var childList:Array = new Array();
			i = container.numChildren;
			while (i--)
			{
				childList[i] = container.getChildAt(i);
			}
			childList.sortOn("y", Array.NUMERIC);
			i = container.numChildren;
			while (i--)
			{
				if (childList[i] != container.getChildAt(i))
				{
					container.setChildIndex(childList[i], i);
				}
			}
		}
	}
}
