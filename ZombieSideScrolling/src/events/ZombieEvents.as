package events
{
	import starling.events.Event;
	/**
	 * @author shaun.mitchell
	 */
	public class ZombieEvents extends Event
	{
		public static const ENTITY_LOADED:String = "ZombieEvents_ENTITY_LOADED";
		public static const ASSET_LOADED:String = "ZombieEvents_ASSET_LOADED";
		public static const ALL_ASSETS_LOADED:String = "ZombieEvents_ALL_ASSETS_LOADED";
		public function ZombieEvents(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
