package com.culpritgames.zombies.entities
{
	import starling.display.Sprite;
	import treefortress.spriter.SpriterClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author shaun.mitchell
	 */
	public interface IEntity
	{
		function create(container:Sprite, spriteName:String, startAnim:String, startPos:Point, scaling:Number, moveSpeed:Number):void
		function update():void
		function handleFrameListeners():void;
		function get y():Number;
		function getBoundingRect():Rectangle;
		function get spriterClip():SpriterClip;
	}
}
