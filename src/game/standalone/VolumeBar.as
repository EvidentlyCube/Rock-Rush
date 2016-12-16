package game.standalone {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import net.retrocade.retrocamel.components.RetrocamelDisplayObject;
	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.utils.UtilsNumber;

	public class VolumeBar extends RetrocamelDisplayObject {
		private var _colorSelected:uint;
		private var _colorUnselected:uint;

		private var _onChange:Function;

		private var _display:Sprite = new Sprite;

		private var _dragStarted:Boolean = false;

		private var _value:Number = 1.0;

		public function get value():Number {
			return _value;
		}

		public function set value(value:Number):void {
			_value = value;
			_onChange(_value);
			redraw();
		}

		private var _bars:uint = 20;

		/**
		 * @param onChange Function taking one Number argument (0.0 to 1.0)
		 * @param colorSelected Color of the bar when unselected
		 * @param colorUnselected Color of the bar when selected
		 */
		public function VolumeBar(onChange:Function, colorSelected:uint = 0xFFFFFF, colorUnselected:uint = 0x666666) {
			_onChange = onChange;
			_colorSelected = colorSelected;
			_colorUnselected = colorUnselected;

			_width = 195;

			_gfx = _display;

			_display.buttonMode = true;

			_display.addEventListener(Event.REMOVED_FROM_STAGE, onRemoval, false, 0, true);
			_display.addEventListener(Event.ADDED_TO_STAGE, onAddition, false, 0, true);

			redraw();
		}

		override public function update():void {
			if (_dragStarted) {
				var valueTemp:Number = UtilsNumber.limit((_display.mouseX + _width / _bars) / _width, 1, 0);
				valueTemp = (valueTemp * _bars | 0) / _bars;

				if (valueTemp != _value) {
					value = valueTemp;
				}

				if (!RetrocamelInputManager.isMouseDown()) {
					_dragStarted = false;
				}
			}
		}

		private function redraw():void {
			var g:Graphics = _display.graphics;

			g.clear();
			g.beginFill(0, 0);
			g.drawRect(0, 0, _width, 5 + _bars);
			g.beginFill(_colorSelected);

			var barWidth:Number = _width / (_bars * 2 - 1);
			var drawTo:uint = Math.min(Math.round(_value * _bars), _bars);

			for (var i:uint = 0; i < drawTo; i++) {
				g.drawRect(i * barWidth * 2, _bars - i, barWidth, 5 + i);
			}

			g.beginFill(_colorUnselected);

			for (; i < _bars; i++) {
				g.drawRect(i * barWidth * 2, _bars - i, barWidth, 5 + i);
			}
		}


		private function onMouseDown(e:MouseEvent):void {
			_dragStarted = true;
		}

		private function onRemoval(e:Event):void {
			RetrocamelCore.groupBefore.remove(this);
			_display.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		private function onAddition(e:Event):void {
			RetrocamelCore.groupBefore.add(this);
			_display.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
	}
}