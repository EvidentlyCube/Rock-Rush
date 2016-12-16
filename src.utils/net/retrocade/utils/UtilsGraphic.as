package net.retrocade.utils {
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class UtilsGraphic {
		/****************************************************************************************************************/
		/**                                                                                               STATIC STUFF  */
		/****************************************************************************************************************/

		/**
		 * @private
		 * Instance of the UGraphic utility
		 */
		private static var _instance:UtilsGraphic = new UtilsGraphic();

		/**
		 * Starts drawing with given object
		 * @param object Graphics object or any class which contains graphics parameter
		 * @return net.retrocade.utils.UtilsGraphic objct for chaining
		 */
		public static function draw(object:*):UtilsGraphic {
			if (object is Graphics) {
				_instance.graphics = object;
			}

			else if (object is Shape) {
				_instance.graphics = Shape(object).graphics;
			}

			else if (object is Sprite) {
				_instance.graphics = Sprite(object).graphics;
			}

			else if (object is MovieClip) {
				_instance.graphics = MovieClip(object).graphics;
			}

			return _instance;
		}

		/**
		 * Clears and starts drawing with given object
		 * @param object Graphics object or any class which contains graphics parameter
		 * @return net.retrocade.utils.UtilsGraphic objct for chaining
		 */
		public static function clear(object:*):UtilsGraphic {
			return draw(object).clear();
		}


		/****************************************************************************************************************/
		/**                                                                                                  VARIABLES  */
		/****************************************************************************************************************/
		/**
		 * @private
		 * The graphics object used for drawing
		 */
		private var graphics:Graphics;
		private var matrix:Matrix = new Matrix();


		/****************************************************************************************************************/
		/**                                                                                                  FUNCTIONS  */
		/****************************************************************************************************************/

		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Non standard
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		public function UtilsGraphic() {
		}

		/**
		 * Draws rectangle
		 * @param x X position of the left edge
		 * @param y Y position of the top edge
		 * @param width Width of the rectangle
		 * @param height Height of the rectangle
		 * @param color Color of the rectangle
		 * @param alpha Alpha of the rectangle
		 * @return Chain
		 */
		public function rectFill(x:Number, y:Number, width:Number, height:Number, color:uint, alpha:Number = 1):UtilsGraphic {
			graphics.beginFill(color, alpha);
			graphics.drawRect(x, y, width, height);
			graphics.endFill();

			return this;
		}

		/**
		 * Draws rectangle filled with gradient
		 * @param x X position of the left edge
		 * @param y Y position of the top edge
		 * @param width Width of the rectangle
		 * @param height Height of the rectangle
		 * @param colors Colors of the gradient
		 * @param alphas Alphas of the gradient
		 * @param ratios Ratios of the gradient
		 * @param rotation Rotation of the gradient in degrees
		 * @return Chain
		 */
		public function rectFillGradient(x:Number, y:Number, width:Number, height:Number, colors:Array, alphas:Array, ratios:Array, rotation:Number):UtilsGraphic {
			var matrix:Matrix = new Matrix();

			matrix.createGradientBox(width, height, rotation * Math.PI / 180);

			graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			graphics.drawRect(x, y, width, height);
			graphics.endFill();

			return this;
		}

		/**
		 * Draws rectangle
		 * @param x X position of the left edge
		 * @param y Y position of the top edge
		 * @param width Width of the rectangle
		 * @param height Height of the rectangle
		 * @param color Color of the rectangle
		 * @param alpha Alpha of the rectangle
		 * @return Chain
		 */
		public function rectFillBitmap(x:Number, y:Number, width:Number, height:Number, bitmap:BitmapData, offsetX:Number, offsetY:Number):UtilsGraphic {
			matrix.identity();

			matrix.translate(offsetX, offsetY);
			graphics.beginBitmapFill(bitmap, matrix, true);
			graphics.drawRect(x, y, width, height);
			graphics.endFill();

			return this;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Maps to the standard Graphics methods
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Draws outline of a rectangle (within the width - height bounds!)
		 * @param x X position of the left edge
		 * @param y Y position of the top edge
		 * @param width Width of the rectangle
		 * @param height height of the rectangle
		 * @param bold Size of the ouline
		 * @param color Color of the outline
		 * @param alpha Alpha of the rectangle
		 * @return Chain
		 */
		public function rectOutline(x:Number, y:Number, width:Number, height:Number, bold:Number, color:uint, alpha:Number = 1):UtilsGraphic {
			graphics.beginFill(color, alpha);
			graphics.drawRect(x, y, width, bold);
			graphics.drawRect(x, y + height - bold, width, bold);
			graphics.drawRect(x, y + bold, bold, height - 2 * bold);
			graphics.drawRect(x + width - bold, y + bold, bold, height - 2 * bold);
			graphics.endFill();

			return this;
		}

		/**
		 * @copy flash.display.Graphics#beginBitmapFill()
		 */
		public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):UtilsGraphic {
			graphics.beginBitmapFill(bitmap, matrix, repeat, smooth);

			return this;
		}

		/**
		 * A simplifier for the beginBitmapFill function
		 * @param    bitmap Bitmap to draw
		 * @param    x X offset on the Bitmap
		 * @param    y Y offset on the Bitmap
		 * @param    repeat Whether to repeat
		 * @param    smooth Whether to smooth the image
		 * @return UGraphics object
		 */
		public function beginBitmapFillSimple(bitmap:BitmapData, x:Number, y:Number, repeat:Boolean = true, smooth:Boolean = false):UtilsGraphic {
			matrix.identity();

			matrix.translate(x, y);

			graphics.beginBitmapFill(bitmap, matrix, repeat, smooth);

			return this;
		}

		/**
		 * @copy flash.display.Graphics#beginFill()
		 */
		public function beginFill(color:uint, alpha:Number = 1.0):UtilsGraphic {
			graphics.beginFill(color, alpha);

			return this;
		}

		/**
		 * @copy flash.display.Graphics#clear()
		 */
		public function clear():UtilsGraphic {
			graphics.clear();

			return this;
		}

		/**
		 * @copy flash.display.Graphics#copyFrom()
		 */
		public function copyFrom(sourceGraphics:Graphics):UtilsGraphic {
			graphics.copyFrom(sourceGraphics);

			return this;
		}

		/**
		 * @copy flash.display.Graphics#curveTo()
		 */
		public function curveTo(curveX:Number, curveY:Number, toX:Number, toY:Number):UtilsGraphic {
			graphics.curveTo(curveX, curveY, toX, toY);

			return this;
		}

		/**
		 * @copy flash.display.Graphics#drawCircle()
		 */
		public function drawCircle(x:Number, y:Number, radius:Number):UtilsGraphic {
			graphics.drawCircle(x, y, radius);

			return this;
		}

		/**
		 * @copy flash.display.Graphics#drawEllipse()
		 */
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):UtilsGraphic {
			graphics.drawEllipse(x, y, width, height);

			return this;
		}

		/**
		 * @copy flash.display.Graphics#drawRect()
		 */
		public function drawRect(x:Number, y:Number, width:Number, height:Number):UtilsGraphic {
			graphics.drawRect(x, y, width, height);

			return this;
		}

		/**
		 * @copy flash.display.Graphics#drawRoundRect()
		 */
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number = NaN):UtilsGraphic {
			graphics.drawRoundRect(x, y, width, height, ellipseWidth, ellipseHeight);

			return this;
		}

		/**
		 * @copy flash.display.Graphics#endFill()
		 */
		public function endFill():UtilsGraphic {
			graphics.endFill();

			return this;
		}

		/**
		 * @copy flash.display.Graphics#lineBitmapStyle()
		 */
		public function lineBitmapStyle(bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):UtilsGraphic {
			graphics.lineBitmapStyle(bitmap, matrix, repeat, smooth);

			return this;
		}

		/**
		 * @copy flash.display.Graphics#lineBitmapStyle()
		 */
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):UtilsGraphic {
			graphics.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);

			return this;
		}

		/**
		 * @copy flash.display.Graphics#lineTo()
		 */
		public function lineTo(x:Number, y:Number):UtilsGraphic {
			graphics.lineTo(x, y);

			return this;
		}

		/**
		 * @copy flash.display.Graphics#moveTo()
		 */
		public function moveTo(x:Number, y:Number):UtilsGraphic {
			graphics.moveTo(x, y);

			return this;
		}
	}
}