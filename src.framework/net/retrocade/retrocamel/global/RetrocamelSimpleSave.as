package net.retrocade.retrocamel.global {

	import flash.net.SharedObject;

	import net.retrocade.retrocamel.core.*;

	use namespace retrocamel_int;

	public class RetrocamelSimpleSave {
		/****************************************************************************************************************/
		/**                                                                                                  VARIABLES  */
		/****************************************************************************************************************/

		/**
		 * Shared object used to work with saves
		 */
		private static var currentSharedObject:SharedObject;

		/**
		 * An array of shared objects: storagename => SharedObject
		 */
		private static var sharedObjects:Array = [];


		/****************************************************************************************************************/
		/**                                                                                                  FUNCTIONS  */
		/****************************************************************************************************************/

		public function RetrocamelSimpleSave() {
			new Error("Can't instantiate SaveLoad object - please use static methods only!")
		}

		public static function setStorage(storageName:String):void {
			if (!storageName || storageName.length == 0)
				throw new ArgumentError("Invalid storage name");

			if (sharedObjects[storageName])
				currentSharedObject = sharedObjects[storageName];
			else {
				currentSharedObject = SharedObject.getLocal(storageName, "/");
				sharedObjects[storageName] = currentSharedObject;
			}
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Save & Load
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Writes data to the currently set SharedObject or the one with a specified name.
		 * If you try to access a storage which hasn't been previosly set even once you'll get an error.
		 * @param dataName Name of the data to save
		 * @param data Value to save
		 * @param storageName Optional custom storage name
		 */
		public static function write(dataName:String, data:*, storageName:String = null):void {
			var so:SharedObject;

			if (storageName) {
				if (!sharedObjects[storageName])
					throw new Error("Tried to access not yet created storage: " + storageName);

				so = sharedObjects[storageName];
			} else
				so = currentSharedObject;

			currentSharedObject.data[dataName] = data;
		}

		/**
		 * Reads data from the currently set SharedObject or the one with a specified name. If the data was not set
		 * the default value will be retrieved instead.
		 * If you try to access a storage which hasn't been previosly set even once you'll get an error.
		 * @param dataName Name of the data to read
		 * @param defaultVal Default value to return if no data was found
		 * @param storageName Optional custom storage name
		 * @return Previously written data
		 */
		public static function read(dataName:String, defaultVal:*, storageName:String = null):* {
			var so:SharedObject;
			if (storageName) {
				if (!sharedObjects[storageName])
					throw new Error("Tried to access not yet created storage: " + storageName);

				so = sharedObjects[storageName];
			} else
				so = currentSharedObject;

			if (!so.data.hasOwnProperty(dataName))
				return defaultVal;

			return so.data[dataName];
		}

		/**
		 * Writes data to the currently set SharedObject or the one with a specified name.
		 * Also perfoorms a flush.
		 * If you try to access a storage which hasn't been previosly set even once you'll get an error.
		 * @param dataName Name of the data to save
		 * @param data Value to save
		 * @param storageName Optional custom storage name
		 */
		public static function writeFlush(dataName:String, data:*, storageName:String = null):void {
			write(dataName, data, storageName);
			flush();
		}

		/**
		 * Removed data from the currently set SharedObject or the one with a specified name.
		 * If you try to access a storage which hasn't been previosly set even once you'll get an error.
		 * @param name Name of the ddata to remove
		 * @param storageName Optional custom storage name
		 */
		public static function deleteData(name:String, storageName:String = null):void {
			var so:SharedObject;
			if (storageName) {
				if (!sharedObjects[storageName])
					throw new Error("Tried to access not yet created storage: " + storageName);

				so = sharedObjects[storageName];
			} else
				so = currentSharedObject;

			delete so.data[name];
		}

		/**
		 * Flushes the currently set SharedObject or the one with a specified name.
		 * If you try to access a storage which hasn't been previosly set even once you'll get an error.
		 * @param size The requested diskspace
		 * @param storageName Optional custom storage name
		 */
		public static function flush(size:int = 0, storageName:String = null):void {
			var so:SharedObject;
			if (storageName) {
				if (!sharedObjects[storageName])
					throw new Error("Tried to access not yet created storage: " + storageName);

				so = sharedObjects[storageName];
			} else
				so = currentSharedObject;

			so.flush(size);
		}

	}
}