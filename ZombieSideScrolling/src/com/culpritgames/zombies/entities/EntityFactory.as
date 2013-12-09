package com.culpritgames.zombies.entities 
{
	import flash.utils.getDefinitionByName;

	/**
	 * @author shaun.mitchell
	 */
	public class EntityFactory {
		private static var _instance : EntityFactory = null;

		public function EntityFactory(enforcer : SingletonEnforcer) : void 
		{
			var play:Player; // allow getDefinitionByName to work
		}

		public static function getInstance() : EntityFactory {
			if (_instance == null) {
				_instance = new EntityFactory(new SingletonEnforcer());
			}

			return _instance;
		}

		public function createNew(type : String) : IEntity 
		{
			var entity : Class = getDefinitionByName("entities." + type) as Class;
			var returnedEntity : IEntity = new entity();

			return returnedEntity;
		}
	}
}

internal class SingletonEnforcer {
}
