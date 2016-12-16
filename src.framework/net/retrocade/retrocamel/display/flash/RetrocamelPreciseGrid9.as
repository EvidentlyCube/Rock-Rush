package net.retrocade.retrocamel.display.flash {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import net.retrocade.utils.UtilsBitmapData;

	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	public class RetrocamelPreciseGrid9 extends RetrocamelSprite {
		/****************************************************************************************************************/
		/**                                                                                           STATIC FUNCTIONS  */
		/****************************************************************************************************************/

		private static var _gridLibrary:Array = [];

		public static function make(name:String, bitmapData:BitmapData, x:uint, y:uint, width:uint, height:uint):void {
			var g:RetrocamelPreciseGrid9 = new RetrocamelPreciseGrid9();
			var r:Rectangle = new Rectangle();
			var p:Point = new Point();

			g._widthLeft = x;
			g._widthRight = bitmapData.width - width - x;
			g._heightTop = y;
			g._heightBottom = bitmapData.height - height - y;
			g._minWidth = g._widthLeft + g._widthRight;
			g._minHeight = g._heightTop + g._heightBottom;

			r.x = 0;
			r.y = 0;
			r.width = x;
			r.height = y;
			g._topLeftBD = new BitmapData(x, y, true, 0);
			g._topLeftBD.copyPixels(bitmapData, r, p, null, null, true);

			r.x = x;
			r.y = 0;
			r.width = width;
			r.height = y;
			g._topBD = new BitmapData(width, y, true, 0);
			g._topBD.copyPixels(bitmapData, r, p, null, null, true);

			r.x = x + width;
			r.y = 0;
			r.width = g._widthRight;
			r.height = y;
			g._topRightBD = new BitmapData(g._widthRight, y, true, 0);
			g._topRightBD.copyPixels(bitmapData, r, p, null, null, true);

			r.x = 0;
			r.y = y;
			r.width = x;
			r.height = height;
			g._leftBD = new BitmapData(x, height, true, 0);
			g._leftBD.copyPixels(bitmapData, r, p, null, null, true);

			r.x = x;
			r.y = y;
			r.width = width;
			r.height = height;
			g._midBD = new BitmapData(width, height, true, 0);
			g._midBD.copyPixels(bitmapData, r, p, null, null, true);


			r.x = x + width;
			r.y = y;
			r.width = g._widthRight;
			r.height = height;
			g._rightBD = new BitmapData(g._widthRight, height, true, 0);
			g._rightBD.copyPixels(bitmapData, r, p, null, null, true);

			r.x = 0;
			r.y = y + height;
			r.width = x;
			r.height = g._heightBottom;
			g._bottomLeftBD = new BitmapData(x, g._heightBottom, true, 0);
			g._bottomLeftBD.copyPixels(bitmapData, r, p, null, null, true);

			r.x = x;
			r.y = y + height;
			r.width = width;
			r.height = g._heightBottom;
			g._bottomBD = new BitmapData(width, g._heightBottom, true, 0);
			g._bottomBD.copyPixels(bitmapData, r, p, null, null, true);

			r.x = x + width;
			r.y = y + height;
			r.width = g._widthRight;
			r.height = g._heightBottom;
			g._bottomRightBD = new BitmapData(g._widthRight, g._heightBottom, true, 0);
			g._bottomRightBD.copyPixels(bitmapData, r, p, null, null, true);

			_gridLibrary[name] = g;
		}

		public static function getGrid(name:String, dontScale:Boolean = false):RetrocamelPreciseGrid9 {
			var newGrid:RetrocamelPreciseGrid9 = new RetrocamelPreciseGrid9(dontScale);
			var source:RetrocamelPreciseGrid9 = _gridLibrary[name];

			newGrid._topLeftBD = source._topLeftBD;
			newGrid._topBD = source._topBD;
			newGrid._topRightBD = source._topRightBD;
			newGrid._leftBD = source._leftBD;
			newGrid._midBD = source._midBD;
			newGrid._rightBD = source._rightBD;
			newGrid._bottomLeftBD = source._bottomLeftBD;
			newGrid._bottomBD = source._bottomBD;
			newGrid._bottomRightBD = source._bottomRightBD;

			newGrid._widthLeft = source._widthLeft;
			newGrid._widthRight = source._widthRight;
			newGrid._heightTop = source._heightTop;
			newGrid._heightBottom = source._heightBottom;
			newGrid._minWidth = source._minWidth;
			newGrid._minHeight = source._minHeight;

			newGrid.width = newGrid._minWidth;
			newGrid.height = newGrid._minHeight;

			return newGrid;
		}


		/****************************************************************************************************************/
		/**                                                                                                   VARIABLES */
		/****************************************************************************************************************/

		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Unchangeable variables
		// ::::::::::::::::::::::::::::::::::::::::::::::

		private var _topLeftBD:BitmapData;
		private var _topBD:BitmapData;
		private var _topRightBD:BitmapData;
		private var _leftBD:BitmapData;
		private var _midBD:BitmapData;
		private var _rightBD:BitmapData;
		private var _bottomLeftBD:BitmapData;
		private var _bottomBD:BitmapData;
		private var _bottomRightBD:BitmapData;

		private var _bitmapData:BitmapData;
		private var _bitmap:Bitmap;

		private var _widthLeft:uint;

		public function get widthLeft():uint {
			return _widthLeft;
		}

		private var _widthRight:uint;

		public function get widthRight():uint {
			return _widthRight;
		}

		private var _heightTop:uint;

		public function get heightTop():uint {
			return _heightTop;
		}

		private var _heightBottom:uint;

		public function get heightBottom():uint {
			return _heightBottom;
		}
		private var _minWidth:uint;
		private var _minHeight:uint;

		private var _dontScale:Boolean;
		private var _matrix:Matrix;


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Inner Dimensions and Positions
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Accesses the height of the inner part of the grid
		 */
		public function get innerWidth():Number {
			return width - _minWidth;
		}

		/**
		 * @private
		 */
		public function set innerWidth(value:Number):void {
			width = value + _minWidth;
		}

		/**
		 * Accesses the height of the inner part of the grid
		 */
		public function get innerHeight():Number {
			return height - _minHeight;
		}

		/**
		 * @private
		 */
		public function set innerHeight(value:Number):void {
			height = value + _minHeight;
		}

		/**
		 * Accesses the X position of the inner part of the grid
		 */
		public function get innerX():Number {
			return x + _widthLeft;
		}

		/**
		 * @private
		 */
		public function set innerX(value:Number):void {
			x = value - _widthLeft;
		}

		/**
		 * Accesses the Y position of the inner part of the grid
		 */
		public function get innerY():Number {
			return y + _heightTop;
		}

		/**
		 * @private
		 */
		public function set innerY(value:Number):void {
			y = value - _heightTop;
		}


		/****************************************************************************************************************/
		/**                                                                                                   OVERRIDES */
		/****************************************************************************************************************/

		override public function set width(value:Number):void {
			value |= 0;

			if (value < _minWidth)
				value = _minWidth;

			redraw(value, height);

		}

		override public function set height(value:Number):void {
			value |= 0;

			if (value < _minHeight)
				value = _minHeight;

			redraw(width, value);
		}

		override public function set x(value:Number):void {
			super.x = value | 0;
		}

		override public function set y(value:Number):void {
			super.y = value | 0;
		}

		public function RetrocamelPreciseGrid9(dontScale:Boolean = false):void {
			_dontScale = dontScale;
			_matrix = new Matrix();

			_bitmapData = new BitmapData(1, 1);
			_bitmap = new Bitmap(_bitmapData);

			addChild(_bitmap);
		}

		private function redraw(newWidth:uint, newHeight:uint):void {
			if (_bitmapData.width !== newWidth || _bitmapData.height !== newHeight) {
				_bitmapData.dispose();
				_bitmapData = new BitmapData(newWidth, newHeight, true, 0x00000000);
				_bitmapData.fillRect(new Rectangle(0, 0, newWidth, newHeight), 0);
				_bitmap.bitmapData = _bitmapData;
				_bitmap.width = _bitmapData.width;
				_bitmap.height = _bitmapData.height;

				_bitmap.scaleX = 1;
				_bitmap.scaleY = 1;
			}

			var drawFunction:Function = _dontScale ? UtilsBitmapData.blitToRectangleRepeat : UtilsBitmapData.blitToRectangleScaled;

			drawFunction(_midBD, _bitmapData, new Rectangle(widthLeft, heightTop, innerWidth, innerHeight));
			drawFunction(_leftBD, _bitmapData, new Rectangle(0, heightTop, widthLeft, innerHeight));
			drawFunction(_topBD, _bitmapData, new Rectangle(widthLeft, 0, innerWidth, heightTop));
			drawFunction(_rightBD, _bitmapData, new Rectangle(innerWidth + widthLeft, heightTop, widthLeft, innerHeight));
			drawFunction(_bottomBD, _bitmapData, new Rectangle(widthLeft, innerHeight + heightTop, innerWidth, heightTop));

			UtilsBitmapData.blit(_topLeftBD, _bitmapData, 0, 0);
			UtilsBitmapData.blit(_topRightBD, _bitmapData, _bitmapData.width - _topRightBD.width, 0);
			UtilsBitmapData.blit(_bottomLeftBD, _bitmapData, 0, _bitmapData.height - _topRightBD.height);
			UtilsBitmapData.blit(_bottomRightBD, _bitmapData, _bitmapData.width - _topRightBD.width, _bitmapData.height - _topRightBD.height);
		}
	}
}