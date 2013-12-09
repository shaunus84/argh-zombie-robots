package com.culpritgames.zombies.core
{
	/**
	 * @author shaun.mitchell
	 */
	public class ScriptValue
	{
		private var _text:String;
		private var _speaker:String;
		
		public function ScriptValue(text:String, speaker:String):void
		{
			_text = text;
			_speaker = speaker;
		}

		public function get text():String
		{
			return _text;
		}

		public function get speaker():String
		{
			return _speaker;
		}
	}
}
