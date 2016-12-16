package net.retrocade.retrocamel.effects {
	import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.retrocamel_int;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;

	use namespace retrocamel_int;

	public class RetrocamelEffectSolidScreen extends RetrocamelScreenEffectBase {
		public static function make():RetrocamelEffectSolidScreen {
			return new RetrocamelEffectSolidScreen();
		}

		private var _alpha:Number = 1;
		private var _color:uint = 0x000000;

		public function RetrocamelEffectSolidScreen() {
			super(new RetrocamelLayerFlashSprite());
		}

		override public function update():void {
		}

		override public function run(addTo:RetrocamelUpdatableGroup = null):RetrocamelEffectBase {
			typedLayer.graphics.beginFill(_color, _alpha);
			typedLayer.graphics.drawRect(0, 0, RetrocamelCore.settings.gameWidth, RetrocamelCore.settings.gameHeight);
			typedLayer.graphics.endFill();

			return super.run(addTo);
		}

		public function alpha(value:Number):RetrocamelEffectSolidScreen {
			_alpha = value;

			return this;
		}

		public function color(value:uint):RetrocamelEffectSolidScreen {
			_color = value;

			return this;
		}

		public function get flashSpriteLayer():RetrocamelLayerFlashSprite {
			return typedLayer;
		}

		private function get typedLayer():RetrocamelLayerFlashSprite {
			return RetrocamelLayerFlashSprite(_layer);
		}
	}
}