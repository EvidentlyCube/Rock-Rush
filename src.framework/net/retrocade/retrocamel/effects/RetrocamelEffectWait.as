package net.retrocade.retrocamel.effects {
	public class RetrocamelEffectWait extends RetrocamelEffectBase {
		public static function make(waitDuration:int):RetrocamelEffectWait {
			return new RetrocamelEffectWait(waitDuration);
		}

		public function RetrocamelEffectWait(waitDuration:int) {
			duration(waitDuration);
		}

		override public function update():void {
			if (_blocked) {
				blockUpdate();
			} else {
				super.update();
			}
		}
	}
}