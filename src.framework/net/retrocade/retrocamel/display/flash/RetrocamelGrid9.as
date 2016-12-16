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
	public class RetrocamelGrid9 extends RetrocamelSprite {
		/****************************************************************************************************************/
		/**                                                                                           STATIC FUNCTIONS  */
		/****************************************************************************************************************/

		private static var _gridLibrary:Array = [];

		public static function make(name:String, bitmapData:BitmapData, x:uint, y:uint, width:uint, height:uint):void {
			var g:RetrocamelGrid9 = new RetrocamelGrid9();
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

		public static function getGrid(name:String, dontScale:Boolean = false):RetrocamelGrid9 {
			var newGrid:RetrocamelGrid9 = new RetrocamelGrid9(dontScale);
			var source:RetrocamelGrid9 = _gridLibrary[name];

			if (dontScale && false) {
				newGrid._midBD = source._midBD;

				newGrid._topBD = UtilsBitmapData.expandBitmapData(source._topBD, false, false, true, false);
				newGrid._leftBD = UtilsBitmapData.expandBitmapData(source._leftBD, false, true, false, false);
				newGrid._rightBD = UtilsBitmapData.expandBitmapData(source._rightBD, false, false, false, true);
				newGrid._bottomBD = UtilsBitmapData.expandBitmapData(source._bottomBD, true, false, false, false);

				newGrid._topLeftBD = source._topLeftBD;
				newGrid._topRightBD = source._topRightBD;
				newGrid._bottomLeftBD = source._bottomLeftBD;
				newGrid._bottomRightBD = source._bottomRightBD;
			} else {
				newGrid._topLeftBD = source._topLeftBD;
				newGrid._topBD = source._topBD;
				newGrid._topRightBD = source._topRightBD;
				newGrid._leftBD = source._leftBD;
				newGrid._midBD = source._midBD;
				newGrid._rightBD = source._rightBD;
				newGrid._bottomLeftBD = source._bottomLeftBD;
				newGrid._bottomBD = source._bottomBD;
				newGrid._bottomRightBD = source._bottomRightBD;
			}

			newGrid._widthLeft = source._widthLeft;
			newGrid._widthRight = source._widthRight;
			newGrid._heightTop = source._heightTop;
			newGrid._heightBottom = source._heightBottom;
			newGrid._minWidth = source._minWidth;
			newGrid._minHeight = source._minHeight;

			if (!dontScale) {
				newGrid._topLeft = new Bitmap(newGrid._topLeftBD);
				newGrid._top = new Bitmap(newGrid._topBD);
				newGrid._topRight = new Bitmap(newGrid._topRightBD);
				newGrid._left = new Bitmap(newGrid._leftBD);
				newGrid._mid = new Bitmap(newGrid._midBD);
				newGrid._right = new Bitmap(newGrid._rightBD);
				newGrid._bottomLeft = new Bitmap(newGrid._bottomLeftBD);
				newGrid._bottom = new Bitmap(newGrid._bottomBD);
				newGrid._bottomRight = new Bitmap(newGrid._bottomRightBD);

				newGrid.addChild(newGrid._mid);
				newGrid.addChild(newGrid._top);
				newGrid.addChild(newGrid._left);
				newGrid.addChild(newGrid._right);
				newGrid.addChild(newGrid._bottom);
				newGrid.addChild(newGrid._topLeft);
				newGrid.addChild(newGrid._topRight);
				newGrid.addChild(newGrid._bottomLeft);
				newGrid.addChild(newGrid._bottomRight);

				newGrid._top.x = newGrid._widthLeft - 1;
				newGrid._bottom.x = newGrid._widthLeft - 1;
				newGrid._left.y = newGrid._heightTop - 1;
				newGrid._right.y = newGrid._heightTop - 1;
				newGrid._mid.x = newGrid._widthLeft - 1;
				newGrid._mid.y = newGrid._heightTop - 1;
			}

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

		private var _topLeft:Bitmap;
		private var _top:Bitmap;
		private var _topRight:Bitmap;
		private var _left:Bitmap;
		private var _mid:Bitmap;
		private var _right:Bitmap;
		private var _bottomLeft:Bitmap;
		private var _bottom:Bitmap;
		private var _bottomRight:Bitmap;

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

			if (_dontScale) {
				redraw(value, height);

			} else {
				_bottom.width = _mid.width = _top.width = (value - _minWidth | 0) + 2;

				_topRight.x = _right.x = _bottomRight.x = value - _widthRight | 0;
			}
		}

		override public function set height(value:Number):void {
			value |= 0;

			if (value < _minHeight)
				value = _minHeight;

			if (_dontScale) {
				redraw(width, value);

			} else {
				_left.height = _mid.height = _right.height = (value - _minHeight | 0) + 2;

				_bottomLeft.y = _bottom.y = _bottomRight.y = value - _heightBottom | 0;
			}
		}

		override public function set x(value:Number):void {
			super.x = value | 0;
		}

		override public function set y(value:Number):void {
			super.y = value | 0;
		}

		public function RetrocamelGrid9(dontScale:Boolean = false):void {
			_dontScale = dontScale;
			_matrix = new Matrix();
		}

		private function redraw(newWidth:uint, newHeight:uint):void {
			graphics.clear();

			// Draw Top
			_matrix.tx = _widthLeft;
			_matrix.ty = 0;
			graphics.beginBitmapFill(_topBD, _matrix);
			graphics.drawRect(_widthLeft - 1, 0, newWidth - _widthLeft - _widthRight + 2, _topBD.height);

			// Draw Left
			_matrix.tx = 0;
			_matrix.ty = _heightTop;
			graphics.beginBitmapFill(_leftBD, _matrix);
			graphics.drawRect(0, _heightTop - 1, _leftBD.width, newHeight - _heightTop - _heightBottom + 2);

			// Draw Right
			_matrix.tx = newWidth - _widthRight;
			_matrix.ty = _heightTop;
			graphics.beginBitmapFill(_rightBD, _matrix);
			graphics.drawRect(newWidth - _widthRight,
				_heightTop - 1,
				_rightBD.width,
				newHeight - _heightTop - _heightBottom + 2
			);

			// Draw Bottom
			_matrix.tx = _widthLeft;
			_matrix.ty = newHeight - _heightBottom;
			graphics.beginBitmapFill(_bottomBD, _matrix);
			graphics.drawRect(_widthLeft - 1,
				newHeight - _heightBottom,
				newWidth - _widthLeft - _widthRight + 2,
				_bottomBD.height);


			// Draw Center
			_matrix.tx = _widthLeft;
			_matrix.ty = _heightTop;
			graphics.beginBitmapFill(_midBD, _matrix);
			graphics.drawRect(_widthLeft - 1,
				_heightTop - 1,
				newWidth - _widthLeft - _widthRight + 2,
				newHeight - _heightTop - _heightBottom + 2);


			// Draw Top Left
			_matrix.tx = _matrix.ty = 0;
			graphics.beginBitmapFill(_topLeftBD, _matrix);
			graphics.drawRect(0, 0, _topLeftBD.width, _topLeftBD.height);

			// Draw Top Right
			_matrix.tx = newWidth - _widthRight;
			_matrix.ty = 0;
			graphics.beginBitmapFill(_topRightBD, _matrix);
			graphics.drawRect(newWidth - _widthRight, 0, _widthRight, _topRightBD.height);

			// Draw Bottom Right
			_matrix.tx = newWidth - _widthRight;
			_matrix.ty = newHeight - _heightBottom;
			graphics.beginBitmapFill(_bottomRightBD, _matrix);
			graphics.drawRect(newWidth - _widthRight,
				newHeight - _heightBottom,
				_bottomRightBD.width,
				_bottomRightBD.height);

			// Draw Bottom Left
			_matrix.tx = 0;
			_matrix.ty = newHeight - _heightBottom;
			graphics.beginBitmapFill(_bottomLeftBD, _matrix);
			graphics.drawRect(0, newHeight - _heightBottom, _bottomLeftBD.width, _heightBottom);

		}
	}
}