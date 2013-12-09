package 
{
	import core.AssetLoader;
	import core.QuadTree;

	import entities.EntityFactory;
	import entities.IEntity;

	import events.ZombieEvents;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ZombieSideScrolling extends Sprite
	{
		private var _entities:Vector.<IEntity> = new Vector.<IEntity>();
		private var _levelXML:XML;
		private var _quadtree:QuadTree = new QuadTree(0, new Rectangle(0, 0, 640, 480));

		public function ZombieSideScrolling()
		{
			AssetLoader._scaling = 0.5;
			DEFINE::LOCAL
			{
				loadLevel("as3-workspace/argh-zombie-robots/ZombieSideScrolling/assets/config/level1.xml");
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

			var ents:XMLList = _levelXML.entities.entity;

			for (var i:int = 0; i < ents.length(); i++)
			{
				var entity:IEntity = EntityFactory.getInstance().createNew(ents[i].@type);
				var pos:Array = String(ents[i].@startPos).split(',');
				entity.create(ents[i].@spriteName, ents[i].@startAnim, new Point(Number(pos[0]), Number(pos[1])), Number(ents[i].@scaling), Number(ents[i].@moveSpeed));
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

		private function sortChildrenByY():void
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
					childList.sort(sortYandAttack);
					j = objs.length;
					for (var k:int = objs.length - 1; k >= 0; k--)
					{
						Starling.current.stage.setChildIndex(IEntity(childList[k]).spriterClip, k);
					}
				}
			}
		}
		
		function sortYandAttack(a:IEntity, b:IEntity):int
		{
			if(a.y > b.y)
			{
				return 1;
			}
			
			if(a.playingAttack)
			{
				return 1;
			}
			
			return -1;
		}
	}
}
