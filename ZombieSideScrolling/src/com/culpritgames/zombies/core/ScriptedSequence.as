package com.culpritgames.zombies.core
{
	import treefortress.spriter.SpriterClip;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import com.culpritgames.zombies.FileNameResolver;
	import com.culpritgames.zombies.entities.Entity;
	import com.culpritgames.zombies.entities.EntityFactory;
	import com.culpritgames.zombies.entities.IEntity;
	import com.culpritgames.zombies.events.ZombieEvents;
	import com.greensock.TweenLite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	/**
	 * @author shaun.mitchell
	 */
	public class ScriptedSequence
	{
		private var _frames:Vector.<IScriptFrame> = new Vector.<IScriptFrame>();
		private var _scriptXML:XML;
		private var _currentChar:int = 0;
		private var _maxLength:int = 0;
		private var _tf:TextField;
		private var _nameField:TextField;
		private var _scriptBuffer:String;
		private var _textQuad:Quad;
		private var _nameQuad:Quad;
		private var _leftImageName:String;
		private var _rightImageName:String;
		private var _currentFrame:int = 0;
		private var _currentScript:int = 0;
		private var _numScripts:int = 0;
		private var _numTweens:int = 0;
		private var _entities:Vector.<IEntity> = new Vector.<IEntity>();
		// a quadtree for this state
		private var _quadtree:QuadTree = new QuadTree(0, new Rectangle(0, 0, 640, 480));
		private var _entityContainer:Sprite = new Sprite();
		private var _tweensComplete:int = 0;
		private var _maxFrames:int = 0;
		private var _timeOut;

		public function loadSequence(scriptFile:String):void
		{
			var file:File = FileNameResolver.resolveFilename(FileNameResolver.ASSETS_LOCATION + "/script/scripts/" + scriptFile);

			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			var text:String = fs.readUTFBytes(file.size);

			_scriptXML = XML(text);

			// load needed assets for the state
			AssetLoader.getInstance().addEventListener(ZombieEvents.ALL_ASSETS_LOADED, onAssetsLoaded);
			AssetLoader.getInstance().loadAssets(_scriptXML.assets.asset);
		}

		private function onAssetsLoaded(event:ZombieEvents):void
		{
			var image:Image = Image.fromBitmap(AssetLoader.getInstance().getTexture("lab"));
			Starling.current.stage.addChild(image);

			var ents:XMLList = _scriptXML.entities.entity;
			// populate display list
			for (var i:int = 0; i < ents.length(); i++)
			{
				var entity:IEntity = EntityFactory.getInstance().createNew(ents[i].@type);
				var pos:Array = String(ents[i].@startPos).split(',');
				entity.create(_entityContainer, ents[i].@childName, ents[i].@spriteName, ents[i].@startAnim, new Point(Number(pos[0]), Number(pos[1])), Number(ents[i].@scaling), Number(ents[i].@moveSpeed));
				_entities.push(entity);
			}

			Starling.current.stage.addChild(_entityContainer);

			_nameQuad = new Quad(Starling.current.stage.width * 0.85, Starling.current.stage.height * 0.05, 0x88222222, false);
			_nameQuad.blendMode = BlendMode.MULTIPLY;
			_nameQuad.x = (Starling.current.stage.width - _nameQuad.width) * 0.5;
			_nameQuad.y = ((Starling.current.stage.height * 0.75) - _nameQuad.height);
			Starling.current.stage.addChild(_nameQuad);

			_textQuad = new Quad(Starling.current.stage.width * 0.85, Starling.current.stage.height * 0.2, 0x88222222, false);
			_textQuad.blendMode = BlendMode.MULTIPLY;
			_textQuad.x = (Starling.current.stage.width - _textQuad.width) * 0.5;
			_textQuad.y = (_nameQuad.y + _nameQuad.height) + (Starling.current.stage.height * 0.01);
			Starling.current.stage.addChild(_textQuad);

			_scriptBuffer = "Let's test the machine!";

			_tf = new starling.text.TextField(_textQuad.width, _textQuad.height, "");
			_tf.x = _textQuad.x;
			_tf.y = _textQuad.y;
			_tf.fontSize = 17;
			_tf.color = 0xffffff;
			_tf.hAlign = HAlign.LEFT;
			_tf.vAlign = VAlign.TOP;
			Starling.current.stage.addChild(_tf);

			_nameField = new starling.text.TextField(_nameQuad.width, _nameQuad.height, "");
			_nameField.x = _nameQuad.x;
			_nameField.y = _nameQuad.y;
			_nameField.fontSize = 17;
			_nameField.color = 0xffffff;
			_nameField.hAlign = HAlign.CENTER;
			_nameField.vAlign = VAlign.TOP;
			Starling.current.stage.addChild(_nameField);

			_maxLength = _scriptBuffer.length;

			Starling.current.stage.addEventListener(starling.events.Event.ENTER_FRAME, onUpdate);

			// setTimeout(updateMessage, 50);

			populateFrames();
		}

		private function populateFrames():void
		{
			var frames:XMLList = _scriptXML.scripts.frames.frame;
			trace(String(frames))
			for (var i:int = 0; i < frames.length(); i++)
			{
				var newframe:IScriptFrame = new ScriptFrame();
				newframe.imageLeft = frames[i].@leftImage;
				newframe.imageRight = frames[i].@rightImage;

				var scripts:XMLList = frames[i].script;
				for (var j:int = 0; j < scripts.length(); j++)
				{
					var scriptValue:ScriptValue = new ScriptValue(scripts[j], scripts[j].@speaker);
					newframe.scripts.push(scriptValue);
				}

				var tweens:XMLList = frames[i].tween;
				for (var k:int = 0; k < tweens.length(); k++)
				{
					var split:Array = tweens[k].@to.split(",");
					var tweenValue:TweenValue = new TweenValue(new Point(int(split[0]), int(split[1])), tweens[k].@animation, tweens[k].@entityName, Number(tweens[k].@delay));
					newframe.tweens.push(tweenValue);
				}

				_frames.push(newframe);
			}

			_maxFrames = _frames.length;

			start();
		}

		private function updateMessage():void
		{
			_tf.text += _scriptBuffer.charAt(_currentChar);
			_currentChar++;

			if (_currentChar <= _scriptBuffer.length)
			{
				_timeOut = setTimeout(updateMessage, 50);
			}
			else
			{
				Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onSkipToNext);
			}
		}

		private function onSkipToNext(event:KeyboardEvent):void
		{
			Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onSkipToNext);

			_currentScript++;

			if (_currentScript >= _numScripts)
			{
				incrementFrame();
			}
			else
			{
				incrementScript();
			}
		}

		private function incrementScript():void
		{
			_tf.text = "";
			_currentChar = 0;

			_nameField.text = _frames[_currentFrame].scripts[_currentScript].speaker;

			_scriptBuffer = _frames[_currentFrame].scripts[_currentScript].text;

			_timeOut = setTimeout(updateMessage, 50);
		}

		private function incrementFrame():void
		{
			_currentFrame++;

			if (_currentFrame >= _maxFrames)
			{
				return;
			}
			_tf.text = "";
			_currentChar = 0;
			_currentScript = 0;
			// get images for this frame
			_leftImageName = _frames[_currentFrame].imageLeft;
			_rightImageName = _frames[_currentFrame].imageRight;

			trace(Starling.current.stage.numChildren);

			Starling.current.stage.removeChild(Starling.current.stage.getChildByName("leftImage"));
			Starling.current.stage.removeChild(Starling.current.stage.getChildByName("rightImage"));

			trace(Starling.current.stage.numChildren);
			// add new ones
			var leftImage:Image = Image.fromBitmap(AssetLoader.getInstance().getTexture(_leftImageName), true, 1.5);
			leftImage.name = "leftImage";
			leftImage.y = _nameQuad.y - leftImage.height;
			Starling.current.stage.addChild(leftImage);

			var rightImage:Image = Image.fromBitmap(AssetLoader.getInstance().getTexture(_rightImageName), true, 1.5);
			rightImage.name = "rightImage";
			rightImage.x = Starling.current.stage.width - rightImage.width;
			rightImage.y = _nameQuad.y - rightImage.height;
			rightImage.scaleX = -1;
			rightImage.x += rightImage.width;
			Starling.current.stage.addChild(rightImage);

			_numScripts = _frames[_currentFrame].scripts.length;
			_numTweens = _frames[_currentFrame].tweens.length;

			if (_numScripts != 0)
			{
				_nameField.text = _frames[_currentFrame].scripts[0].speaker;

				_scriptBuffer = _frames[_currentFrame].scripts[0].text;

				setTimeout(updateMessage, 50);
			}

			if (_numTweens != 0)
			{
				for (var i:int = 0; i < _numTweens; i++)
				{
					SpriterClip(_entityContainer.getChildByName(_frames[_currentFrame].tweens[i].entityName)).play(_frames[_currentFrame].tweens[i].animation);
					TweenLite.to(_entityContainer.getChildByName(_frames[_currentFrame].tweens[i].entityName), _frames[_currentFrame].tweens[i].delay, {x:_frames[_currentFrame].tweens[i].to.x, y:_frames[_currentFrame].tweens[i].to.y, onComplete:incrementTweens});
				}
			}
		}

		private function incrementTweens():void
		{
			_tweensComplete++;

			if (_tweensComplete == _numTweens)
			{
				incrementFrame();
				_tweensComplete = 0;
			}
		}

		public function start():void
		{
			_tf.text = "";
			// get images for this frame
			_leftImageName = _frames[_currentFrame].imageLeft;
			_rightImageName = _frames[_currentFrame].imageRight;

			// add new ones
			var leftImage:Image = Image.fromBitmap(AssetLoader.getInstance().getTexture(_leftImageName), true, 1.5);
			leftImage.name = "leftImage";
			leftImage.y = _nameQuad.y - leftImage.height;
			Starling.current.stage.addChild(leftImage);

			var rightImage:Image = Image.fromBitmap(AssetLoader.getInstance().getTexture(_rightImageName), true, 1.5);
			rightImage.name = "rightImage";
			rightImage.x = Starling.current.stage.width - rightImage.width;
			rightImage.y = _nameQuad.y - rightImage.height;
			rightImage.scaleX = -1;
			rightImage.x += rightImage.width;
			Starling.current.stage.addChild(rightImage);

			_numScripts = _frames[_currentFrame].scripts.length;
			_numTweens = _frames[_currentFrame].tweens.length;

			_nameField.text = _frames[_currentFrame].scripts[0].speaker;
			_scriptBuffer = _frames[_currentFrame].scripts[0].text;

			if (_numTweens != 0)
			{
				for (var i:int = 0; i < _numTweens; i++)
				{
					TweenLite.to(_entityContainer.getChildByName(_frames[_currentFrame].tweens[i].entityName), 1, {x:_frames[_currentFrame].tweens[i].to.x, y:_frames[_currentFrame].tweens[i].to.y});
				}
			}

			setTimeout(updateMessage, 50);
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

		public function remove():void
		{
		}
	}
}
