package com.culpritgames.zombies.entities
{
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import flash.geom.Point;

	/**
	 * @author shaun.mitchell
	 */
	public class Player extends Entity
	{
		private var _movingLeft:Boolean = false;
		private var _movingRight:Boolean = false;
		private var _movingUp:Boolean = false;
		private var _movingDown:Boolean = false;

		public function Player()
		{
		}

		public override function create(container:Sprite, spriteName:String, startAnim:String, startPos:Point, scaling:Number, moveSpeed:Number):void
		{
			super.create(container, spriteName, startAnim, startPos, scaling, moveSpeed);

			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		private function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				// ---- MOVEMENT ---------
				// right
				case 39:
					if (!_playingAttack && !_movingLeft)
					{
						_velocity.x = _moveSpeed;
						_movingRight = true;
					}
					break;
				// left
				case 37:
					if (!_playingAttack && !_movingRight)
					{
						_velocity.x = -_moveSpeed;
						_movingLeft = true;
					}
					break;
				// up
				case 38:
					if (!_playingAttack && !_movingDown)
					{
						_velocity.y = -_moveSpeed;
						_movingUp = true;
					}
					break;
				// down
				case 40:
					if (!_playingAttack && !_movingUp)
					{
						_velocity.y = _moveSpeed;
						_movingDown = true;
					}
					break;
				// ------ ATTACKS -------
				case 65:
					// a key
					if (_allowedToAttack)
					{
						if (!_playingAttack)
						{
							_spriterClip.play("attack");
							_playingAttack = true;
							_playingRun = false;
							_playingIdle = false;
							_allowedToAttack = false;
						}
					}
					_velocity.x = 0;
					_velocity.y = 0;
					break;
				case 83:
					// s key
					if (_allowedToAttack)
					{
						if (!_playingAttack)
						{
							_spriterClip.play("attackUp");
							_playingAttack = true;
							_playingRun = false;
							_playingIdle = false;
							_allowedToAttack = false;
						}
					}
					_velocity.x = 0;
					_velocity.y = 0;
					break;
				default:
			}
		}

		private function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case 39:
					if (!_movingLeft)
					{
						_velocity.x = 0.0;
						_movingRight = false;
					}
					break;
				case 37:
					if (!_movingRight)
					{
						_velocity.x = 0.0;
						_movingLeft = false;
					}
					break;
				case 38:
					if (!_movingDown)
					{
						_velocity.y = 0.0;
						_movingUp = false;
					}
					break;
				case 40:
					if (!_movingUp)
					{
						_velocity.y = 0.0;
						_movingDown = false;
					}
					break;
				case 65:
					_allowedToAttack = true;
					break;
				case 83:
					_allowedToAttack = true;
					break;
				default:
			}
		}
	}
}

