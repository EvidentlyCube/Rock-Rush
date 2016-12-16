package net.retrocade.retrocamel.effects {
	import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.RetrocamelDisplayManager;
	import net.retrocade.retrocamel.core.retrocamel_int;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;

	use namespace retrocamel_int;

	public class RetrocamelEffectQuake extends RetrocamelScreenEffectBase {
		public static const MODE_SINUS:uint = 0;
		public static const MODE_RANDOM:uint = 1;

		private var _mode:uint = MODE_RANDOM;
		private var _vPower:Number = 10;
		private var _hPower:Number = 10;
		private var _hSpeed:Number = 1;
		private var _vSpeed:Number = 1;
		private var _toQuake:Object;
		private var _originalX:Number;
		private var _originalY:Number;

		public static function make():RetrocamelEffectQuake {
			return new RetrocamelEffectQuake();
		}

		private function get typedLayer():RetrocamelLayerFlashSprite {
			return RetrocamelLayerFlashSprite(_layer);
		}

		override public function run(addTo:RetrocamelUpdatableGroup = null):RetrocamelEffectBase {
			typedLayer.graphics.beginFill(0);
			typedLayer.graphics.drawRect(-_hPower, -_vPower, RetrocamelCore.settings.gameWidth + 2 * _hPower, _vPower);
			typedLayer.graphics.drawRect(-_hPower, RetrocamelCore.settings.gameHeight, RetrocamelCore.settings.gameWidth + 2 * _hPower, _vPower);
			typedLayer.graphics.drawRect(-_hPower, 0, _hPower, RetrocamelCore.settings.gameHeight);
			typedLayer.graphics.drawRect(RetrocamelCore.settings.gameWidth, 0, _hPower, RetrocamelCore.settings.gameHeight);
			typedLayer.graphics.endFill();

			return super.run(addTo);
		}

		public function RetrocamelEffectQuake() {
			super(new RetrocamelLayerFlashSprite());

			_duration = 0;

			_toQuake = RetrocamelDisplayManager.flashApplication;

			_originalX = NaN;
			_originalY = NaN;
		}

		override public function update():void {
			if (_blocked) {
				return blockUpdate();
			}

			if (isNaN(_originalX)) {
				_originalX = _toQuake.x;
			}
			if (isNaN(_originalY)) {
				_originalY = _toQuake.y;
			}

			var intervalCache:Number = interval;

			if (_mode == MODE_SINUS) {
				_toQuake.x = _originalX + Math.sin(timeFromStart * _hSpeed) * _hPower * (1 - intervalCache) | 0;
				_toQuake.y = _originalY + Math.sin(timeFromStart * _vSpeed) * _vPower * (1 - intervalCache) | 0;

			} else {
				_toQuake.x = _originalX + (Math.random() * 2 - 1) * _hPower * (1 - intervalCache) | 0;
				_toQuake.y = _originalY + (Math.random() * 2 - 1) * _vPower * (1 - intervalCache) | 0;
			}

			super.update();
		}

		public function power(powerH:Number, poverV:Number):RetrocamelEffectQuake {
			return hPower(powerH).vPower(poverV);
		}

		public function hPower(value:Number):RetrocamelEffectQuake {
			_hPower = value;

			return this;
		}

		public function vPower(value:Number):RetrocamelEffectQuake {
			_vPower = value;

			return this;
		}

		public function hSpeed(value:Number):RetrocamelEffectQuake {
			_hSpeed = value;

			return this;
		}

		public function vSpeed(value:Number):RetrocamelEffectQuake {
			_vSpeed = value;

			return this;
		}

		public function mode(value:uint):RetrocamelEffectQuake {
			_mode = value;

			return this;
		}

		public function toQuake(object:Object):RetrocamelEffectQuake {
			if (!object) {
				throw new ArgumentError("Cannot quake null object");
			} else if (!object.hasOwnProperty('x')) {
				throw new ArgumentError("Cannot throw object which has no x property");
			} else if (!object.hasOwnProperty('y')) {
				throw new ArgumentError("Cannot throw object which has no y property");
			}

			// Testing if get or set for X and Y don't throw an automatic error due to not being public variables or public properties
			//noinspection SillyAssignmentJS
			object.x = object.x;

			//noinspection SillyAssignmentJS
			object.y = object.y;

			_toQuake = object;

			return this;
		}

		override protected function finish():void {
			_toQuake.x = _originalX;
			_toQuake.y = _originalY;

			_toQuake = null;

			super.finish();
		}
	}
}