package net.retrocade.retrocamel.effects {
	import flash.utils.getQualifiedClassName;

	public class RetrocamelEffectSequence extends RetrocamelEffectBase {
		public static function make():RetrocamelEffectSequence {
			return new RetrocamelEffectSequence();
		}

		private var _effectStack:Vector.<RetrocamelEffectBase>;
		private var _currentEffect:RetrocamelEffectBase;

		public function RetrocamelEffectSequence() {
			_effectStack = new Vector.<RetrocamelEffectBase>();
		}

		override public function skip():void {
			if (_currentEffect) {
				_currentEffect.skip();
			}

			for each(var effect:RetrocamelEffectBase in _effectStack) {
				effect.run(addTo).skip();
			}

			super.skip();
		}

		override protected function finish():void {
			_currentEffect = null;
			_effectStack = null;

			super.finish();
		}

		override public function update():void {
			if (!_currentEffect) {
				_currentEffect = _effectStack.shift();
				_currentEffect.run(addTo);
			}

			if (_currentEffect.hasFinished) {
				_currentEffect = null;

				if (_effectStack.length === 0) {
					finish();
				} else {
					update();
				}
			}
		}

		public function skipCurrentEffect():void {
			if (_currentEffect) {
				_currentEffect.skip();
				_currentEffect = null;
			}
		}

		public function addEffect(effect:RetrocamelEffectBase):RetrocamelEffectSequence {
			if (!effect) {
				throw new ArgumentError("Added effect cannot be null");
			} else if (effect.isRunning) {
				throw new ArgumentError("Cannot add running effect to effect sequence");
			}

			_effectStack.push(effect);

			return this;
		}

		public function addEffects(...rest:Array):RetrocamelEffectSequence {
			for each(var effect:Object in rest) {
				if (effect is RetrocamelEffectBase) {
					addEffect(effect as RetrocamelEffectBase);
				} else {
					throw new ArgumentError("Cannot add '" + getQualifiedClassName(effect) + "' to effect sequence.");
				}
			}

			return this;
		}
	}
}