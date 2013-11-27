package com.culpritgames.zombies.entities
{
	import flash.geom.Point;
	/**
	 * @author shaun.mitchell
	 */
	public interface IEntity
	{
		function create(spriteName:String, startAnim:String, startPos:Point, scaling:Number, moveSpeed:Number):void
		function update():void
		function handleFrameListeners():void;
		function getY():Number;
	}
}
