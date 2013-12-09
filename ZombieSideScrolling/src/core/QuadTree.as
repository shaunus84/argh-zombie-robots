package core
{
	import entities.IEntity;
	import flash.geom.Rectangle;

	/**
	 * @author shaun.mitchell
	 */
	public class QuadTree
	{
		private const MAX_OBJECTS:int = 5;
		private const MAX_LEVELS:int = 5;
		private var _level:int = 0;
		private var _objects:Vector.<IEntity>;
		private var _bounds:Rectangle;
		private var _nodes:Vector.<QuadTree>;

		public function QuadTree(level:int, bounds:Rectangle):void
		{
			_level = level;
			_objects = new Vector.<IEntity>();
			_bounds = bounds;
			_nodes = new Vector.<QuadTree>(4, true);
		}

		// Clear the quadtree
		public function clear():void
		{
			_objects.splice(0, _objects.length);
			_nodes.splice(0, _nodes.length);
			
			_objects = null;
			_nodes = null;
			
			_nodes = new Vector.<QuadTree>(4, true);
			_objects = new Vector.<IEntity>();
		}

		private function split():void
		{
			var subWidth:int = int(_bounds.width * 0.5);
			var subHeight:int = int(_bounds.height * 0.5);

			var x:int = int(_bounds.x);
			var y:int = int(_bounds.y);

			_nodes[0] = new QuadTree(_level + 1, new Rectangle(x + subWidth, y, subWidth, subHeight));
			_nodes[1] = new QuadTree(_level + 1, new Rectangle(x, y, subWidth, subHeight));
			_nodes[2] = new QuadTree(_level + 1, new Rectangle(x, y + subHeight, subWidth, subHeight));
			_nodes[3] = new QuadTree(_level + 1, new Rectangle(x + subWidth, y + subHeight, subWidth, subHeight));
		}

		private function getIndex(rect:Rectangle):int
		{
			var index:int = -1;
			var verticalMidpoint:Number = _bounds.x + (_bounds.width * 0.5);
			var horizontalMidpoint:Number = _bounds.y + (_bounds.height * 0.5);

			// Object can completely fit within the top quadrants
			var topQuadrant:Boolean = (rect.y < horizontalMidpoint && rect.y + rect.height < horizontalMidpoint);
			// Object can completely fit within the bottom quadrants
			var bottomQuadrant:Boolean = (rect.y > horizontalMidpoint);

			// Object can completely fit within the left quadrants
			if (rect.x < verticalMidpoint && rect.x + rect.width < verticalMidpoint)
			{
				if (topQuadrant)
				{
					index = 1;
				}
				else if (bottomQuadrant)
				{
					index = 2;
				}
			}
			// Object can completely fit within the right quadrants
			else if (rect.x > verticalMidpoint)
			{
				if (topQuadrant)
				{
					index = 0;
				}
				else if (bottomQuadrant)
				{
					index = 3;
				}
			}

			return index;
		}

		public function insert(ent:IEntity):void
		{
			if (_nodes[0] != null)
			{
				var index:int = getIndex(ent.getBoundingRect());

				if (index != -1)
				{
					_nodes[index].insert(ent);

					return;
				}
			}

			_objects.push(ent);

			if (_objects.length > MAX_OBJECTS && _level < MAX_LEVELS)
			{
				if (_nodes[0] == null)
				{
					split();
				}

				var i:int = 0;
				while (i < _objects.length)
				{
					var index2:int = getIndex(_objects[i].getBoundingRect());
					if (index2 != -1)
					{
						_nodes[index2].insert(_objects[i]);
						_objects.splice(_objects.indexOf(_objects[i]), _objects.indexOf(_objects[i]) + 1);
					}
					else
					{
						i++;
					}
				}
			}
		}

		public function retrieve(returnObjects:Vector.<IEntity>, ent:IEntity):Vector.<IEntity>
		{
			var index:int = getIndex(ent.getBoundingRect());
			if (index != -1 && _nodes[0] != null)
			{
				_nodes[index].retrieve(returnObjects, ent);
			}

			for (var i:int = 0; i < _objects.length; i++)
			{
				returnObjects.push(_objects[i]);
			}

			return returnObjects;
		}
	}
}
