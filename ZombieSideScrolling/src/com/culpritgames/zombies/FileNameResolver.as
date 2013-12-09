package com.culpritgames.zombies
{
	import flash.filesystem.File;

	/**
	 * @author shaun.mitchell
	 */
	public class FileNameResolver
	{
		DEFINE::LOCAL
		{
			public static var ASSETS_LOCATION:String = "repos/argh-zombie-robots/ZombieSideScrolling/assets";
		}
		DEFINE::PACKAGE
		{
			public static var ASSETS_LOCATION:String = "/assets";
		}
		public static var STATES_LOCATION:String = ASSETS_LOCATION + "/states/";
		public static var SCRIPTS_LOCATION:String = ASSETS_LOCATION + "/script/scripts/";
		public static var SPRITES_LOCATION:String = ASSETS_LOCATION + "/entities/";
		public static var TEXTURES_LOCATION:String = ASSETS_LOCATION + "/textures/";

		public static function resolveFilename(file:String):File
		{
			var returnFile:File = null;
			DEFINE::LOCAL
			{
				returnFile = File.userDirectory.resolvePath(file);
				trace(returnFile.url);
			}

			DEFINE::PACKAGE
			{
				returnFile = File.applicationDirectory.resolvePath(file);
			}

			return returnFile;
		}
	}
}
