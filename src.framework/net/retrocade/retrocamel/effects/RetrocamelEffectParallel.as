package net.retrocade.retrocamel.effects {
	import flash.utils.getQualifiedClassName;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;

	public class RetrocamelEffectParallel extends RetrocamelEffectBase {
		public static function make():RetrocamelEffectParallel {
			return new RetrocamelEffectParallel();
		}

		private var _canFinish:Boolean = false;

		private var _effectStack:Vector.<RetrocamelEffectBase>;

		public function RetrocamelEffectParallel() {
			_effectStack = new Vector.<RetrocamelEffectBase>();
		}

		override public function skip():void {
			for each(var effect:RetrocamelEffectBase in _effectStack) {
				if (effect.isRunning) {
					effect.skip();
				}
			}

			super.skip();
		}

		override protected function finish():void {
			_effectStack = null;

			super.finish();
		}

		override public function update():void {
			if (_canFinish) {
				finish();
			}
		}


		override public function run(addTo:RetrocamelUpdatableGroup = null):RetrocamelEffectBase {
			super.run(addTo);

			for each(var effect:RetrocamelEffectBase in _effectStack) {
				effect.run();
			}

			_canFinish = true;

			return this;
		}

		public function addEffect(effect:RetrocamelEffectBase):RetrocamelEffectParallel {
			if (!effect) {
				throw new ArgumentError("Added effect cannot be null");
			} else if (effect.isRunning) {
				throw new ArgumentError("Cannot add running effect to effect sequence");
			}

			_effectStack.push(effect);

			return this;
		}

		public function addEffects(...rest:Array):RetrocamelEffectParallel {
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