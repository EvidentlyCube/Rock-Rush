package game.windows {
	import game.global.Make;
	import game.global.Options;
	import game.global.pre.Pre;

	import net.retrocade.constants.KeyConst;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.flash.RetrocamelPreciseGrid9;
	import net.retrocade.retrocamel.display.flash.RetrocamelWindowFlash;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.locale._;

	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	public class TWinOptions extends RetrocamelWindowFlash {
		public static function showWindow():void {
			var window:TWinOptions = new TWinOptions();
			window.show();
		}

		public function TWinOptions() {
			this._blockUnder = true;
			this._pauseGame = false;

			var backgroundGrid9:RetrocamelPreciseGrid9 = RetrocamelPreciseGrid9.getGrid("window", true);

			var textHeader:RetrocamelBitmapText = Make().text(_("Options"), 0xFFFFFF, 3);
			textHeader.addShadow();

			var optionsComponent:Options = new Options();
			var buttonClose:RetrocamelButton = Make().button(onClose, _('Close'));
			buttonClose.filters = Pre.DROP_SHADOW_FILTER;

			addChild(backgroundGrid9);
			addChild(textHeader);
			addChild(optionsComponent);
			addChild(buttonClose);

			backgroundGrid9.width = width + 10;
			backgroundGrid9.height = optionsComponent.height + buttonClose.height + 75;

			optionsComponent.x = (width - optionsComponent.width) / 2 | 0;
			optionsComponent.y = 55;

			textHeader.x = (width - textHeader.width) / 2 | 0;

			buttonClose.x = (width - buttonClose.width) / 2 | 0;
			buttonClose.y = height - buttonClose.height - 10;

			centerWindow();
		}

		private function onClose():void {
			if (mouseEnabled) {
				mouseEnabled = false;
				mouseChildren = false;

				RetrocamelEffectFadeFlash.make(this).alpha(1, 0).duration(250).callback(onHide).run();
			}
		}

		private function onHide():void {
			hide();
		}

		override public function update():void {
			if (RetrocamelInputManager.isKeyHit(KeyConst.ESCAPE)) {
				onClose();
			}

			super.update();
		}

		override public function show():void {
			super.show();

			mouseEnabled = false;
			mouseChildren = false;

			RetrocamelEffectFadeFlash.make(this).alpha(0, 1).duration(250).callback(callbackEnableMouse).run();
		}
	}
}