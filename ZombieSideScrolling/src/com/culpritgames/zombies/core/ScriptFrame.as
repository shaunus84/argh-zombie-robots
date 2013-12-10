package com.culpritgames.zombies.core
{

	/**
	 * @author shaun.mitchell
	 */
	public class ScriptFrame implements IScriptFrame
	{
		private var _imageLeft:String;
		private var _imageRight:String;
		private var _scripts:Vector.<ScriptValue> = new Vector.<ScriptValue>();
		private var _tweens:Vector.<TweenValue> = new Vector.<TweenValue>();
		
		public function set imageLeft(image:String):void
		{
			_imageLeft = image;
		}

		public function set imageRight(image:String):void
		{
			_imageRight = image;
		}

		public function get scripts():Vector.<ScriptValue>
		{
			return _scripts;
		}

		public function get imageLeft():String
		{
			return _imageLeft;
		}

		public function get imageRight():String
		{
			return _imageRight;
		}

		public function get tweens():Vector.<TweenValue>
		{
			return _tweens;
		}
	}
}
