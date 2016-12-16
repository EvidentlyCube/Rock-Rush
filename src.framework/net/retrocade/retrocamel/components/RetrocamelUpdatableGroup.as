package net.retrocade.retrocamel.components {

	import net.retrocade.retrocamel.interfaces.IRetrocamelUpdatable;

	final public class RetrocamelUpdatableGroup implements IRetrocamelUpdatable {
		/**
		 * An array of group's objects
		 */
		protected var _objects:Array;

		/**
		 * Returns the amount of not nulled elements in the group
		 */
		public function get length():uint {
			return _objectsArrayLength - _nulledObjectsCount;
		}

		/**
		 * Length of the items arrays
		 */
		protected var _objectsArrayLength:Number = 0;


		/**
		 * HELPER: Counts how many elements were nulled
		 */
		protected var _nulledObjectsCount:uint = 0;

		/**
		 * How many objects are nulled right now
		 */
		public function get nulledObjectsCount():uint {
			return _nulledObjectsCount;
		}

		/**
		 * Amount of Null variables in list which should turn the GC on automatically
		 */
		public var gcThreshold:uint = 10;

		/**
		 * If true automatic GC will use advanced garbage collection
		 */
		public var useAdvancedGc:Boolean = false;

		/**
		 * HELPER: True if the group is currently updating
		 */
		protected var isUpdating:Boolean = false;

		/**
		 * HELPER: Index of the currently updated element
		 */
		protected var updatingIndex:int = -1;

		/**
		 * Constructor
		 */
		public function RetrocamelUpdatableGroup() {
			_objects = [];
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Adding
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Adds an object at the end of the group
		 * @param object rIUpdatable to be added to the group
		 */
		public function add(object:IRetrocamelUpdatable):void {
			_objects[_objectsArrayLength++] = object;
		}

		/**
		 * Adds an object to the group at specified index
		 * @param object rIUpdatable to be added to the group
		 * @param index Index where to add the item to the group
		 */
		public function addAt(object:IRetrocamelUpdatable, index:uint):void {
			if (index > _objectsArrayLength) {
				_objects.length = index - 1;
			}

			_objects.splice(index, 0, object);
			_objectsArrayLength = _objects.length;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Checking
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Checks if specified object is added to given group
		 * @param object Object to check
		 * @return True if this object already resides in the group
		 */
		public function contains(object:IRetrocamelUpdatable):Boolean {
			return _objects.indexOf(object) != -1;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Garbage Collecting
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Removes all Nulled objects from group and fills gap with items from the end of the list.
		 * Order is not retained
		 */
		public function garbageCollect():void {
			var l:uint = _objectsArrayLength;
			var i:uint = 0;

			for (; i < l; ++i) {
				while (_objects[i] == null && i < l) {
					_objects[i] = _objects[--l];
				}
			}

			_objects.length = l;
			_nulledObjectsCount = 0;
			_objectsArrayLength = l;
		}

		/**
		 * Splices all Nulled objects from group, Order is retained.
		 */
		public function garbageCollectAdvanced():void {
			var l:uint = _objectsArrayLength;
			var i:uint = 0;
			var gap:uint = 0;

			for (; i < l; i++) {
				if (_objects[i] == null) {
					gap++;

				} else if (gap) {
					_objects[i - gap] = _objects[i];
				}
			}

			_objectsArrayLength -= gap;
			_objects.length -= gap;
			_nulledObjectsCount = 0;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Retrieving
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Retrieves an rIUpdatable from a given index position
		 * @param    index An index position of the object to be retrieved
		 * @return net.retrocade.retrocamel.interfaces.IRetrocamelUpdatable located at given index
		 */
		public function getAt(index:uint):IRetrocamelUpdatable {
			if (index < _objectsArrayLength) {
				return _objects[index];
			}

			return null;
		}

		/**
		 * Returns a copy of an array of all objects (pretty slow)
		 * @return Array of all objects
		 */
		public function getAll():Array {
			return _objects.concat();
		}

		/**
		 * Returns an array of all objects, the original array used by group. Do NOT modify it!
		 * @return Array of all objects
		 */
		public function getAllOriginal():Array {
			return _objects;
		}

		/**
		 * Returns the first not null object stored
		 * @return First not null object, or null if there are none
		 */
		public function getFirst():IRetrocamelUpdatable {
			var i:uint = 0;
			while (i < _objectsArrayLength) {
				if (_objects[i++]) {
					return _objects[i - 1];
				}
			}
			return null;
		}

		/**
		 * Returns the index of the object added or -1 if not found
		 * @param object Object which index you want to check
		 * @return Index of the object in the group or -1 if the object was not found
		 */
		public function getIndexOf(object:IRetrocamelUpdatable):int {
			return _objects.indexOf(object);
		}


		/**
		 * Removes all elements from the group
		 */
		public function clear():void {
			_objects.length = 0;
			_objectsArrayLength = 0;
			_nulledObjectsCount = 0;
		}

		/**
		 * Nulls the specified object from the group
		 * @param object Object to be nulled
		 */
		public function nullify(object:IRetrocamelUpdatable):void {
			var index:int = _objects.indexOf(object);
			if (index == -1)
				return;

			_nulledObjectsCount++;
			_objects[index] = null;
		}

		/**
		 * Nulls an object from the group at the specified index
		 * @param index Index at which an object has to be nulled
		 */
		public function nullifyAt(index:uint):void {
			if (index < _objects.length) {
				if (_objects[index] != null)
					_nulledObjectsCount++;

				_objects[index] = null;
			}
		}

		/**
		 * Removes the specified object from the group using splice
		 * @param object Object to be removed
		 */
		public function remove(object:IRetrocamelUpdatable):void {
			var index:int = _objects.indexOf(object);
			if (index == -1)
				return;

			_objectsArrayLength--;
			_objects.splice(index, 1);

			if (isUpdating && index < updatingIndex)
				updatingIndex--;
		}

		/**
		 * Removes an object from the group at the specified index using splice
		 * @param index Index at which an object has to be removed
		 */
		public function removeAt(index:uint):void {
			if (index < _objectsArrayLength) {
				_objects.splice(index, 1);
				_objectsArrayLength--;

				if (isUpdating && index < updatingIndex)
					updatingIndex--;
			}
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Updating
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Calls update on all active elements
		 */
		public function update():void {
			if (isUpdating)
				throw new Error("You can't update group when it is already in the process of updating");

			isUpdating = true;
			updatingIndex = 0;

			//try{
			for (var o:IRetrocamelUpdatable; updatingIndex < _objectsArrayLength; updatingIndex++) {
				o = _objects[updatingIndex];

				if (o)
					o.update();
			}
			//} catch(e:*){
			//    isUpdating = false;
			//    updatingIndex = -1;
			//    
			//    throw e;
			//}

			isUpdating = false;
			updatingIndex = -1;

			// Garbage Collect
			if (_nulledObjectsCount > gcThreshold) {
				if (useAdvancedGc) garbageCollectAdvanced(); else garbageCollect();
			}
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Miscellanous
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Counts amount of objects which returned tru when checked agains given function
		 * @param closure Function to be checked against function(o:rIUpdatable):Boolean;
		 * @return Amount of objects which pass the closure call with true
		 */
		public function countByFunction(closure:Function):uint {
			var count:uint = 0;

			for (var o:IRetrocamelUpdatable, i:int = 0; i < _objectsArrayLength; i++) {
				o = _objects[i];
				if (o != null && closure.apply(o))
					count++;
			}

			return count;
		}

		/**
		 * Returns an object that matches the function
		 * @param closure Function be check the object against function(o:rIUpdatable):Boolean;
		 * @return An instance that returned true for closure
		 */
		public function getOneByFunction(closure:Function):IRetrocamelUpdatable {
			for (var o:IRetrocamelUpdatable, i:int = 0; i < _objectsArrayLength; i++) {
				o = _objects[i];
				if (o != null && closure.apply(o))
					return o;
			}

			return null;
		}

		/**
		 * Returns all object that match the function
		 * @param closure Function be check the object against function(o:rIUpdatable):Boolean;
		 * @return All objects that returned true for the closure
		 */
		public function getAllByFunction(closure:Function):Array {
			var array:Array = [];
			for (var o:IRetrocamelUpdatable, i:int = 0; i < _objectsArrayLength; i++) {
				o = _objects[i];

				if (o != null && closure.apply(o))
					array.push(o);
			}

			return array;
		}

		/**
		 * Calls given function with all objects
		 * @param closure Function to be called with each object function(o:rIUpdatable):Boolean;
		 */
		public function callOnAll(closure:Function):void {
			for (var i:int = 0; i < _objectsArrayLength; i++)
				closure.apply(_objects[i]);
		}

		/**
		 * Calls the function of given name on each object and passes the params specified in the array
		 * @param functionName Name of the function to call
		 * @param params Array of parameters
		 */
		public function applyOfAll(functionName:String, params:Array = null):void {
			var item:*;

			for (var i:int = 0; i < _objectsArrayLength; i++) {
				item = _objects[i];

				if (item && item.hasOwnProperty(functionName))
					Function(item[functionName]).apply(item, params);
			}
		}

		/**
		 * Calls the given function by name on each object and passes the params specified
		 * @param functionName Name of the function to call
		 * @param params Parameters
		 */
		public function callOfAll(functionName:String, ...params):void {
			var item:*;
			for (var i:int = 0; i < _objectsArrayLength; i++) {
				item = _objects[i];
				if (item && item.hasOwnProperty(functionName))
					item[functionName].apply(item, params);
			}
		}
	}
}