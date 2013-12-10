package com.culpritgames.zombies.states {
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	import com.culpritgames.zombies.FileNameResolver;
	import com.culpritgames.zombies.core.AssetLoader;
	import com.culpritgames.zombies.core.QuadTree;
	import com.culpritgames.zombies.core.ScriptedSequence;
	import com.culpritgames.zombies.entities.EntityFactory;
	import com.culpritgames.zombies.entities.IEntity;
	import com.culpritgames.zombies.events.ZombieEvents;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author shaun.mitchell
	 */
	public class GameState implements IGameState
	{
		// xml file describing this state's assets and level file
		private var _stateXML:XML;
		// the entities for this state
		private var _entities:Vector.<IEntity> = new Vector.<IEntity>();
		// a quadtree for this state
		private var _quadtree:QuadTree = new QuadTree(0, new Rectangle(0, 0, 640, 480));
		private var _entityContainer:Sprite = new Sprite();

		public function onCreate(stateName:String):void
		{
			// grab xml for this state
			var file:File = FileNameResolver.resolveFilename(FileNameResolver.STATES_LOCATION + stateName + ".xml");

			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			var text:String = fs.readUTFBytes(file.size);
			
			var sequence:ScriptedSequence = new ScriptedSequence();
			sequence.loadSequence("sequence1.xml");

//			_stateXML = XML(text);
//
//			// load needed assets for the state
//			AssetLoader.getInstance().addEventListener(ZombieEvents.ALL_ASSETS_LOADED, onAssetsLoaded);
//			AssetLoader.getInstance().loadAssets(_stateXML.assets.asset);
		}

		protected function onAssetsLoaded(e:ZombieEvents):void
		{
			var image:Image = Image.fromBitmap(AssetLoader.getInstance().getTexture("lab"));
			Starling.current.stage.addChild(image);

			var ents:XMLList = _stateXML.entities.entity;

			// populate display list
			for (var i:int = 0; i < ents.length(); i++)
			{
				var entity:IEntity = EntityFactory.getInstance().createNew(ents[i].@type);
				var pos:Array = String(ents[i].@startPos).split(',');
				entity.create(_entityContainer, ents[i].@childName, ents[i].@spriteName, ents[i].@startAnim, new Point(Number(pos[0]), Number(pos[1])), Number(ents[i].@scaling), Number(ents[i].@moveSpeed));
				_entities.push(entity);
			}

			Starling.current.stage.addChild(_entityContainer);

			Starling.current.showStats = true;
			Starling.current.stage.addEventListener(starling.events.Event.ENTER_FRAME, onUpdate);

		}

		public function onDestroy():void
		{
			Starling.current.stage.removeEventListener(starling.events.Event.ENTER_FRAME, onUpdate);
			_quadtree.clear();
			AssetLoader.getInstance().clearAssets();
		}

		public function onUpdate(e:starling.events.Event):void
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
					childList.sortOn("y", Array.NUMERIC);
					j = objs.length;
					for (var k:int = objs.length - 1; k >= 0; k--)
					{
						_entityContainer.setChildIndex(IEntity(childList[k]).spriterClip, k);
					}
				}
			}
		}
	}
}
