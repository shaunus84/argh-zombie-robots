package com.culpritgames.zombies.states
{
	import starling.events.Event;
	/**
	 * @author shaun.mitchell
	 */
	public interface IGameState
	{
		function onCreate(stateFile:String):void;
		function onDestroy():void;
		
		function onUpdate(e:starling.events.Event):void;
	}
}
