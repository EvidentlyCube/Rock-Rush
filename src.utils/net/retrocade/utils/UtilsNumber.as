package net.retrocade.utils {
	/**
	 * An utility class which containst number-related functions
	 *
	 * @author Maurycy Zarzycki
	 */
	public class UtilsNumber {
		/**
		 * @private
		 * Helper used by the average function
		 */
		private static var _averageAdditionalElements:int = 0;

		/**
		 * Counter used by the unique function
		 */
		private static var _uniqueCounter:uint = 0;

		/**
		 * Modifies Initial to get closer to Target by a Factor, and rounds to it when the difference is equal or smaller to RoundWhen
		 *
		 * @param initial The number to be changed
		 * @param target Target number
		 * @param factor Factor by which the initial number is to be modified
		 * @param roundWhen Set to target when difference between initial and target is smaller than
		 * @param maxSpeed Maximum amount of change in one call
		 * @return The new number
		 */
		public static function approach(initial:Number, target:Number, factor:Number = 0.1, roundWhen:Number = 0.1, maxSpeed:Number = NaN):Number {
			if (isNaN(maxSpeed))
				initial += (target - initial) * factor;
			else
				initial += limit((target - initial) * factor, maxSpeed);

			if (target - initial <= roundWhen && target - initial >= -roundWhen)
				initial = target;

			return initial;
		}

		/**
		 * Calculates an average of all the passed integers and array elements.
		 *
		 * @return Average of all the numbers passed
		 */
		public static function average(...rest):Number {
			_averageAdditionalElements = 0;

			var i:int = 0;
			var l:int = rest.length;

			var summer:Number = 0;
			var elements:int = 0;

			for (i; i < l; i++) {
				if (rest[i] is Array) {
					summer += _averageArray.apply(null, rest[i]) * _averageAdditionalElements;
					elements += _averageAdditionalElements;

				} else {
					summer += rest[i];
					elements += 1;
				}

			}

			return summer / elements;
		}

		/**
		 * Calculates the distance, using the Pythagorean theorem
		 *
		 * @param    x1 X of the first object
		 * @param    y1 Y of the first object
		 * @param    x2 X of the second object
		 * @param    y2 Y of the second object
		 * @return Distance between the objects
		 */
		public static function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
		}

		/**
		 * Calculates the distance in a number of steps through a grid where diagonal movement
		 * costs as much as orthogonal
		 *
		 * @param    x1 X of the first object
		 * @param    y1 Y of the first object
		 * @param    x2 X of the second object
		 * @param    y2 Y of the second object
		 * @return Distance between the objects
		 */
		public static function distanceGrid(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			x1 = (x1 > x2 ? x1 - x2 : x2 - x1);
			y1 = (y1 > y2 ? y1 - y2 : y2 - y1);
			return x1 < y1 ? y1 : x1;
		}

		/**
		 * Calculates the manhattan distance
		 *
		 * @param    x1 X of the first object
		 * @param    y1 Y of the first object
		 * @param    x2 X of the second object
		 * @param    y2 Y of the second object
		 * @return Distance between the objects
		 */
		public static function distanceManhattan(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return (x1 > x2 ? x1 - x2 : x2 - x1) + (y1 > y2 ? y1 - y2 : y2 - y1);
		}

		/**
		 * Converts an HSV color to RGB
		 * @param    hue Hue (0 - 360)
		 * @param    sat Saturation (0 - 1)
		 * @param    val (0 - 1)
		 * @return RGB color
		 */
		public static function hsvToRGB(hue:Number, sat:Number, val:Number):uint {
			hue = hue % 360;

			var i:int;
			var f:Number;
			var p:Number;
			var q:Number;
			var t:Number;
			var h:Number;
			var r:uint;
			var g:uint;
			var b:uint;

			if (sat == 0) {
				r = val * 255;
				g = val * 255;
				b = val * 255;
				return (r << 16) | (g << 8) | b;
			}

			h = hue / 60;
			i = h | 0;
			f = h - i;
			p = val * (1 - sat);
			q = val * (1 - sat * f);
			t = val * (1 - sat * (1 - f));

			switch (i) {
				case(0):
					r = val * 255;
					g = t * 255;
					b = p * 255;
					break;

				case(1):
					r = q * 255;
					g = val * 255;
					b = p * 255;
					break;

				case(2):
					r = p * 255;
					g = val * 255;
					b = t * 255;
					break;

				case(3):
					r = p * 255;
					g = q * 255;
					b = val * 255;
					break;

				case(4):
					r = t * 255;
					g = p * 255;
					b = val * 255;
					break;

				case(5):
					r = val * 255;
					g = p * 255;
					b = q * 255;
					break;
			}

			return (r << 16) | (g << 8) | b;
		}

		/**
		 * Modifies the passed variable so that it doesn't exceed set limits
		 *
		 * @param limited The number to be modified
		 * @param topLimit The largest value the variable can be
		 * @param mirror If set to true, bottomLimit is set to negated value of topLimited
		 * @param bottomLimit The smallest value the variable can be
		 * @return The modified number
		 */
		public static function limit(limited:Number, topLimit:Number = NaN, bottomLimit:Number = NaN, mirror:Boolean = true):Number {
			if (mirror && isNaN(bottomLimit)) {
				bottomLimit = -topLimit;
			}

			if (bottomLimit > topLimit) {
				var temp:Number = bottomLimit;
				bottomLimit = topLimit;
				topLimit = temp;
			}

			if (!isNaN(topLimit) && limited > topLimit) {
				return topLimit;
			}

			if (!isNaN(bottomLimit) && limited < bottomLimit) {
				return bottomLimit;
			}

			return limited;
		}

		/**
		 * Finds the biggest number of all the passed integers and array elements.
		 *
		 * @return The smallest value from all of the passed
		 */
		public static function max(...rest):Number {
			var smallest:Number = Number.MIN_VALUE;
			var l:int = rest.length;

			for (var i:int = 0; i < l; i++) {
				if (rest[i] is Array) {
					smallest = Math.min(smallest, max.apply(null, rest[i]));
				}

				else if (rest[i] > smallest) {
					smallest = rest[i];
				}
			}

			return smallest;
		}

		/**
		 * Finds the smallest number of all the passed integers and array elements.
		 *
		 * @return The smallest value from all of the passed
		 */
		public static function min(...rest):Number {
			var smallest:Number = Number.MAX_VALUE;
			var l:int = rest.length;

			for (var i:int = 0; i < l; i++) {
				if (rest[i] is Array) {
					smallest = Math.min(smallest, min.apply(null, rest[i]));
				}

				else if (rest[i] < smallest) {
					smallest = rest[i];
				}
			}

			return smallest;
		}

		/**
		 * A modulo operator which always returns positive result
		 *
		 * @param dividend Value which will be moduled
		 * @param divisor Value which will module
		 * @return Positive module
		 */
		public static function modulo(dividend:Number, divisor:Number):Number {
			dividend %= divisor;

			while (dividend < 0) {
				dividend += divisor;
			}

			return dividend;
		}

		/**
		 * Given x and y (and optional offset to the result) it calculates a net.retrocade.random value.
		 * It can be used if you have one tile type which has some variations, and you want to randomly declare
		 * which tile will get which variation - this function will ensure that the variations will be consistent
		 * between all games, but initially still net.retrocade.random
		 * @param    x X position
		 * @param    y Y position
		 * @param    offset Optional offest to the calculation
		 * @return Random int
		 */
		public static function randomXY(x:Number, y:Number, offset:Number = 1):int {
			x += offset;
			y *= offset;

			x = 36969 * (x & 65535) + (x >> 16);
			y = 18000 * (y & 65535) + (y >> 16);

			return ((x << 16) + y) / int.MAX_VALUE;
			/* 32-bit result */
		}

		/**
		 * Using standard Math.net.retrocade.random(), it gives you a net.retrocade.random number which is in range:
		 * <start - wave, start + wave>
		 *
		 * @param    start Initial value which will be offsetted by wave
		 * @param    wave Maximum offset from start
		 * @return A net.retrocade.random number
		 */
		public static function randomWaved(start:Number, wave:Number):Number {
			return start + (Math.random() * 2 - 1) * wave;
		}

		/**
		 * Rounds the specified number away from zero
		 *
		 * @param number The number to be rounded
		 * @return The modified number
		 */
		public static function roundFromZero(number:Number):Number {
			return number > 0 ? Math.ceil(number) : Math.floor(number);
		}

		/**
		 * Rounds the specified number towards zero
		 *
		 * @param number The number to be rounded
		 * @return The modified number
		 */
		public static function roundToZero(number:Number):Number {
			return number < 0 ? Math.ceil(number) : Math.floor(number);
		}

		/**
		 * Returns a sign (-1 for negative, 1 for positive and 0 for anything else) of specified number
		 *
		 * @param number The number to get the sign
		 * @return Sign of the passed number
		 */
		public static function sign(number:Number):int {
			if (number > 0) {
				return 1;
			}

			else if (number < 0) {
				return -1;
			}

			else {
				return 0;
			}
		}

		/**
		 * Returns a sum of all number found in the passed parameters and arrays in it
		 *
		 * @param rest Numbers to be summed
		 * @return Sum of all the numbers
		 */
		public static function sum(...rest):Number {
			var i:int = 0;
			var l:int = rest.length;
			var summed:Number = 0;
			for (i; i < l; i++) {
				if (rest[i] is Array) {
					summed += sum.apply(null, rest[i]);
				} else {
					summed += rest[i];
				}
			}

			return summed;
		}

		/**
		 * Returns a number. Subsequent calls increase the number returned by one
		 *
		 * @return Number from sequence 0, 1, 2...
		 */
		public static function unique():uint {
			return _uniqueCounter++;
		}

		public static function nextPrime(value:uint):uint {
			do {
				value++;
			} while (!isPrime(value));

			return value;
		}

		public static function previousPrime(value:uint):uint {
			do {
				value--;
			} while (!isPrime(value));

			return value;
		}

		public static function isPrime(number:uint):Boolean {
			if (number == 2) {
				return true;
			} else if (number < 2) {
				return false;
			} else if ((number & 0x1) === 0) {
				return false;
			}

			var l:uint = Math.sqrt(number) | 0;
			for (var i:int = 3; i <= l; i += 2) {
				if (number % i === 0) {
					return false;
				}
			}

			return true;
		}

		/**
		 * @private
		 * Subfunction of average(), calculate value of ALL nested arrays
		 */
		private static function _averageArray(...rest):Number {
			_averageAdditionalElements = 0;

			var i:int = 0;
			var l:int = rest.length;

			var summer:Number = 0;
			var elements:int = 0;

			for (i; i < l; i++) {
				if (rest[i] is Array) {
					summer += _averageArray.apply(null, rest[i]) * _averageAdditionalElements;
					elements += _averageAdditionalElements;

				} else {
					summer += rest[i];
					elements += 1;
				}

			}

			_averageAdditionalElements = elements;

			return summer / elements;
		}
	}
}