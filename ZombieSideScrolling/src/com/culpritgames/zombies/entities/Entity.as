package com.culpritgames.zombies.entities
{
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.Sprite;
	import treefortress.spriter.SpriterClip;
	import com.culpritgames.zombies.core.AssetLoader;
	import com.culpritgames.zombies.maths.Vec2;
	import flash.geom.Point;

	/**
	 * @author shaun.mitchell
	 */
	public class Entity extends Sprite implements IEntity
	{
		protected var _spriterClip:SpriterClip;
		protected var _playingRun:Boolean = false;
		protected var _playingIdle:Boolean = true;
		protected var _playingAttack:Boolean = false;
		protected var _allowedToAttack:Boolean = true;
		protected var _spriteName:String;
		protected var _startAnim:String;
		protected var _startPos:Point;
		protected var _scaling:Number;
		protected var _moveSpeed:Number;
		protected var _velocity:Vec2 = new Vec2();

		public function create(container:Sprite, spriteName:String, startAnim:String, startPos:Point, scaling:Number, moveSpeed:Number):void
		{
			_spriteName = spriteName;
			_startAnim = startAnim;
			_startPos = startPos;
			_scaling = scaling;
			_moveSpeed = moveSpeed;
			
			_spriterClip = AssetLoader.getInstance().getSprite(_spriteName);
			_spriterClip.setPosition(_startPos.x, _startPos.y);
			_spriterClip.play(_startAnim);
			container.addChild(_spriterClip);
			Starling.juggler.add(_spriterClip);

			handleFrameListeners();
		}

		public function update():void
		{
			if ((_spriterClip.x + _velocity.x) > 0 && (_spriterClip.x + _velocity.x) < 640)
			{
				_spriterClip.x += _velocity.x;
			}
			
			if ((_spriterClip.y + _velocity.y) < 480 && (_spriterClip.y + _velocity.y) > 250)
			{
				_spriterClip.y += _velocity.y;
			}

			if (_velocity.x > 0)
			{
				if (_spriterClip.scaleX != -1)
				{
					_spriterClip.scaleX = -1;
				}
			}
			else if (_velocity.x < 0)
			{
				if (_spriterClip.scaleX != 1)
				{
					_spriterClip.scaleX = 1;
				}
			}

			if (!_playingAttack)
			{
				if (_velocity.x != 0 || _velocity.y != 0)
				{
					if (!_playingRun)
					{
						_spriterClip.play("run");
						_playingRun = true;
						_playingIdle = false;
					}
				}
				else
				{
					if (!_playingIdle)
					{
						_spriterClip.play("idle");
						_playingIdle = true;
						_playingRun = false;
					}
				}
			}
		}

		public function handleFrameListeners():void
		{
			// To determing when an animation has completed, just listen for the animationComplete signal.
			_spriterClip.animationComplete.add(function(clip:SpriterClip)
			{
				if (clip.animation.name == "attack" || clip.animation.name == "attackUp")
				{
					_playingAttack = false;
				}
			});
		}

		public override function get y():Number
		{
			return _spriterClip.y;
		}

		public function getBoundingRect():Rectangle
		{
			return new Rectangle(_spriterClip.x, _spriterClip.y, _spriterClip.width * _scaling, _spriterClip.height * _scaling);
		}

		public function get spriterClip():SpriterClip
		{
			return _spriterClip;
		}
	}
}
