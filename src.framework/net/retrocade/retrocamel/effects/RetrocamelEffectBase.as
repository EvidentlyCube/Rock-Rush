package net.retrocade.retrocamel.effects {
	import flash.errors.IllegalOperationError;
	import flash.utils.getTimer;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.retrocamel_int;
	import net.retrocade.retrocamel.interfaces.IRetrocamelUpdatable;

	use namespace retrocamel_int;

	public class RetrocamelEffectBase implements IRetrocamelUpdatable {
		/**
		 * Boolean indicating if the effects are blocked
		 */
		protected static var _blocked:Boolean = false;
		/**
		 * Time when the block started
		 */
		protected static var _blockStarted:Number = NaN;

		/**
		 * Blocks all effects playing
		 */
		public static function block():void {
			if (!_blocked) {
				_blocked = true;
				_blockStarted = getTimer();
			}
		}

		/**
		 * Unblocks all effects
		 */
		public static function unblock():void {
			_blocked = false;
		}

		/**
		 * Duration of the effect in milliseconds
		 */
		protected var _duration:uint = 1000;
		/**
		 * Time when the effect started
		 */
		private var _startTime:Number;
		/**
		 * Function to be called after the effect finishes
		 */
		private var _callback:Function;
		/**
		 * Is the effect currently running?
		 */
		private var _isRunning:Boolean = false;

		public function get isRunning():Boolean {
			return _isRunning;
		}

		/**
		 * If the object was added to the default group and has to be removed automatically
		 */
		private var _addTo:RetrocamelUpdatableGroup;

		public function get addTo():RetrocamelUpdatableGroup {
			return _addTo;
		}
		/**
		 * If this effect is blocked
		 */
		private var _isBlocked:Boolean = false;
		/**
		 * Easing function used by given effect, null by default
		 */
		private var _easing:Function = null;


		/****************************************************************************************************************/
		/**                                                                                                  FUNCTIONS  */
		/****************************************************************************************************************/

		/**
		 * True if the effect has already finished
		 */
		private var _hasFinished:Boolean = false;

		public function get hasFinished():Boolean {
			return _hasFinished;
		}

		/**
		 * Constructor
		 */
		public function RetrocamelEffectBase() {
		}

		public function skip():void {
			finish();
		}

		/**
		 * Update, should be overriden and then super-called. Checks if the
		 * effect is finished
		 */
		public function update():void {
			if (isFinished) {
				finish();
			}
		}

		public function run(addTo:RetrocamelUpdatableGroup = null):RetrocamelEffectBase {
			if (_isRunning) {
				throw new IllegalOperationError("Cannot run an already active effect");
			}

			if (!addTo) {
				addTo = RetrocamelCore.groupBefore;
			}

			_addTo = addTo;
			_addTo.add(this);

			_isRunning = true;
			_startTime = getTimer();

			update();

			return this;
		}

		final public function callback(callbackFunction:Function):RetrocamelEffectBase {
			_callback = callbackFunction;

			return this;
		}

		final public function easing(easing:Function):RetrocamelEffectBase {
			_easing = easing;

			return this;
		}

		final public function duration(duration:uint):RetrocamelEffectBase {
			_duration = duration;

			return this;
		}

		/**
		 * Called when the effect has finished, calls the callback function
		 */
		protected function finish():void {
			if (_callback != null) {
				if (_callback.length) {
					_callback(this);
				}
				else {
					_callback();
				}
			}

			_addTo.nullify(this);
			_addTo = null;
			_callback = null;

			_hasFinished = true;
		}

		/**
		 * Return the interval of the current animation state, as a number between passed values
		 */
		protected function getInterval(fromValue:Number, toValue:Number):Number {
			return fromValue + (toValue - fromValue) * interval;
		}

		/**
		 *  Called by update() when the animation playback is blocked
		 */
		protected function blockUpdate():void {
			if (_blocked && !_isBlocked) {
				_isBlocked = true;
			}
		}

		protected function resetDuration(newDuration:Number = NaN):void {
			_startTime = getTimer();

			if (!isNaN(_duration) && _duration > 0) {
				_duration = newDuration | 0;
			}
		}

		/**
		 * Returns the interval of the current animation state, as a value between 0 and 1
		 */
		protected function get interval():Number {
			if (_duration === 0) {
				return 1;
			}

			var timer:Number = getTimer();

			if (_isBlocked) {
				_startTime += getTimer() - _blockStarted;
				_isBlocked = false;
			}

			timer = (timer - _startTime) / _duration;

			if (_easing != null) {
				return Math.max(0, Math.min(1, _easing(timer)));
			} else {
				return Math.max(0, Math.min(1, timer));
			}
		}

		/**
		 * Returns true if the effect is and should be finished
		 */
		private function get isFinished():Boolean {
			if (_duration === 0) {
				return false;
			} else {
				return _isBlocked ? false : getTimer() >= _startTime + _duration;
			}
		}

		public function get timeFromStart():Number {
			return getTimer() - _startTime;
		}
	}
}