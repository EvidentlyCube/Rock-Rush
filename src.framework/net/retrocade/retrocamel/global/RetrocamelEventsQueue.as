package net.retrocade.retrocamel.global {

	import net.retrocade.retrocamel.core.*;

	/**
	 * ...
	 * @author
	 */

	use namespace retrocamel_int;

	public class RetrocamelEventsQueue {
		private static var _eventSetCount:Array;
		private static var _eventData:Array;

		private static var _eventsSet:uint;

		public static var autoClear:Boolean = true;

		retrocamel_int static function initialize():void {
			_eventSetCount = [];
			_eventData = [];

			for (var i:uint = 0; i < RetrocamelCore.settings.eventsCount; i++) {
				_eventSetCount[i] = 0;
				_eventData    [i] = [];
			}
		}

		/**
		 * Clears all events
		 */
		public static function clear():void {
			if (_eventsSet == 0)
				return;

			var eventCount:uint = RetrocamelCore.settings.eventsCount;

			for (var i:uint = 0; i < eventCount; i++) {
				_eventSetCount[i] = 0;
				_eventData    [i].length = 0;
			}

			_eventsSet = 0;
		}

		/**
		 * Clears an event state. Removes all set
		 * @param eventID ID of the event to check
		 */
		public static function clearEvent(eventID:uint):void {
			_eventData[eventID].length = 0;

			if (_eventSetCount[eventID]) {
				_eventSetCount[eventID] = 0;
				_eventsSet--;
			}
		}

		/**
		 * The number of times a specified event has occured
		 * @param eventID ID of the event to check
		 * @return The number of times a specified event has occured
		 */
		public static function getOccurenceCount(eventID:uint):uint {
			return _eventSetCount[eventID];
		}

		/**
		 * The amount of data attached to a specified event
		 * @param eventID ID of the event to check
		 * @return The amount of data attached to the given event
		 */
		public static function getDataCount(eventID:uint):uint {
			return _eventData[eventID].length;
		}

		/**
		 * Whether a given a given event has occured
		 * @param eventID ID of the event to check
		 * @return True if this event has occured
		 */
		public static function occured(eventID:uint):Boolean {
			return _eventSetCount[eventID] != 0;
		}

		/**
		 * Marks the event of the given ID as occured and optionally adds more data to the event
		 * @param eventID ID of the event to mark as occured
		 * @param data Optional data to be added to the event
		 */
		public static function add(eventID:uint, data:* = null):void {
			if (!_eventSetCount[eventID])
				_eventsSet++;

			_eventSetCount[eventID]++;

			if (data)
				_eventData[eventID].push(data);
		}

		/**
		 * Retrieves an array containing all of the data associated with a given event
		 * @param eventID ID of the event
		 * @return Array of data which was previously associated with the data via rEvents:add()
		 */
		public static function getData(eventID:uint):Array {
			return _eventData[eventID];
		}

		/**
		 * Checks if event of any of the IDs in the passed array has occured
		 * @param arrayOfCID Array of IDs
		 * @return True if any of the events has occured
		 */
		public static function occuredArray(arrayOfCID:Array):Boolean {
			for each(var i:uint in arrayOfCID) {
				if (_eventSetCount[i])
					return true;
			}

			return false;
		}

		/**
		 * Checks if an event has occured with a specific data
		 * @param eventID ID of an event to check
		 * @param data Data to check
		 * @return True if the event has occured with data
		 */
		public static function occuredWith(eventID:uint, data:*):Boolean {
			for each(var i:* in _eventData[eventID]) {
				if (i == data)
					return true;
			}
			return false;
		}


		/**
		 * Removes a specific data from an event
		 * @param eventID ID of an event
		 * @param data Data to remove
		 * @return True if the data was found and removed
		 */
		public static function removeData(eventID:uint, data:*):Boolean {
			var found:Boolean = false;
			for (var i:uint = 0, l:uint = _eventData[eventID].length; i < l; i++) {
				if (found) {
					_eventData[eventID][i - 1] = _eventData[eventID][i];

				} else if (_eventData[eventID][i] == data) {
					found = true;
				}
			}

			if (found)
				_eventData[eventID][i].length--;

			return found;
		}
	}
}