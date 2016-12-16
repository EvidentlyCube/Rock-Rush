package net.retrocade.retrocamel.display.flash {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;

	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.retrocamel_int;
	import net.retrocade.utils.UtilsString;

	use namespace retrocamel_int;

	public class RetrocamelBitmapText extends Bitmap {
		/****************************************************************************************************************/
		/**                                                                                                  CONSTANTS  */
		/****************************************************************************************************************/

		public static const ALIGN_LEFT:uint = 0;
		public static const ALIGN_MIDDLE:uint = 1;
		public static const ALIGN_RIGHT:uint = 2;

		private static var POINT_0x0:Point = new Point();


		/****************************************************************************************************************/
		/**                                                                                                  VARIABLES  */
		/****************************************************************************************************************/

		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Horizontal Align
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Type of the horizontal align
		 */
		protected var _align:uint = 0;

		/**
		 * Type of the horizontal align
		 */
		public function get align():uint {
			return _align;
		}

		/**
		 * @private
		 */
		public function set align(value:uint):void {
			if (_align != value) {
				_align = value;
				_needFullRedraw = true;

				if (_autoDraw)
					draw();
			}
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Auto Draw
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Whether to draw the text whenever any of its properties is changed
		 */
		protected var _autoDraw:Boolean = true;

		/**
		 * Whether to draw the text whenever any of its properties is changed
		 */
		public function get autoDraw():Boolean {
			return _autoDraw;
		}

		/**
		 * @private
		 */
		public function set autoDraw(value:Boolean):void {
			_autoDraw = true;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Cache
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Whether to cache the unmodified text's BitmapData
		 */
		protected var _cache:Boolean = false;

		/**
		 * Whether to cache the unmodified text's BitmapData
		 */
		public function get cache():Boolean {
			return _cache;
		}

		public function set cache(value:Boolean):void {
			if (_cache != value) {
				_cache = value;

				if (!_cache) {
					_originalBitmapData.dispose();
					_originalBitmapData = null;
				} else {
					_needFullRedraw = true;
					draw();
				}
			}
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Color
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Color of the text, works correctly only on the grayscale text
		 */
		protected var _color:uint = 0xFFFFFF;

		public function get color():uint {
			return _color;
		}

		public function set color(value:uint):void {
			if (_color != value) {
				_color = value;

				if (_autoDraw) {
					if (_isColorApplied || _isTextureApplied) {
						_needEffectRedraw = true;
						draw();
					} else
						applyColorize();
				}
			}
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Letter Spacing
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Amount of pixels between each letter
		 */
		protected var _letterSpace:int = 1;

		/**
		 * Amount of pixels between each letter
		 */
		public function get letterSpace():uint {
			return _letterSpace;
		}

		/**
		 * @private
		 */
		public function set letterSpace(value:uint):void {
			if (value != _letterSpace) {
				_letterSpace = value;

				_needFullRedraw = true;

				if (_autoDraw)
					draw();
			}
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Line Height
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Height of one line of text in pixels
		 */
		public function get lineHeight():uint {
			return _font.fontHeight;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Line Spacing
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Amount of pixels between each line
		 */
		protected var _lineSpace:int = 1;

		/**
		 * Amount of pixels between each line
		 */
		public function get lineSpace():int {
			return _lineSpace;
		}

		/**
		 * @private
		 */
		public function set lineSpace(value:int):void {
			if (_lineSpace != value) {
				_lineSpace = value;

				_needFullRedraw = true;

				if (_autoDraw)
					draw();
			}
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Multiline
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * If text can span multiple lines
		 */
		protected var _multiline:Boolean = true;

		/**
		 * If text can span multiple lines
		 */
		public function get multiline():Boolean {
			return _multiline;
		}

		/**
		 * @private
		 */
		public function set multiline(value:Boolean):void {
			if (value != value) {
				_multiline = value;

				_needFullRedraw = true;

				if (_autoDraw)
					draw();
			}
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Number of Lines
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Retrieves the amount of text lines. If there is no text it returns 0, if the text is not multiline it always returns 1
		 */
		public function get numberOfLines():uint {
			if (_text == "")
				return 0;

			else if (_multiline)
				return _text.match(/\n/g).length + 1;

			else
				return 1;

		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Text
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Text to be displayed
		 */
		protected var _text:String;

		/**
		 * Text to be displayed
		 */
		public function get text():String {
			return _text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void {
			if (value != _text) {
				_text = value;

				_needFullRedraw = true;

				if (_autoDraw)
					draw();
			}
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Texture
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Texture to be drawn over the text
		 */
		protected var _texture:BitmapData;

		/**
		 * Texture to be drawn over the text
		 */
		public function get texture():BitmapData {
			return _texture;
		}

		public function set texture(value:BitmapData):void {
			if (value != _texture) {
				_texture = value;

				_needEffectRedraw = true;

				if (_autoDraw) {
					if (_isColorApplied || _isShadowApplied || _isTextureApplied) {
						_needEffectRedraw = true;
						draw();
					} else
						applyTexture();
				}
			}
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Internals
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * The BitextFont used for drawing this Bitext
		 */
		retrocamel_int var _font:RetrocamelBitmapFont;

		/**
		 * Variable containing shadow effect, internal use only
		 */
		protected var _shadow:DropShadowFilter;

		/**
		 * Variable containing the color transform for this text
		 */
		protected var _colorTransform:ColorTransform;

		/**
		 * When there are any effects used on the text, and the cache parameter is set to true,
		 * this variable will hold the original, unmodified BitmapData
		 */
		protected var _originalBitmapData:BitmapData;

		/**
		 * True if the texture effect is already applied
		 */
		protected var _isTextureApplied:Boolean = false;

		/**
		 * True if the shadow effect is already applied
		 */
		protected var _isShadowApplied:Boolean = false;

		/**
		 * True if the color transform is already applied
		 */
		protected var _isColorApplied:Boolean = false;

		protected var _needFullRedraw:Boolean = false;
		protected var _needEffectRedraw:Boolean = false;


		/****************************************************************************************************************/
		/**                                                                                                  FUNCTIONS  */
		/****************************************************************************************************************/

		/**
		 * Creates a news bitmap text object
		 * @param    text Text to be displayed
		 * @param    font Font to  be used
		 * @param    enableCaching Whether to use pre effect caching
		 */
		public function RetrocamelBitmapText(text:String = "", font:RetrocamelBitmapFont = null, enableCaching:Boolean = false) {
			if (font == null)
				_font = RetrocamelBitmapFont.defaultFont;
			else
				_font = font;

			_cache = enableCaching;

			smoothing = false;

			this.text = text;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Effects
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Forces a text redraw
		 */
		public function forceRedraw():void {
			draw();
		}

		/**
		 * Adds one pixel shadow
		 */
		public function addShadow(distance:Number = 1, angle:Number = 45, color:uint = 0, alpha:Number = 1,
		                          blurX:Number = 0, blurY:Number = 0, strength:Number = 4, inner:Boolean = false,
		                          knockout:Boolean = false, hideObject:Boolean = false):void {
			if (!_shadow)
				_shadow = new DropShadowFilter();

			else if (_shadow.distance == distance && _shadow.angle == angle && _shadow.color == color &&
				_shadow.alpha == alpha && _shadow.blurX == blurX && _shadow.blurY == blurY &&
				_shadow.strength == strength && _shadow.inner == inner && _shadow.knockout == knockout &&
				_shadow.hideObject == hideObject)
				return;

			_shadow.distance = distance;
			_shadow.angle = angle;
			_shadow.color = color;
			_shadow.alpha = alpha;
			_shadow.blurX = blurX;
			_shadow.blurY = blurY;
			_shadow.strength = strength;
			_shadow.inner = inner;
			_shadow.knockout = knockout;
			_shadow.hideObject = hideObject;

			if (alpha <= 0)
				_shadow = null;

			if (_autoDraw) {
				if (_isShadowApplied) {
					_needEffectRedraw = true;
					draw();
				} else
					applyShadow();
			}
		}

		/**
		 * Sets the scale (both X and Y)
		 * @param n Scale to set
		 */
		public function setScale(n:Number):void {
			scaleX = scaleY = n;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Positioning
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Position the text horizontally in the center of its parent
		 */
		public function positionToCenter():void {
			if (!parent)
				return;

			var preWidth:uint = width;
			width = 1;
			x = 0;
			x = (parent.width - preWidth) / 2 | 0;
			width = preWidth;
		}

		/**
		 * Positions the text horizontally in the center of the screen
		 */
		public function positionToCenterScreen():void {
			x = (RetrocamelCore.settings.gameWidth - width) / 2 | 0;
		}

		/**
		 * Positions the text to the center of the given dimension
		 */
		public function positionToCenterAgainst(width:uint, x:uint = 0):void {
			this.x = x + (width - this.width) / 2 | 0;
		}

		/**
		 * Positions the text vertically in the middle of its parent
		 */
		public function positionToMiddle():void {
			if (!parent)
				return;

			var preHeight:uint = height;
			height = 1;
			y = 0;
			y = (parent.height - preHeight) / 2 | 0;
			height = preHeight;
		}

		/**
		 * Positions the text vertically in the middle of the screen
		 */
		public function positionToMiddleScreen():void {
			y = (RetrocamelCore.settings.gameHeight - height) / 2 | 0;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Miscellanous
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public function getWordWrapToWidth(txt:String, width:uint):String {
			txt = txt.replace(/\n/g, " ");
			var txtNew:String = "";

			var currentLine:String = "";

			while (txt.length > 0) {
				if (currentLine)
					currentLine += " ";

				currentLine += getWord();

				if (_font.calculateLineWidth(currentLine, letterSpace) > width) {
					removeLastAddedWord();
					txtNew += currentLine + "\n";
					currentLine = "";

				} else {
					removeWord();
				}

				txt = UtilsString.trim(txt);
			}

			txtNew += currentLine;

			return txtNew;

			function getWord():String {
				var __index:uint = txt.indexOf(" ");
				if (__index == -1)
					return txt;
				return txt.substr(0, __index);
			}

			function removeWord():void {
				var __index:uint = txt.indexOf(" ");
				if (__index == -1)
					txt = "";
				else
					txt = txt.substr(__index + 1);
			}

			function removeLastAddedWord():void {
				var __index:uint = currentLine.lastIndexOf(" ");
				currentLine = currentLine.substr(0, __index);
			}
		}

		/****************************************************************************************************************/
		/**                                                                                          PRIVATE FUNCTIONS  */
		/****************************************************************************************************************/

		/**
		 * Redraws the text and applies effects
		 */
		protected function draw():void {
			if (text == "") {
				if ($bitmapData && $bitmapData.width != 1) {
					$bitmapData.dispose();
					$bitmapData = new BitmapData(1, 1);

				} else if (!$bitmapData)
					$bitmapData = new BitmapData(1, 1);

				return;
			}

			if (_needFullRedraw || !$bitmapData)
				fullRedraw();

			if (_needEffectRedraw) {
				fillBitmapDataIsUntouched();

				_isTextureApplied = false;
				_isColorApplied = false;
				_isShadowApplied = false;
			}

			if (_texture && !_isTextureApplied)
				applyTexture();

			if (_color != 0xFFFFFF && !_isColorApplied)
				applyColorize();

			if (_shadow && !_isShadowApplied)
				applyShadow();

			_needEffectRedraw = false;
			_needFullRedraw = false;

			width = $bitmapData.width * scaleX;
			height = $bitmapData.height * scaleY;
		}

		/**
		 * Performs a full redraw and caching
		 */
		protected function fullRedraw():void {
			if (_originalBitmapData)
				_originalBitmapData.dispose();

			if ($bitmapData)
				$bitmapData.dispose();

			_originalBitmapData = null;
			$bitmapData = null;

			$bitmapData = _font.drawText(this);

			_needEffectRedraw = true;
			_isTextureApplied = false;
			_isColorApplied = false;
			_isShadowApplied = false;

			if (_cache)
				_originalBitmapData = $bitmapData.clone();
		}

		/**
		 * Replaces the BitmapData with cached or redraws, if effects are already applied
		 */
		protected function fillBitmapDataIsUntouched():void {
			if (_isColorApplied || _isShadowApplied || _isTextureApplied) {
				if (_originalBitmapData) {
					$bitmapData.fillRect($bitmapData.rect, 0x00000000);
					$bitmapData.copyPixels(_originalBitmapData, _originalBitmapData.rect, POINT_0x0, null, null, true);
				} else
					fullRedraw();
			}
		}

		protected function applyTexture():void {
			for (var i:int = 0, l:int = numberOfLines; i < l; i++) {
				POINT_0x0.y = (lineHeight + lineSpace) * i;
				$bitmapData.copyChannel(_texture, _texture.rect, POINT_0x0, 1, 1);
				$bitmapData.copyChannel(_texture, _texture.rect, POINT_0x0, 2, 2);
				$bitmapData.copyChannel(_texture, _texture.rect, POINT_0x0, 4, 4);
			}

			POINT_0x0.y = 0;

			_isTextureApplied = true;
		}

		/**
		 * Applies the colorize effect
		 */
		protected function applyColorize():void {
			if (!_colorTransform)
				_colorTransform = new ColorTransform();

			_colorTransform.redMultiplier = Number(color >> 16 & 0xFF) / 255;
			_colorTransform.greenMultiplier = Number(color >> 8 & 0xFF) / 255;
			_colorTransform.blueMultiplier = Number(color & 0xFF) / 255;

			$bitmapData.colorTransform($bitmapData.rect, _colorTransform);

			_isColorApplied = true;
		}

		/**
		 * Applies the shadow effect
		 */
		protected function applyShadow():void {
			$bitmapData.applyFilter($bitmapData, $bitmapData.rect, POINT_0x0, _shadow);

			_isShadowApplied = true;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Supers
		// ::::::::::::::::::::::::::::::::::::::::::::::

		retrocamel_int function get $bitmapData():BitmapData {
			return super.bitmapData;
		}

		retrocamel_int function set $bitmapData(value:BitmapData):void {
			super.bitmapData = value;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Overrides
		// ::::::::::::::::::::::::::::::::::::::::::::::

		override public function get bitmapData():BitmapData {
			throw new Error("Can't modify this property!");
		}

		override public function set bitmapData(data:BitmapData):void {
			throw new Error("Can't modify this property!");
		}

		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: X override
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * @inherit
		 */
		override public function get x():Number {
			return super.x;
		}

		/**
		 * @inherit
		 */
		override public function set x(value:Number):void {
			super.x = value;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Y override
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * @inherit
		 */
		override public function get y():Number {
			return super.y;
		}

		/**
		 * @inherit
		 */
		override public function set y(value:Number):void {
			super.y = value;
		}


		/******************************************************************************************************/
		/**                                                                                           ALIGNS  */
		/******************************************************************************************************/

		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Align Center
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Horizontally aligns this component to the center of the screen
		 * @param offset The offset from the center at which this component should be aligned
		 */
		public function alignCenter(offset:Number = 0):void {
			x = ((RetrocamelCore.settings.gameWidth - width) / 2 | 0) + offset | 0;
		}

		/**
		 * Horizontally aligns this component to the center of its parent or specified width
		 * @param offset The offset from the center at which this component should be aligned
		 * @param width The width against which to center this object. If left alone, it centers
		 * against the parent.
		 */
		public function alignCenterParent(offset:Number = 0, width:Number = NaN):void {
			if (isNaN(width)) {
				if (!parent) {
					return;
				} else {
					width = parent.width;
				}
			}

			x = ((width - this.width) / 2 | 0) + offset;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Align Middle
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Vertically aligns this component to the middle of the screen
		 * @param offset The offset from the middle at which this component should be aligned
		 */
		public function alignMiddle(offset:Number = 0):void {
			y = ((RetrocamelCore.settings.gameHeight - height) / 2 | 0) + offset;
		}

		/**
		 * Vertically aligns this component to the middle of its parent or specified height
		 * @param offset The offset from the middle at which this component should be aligned
		 * @param height The width against which to center this object. If left alone, it centers
		 * against the parent.
		 */
		public function alignMiddleParent(offset:Number = 0, height:Number = NaN):void {
			if (isNaN(height)) {
				if (!parent) {
					return;
				} else {
					height = parent.height;
				}
			}

			y = ((height - this.height) / 2 | 0) + offset;
		}


		/******************************************************************************************************/
		/**                                                                        POSTION GETTERS / SETTERS  */
		/******************************************************************************************************/

		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Bottom
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * The bottom edge of the sprite (y + height)
		 */
		public function get bottom():Number {
			return y + height;
		}

		/**
		 * @private
		 */
		public function set bottom(newVal:Number):void {
			y = newVal - height;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Center
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Horizontal center of this sprite
		 */
		public function get center():Number {
			return x + width / 2;
		}

		/**
		 * @private
		 */
		public function set center(value:Number):void {
			x = value - width / 2;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Middle
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Vertical middle of this sprite
		 */
		public function get middle():Number {
			return y + height / 2;
		}

		/**
		 * @private
		 */
		public function set middle(value:Number):void {
			y = value - height / 2;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Right
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * The right edge of the sprite (x + width)
		 */
		public function get right():Number {
			return x + width;
		}

		/**
		 * @private
		 */
		public function set right(newVal:Number):void {
			x = newVal - width;
		}
	}
}