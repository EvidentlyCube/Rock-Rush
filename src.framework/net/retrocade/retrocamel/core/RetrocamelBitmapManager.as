package net.retrocade.retrocamel.core {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import net.retrocade.retrocamel.display.flash.RetrocamelBitmap;

	public class RetrocamelBitmapManager {
		private static var _graphics:Dictionary = new Dictionary();

		private static var _rect:Rectangle = new Rectangle();
		private static var _point:Point = new Point();


		/**
		 * Loads a bitmap stored as ByteArray
		 * @param    gfx Class containing the ByteArray
		 * @return Loader which will load the graphic
		 */
		public static function load(gfx:Class):Loader {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, bitmapLoaded);

			_graphics[loader] = gfx;

			loader.loadBytes(new gfx);

			return loader;
		}


		private static function bitmapLoaded(event:Event):void {
			var loader:Loader = LoaderInfo(event.target).loader;
			var gfxClass:Class = _graphics[loader];

			loader.contentLoaderInfo.removeEventListener(Event.INIT, bitmapLoaded);

			var bitmap:Bitmap = Bitmap(loader.content);

			_graphics[gfxClass] = new RetrocamelBitmap(bitmap.bitmapData);
		}

		/**
		 * Retrieves the Bitmap of the given asset
		 * @param gfx Class of the embedded asset
		 * @return Bitmap od the specified class
		 */
		public static function getB(gfx:Class, smoothing:Boolean = false):RetrocamelBitmap {
			if (!_graphics[gfx]) {
				var bitmap:Bitmap = new gfx;

				_graphics[gfx] = new RetrocamelBitmap(bitmap.bitmapData);
			}

			var retrocadeBitmap:RetrocamelBitmap = new RetrocamelBitmap(RetrocamelBitmap(_graphics[gfx]).bitmapData);
			retrocadeBitmap.smoothing = smoothing;

			return retrocadeBitmap;
		}

		/**
		 * Retrieves the BitmapData of the given asset
		 * @param gfx Class of the embedded asset
		 * @return BitmapData of the specified class
		 */
		public static function getBD(gfx:Class):BitmapData {
			if (!_graphics[gfx])
				getB(gfx);

			return Bitmap(_graphics[gfx]).bitmapData;
		}

		/**
		 * Retrieves the BitmapData of the given asset
		 * @param gfx Class of the embedded asset
		 * @return Bitmap od the specified class
		 */
		public static function getBDExt(gfx:Class, x:uint, y:uint, width:uint, height:uint):BitmapData {
			var code:String = Object(gfx).toString() + ":" + x + ":" + y + ":" + width + ":" + height;

			if (_graphics[code])
				return Bitmap(_graphics[code]).bitmapData;

			var original:BitmapData = getBD(gfx);

			var bData:BitmapData = new BitmapData(width, height, true, 0);
			_rect.x = x;
			_rect.y = y;
			_rect.width = width;
			_rect.height = height;

			bData.copyPixels(original, _rect, _point, null, null, true);

			_graphics[code] = new Bitmap(bData);

			return bData;
		}
	}
}