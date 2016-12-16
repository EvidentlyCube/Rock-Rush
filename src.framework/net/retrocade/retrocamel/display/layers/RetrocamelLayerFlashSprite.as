package net.retrocade.retrocamel.display.layers {
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;

	/**
	 * A Layer which consists of Sprite object, classical display list
	 */
	public class RetrocamelLayerFlashSprite extends RetrocamelLayerFlash {

		/**
		 * The Sprite which makes this layer
		 */
		private var _layer:Sprite;

		/**
		 * Returns the display object of this layer
		 */
		override public function get layer():DisplayObject {
			return _layer;
		}

		/**
		 * Creates a new Sprite Layer and attaches it to the top of the Display tree
		 */
		public function RetrocamelLayerFlashSprite(addAt:Number = -1) {
			_layer = new Sprite;

			addLayer(addAt);
		}

		/**
		 * Adds a DisplayObject to this layer
		 * @param d DisplayObject to be added
		 */
		public function add(d:DisplayObject):void {
			_layer.addChild(d);
		}

		public function get graphics():Graphics {
			return _layer.graphics;
		}

		/**
		 * Adds an rObjectDisplay to this layer
		 * @param d rObjectDisplay to be added
		 * @param index index at which to add
		 */
		public function addAt(d:DisplayObject, index:uint):void {
			_layer.addChildAt(d, index);
		}

		/**
		 * Removes all children from this layer
		 */
		override public function clear():void {
			var i:uint = _layer.numChildren;

			while (i--) {
				_layer.removeChildAt(i);
			}

			_layer.graphics.clear();
		}

		/**
		 * Sets the layer alpha
		 */
		public function set alpha(value:Number):void {
			_layer.alpha = value;
		}

		/**
		 * Checks if given DisplayObject is added to this layer
		 * @param d The DisplayObject to be checked
		 * @return True if this layer contains d
		 */
		public function contains(d:DisplayObject):Boolean {
			return _layer.contains(d);
		}

		/**
		 * Removes an DisplayObject from this layer
		 * @param d The DisplayObject to be removed
		 */
		public function remove(d:DisplayObject):void {
			_layer.removeChild(d);
		}

		override public function get inputEnabled():Boolean {
			return _layer.mouseChildren;
		}

		override public function set inputEnabled(value:Boolean):void {
			_layer.mouseChildren = _layer.mouseEnabled = value;
		}

		public function set mouseChildren(value:Boolean):void {
			_layer.mouseChildren = value;
		}
	}
}