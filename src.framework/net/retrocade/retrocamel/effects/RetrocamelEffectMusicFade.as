package net.retrocade.retrocamel.effects {
	import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.retrocamel.core.retrocamel_int;

	use namespace retrocamel_int;

	public class RetrocamelEffectMusicFade extends RetrocamelEffectBase {
		private static var _currentMusicFade:RetrocamelEffectMusicFade;
		private var _fadeFrom:Number;
		private var _fadeTo:Number;

		public static function make(fadeTo:Number):RetrocamelEffectMusicFade {
			return new RetrocamelEffectMusicFade(fadeTo);
		}

		public function RetrocamelEffectMusicFade(fadeTo:Number) {
			_fadeFrom = RetrocamelSoundManager.musicFadeVolume;
			_fadeTo = fadeTo;
		}

		override public function update():void {
			if (_blocked) {
				return blockUpdate();
			}

			RetrocamelSoundManager.musicFadeVolume = getInterval(_fadeFrom, _fadeTo);

			super.update();
		}

		override protected function finish():void {
			RetrocamelSoundManager.musicFadeVolume = _fadeTo;

			_currentMusicFade = null;

			super.finish();
		}

		public function fadeFrom(value:Number):RetrocamelEffectMusicFade {
			_fadeFrom = value;

			return this;
		}

		override public function run(addTo:RetrocamelUpdatableGroup = null):RetrocamelEffectBase {
			if (_currentMusicFade) {
				_currentMusicFade.finish();
				_currentMusicFade = this;
			}

			return super.run(addTo);
		}
	}
}