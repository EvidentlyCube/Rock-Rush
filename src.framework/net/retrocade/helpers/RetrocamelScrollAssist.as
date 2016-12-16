package net.retrocade.helpers {
	import net.retrocade.utils.UtilsNumber;

	public class RetrocamelScrollAssist {
		/****************************************************************************************************************/
		/**                                                                                              STATIC ACCESS  */
		/****************************************************************************************************************/

		/**
		 * Instance of the currently used scroller
		 */
		private static var _instance:RetrocamelScrollAssist = new RetrocamelScrollAssist();

		public static function get instance():RetrocamelScrollAssist {
			return _instance;
		}
		public var speed:Number = 1;

		private var _displayWidth:uint;

		public function get displayWidth():uint {
			return _displayWidth;
		}

		public function set displayWidth(value:uint):void {
			_displayWidth = value;
		}

		private var _displayHeight:uint;

		public function get displayHeight():uint {
			return _displayHeight;
		}

		public function set displayHeight(value:uint):void {
			_displayHeight = value;
		}
		private var _cornerLeft:int = 0;
		private var _cornerTop:int = 0;
		private var _cornerRight:int = 0;
		private var _cornerBottom:int = 0;

		private var _x:Number = 0;

		public static function get x():Number {
			return _instance._x | 0;
		}

		private var _y:Number = 0;

		public static function get y():Number {
			return _instance._y | 0;
		}
		private var _toX:Number = 0;


		/****************************************************************************************************************/
		/**                                                                                                  Functions  */
		/****************************************************************************************************************/
		private var _toY:Number = 0;

		private var _isScrollLocked:Boolean = false;

		public function get isScrollLocked():Boolean {
			return _isScrollLocked;
		}

		public function set isScrollLocked(value:Boolean):void {
			_isScrollLocked = value;
		}

		private var _horizontalScrollEnabled:Boolean = true;

		public function get horizontalScrollEnabled():Boolean {
			return _horizontalScrollEnabled;
		}

		public function set horizontalScrollEnabled(value:Boolean):void {
			_horizontalScrollEnabled = value;
		}

		private var _verticalScrollEnabled:Boolean = true;

		public function get verticalScrollEnabled():Boolean {
			return _verticalScrollEnabled;
		}

		public function set verticalScrollEnabled(value:Boolean):void {
			_verticalScrollEnabled = value;
		}

		/**
		 * Constructor
		 */
		public function RetrocamelScrollAssist() {
			_instance = this;
		}

		public function update():void {
			if (!_isScrollLocked) {
				if (_horizontalScrollEnabled && _x != _toX) {
					_x = UtilsNumber.limit(UtilsNumber.approach(_x, _toX, speed), cornerRightWithoutWidth(), _cornerLeft);
				}

				if (_verticalScrollEnabled && _y != _toY) {
					_y = UtilsNumber.limit(UtilsNumber.approach(_y, _toY, speed), cornerBottomWithoutHeight(), _cornerTop);
				}
			}
		}

		/**
		 * Sets the edges of the scroller, maximum postion which can be displayed by it
		 * @param left Left edge of the scroller (this is the last pixel which will be displayed)
		 * @param top Top edge of the scroller (this is the last pixel which will be displayed)
		 * @param right Right edge of the scroller (this is the last pixel which will be displayed)
		 * @param bottom Bottom edge of the scroller (this is the last pixel which will be displayed)
		 */
		public function setCorners(left:Number, top:Number, right:Number, bottom:Number):void {
			_cornerLeft = left;
			_cornerTop = top;
			_cornerRight = right;
			_cornerBottom = bottom;
		}

		/**
		 * Tells the scroller to scroll to given position, only applicable if locked or there is no following object
		 * @param toX X position to scroll to
		 * @param toY Y position to scroll to
		 */
		public function scrollTo(toX:Number, toY:Number):void {
			_toX = UtilsNumber.limit(toX - _displayWidth / 2, _cornerRight, _cornerLeft);
			_toY = UtilsNumber.limit(toY - _displayHeight / 2, _cornerBottom, _cornerTop);
		}

		/**
		 * Sets the scroller position to given coordinates immediately
		 * @param toX X position to set the scroller to
		 * @param toY Y position to set the scroller to
		 */
		public function setScroll(toX:Number, toY:Number):void {
			_x = _toX = Math.max(_cornerLeft, Math.min(_cornerRight, toX));
			_y = _toY = Math.max(_cornerTop, Math.min(_cornerBottom, toY));
		}

		public function get x():Number {
			return Math.floor(_x);
		}

		public function get y():Number {
			return Math.floor(_y);
		}

		public function get edgeLeft():Number {
			return _cornerLeft;
		}

		public function get edgeRight():Number {
			return _cornerRight;
		}

		public function get edgeTop():Number {
			return _cornerTop
		}

		public function get edgeBottom():Number {
			return _cornerBottom;
		}

		private function cornerRightWithoutWidth():Number {
			return _cornerRight - _displayWidth;
		}

		private function cornerBottomWithoutHeight():Number {
			return _cornerBottom - _displayHeight;
		}
	}
}