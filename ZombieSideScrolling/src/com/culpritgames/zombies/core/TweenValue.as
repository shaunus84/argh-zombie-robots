package com.culpritgames.zombies.core
{
	import flash.geom.Point;
	/**
	 * @author shaun.mitchell
	 */
	public class TweenValue
	{
		private var _to:Point;
		private var _animation:String;
		private var _entityName:String;
		private var _delay:Number;
		
		public function TweenValue(to:Point, animation:String, entityName:String, delay:Number):void
		{
			_to = to;
			_animation = animation;
			_entityName = entityName;
			_delay = delay;
		}

		public function get to():Point
		{
			return _to;
		}

		public function get animation():String
		{
			return _animation;
		}
		
		public function get entityName():String
		{
			return _entityName;
		}

		public function get delay():Number
		{
			return _delay;
		}
	}
}
