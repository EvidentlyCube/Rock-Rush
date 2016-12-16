package net.retrocade.utils {

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class UtilsDisplay {
		/****************************************************************************************************************/
		/**                                                                                                  CONSTANTS  */
		/****************************************************************************************************************/

		/**
		 * Show all scale mode, proportionally scales the display object so that it is fully displayed
		 */
		public static const SHOW_ALL:String = "showAll";
		/**
		 * Exact fit scale mode, unproportionally scales the display object to fill the whole specified area
		 */
		public static const EXACT_FIT:String = "exactFit";
		/**
		 * No scale scale mode, doesn't perform any scaling
		 */
		public static const NO_SCALE:String = "noScale";
		/**
		 * No border scale mode, proportionally scales the display object so that the whole specified area is filled
		 */
		public static const NO_BORDER:String = "noBorder";
		/**
		 * To width scale mode, proportionally scales the display object to the provided width
		 */
		public static const TO_WIDTH:String = "toWidth";
		/**
		 * To height scale mode, proportionally scales the display object to the provided height
		 */
		public static const TO_HEIGHT:String = "toHeight";

		// HELPERS
		private static const _RECT:Rectangle = new Rectangle();
		private static const _POINT:Point = new Point();


		/****************************************************************************************************************/
		/**                                                                                                  VARIABLES  */
		/****************************************************************************************************************/

		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Last Scale X
		// ::::::::::::::::::::::::::::::::::::::::::::::::
		/**
		 * ScaleX acquired from last calculation
		 */
		private static var _lastScaleX:Number = 1;

		/**
		 * ScaleX acquired from last calculation
		 */
		public static function get lastScaleX():Number {
			return _lastScaleX;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Last Scale Y
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * ScaleY acquired from last calculation
		 */
		private static var _lastScaleY:Number = 1;

		/**
		 * ScaleY acquired from last calculation
		 */
		public static function get lastScaleY():Number {
			return _lastScaleY;
		}


		/****************************************************************************************************************/
		/**                                                                                                  FUNCTIONS  */
		/****************************************************************************************************************/

		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Action
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Draws an invisible circle in the specified graphics object so that mouse can check mouse events against this area.
		 * @param graphics Graphics object of the displayObject
		 * @param x X of the collision area circle
		 * @param y Y of the collision area circle
		 * @param radius Radius of the collision area circle
		 */
		public static function addMouseAreaCircle(graphics:Graphics, x:int, y:int, radius:int):void {
			graphics.beginFill(0, 0);
			graphics.drawCircle(x, y, radius);
			graphics.endFill();
		}

		/**
		 * Draws an invisible ellipse in the specified graphics object so that mouse can check mouse events against this area.
		 * @param graphics Graphics object of the displayObject
		 * @param x X position of the collision area ellipse
		 * @param y Y position of the collision area ellipse
		 * @param width Width of the collision area ellipse
		 * @param height Height of the collision area ellipse
		 */
		public static function addMouseAreaEllipse(graphics:Graphics, x:int, y:int, width:int, height:int):void {
			graphics.beginFill(0, 0);
			graphics.drawEllipse(x, y, width, height);
			graphics.endFill();
		}

		/**
		 * Draws an invisible rectangle in the specified graphics object so that mouse can check mouse events against this area.
		 * @param graphics Graphics object of the displayObject
		 * @param x X position of the collision area rectangle
		 * @param y Y position of the collision area rectangle
		 * @param width Width of the collision area rectangle
		 * @param height Height of the collision area rectangle
		 */
		public static function addMouseAreaRect(graphics:Graphics, x:int, y:int, width:int, height:int):void {
			graphics.beginFill(0, 0);
			graphics.drawRect(x, y, width, height);
			graphics.endFill();
		}

		/**
		 * Calculates the target scaleX and scaleY values for specified dimensions
		 * @param currentWidth Current width
		 * @param currentHeight Current height
		 * @param targetWidth Target width
		 * @param targetHeight Target height
		 * @param scaleMode Scale mode, constants are defined in StageScaleMode
		 */
		public static function calculateScale(currentWidth:Number, currentHeight:Number, targetWidth:Number, targetHeight:Number,
		                                      scaleMode:String = SHOW_ALL):void {
			switch (scaleMode) {
				case(EXACT_FIT):
					_lastScaleX = targetWidth / currentWidth;
					_lastScaleY = targetHeight / currentHeight;
					return;

				case(NO_BORDER):
					if (targetWidth / targetHeight < currentWidth / currentHeight) {
						_lastScaleX = _lastScaleY = targetHeight / currentHeight;

					} else {
						_lastScaleX = _lastScaleY = targetWidth / currentWidth;
					}
					return;

				case(SHOW_ALL):
					if (targetWidth / targetHeight > currentWidth / currentHeight) {
						_lastScaleX = _lastScaleY = targetHeight / currentHeight;

					} else {
						_lastScaleX = _lastScaleY = targetWidth / currentWidth;
					}
					return;

				case(NO_SCALE):
					_lastScaleX = 1;
					_lastScaleY = 1;
					return;

				case (TO_WIDTH):
					_lastScaleY = _lastScaleX = targetWidth / currentWidth;
					return;

				case (TO_HEIGHT):
					_lastScaleY = _lastScaleX = targetHeight / currentHeight;
					return;
			}
		}

		/**
		 * Calculates the target scaleX and scaleY values for the specified display object and dimensions, takes into
		 * consideration current object scale
		 * @param displayObject DisplayObject which properties are used to calculate target scale values
		 * @param targetWidth Target width
		 * @param targetHeight Target height
		 * @param scaleMode Scale mode, constants are defined in StageScaleMode
		 */
		public static function calculateScaleObject(displayObject:DisplayObject, targetWidth:Number, targetHeight:Number,
		                                            scaleMode:String = SHOW_ALL):void {
			calculateScale(displayObject.width / displayObject.scaleX, displayObject.height / displayObject.scaleY, targetWidth,
				targetHeight, scaleMode);
		}

		public static function forcePositiveCoordinates(doc:DisplayObjectContainer):void {
			var count:uint = doc.numChildren;
			var minimalX:Number = 0;
			var minimalY:Number = 0;
			var child:DisplayObject;

			for (var i:uint = 0; i < count; i++) {
				child = doc.getChildAt(i);

				if (child.x < minimalX) {
					minimalX = child.x;
				}

				if (child.y < minimalY) {
					minimalY = child.y;
				}
			}

			for (i = 0; i < count; i++) {
				child = doc.getChildAt(i);
				child.x -= minimalX;
				child.y -= minimalY;
			}
		}

		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Modifiers
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * Adds multiple display objects to the given parent
		 * @param    parent DisplayObjectContainer to which the objects are to be added
		 * @param    ...rest Display objects to be added to the parent
		 */
		public static function addMulti(parent:DisplayObjectContainer, ...rest):void {
			for each(var i:* in rest) {
				if (i is Array) {
					addArray(parent, i);
				} else {
					parent.addChild(i);
				}
			}
		}

		/**
		 * Adds multiple display objects to the given parent
		 * @param    parent DisplayObjectContainer to which the objects are to be added
		 * @param    array An array of display objects to be added
		 */
		public static function addArray(parent:DisplayObjectContainer, array:Array):void {
			for each(var i:* in array) {
				if (i is Array) {
					addArray(parent, i);
				} else {
					parent.addChild(i);
				}
			}
		}

		/**
		 * Scales the passed DisplayObject, takes into consideration current object scale
		 * @param scaledObject The object to be scaled
		 * @param targetWidth Target width
		 * @param targetHeight Target height
		 * @param scaleMode Scale mode, constants are defined in StageScaleMode
		 */
		public static function scaleDisplayObject(scaledObject:DisplayObject, targetWidth:Number, targetHeight:Number,
		                                          scaleMode:String = SHOW_ALL):void {
			calculateScaleObject(scaledObject, targetWidth, targetHeight, scaleMode);
			scaledObject.scaleX = _lastScaleX;
			scaledObject.scaleY = _lastScaleY;
		}

		/**
		 * Scales the passed DisplayObject, takes into consideration current object scale but never allows the object
		 * to be scaled above 1:1
		 * @param scaledObject The object to be scaled
		 * @param targetWidth Target width
		 * @param targetHeight Target height
		 * @param scaleMode Scale mode, constants are defined in StageScaleMode
		 */
		public static function scaleDisplayObjectDown(scaledObject:DisplayObject, targetWidth:Number, targetHeight:Number,
		                                              scaleMode:String = SHOW_ALL):void {
			calculateScaleObject(scaledObject, targetWidth, targetHeight, scaleMode);
			scaledObject.scaleX = (_lastScaleX > 1 ? 1 : _lastScaleX);
			scaledObject.scaleY = (_lastScaleY > 1 ? 1 : _lastScaleY);
		}

		public static function pushChildren(displayObjectContainer:DisplayObjectContainer, deltaX:Number, deltaY:Number):void {
			var numChildren:int = displayObjectContainer.numChildren;

			for (var i:int = 0; i < numChildren; i++) {
				var child:DisplayObject = displayObjectContainer.getChildAt(i);

				child.x += deltaX;
				child.y += deltaY;
			}
		}

		/**
		 * Places items in a column:
		 * @param    items Array of DisplayObjects to columnify
		 * @param    space Amount of vertical space between each item
		 * @param    minWidth Minimal width of the column
		 * @param    offsetX Offset X from the left and right (horizontal padding)
		 * @param    offsetY Offset Y from the top (vertical padding)
		 * @return  Width of the column
		 */
		public static function columnify(items:Array, space:Number = 0, minWidth:Number = 0, offsetX:Number = 0,
		                                 offsetY:Number = 0):Number {
			var item:DisplayObject;

			for (var i:int = 0, l:int = items.length; i < l; i++) {
				item = items[i];
				minWidth = minWidth < item.width ? item.width : minWidth;

				if (i == 0) {
					item.y = offsetY;
				} else {
					item.y = items[i - 1].y + items[i - 1].height + space;
				}
			}

			for (i = 0; i < l; i++) {
				item = items[i];

				item.x = (minWidth + 2 * offsetX - item.width) / 2;
			}
			return minWidth + 2 * offsetX;
		}

		/**
		 * Removes multiple display objects from the given parent
		 * @param parent DisplayObjectContainer from which the objects are to be remove
		 * @param rest Display objects to be removed to the parent
		 */
		public static function removeMulti(parent:DisplayObjectContainer, ...rest):void {
			for each(var i:* in rest) {
				if (i is Array) {
					removeArray(parent, i);

				} else if (i is DisplayObject && parent.contains(i)) {
					parent.removeChild(i);
				}
			}
		}

		/**
		 * Removes multiple display objects from the given parent
		 * @param    parent DisplayObjectContainer from which the objects are to be removed
		 * @param    array An array of display objects to be removed
		 */
		public static function removeArray(parent:DisplayObjectContainer, array:Array):void {
			for each(var i:* in array) {
				if (i is Array) {
					removeArray(parent, i);

				} else if (i is DisplayObject && parent.contains(i)) {
					parent.removeChild(i);
				}
			}
		}

		/**
		 * Wraps a given DisplayObject with a given wrap object. If the object is already in the
		 * display tree it is removed, added to the sprite, and then the sprite is placed where the object was previously standing.
		 * @param displayObject Display object to be wrapped.
		 * @return Sprite wrapping the displayObject
		 */
		public static function wrapWith(displayObject:DisplayObject, wrapWith:DisplayObjectContainer):DisplayObjectContainer {
			var parent:DisplayObjectContainer = displayObject.parent;

			if (parent) {
				var index:uint = parent.getChildIndex(displayObject);

				parent.removeChild(displayObject);
				wrapWith.addChild(displayObject);
				parent.addChildAt(wrapWith, index);

			} else {
				wrapWith.addChild(displayObject);
			}

			return wrapWith;
		}

		/**
		 * Blits a designated BitmapData to another BitmapData
		 * @param source Source BitmapData
		 * @param target Target BitmapData
		 * @param x Target draw position
		 * @param y Target draw position
		 */
		public static function blit(source:BitmapData, target:BitmapData, x:uint, y:uint):void {
			_POINT.x = x;
			_POINT.y = y;

			target.copyPixels(source, source.rect, _POINT, null, null, true);
		}
	}
}