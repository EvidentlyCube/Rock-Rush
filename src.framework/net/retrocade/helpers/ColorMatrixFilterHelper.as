package net.retrocade.helpers {
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;

	public class ColorMatrixFilterHelper {
		private var _displayObject:DisplayObject;

		public function get displayObject():DisplayObject {
			return _displayObject;
		}

		public function set displayObject(d:DisplayObject):void {
			if (d == _displayObject)
				return;

			removeFilterFromDisplayObject();

			_displayObject = d;
			calculate();
		}

		private var _saturation:Number;

		public function get saturation():Number {
			return _saturation;
		}

		public function set saturation(n:Number):void {
			_saturation = n;

			calculate();
		}

		private var _contrast:Number;

		public function get contrast():Number {
			return _contrast;
		}

		public function set contrast(n:Number):void {
			_contrast = n;

			calculate();
		}

		private var _brightness:int;

		public function get brightness():int {
			return _brightness;
		}

		public function set brightness(n:int):void {
			_brightness = n;

			calculate();
		}

		private var _luminosity:Number;

		public function get luminosity():Number {
			return _luminosity;
		}

		public function set luminosity(n:Number):void {
			_luminosity = n;

			calculate();
		}

		private var _blueOffset:int;


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Set all parameters
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		public function get blueOffset():int {
			return _blueOffset;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Set parameter groups
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		public function set blueOffset(n:int):void {
			_blueOffset = n;

			calculate();
		}

		private var _greenOffset:int;

		public function get greenOffset():int {
			return _greenOffset;
		}

		public function set greenOffset(n:int):void {
			_greenOffset = n;

			calculate();
		}

		private var _redOffset:int;

		public function get redOffset():int {
			return _redOffset;
		}

		public function set redOffset(n:int):void {
			_redOffset = n;

			calculate();
		}

		private var _blueMultiplier:Number;


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Set single parameters
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		public function get blueMultiplier():Number {
			return _blueMultiplier;
		}

		public function set blueMultiplier(n:Number):void {
			_blueMultiplier = n;

			calculate();
		}

		private var _greenMultiplier:Number;

		public function get greenMultiplier():Number {
			return _greenMultiplier;
		}

		public function set greenMultiplier(n:Number):void {
			_greenMultiplier = n;

			calculate();
		}

		private var _redMultiplier:Number;

		public function get redMultiplier():Number {
			return _redMultiplier;
		}

		public function set redMultiplier(n:Number):void {
			_redMultiplier = n;

			calculate();
		}
		private var _matrixArray:Array;
		private var _currentlyUsedArrayHash:String = "";


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Change display object
		// ::::::::::::::::::::::::::::::::::::::::::::::::
		/**
		 * If set to true whenever you make changes to any of the properties the changes are automatically applied, otherwise you have to manually call apply()
		 */
		public var autoApply:Boolean = true;
		public var simpleMode:Boolean = true;


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Getters
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		public function ColorMatrixFilterHelper(displayObject:DisplayObject = null,
		                                        blueOffset:int = 0, greenOffset:int = 0, redOffset:int = 0,
		                                        blueMultiplier:Number = 1, greenMultiplier:Number = 1, redMultiplier:Number = 1,
		                                        saturation:Number = 1, contrast:Number = 1, brightness:int = 0, luminosity:Number = 1,
		                                        autoApply:Boolean = true) {

			this.autoApply = autoApply;

			_displayObject = displayObject;

			_matrixArray = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];

			if (_displayObject) {
				var filterArray:Array = displayObject.filters;

				filterArray.push(new ColorMatrixFilter(_matrixArray));

				_currentlyUsedArrayHash = _matrixArray.toString();

				displayObject.filters = filterArray;
			}

			setAll(blueOffset, greenOffset, redOffset, blueMultiplier, greenMultiplier, redMultiplier, saturation, contrast, brightness, luminosity);
		}

		public function setAll(blueOffset:int = 0, greenOffset:int = 0, redOffset:int = 0,
		                       blueMultiplier:Number = 1, greenMultiplier:Number = 1, redMultiplier:Number = 1,
		                       saturation:Number = 1, contrast:Number = 1, brightness:int = 0, luminosity:Number = 1):void {

			_blueOffset = blueOffset;
			_greenOffset = greenOffset;
			_redOffset = redOffset;
			_blueMultiplier = blueMultiplier;
			_greenMultiplier = greenMultiplier;
			_redMultiplier = redMultiplier;
			_saturation = saturation;
			_contrast = contrast;
			_brightness = brightness;
			_luminosity = luminosity;

			calculate();
		}

		public function setBlue(offset:int = 0, multiplier:Number = 1):void {
			_blueOffset = offset;
			_blueMultiplier = multiplier;

			calculate();
		}

		public function setGreen(offset:int = 0, multiplier:Number = 1):void {
			_greenOffset = offset;
			_greenMultiplier = multiplier;

			calculate();
		}

		public function setRed(offset:int = 0, multiplier:Number = 1):void {
			_redOffset = offset;
			_redMultiplier = multiplier;

			calculate();
		}

		public function setOffsets(blue:int = 0, green:int = 0, red:int = 0):void {
			_blueOffset = blue;
			_greenOffset = green;
			_redOffset = red;

			calculate();
		}

		public function setMultipliers(blue:Number = 1, green:Number = 1, red:Number = 1):void {
			_blueMultiplier = blue;
			_greenMultiplier = green;
			_redMultiplier = red;

			calculate();
		}

		public function setSpecial(contrast:Number = 0, saturation:Number = 1, brightness:int = 0, luminosity:Number = 1):void {
			_contrast = contrast;
			_saturation = saturation;
			_brightness = brightness;
			_luminosity = luminosity;

			calculate();
		}

		public function setColorMultiplierRGB(color:uint):void {
			_redMultiplier = Number(color >> 16 & 0xFF) / 255;
			_greenMultiplier = Number(color >> 8 & 0xFF) / 255;
			_blueMultiplier = Number(color & 0xFF) / 255;

			calculate();
		}

		public function setColorOffsetRGB(color:uint):void {
			_redOffset = color >> 16 & 0xFF;
			_greenOffset = color >> 8 & 0xFF;
			_blueOffset = color & 0xFF;

			calculate();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Update
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Applies all changes to the display object
		 */
		public function apply():void {
			calculate(true);
		}

		private function calculate(forceUpdate:Boolean = false):void {
			_matrixArray[0] = ((1.0 - _saturation) * 0.3086 + _saturation) * _contrast * _redMultiplier * _luminosity;
			_matrixArray[1] = (1.0 - _saturation) * 0.6094 * _contrast * _luminosity;
			_matrixArray[2] = (1.0 - _saturation) * 0.0820 * _contrast * _luminosity;
			_matrixArray[3] = _redOffset;
			_matrixArray[4] = 63.5 * (1 - _contrast) + _brightness;

			_matrixArray[5] = (1.0 - _saturation) * 0.3086 * _contrast * _luminosity;
			_matrixArray[6] = ((1.0 - _saturation) * 0.6094 + _saturation) * _contrast * _greenMultiplier * _luminosity;
			_matrixArray[7] = (1.0 - _saturation) * 0.0820 * _contrast * _luminosity;
			_matrixArray[8] = _greenOffset;
			_matrixArray[9] = 63.5 * (1 - _contrast) + _brightness;

			_matrixArray[10] = (1.0 - _saturation) * 0.3086 * _contrast * _luminosity;
			_matrixArray[11] = (1.0 - _saturation) * 0.6094 * _contrast * _luminosity;
			_matrixArray[12] = ((1.0 - _saturation) * 0.0820 + _saturation) * _contrast * _blueMultiplier * _luminosity;
			_matrixArray[13] = _blueOffset;
			_matrixArray[14] = 63.5 * (1 - _contrast) + _brightness;

			if (autoApply || forceUpdate)
				update();
		}

		private function update():void {
			if (!_displayObject)
				return;

			var filterArray:Array = _displayObject.filters ? _displayObject.filters : [];
			var found:Boolean = false;
			var filterIterator:Object;
			var matrixFilter:ColorMatrixFilter;

			for each(filterIterator in filterArray) {
				if ((matrixFilter = filterIterator as ColorMatrixFilter) === null)
					continue;

				if (simpleMode || matrixFilter.matrix.toString() == _currentlyUsedArrayHash) {
					found = true;
					matrixFilter.matrix = _matrixArray;
					break;
				}
			}

			if (!found)
				filterArray[filterArray.length] = new ColorMatrixFilter(_matrixArray);

			_displayObject.filters = filterArray;

			_currentlyUsedArrayHash = _matrixArray.toString();
		}

		private function removeFilterFromDisplayObject():void {
			var filterArray:Array = _displayObject ? _displayObject.filters : null;
			var filterIterator:Object;
			var matrixFilter:ColorMatrixFilter;

			if (filterArray === null)
				return;


			for each(filterIterator in filterArray) {
				if ((matrixFilter = filterIterator as ColorMatrixFilter) === null)
					continue;

				if (matrixFilter.matrix.toString() == _currentlyUsedArrayHash) {
					filterArray.splice(filterArray.indexOf(matrixFilter), 1);
					return;
				}
			}
		}
	}
}