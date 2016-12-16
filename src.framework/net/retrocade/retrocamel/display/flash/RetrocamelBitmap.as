package net.retrocade.retrocamel.display.flash {
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.retrocamel_int;

	use namespace retrocamel_int;

	public class RetrocamelBitmap extends Bitmap {
		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Constructor
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public function RetrocamelBitmap(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false) {
			super(bitmapData, pixelSnapping, smoothing);
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

			x = ((width - this.width) / 2) + offset;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Align Middle
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Vertically aligns this component to the middle of the screen
		 * @param offset The offset from the middle at which this component should be aligned
		 */
		public function alignMiddle(offset:Number = 0):void {
			y = ((RetrocamelCore.settings.gameHeight - height) / 2) + offset;
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

			y = ((height - this.height) / 2) + offset;
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


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Misc Functions
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Sets the position and the size of this sprite
		 * @param    x Target x
		 * @param    y Target y
		 * @param    width Target width
		 * @param    height Target height
		 */
		public function setSizePosition(x:Number, y:Number, width:Number, height:Number):void {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
	}
}