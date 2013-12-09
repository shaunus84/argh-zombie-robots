package com.culpritgames.zombies
{
	import starling.core.Starling;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @author shaun.mitchell
	 */
	[SWF(width='640', height='480', backgroundColor="#000000")]
	public class Main extends Sprite
	{
		private var _starling:Starling;

		public function Main():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			
			_starling = new Starling(ZombieSideScrolling, stage);
			_starling.start();
		}
	}
}
