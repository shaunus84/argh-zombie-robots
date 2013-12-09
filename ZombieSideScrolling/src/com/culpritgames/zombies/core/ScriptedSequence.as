package com.culpritgames.zombies.core
{
	import starling.events.KeyboardEvent;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import com.culpritgames.zombies.FileNameResolver;
	import com.culpritgames.zombies.events.ZombieEvents;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
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
		private var _scriptBuffer:String;
		private var _textQuad:Quad;
		private var _leftImageName:String;
		private var _rightImageName:String;
		private var _leftImage:Image;
		private var _rightImage:Image;
		private var _currentFrame:int = 0;
		private var _currentScript:int = 0;
		private var _numScripts:int = 0;
		private var _maxFrames:int = 0;

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

			_textQuad = new Quad(Starling.current.stage.width * 0.85, Starling.current.stage.height * 0.3, 0x9899ff99, false);
			_textQuad.blendMode = BlendMode.MULTIPLY;
			_textQuad.x = (Starling.current.stage.width - _textQuad.width) * 0.5;
			_textQuad.y = ((Starling.current.stage.height * 0.95) - _textQuad.height);
			Starling.current.stage.addChild(_textQuad);

			var leftImage:Image = Image.fromBitmap(AssetLoader.getInstance().getTexture("face1"));
			Starling.current.stage.addChild(leftImage);

			var rightImage:Image = Image.fromBitmap(AssetLoader.getInstance().getTexture("face2"));
			rightImage.x = Starling.current.stage.width - rightImage.width;
			Starling.current.stage.addChild(rightImage);

			_scriptBuffer = "Let's test the machine!";
			_tf = new TextField(_textQuad.width, _textQuad.height, "");
			_tf.x = _textQuad.x;
			_tf.y = _textQuad.y;
			_tf.fontSize = 17;
			_tf.color = 0xffffff;
			_tf.hAlign = HAlign.LEFT;
			_tf.vAlign = VAlign.TOP;
			Starling.current.stage.addChild(_tf);

			_maxLength = _scriptBuffer.length;

			// setTimeout(updateMessage, 50);

			populateFrames();
		}

		private function populateFrames():void
		{
			var frames:XMLList = _scriptXML.scripts.frames;
			for (var i:int = 0; i < frames.length(); i++)
			{
				var newframe:IScriptFrame = new ScriptFrame();
				newframe.imageLeft = frames[0].frame.@leftImage;
				newframe.imageRight = frames[0].frame.@rightImage;

				var scripts:XMLList = frames[0].frame.script;
				trace(String(scripts))
				for (var j:int = 0; j < scripts.length(); j++)
				{
					var scriptValue:ScriptValue = new ScriptValue(scripts[j], scripts[j].@speaker)
					newframe.scripts.push(scriptValue);
				}

				_frames.push(newframe);
			}
			
			start();
		}

		private function updateMessage():void
		{
			_tf.text += _scriptBuffer.charAt(_currentChar);
			_currentChar++;

			if (_currentChar <= _maxLength)
			{
				setTimeout(updateMessage, 50);
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

			if (_currentScript > _numScripts)
			{
				_currentFrame++;
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

			_tf.text = _frames[_currentFrame].scripts[_currentScript].speaker + "\n\n";

			_scriptBuffer = _frames[_currentFrame].scripts[_currentScript].text;

			setTimeout(updateMessage, 50);
		}

		private function incrementFrame():void
		{
			_tf.text = "";
			// get images for this frame
			_leftImageName = _frames[_currentFrame].imageLeft;
			_rightImageName = _frames[_currentFrame].imageRight;

			// remove any old ones
			if (Starling.current.stage.contains(_leftImage))
			{
				Starling.current.stage.removeChild(_leftImage);
			}

			if (Starling.current.stage.contains(_rightImage))
			{
				Starling.current.stage.removeChild(_rightImage);
			}

			// add new ones
			_leftImage = Image.fromBitmap(AssetLoader.getInstance().getTexture(_leftImageName));
			Starling.current.stage.addChild(_leftImage);

			_rightImage = Image.fromBitmap(AssetLoader.getInstance().getTexture(_rightImageName));
			_rightImage.x = Starling.current.stage.width - _rightImage.width;
			Starling.current.stage.addChild(_rightImage);

			_numScripts = _frames[_currentFrame].scripts.length;

			_tf.text = _frames[_currentFrame].scripts[0].speaker + "\n\n";

			_scriptBuffer = _frames[_currentFrame].scripts[0].text;

			setTimeout(updateMessage, 50);
		}

		public function start():void
		{
			_tf.text = "";
			// get images for this frame
			_leftImageName = _frames[_currentFrame].imageLeft;
			_rightImageName = _frames[_currentFrame].imageRight;

			// remove any old ones
			if (Starling.current.stage.contains(_leftImage))
			{
				Starling.current.stage.removeChild(_leftImage);
			}

			if (Starling.current.stage.contains(_rightImage))
			{
				Starling.current.stage.removeChild(_rightImage);
			}

			// add new ones
			_leftImage = Image.fromBitmap(AssetLoader.getInstance().getTexture(_leftImageName));
			Starling.current.stage.addChild(_leftImage);

			_rightImage = Image.fromBitmap(AssetLoader.getInstance().getTexture(_rightImageName));
			_rightImage.x = Starling.current.stage.width - _rightImage.width;
			Starling.current.stage.addChild(_rightImage);

			_numScripts = _frames[_currentFrame].scripts.length;

			_tf.text = _frames[_currentFrame].scripts[0].speaker + "\n\n";

			_scriptBuffer = _frames[_currentFrame].scripts[0].text;

			setTimeout(updateMessage, 50);
		}

		public function remove():void
		{
		}
	}
}
