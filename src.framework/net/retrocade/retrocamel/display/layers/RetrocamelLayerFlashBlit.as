package net.retrocade.retrocamel.display.layers {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.retrocamel_int;

	use namespace retrocamel_int;

	public class RetrocamelLayerFlashBlit extends RetrocamelLayerFlash {
		/****************************************************************************************************************/
		/**                                                                                                  VARIABLES  */
		/****************************************************************************************************************/

		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Helpers
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * HELPER: Matrix used in drawAdvanced()
		 */
		private static var _matrix:Matrix = new Matrix();

		/**
		 * HELPER: Rectangle used in draw()
		 */
		private static var _rect:Rectangle = new Rectangle();

		/**
		 * HELPER: Rectangle used in drawImageRect()
		 */
		private static var _rectRect:Rectangle = new Rectangle();

		/**
		 * HELPER: Point used in draw();
		 */
		private static var _point:Point = new Point();

		private static var _colorTransform:ColorTransform = new ColorTransform();

		private static var _sprite:Sprite = new Sprite();

		public var scrollX:Number = 0;
		public var scrollY:Number = 0;


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Display stuff
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * BitmapData of the layer, the draw-on thing
		 */
		private var _bitmapData:BitmapData;

		public function get bitmapData():BitmapData {
			return _bitmapData;
		}

		private var _layer:Bitmap;

		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Dimensions
		// ::::::::::::::::::::::::::::::::::::::::::::::

		override public function get layer():DisplayObject {
			return _layer;
		}
		/**
		 * Width of the layer
		 */
		private var width:uint;
		/**
		 * Height of the layer
		 */
		private var height:uint;

		override public function get inputEnabled():Boolean {
			return false;
		}


		/****************************************************************************************************************/
		/**                                                                                                  FUNCTIONS  */
		/****************************************************************************************************************/

		override public function set inputEnabled(value:Boolean):void {
		}

		public function RetrocamelLayerFlashBlit(width:uint = 0, height:uint = 0, addAt:Number = -1) {
			this.width = width || RetrocamelCore.settings.gameWidth;
			this.height = height || RetrocamelCore.settings.gameHeight;

			_bitmapData = new BitmapData(this.width, this.height, true, 0x00000000);
			_layer = new Bitmap(_bitmapData);

			addLayer(addAt);
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Shape drawing
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		public function setScale(scaleX:Number, scaleY:Number):void {
			_layer.scaleX = scaleX;
			_layer.scaleY = scaleY;
		}

		override public function clear():void {
			_rect.x = 0;
			_rect.y = 0;
			_rect.width = width;
			_rect.height = height;
			_bitmapData.fillRect(_rect, 0x00000000);
		}

		public function clearRect(x:uint, y:uint, width:uint, height:uint):void {
			_rect.x = x;
			_rect.y = y;
			_rect.width = width;
			_rect.height = height;
			_bitmapData.fillRect(_rect, 0x00000000);
		}

		public function plot(x:uint, y:uint, color:uint = 0xFFFFFFFF):void {
			_bitmapData.setPixel32(x + scrollX, y + scrollY, color);
		}

		public function plotARGB(x:uint, y:uint, alpha:uint = 255, red:uint = 255, green:uint = 255, blue:uint = 255):void {
			_bitmapData.setPixel32(x + scrollX, y + scrollY, alpha << 24 | red << 16 | green << 8 | blue);
		}

		public function shapeLine(x:Number, y:Number, toX:Number, toY:Number, color:uint = 0xFFFFFF, alpha:Number = 1, thickness:Number = 1):void {
			_sprite.graphics.clear();
			_sprite.graphics.lineStyle(thickness, color, alpha);
			_sprite.graphics.moveTo(x + scrollX, y + scrollY);
			_sprite.graphics.lineTo(toX + scrollX, toY + scrollY);

			_bitmapData.draw(_sprite);
		}

		public function shapeRect(x:int, y:int, width:int, height:int, color:uint = 0xFFFFFFFF):void {
			_rect.x = x + scrollX;
			_rect.y = y + scrollY;
			_rect.width = width;
			_rect.height = height;

			_bitmapData.fillRect(_rect, color);
		}

		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Blitting
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		public function drawComplexRect(data:IBitmapDrawable, x:int, y:int, alpha:Number, rect:Rectangle, smoothing:Boolean = false):void {

			_matrix.identity();
			_matrix.translate(x - rect.x + scrollX, y - rect.y + scrollY);

			_colorTransform.alphaMultiplier = alpha;

			_rectRect.x = x + scrollX;
			_rectRect.y = y + scrollY;
			_rectRect.width = rect.width;
			_rectRect.height = rect.height;

			_bitmapData.draw(data, _matrix, _colorTransform, null, _rectRect, smoothing);
		}

		public function blit(data:BitmapData, x:int, y:int):void {
			_point.x = x + scrollX;
			_point.y = y + scrollY;

			_rect.x = 0;
			_rect.y = 0;
			_rect.width = data.width;
			_rect.height = data.height;

			_bitmapData.copyPixels(data, _rect, _point, null, null, true);
		}

		public function blitFromRect(source:BitmapData, tileRect:Rectangle, x:int, y:int):void {
			_point.x = x + scrollX;
			_point.y = y + scrollY;

			_bitmapData.copyPixels(source, tileRect, _point, null, null, true);
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Advanced drawing functions
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		public function blitRect(data:BitmapData, targetX:int, targetY:int, sourceX:uint, sourceY:uint, sourceWidth:uint, sourceHeight:uint):void {
			_point.x = targetX;
			_point.y = targetY;

			_rectRect.x = sourceX;
			_rectRect.y = sourceY;

			_rectRect.width = sourceWidth;
			_rectRect.height = sourceHeight;

			_bitmapData.copyPixels(data, _rectRect, _point, null, null, true);

		}

		public function draw(data:*, x:Number, y:Number, alpha:Number = 1, rotation:Number = 0,
		                     scaleX:Number = 1, scaleY:Number = 1, blend:String = null, smoothing:Boolean = false):void {
			if (alpha == 1 && rotation == 0 && scaleX == 1 && scaleY == 1 && blend == null && (data is Bitmap || data is BitmapData)) {
				if (data is Bitmap)
					blit(Bitmap(data).bitmapData, x, y);
				else
					blit(BitmapData(data), x, y);

			} else {
				_matrix.identity();
				_matrix.translate(-data.width / 2, -data.height / 2);
				_matrix.rotate(rotation * Math.PI / 180);
				_matrix.scale(scaleX, scaleY);
				_matrix.translate(data.width / 2 + x + scrollX, data.height / 2 + y + scrollY);

				_colorTransform.redMultiplier = 1;
				_colorTransform.blueMultiplier = 1;
				_colorTransform.greenMultiplier = 1;
				_colorTransform.alphaMultiplier = alpha;

				_bitmapData.draw(data, _matrix, _colorTransform, blend, null, smoothing);
			}
		}

		public function drawColor(data:*, x:int, y:int, rotation:Number = 0, scaleX:Number = 1, scaleY:Number = 1,
		                          alpha:Number = 1, blend:String = null, smoothing:Boolean = true,
		                          redMultiplier:Number = 1, greenMultiplier:Number = 1, blueMultiplier:Number = 1,
		                          redOffset:Number = 0, greenOffset:Number = 0, blueOffset:Number = 0, alphaOffset:Number = 0):void {
			_matrix.identity();
			_matrix.translate(-data.width / 2, -data.height / 2);
			_matrix.rotate(rotation * Math.PI / 180);
			_matrix.scale(scaleX, scaleY);
			_matrix.translate(data.width / 2 + x, data.height / 2 + y);

			_colorTransform.redMultiplier = redMultiplier;
			_colorTransform.blueMultiplier = blueMultiplier;
			_colorTransform.greenMultiplier = greenMultiplier;
			_colorTransform.alphaMultiplier = alpha;
			_colorTransform.redOffset = redOffset;
			_colorTransform.greenOffset = greenOffset;
			_colorTransform.blueOffset = blueOffset;
			_colorTransform.alphaOffset = alphaOffset;

			_bitmapData.draw(data, _matrix, _colorTransform, blend, null, smoothing);

			_colorTransform.redOffset = 0;
			_colorTransform.greenOffset = 0;
			_colorTransform.blueOffset = 0;
			_colorTransform.alphaOffset = 0;
		}

		public function drawFromRect(data:IBitmapDrawable, x:int, y:int, source:Rectangle, alpha:Number,
		                             blend:String = null, smoothing:Boolean = false):void {
			_matrix.identity();
			_matrix.translate(x - source.x + scrollX, y - source.y + scrollY);

			_colorTransform.alphaMultiplier = alpha;

			_rectRect.x = x + scrollX;
			_rectRect.y = y + scrollY;
			_rectRect.width = source.width;
			_rectRect.height = source.height;

			_bitmapData.draw(data, _matrix, _colorTransform, blend, _rectRect, smoothing);
		}

		public function drawImageRect(data:BitmapData, x:int, y:int, rx:uint, ry:uint, width:uint, height:uint):void {
			_point.x = x + scrollX;
			_point.y = y + scrollY;
			_rectRect.x = rx;
			_rectRect.y = ry;
			_rectRect.width = width;
			_rectRect.height = height;
			_bitmapData.copyPixels(data, _rectRect, _point, null, null, true);

		}

		public function drawRect(data:IBitmapDrawable, x:int, y:int, sourceX:Number, sourceY:Number, sourceWidth:Number, sourceHeight:Number, alpha:Number,
		                         blend:String = null, smoothing:Boolean = false):void {

			_matrix.identity();
			_matrix.translate(x - sourceX, y - sourceY);

			_colorTransform.alphaMultiplier = alpha;

			_rectRect.x = x;
			_rectRect.y = y;
			_rectRect.width = sourceWidth;
			_rectRect.height = sourceHeight;

			_bitmapData.draw(data, _matrix, _colorTransform, blend, _rectRect, smoothing);
		}

		public function drawComplexRectColor(data:IBitmapDrawable, x:int, y:int, alpha:Number, rect:Rectangle,
		                                     redOffset:Number = 0, greenOffset:Number = 0, blueOffset:Number = 0):void {

			_matrix.identity();
			_matrix.translate(x - rect.x + scrollX, y - rect.y + scrollY);

			_colorTransform.alphaMultiplier = alpha;

			_rectRect.x = x + scrollX;
			_rectRect.y = y + scrollY;
			_rectRect.width = rect.width;
			_rectRect.height = rect.height;

			_colorTransform.redOffset = redOffset;
			_colorTransform.greenOffset = greenOffset;
			_colorTransform.blueOffset = blueOffset;
			_colorTransform.alphaOffset = 0;

			_bitmapData.draw(data, _matrix, _colorTransform, null, _rectRect);

			_colorTransform.redOffset = 0;
			_colorTransform.greenOffset = 0;
			_colorTransform.blueOffset = 0;
			_colorTransform.alphaOffset = 0;
		}

		public function drawComplexRectColor2(data:IBitmapDrawable, x:int, y:int, alpha:Number, rect:Rectangle,
		                                      redMultiplier:Number = 0, greenMultiplier:Number = 0, blueMultiplier:Number = 0):void {

			_matrix.identity();
			_matrix.translate(x - rect.x + scrollX, y - rect.y + scrollY);

			_colorTransform.alphaMultiplier = alpha;

			_rectRect.x = x + scrollX;
			_rectRect.y = y + scrollY;
			_rectRect.width = rect.width;
			_rectRect.height = rect.height;

			_colorTransform.redMultiplier = redMultiplier;
			_colorTransform.greenMultiplier = greenMultiplier;
			_colorTransform.redMultiplier = blueMultiplier;

			_bitmapData.draw(data, _matrix, _colorTransform, null, _rectRect);

			_colorTransform.redMultiplier = 1;
			_colorTransform.greenMultiplier = 1;
			_colorTransform.blueMultiplier = 1;
			_colorTransform.alphaMultiplier = 1;
		}

		public function get mouseX():Number {
			return _layer.mouseX;
		}

		public function get mouseY():Number {
			return _layer.mouseY;
		}
	}
}