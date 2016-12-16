package net.retrocade.retrocamel.effects {
	import flash.display.DisplayObject;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;

	public class RetrocamelEffectFadeFlash extends RetrocamelEffectBase {
		private var _alphaFrom:Number = 0;
		private var _alphaTo:Number = 1;

		private var _target:DisplayObject;

		public static function doMany(toFade:Array, alphaFrom:Number = 1, alphaTo:Number = 1, duration:uint = 200,
		                              callback:Function = null, addTo:RetrocamelUpdatableGroup = null):void {
			for each (var displayObject:DisplayObject in toFade) {
				RetrocamelEffectFadeFlash.make(displayObject)
					.alphaFrom(alphaFrom)
					.alphaTo(alphaTo)
					.duration(duration)
					.callback(callback)
					.run(addTo);
			}
		}

		public static function make(target:DisplayObject):RetrocamelEffectFadeFlash {
			return new RetrocamelEffectFadeFlash(target);
		}

		public function RetrocamelEffectFadeFlash(toFade:DisplayObject) {
			_target = toFade;

			if (!_target.visible || _target.alpha <= 0) {
				_alphaFrom = 0;
				_alphaTo = 1;
			} else {
				_alphaFrom = _target.alpha;
				_alphaTo = 0;
			}
		}

		override public function update():void {
			if (_blocked) {
				blockUpdate();
			} else {
				_target.visible = true;
				_target.alpha = getInterval(_alphaFrom, _alphaTo);

				super.update();
			}
		}

		override protected function finish():void {
			_target.alpha = _alphaTo;

			if (_target.alpha <= 0) {
				_target.visible = false;
				_target.alpha = 0;
			}

			super.finish();
		}

		override public function skip():void {
			_target.alpha = _alphaTo;

			super.skip();
		}

		public function alpha(valueFrom:Number, valueTo:Number):RetrocamelEffectFadeFlash {
			return this.alphaFrom(valueFrom).alphaTo(valueTo);
		}

		public function alphaFrom(value:Number):RetrocamelEffectFadeFlash {
			_alphaFrom = value;

			return this;
		}

		public function alphaTo(value:Number):RetrocamelEffectFadeFlash {
			_alphaTo = value;

			return this;
		}
	}
}