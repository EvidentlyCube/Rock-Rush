package game.objects {
	import flash.display.BitmapData;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableObject;

	/**
	 * ...
	 * @author
	 */
	public class TRibbon extends RetrocamelUpdatableObject {
		private var _gfx:Array = [];
		private var _items:Array = [];
		private var _edgeOffset:Number;
		private var _spd:Number;

		private var _mostEdgyObject:Object;

		private var _layer:rLayerBlit;
		public var farthestEdge:uint;

		public var isVertical:Boolean = false;

		public var swayPower:Number = 0;
		public var swayOffset:Number = 0;
		public var swaySpeed:Number = 0;
		public var swayPosition:Number = 0;

		public function TRibbon(offset:Number, spd:Number, layer:rLayerBlit) {
			farthestEdge = S.SIZE_GAME_WIDTH;

			_edgeOffset = offset;
			_spd = spd;

			_layer = layer;

			addDefault();
		}

		public function addItem(gfx:BitmapData, probability:Number = 1):void {
			_gfx.push({
				gfx: gfx,
				probability: probability,
				count: 0
			});
		}

		override public function update():void {
			swayPosition += swaySpeed;

			var item:Object;
			for (var i:int = _items.length - 1; i >= 0; i--) {
				item = _items[i];
				if (item == null) {
					continue;
				}

				item.pos += _spd;

				if (_spd > 0 && item.pos > farthestEdge) {
					removeItem(i);
					addOne();
					if (i > 0) {
						i++;
					}

				} else if (_spd < 0 && item.pos + item.size < 0) {
					removeItem(i);
					addOne();
					if (i > 0) {
						i++;
					}

				} else {
					if (isVertical) {
						_layer.draw(item.gfx, _edgeOffset + Math.sin(swayPosition + swayOffset * item.pos) * swayPower, item.pos);
					}
					else {
						_layer.draw(item.gfx, item.pos, _edgeOffset + Math.sin(swayPosition + swayOffset * item.pos) * swayPower);
					}
				}
			}
		}

		private function removeItem(index:uint):void {
			_items[index] = null;
		}

		public function addOne():void {
			var model:Object;
			var max:Number = -1;
			for each(var gfx:Object in _gfx) {
				gfx.count += Math.random() * gfx.probability;
				if (gfx.count > max) {
					max = gfx.count;
					model = gfx;
				}
			}

			model.count = 0;

			var item:Object = {
				gfx: model.gfx,
				pos: 0,
				size: (isVertical ? model.gfx.height : model.gfx.width)
			};

			if (_spd > 0) {
				item.pos = (_mostEdgyObject ? _mostEdgyObject.pos : 0) - item.size;
				_mostEdgyObject = item;

			} else {
				item.pos = (_mostEdgyObject ? _mostEdgyObject.pos + _mostEdgyObject.size : farthestEdge);
				_mostEdgyObject = item;
			}

			for (var i:int = 0; i < _items.length; i++) {
				if (_items[i] == null) {
					break;
				}
			}

			_items[i] = item;
		}

		public function addMany(numberOf:uint = 1):void {
			while (numberOf--) {
				addOne();
			}
		}

		public function moveAll(offset:Number):void {
			for each(var item:Object in _items) {
				item.pos += offset;
			}
		}
	}
}