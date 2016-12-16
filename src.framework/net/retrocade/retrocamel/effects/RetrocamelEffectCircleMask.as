package net.retrocade.retrocamel.effects {
	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.retrocamel_int;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;

	use namespace retrocamel_int;

	public class RetrocamelEffectCircleMask extends RetrocamelScreenEffectBase {

		private var _x:Number;
		private var _y:Number;
		private var _maxDistance:Number;

		public static function make():RetrocamelEffectCircleMask {
			return new RetrocamelEffectCircleMask();
		}

		public function RetrocamelEffectCircleMask() {
			super(new RetrocamelLayerFlashSprite());

			_maxDistance = RetrocamelCore.settings.gameWidth + RetrocamelCore.settings.gameHeight;
		}

		override public function update():void {
			if (_blocked) {
				return blockUpdate();
			}

			typedLayer.graphics.clear();
			typedLayer.graphics.beginFill(0);
			typedLayer.graphics.drawRect(0, 0, RetrocamelCore.settings.gameWidth, RetrocamelCore.settings.gameHeight);
			typedLayer.graphics.drawCircle(_x, _y, _maxDistance * (1 - interval));

			super.update();
		}

		public function x(value:Number):RetrocamelEffectCircleMask {
			_x = value;

			return this;
		}

		public function y(value:Number):RetrocamelEffectCircleMask {
			_y = value;

			return this;
		}

		public function maxDistance(value:Number):RetrocamelEffectCircleMask {
			if (isNaN(value)) {
				throw new ArgumentError("Max distance has to be a real number");
			} else if (value <= 0) {
				throw new ArgumentError('Max distance cannot be smaller or equal to 0');
			}

			_maxDistance = value;

			return this;
		}

		private function get typedLayer():RetrocamelLayerFlashSprite {
			return RetrocamelLayerFlashSprite(_layer);
		}
	}
}