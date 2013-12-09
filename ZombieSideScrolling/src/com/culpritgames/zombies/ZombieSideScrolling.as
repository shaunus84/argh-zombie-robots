package com.culpritgames.zombies 
{
	import starling.display.Sprite;

	import com.culpritgames.zombies.core.AssetLoader;
	import com.culpritgames.zombies.states.StateMachine;

	public class ZombieSideScrolling extends Sprite {
		private var _stateMachine : StateMachine = new StateMachine();

		public function ZombieSideScrolling() {
			AssetLoader._scaling = 0.5;

			_stateMachine.changeState("level1-state", "GameState");
		}
	}
}
