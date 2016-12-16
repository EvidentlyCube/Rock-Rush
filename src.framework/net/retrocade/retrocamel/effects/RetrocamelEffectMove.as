package net.retrocade.retrocamel.effects {
	import flash.display.DisplayObject;

	/**
	 * ...
	 * @author
	 */
	public class RetrocamelEffectMove extends RetrocamelEffectBase {
		private var _initialX:Number;
		private var _initialY:Number;
		private var _targetX:Number;
		private var _targetY:Number;
		private var _target:DisplayObject;

		public static function make(target:DisplayObject):RetrocamelEffectMove {
			return new RetrocamelEffectMove(target);
		}

		public function RetrocamelEffectMove(target:DisplayObject) {
			_target = target;

			_initialX = _target.x;
			_targetX = _target.x;
			_initialY = _target.y;
			_targetY = _target.y;
		}

		override public function update():void {
			if (_blocked) {
				return blockUpdate();
			}

			_target.x = getInterval(_initialX, _targetX);
			_target.y = getInterval(_initialY, _targetY);

			super.update();
		}

		public function initialX(value:Number):RetrocamelEffectMove {
			_initialX = value;

			return this;
		}

		public function initialY(value:Number):RetrocamelEffectMove {
			_initialY = value;

			return this;
		}

		public function targetX(value:Number):RetrocamelEffectMove {
			_targetX = value;

			return this;
		}

		public function targetY(value:Number):RetrocamelEffectMove {
			_targetY = value;

			return this;
		}
	}
}