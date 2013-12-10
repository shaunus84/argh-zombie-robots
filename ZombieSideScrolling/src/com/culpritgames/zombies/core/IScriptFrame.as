package com.culpritgames.zombies.core
{
	/**
	 * @author shaun.mitchell
	 */
	public interface IScriptFrame
	{
		function set imageLeft(image:String):void;
		function set imageRight(image:String):void;
		
		function get imageLeft():String;
		function get imageRight():String;
		
		function get scripts():Vector.<ScriptValue>;
		function get tweens():Vector.<TweenValue>;
	}
}
