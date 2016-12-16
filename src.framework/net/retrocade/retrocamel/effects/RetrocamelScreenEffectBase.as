package net.retrocade.retrocamel.effects {
	import flash.events.Event;

	import net.retrocade.retrocamel.core.RetrocamelDisplayManager;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayer;

	public class RetrocamelScreenEffectBase extends RetrocamelEffectBase {
		/**
		 * Instance of the layer used for this effect
		 */
		protected var _layer:RetrocamelLayer;

		public function get layer():RetrocamelLayer {
			return _layer;
		}

		public function RetrocamelScreenEffectBase(layer:RetrocamelLayer) {
			_layer = layer;

			RetrocamelDisplayManager.flashStage.addEventListener(Event.RESIZE, onResize);
		}

		override protected function finish():void {
			RetrocamelDisplayManager.flashStage.removeEventListener(Event.RESIZE, onResize);

			_layer.clear();
			_layer.removeLayer();
			_layer = null;

			super.finish();
		}

		protected function onResize(e:Event):void {
		}
	}
}