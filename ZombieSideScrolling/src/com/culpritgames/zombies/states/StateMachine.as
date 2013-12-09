package com.culpritgames.zombies.states
{
	import flash.utils.getDefinitionByName;
	/**
	 * @author shaun.mitchell
	 */
	public class StateMachine
	{
		// states to allow for dynamic loading
		private var gameState:GameState;
		
		private var _states:Vector.<IGameState> = new Vector.<IGameState>();

		public function changeState(stateFile:String, type:String):void
		{
			if (_states.length > 0)
			{
				var backState:IGameState = _states.pop();
				backState.onDestroy();
				backState = null;
			}

			var c:Class = getDefinitionByName("com.culpritgames.zombies.states."+type) as Class;
			var state:IGameState = new c();
			state.onCreate(stateFile);

			_states.push(state);
		}

		public function popState():void
		{
			if (_states.length > 0)
			{
				var backState:IGameState = _states.pop();
				backState.onDestroy();
				backState = null;
			}
		}

		public function pushState(state:IGameState):void
		{
		}
	}
}
