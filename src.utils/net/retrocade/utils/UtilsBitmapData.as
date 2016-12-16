package net.retrocade.utils {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class UtilsBitmapData {
		private static var POINT:Point = new Point();
		private static var MATRIX:Matrix = new Matrix();
		private static var RECT:Rectangle = new Rectangle();
		private static var COLORTRANSFORM:ColorTransform = new ColorTransform();

		/**
		 * Returns a mirrored BitmapData, the original is unmodified
		 * @param data BitmapData to be mirrored
		 * @return New, mirrored BitmapData
		 */
		public static function mirror(data:BitmapData):BitmapData {
			var m:Matrix = new Matrix();
			m.scale(-1, 1);
			m.translate(data.width, 0);

			var bitmapData:BitmapData = new BitmapData(data.width, data.height, true, 0);
			bitmapData.draw(data, m);

			return bitmapData;
		}

		public static function expandBitmapData(source:BitmapData, top:Boolean, right:Boolean, bottom:Boolean, left:Boolean):BitmapData {
			var target:BitmapData = new BitmapData(
				source.width + (left ? 1 : 0) + (right ? 1 : 0),
				source.height + (top ? 1 : 0) + (bottom ? 1 : 0)
			);

			blit(source, target, left ? 1 : 0, top ? 1 : 0);

			if (left) {
				blitColumn(source, target, 0, 0);
			}
			if (right) {
				blitColumn(source, target, source.width - 1, target.width - 1);
			}
			if (top) {
				blitRow(source, target, 0, 0);
			}
			if (bottom) {
				blitRow(source, target, source.height - 1, target.height - 1);
			}

			if (top && left) {
				copyPixel(source, target, 0, 0, 0, 0);
			}
			if (top && right) {
				copyPixel(source, target, source.width - 1, 0, target.width - 1, 0);
			}
			if (bottom && left) {
				copyPixel(source, target, 0, source.height - 1, 0, target.height - 1);
			}
			if (bottom && right) {
				copyPixel(source, target, source.width - 1, source.height - 1, target.width - 1, target.height - 1);
			}
			return target;
		}

		public static function copyPixel(source:BitmapData, target:BitmapData, sourceX:uint, sourceY:uint, targetX:uint, targetY:uint):void {
			RECT.x = sourceX;
			RECT.y = sourceY;
			RECT.width = 1;
			RECT.height = 1;
			POINT.x = targetX;
			POINT.y = targetY;

			target.copyPixels(source, RECT, POINT);
		}

		public static function blitRow(source:BitmapData, target:BitmapData, sourceY:uint, targetY:uint):void {
			RECT.x = 0;
			RECT.y = sourceY;
			RECT.width = source.width;
			RECT.height = source.height;

			POINT.x = 0;
			POINT.y = targetY;

			target.copyPixels(source, RECT, POINT, null, null, true);
		}

		public static function blitColumn(source:BitmapData, target:BitmapData, sourceX:uint, targetX:uint):void {
			RECT.x = sourceX;
			RECT.y = 0;
			RECT.width = source.width;
			RECT.height = source.height;

			POINT.x = targetX;
			POINT.y = 0;

			target.copyPixels(source, RECT, POINT, null, null, true);
		}

		public static function blitToRectangleRepeat(source:BitmapData, target:BitmapData, targetRectangle:Rectangle):void {
			var tempR:Rectangle = new Rectangle(0, 0, source.width, source.height);

			for (var x:int = targetRectangle.x; x < targetRectangle.right; x += source.width) {
				for (var y:int = targetRectangle.y; y < targetRectangle.bottom; y += source.height) {
					tempR.x = 0;
					tempR.y = 0;
					tempR.width = Math.min(source.width, targetRectangle.right - x);
					tempR.height = Math.min(source.height, targetRectangle.bottom - y);

					blitByRect(source, tempR, target, x, y);
				}
			}
		}

		public static function blitToRectangleScaled(source:BitmapData, target:BitmapData, targetRectangle:Rectangle):void {
			var scaleX:Number = targetRectangle.width / source.width;
			var scaleY:Number = targetRectangle.height / source.height;

			MATRIX.identity();
			MATRIX.translate(targetRectangle.x, targetRectangle.y);
			MATRIX.scale(scaleX, scaleY);

			target.draw(source, MATRIX);
		}

		public static function blit(source:BitmapData, target:BitmapData, x:uint, y:uint):void {
			POINT.x = x;
			POINT.y = y;

			target.copyPixels(source, source.rect, POINT, null, null, true);
		}

		public static function blitByRect(source:BitmapData, sourceRect:Rectangle, target:BitmapData, x:uint, y:uint):void {
			POINT.x = x;
			POINT.y = y;

			target.copyPixels(source, sourceRect, POINT, null, null, true);
		}

		/**
		 * Blits a designated BitmapData's region to another BitmapData
		 * @param source Source BitmapData
		 * @param target Target BitmapData
		 * @param x Target draw position
		 * @param y Target draw position
		 * @param sourceX X of the top-left corner of the source rectangle
		 * @param sourceY Y of the top-left corner of the source rectangle
		 * @param sourceWidth Width of the source rectangle
		 * @param sourceHeight Height of the source rectangle
		 */
		public static function blitPart(source:BitmapData, target:BitmapData, x:int, y:int, sourceX:uint, sourceY:uint,
		                                sourceWidth:uint, sourceHeight:uint):void {
			RECT.x = sourceX;
			RECT.y = sourceY;
			RECT.width = sourceWidth;
			RECT.height = sourceHeight;

			POINT.x = x;
			POINT.y = y;

			target.copyPixels(source, RECT, POINT, null, null, true);
		}

		/**
		 * Blits a rectangle on a given BitmapData
		 * @param target BitmapData on which you want to draw the rectangle
		 * @param x X position of the desired rectangle
		 * @param y Y position of the desired rectangle
		 * @param width Width of the desired rectangle
		 * @param height Height of the desired rectangle
		 * @param color RGBA color
		 */
		public static function blitRectangle(target:BitmapData, x:uint, y:uint, width:uint, height:uint, color:uint = 0xFFFFFFFF):void {
			RECT.x = x;
			RECT.y = y;
			RECT.width = width;
			RECT.height = height;

			target.fillRect(RECT, color);
		}

		/**
		 * Applies a ColorTransform to a given BitmapData
		 * @param data BitmapData to be colorized
		 * @param redMulti
		 * @param greenMulti
		 * @param blueMulti
		 * @param redOffset
		 * @param greenOffset
		 * @param blueOffset
		 */
		public static function colorize(data:BitmapData, redMulti:Number, greenMulti:Number, blueMulti:Number, redOffset:int, greenOffset:int, blueOffset:int):void {
			COLORTRANSFORM = new ColorTransform(redMulti, greenMulti, blueMulti, 1, redOffset, greenOffset, blueOffset, 0);
			data.colorTransform(data.rect, COLORTRANSFORM);
		}

		public static function draw(source:IBitmapDrawable, target:BitmapData, x:int, y:int):void {
			MATRIX.identity();
			MATRIX.translate(x, y);
			target.draw(source, MATRIX);
		}

		public static function drawPart(source:IBitmapDrawable, target:BitmapData, x:int, y:int, sourceRect:Rectangle, blendMode:String = null):void {

			MATRIX.identity();
			MATRIX.translate(x - sourceRect.x, y - sourceRect.y);

			target.draw(source, MATRIX, null, blendMode, sourceRect);
		}

		public static function drawSpecial(source:*, target:BitmapData, x:int, y:int, rotation:Number = 0, scaleX:Number = 1, scaleY:Number = 1,
		                                   alpha:Number = 1, blend:String = null, smoothing:Boolean = true,
		                                   redMultiplier:Number = 1, greenMultiplier:Number = 1, blueMultiplier:Number = 1,
		                                   redOffset:Number = 0, greenOffset:Number = 0, blueOffset:Number = 0, alphaOffset:Number = 0):void {
			MATRIX.identity();
			MATRIX.translate(-source.width / 2, -source.height / 2);
			MATRIX.rotate(rotation * Math.PI / 180);
			MATRIX.scale(scaleX, scaleY);
			MATRIX.translate(source.width / 2 + x, source.height / 2 + y);
			COLORTRANSFORM.redMultiplier = redMultiplier;
			COLORTRANSFORM.blueMultiplier = blueMultiplier;
			COLORTRANSFORM.greenMultiplier = greenMultiplier;
			COLORTRANSFORM.alphaMultiplier = alpha;
			COLORTRANSFORM.redOffset = redOffset;
			COLORTRANSFORM.greenOffset = greenOffset;
			COLORTRANSFORM.blueOffset = blueOffset;
			COLORTRANSFORM.alphaOffset = alphaOffset;

			target.draw(source, MATRIX, COLORTRANSFORM, blend, null, smoothing);

			COLORTRANSFORM.redOffset = 0;
			COLORTRANSFORM.greenOffset = 0;
			COLORTRANSFORM.blueOffset = 0;
			COLORTRANSFORM.alphaOffset = 0;
			COLORTRANSFORM.redMultiplier = 1;
			COLORTRANSFORM.blueMultiplier = 1;
			COLORTRANSFORM.greenMultiplier = 1;
			COLORTRANSFORM.alphaMultiplier = 1;
		}

		public static function shapeRectangle(data:BitmapData, x:uint, y:uint, w:uint, h:uint, color:uint, alpha:Number):void {
			RECT.x = x;
			RECT.y = y;
			RECT.width = w;
			RECT.height = h;

			if (alpha < 0) alpha = 0;
			else if (alpha > 1) alpha = 1;

			alpha = alpha * 255 | 0;

			color = (color & 0xFFFFFF) | (alpha << 24);

			data.fillRect(RECT, color);
		}
	}
}