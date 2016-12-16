package net.retrocade.retrocamel.effects {

	import flash.events.Event;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.retrocamel_int;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;

	use namespace retrocamel_int;

	public class RetrocamelEffectFadeScreen extends RetrocamelScreenEffectBase {
		private var _alphaFrom:Number = 1;
		private var _alphaTo:Number = 0;
		private var _color:uint = 0x000000;

		public static function make():RetrocamelEffectFadeScreen {
			return new RetrocamelEffectFadeScreen();
		}

		public static function makeOut():RetrocamelEffectFadeScreen {
			return make().alphaFrom(1).alphaTo(0);
		}

		public static function makeIn():RetrocamelEffectFadeScreen {
			return make().alphaFrom(0).alphaTo(1);
		}

		public function RetrocamelEffectFadeScreen() {
			super(new RetrocamelLayerFlashSprite());
		}

		override public function update():void {
			if (_blocked) {
				return blockUpdate();
			}

			typedLayer.alpha = 1 - _alphaFrom - (_alphaTo - _alphaFrom) * interval;

			super.update();
		}

		private function redraw():void {
			typedLayer.graphics.clear();
			typedLayer.graphics.beginFill(_color, 1);
			typedLayer.graphics.drawRect(0, 0, RetrocamelCore.settings.gameWidth, RetrocamelCore.settings.gameHeight);
			typedLayer.graphics.endFill();
		}

		override protected function onResize(e:Event):void {
			redraw();
		}

		public function alphaFrom(value:Number):RetrocamelEffectFadeScreen {
			_alphaFrom = value;

			return this;
		}

		public function alphaTo(value:Number):RetrocamelEffectFadeScreen {
			_alphaTo = value;

			return this;
		}

		public function color(value:uint):RetrocamelEffectFadeScreen {
			_color = value;

			return this;
		}

		private function get typedLayer():RetrocamelLayerFlashSprite {
			return RetrocamelLayerFlashSprite(_layer);
		}

		override public function run(addTo:RetrocamelUpdatableGroup = null):RetrocamelEffectBase {
			redraw();

			return super.run(addTo);
		}
	}
}