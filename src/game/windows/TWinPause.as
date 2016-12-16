package game.windows {
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import game.global.Make;
	import game.global.pre.Pre;
	import game.objects.TEscButton;
	import game.states.TStateTitle;

	import net.retrocade.constants.KeyConst;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.flash.RetrocamelPreciseGrid9;
	import net.retrocade.retrocamel.display.flash.RetrocamelWindowFlash;
	import net.retrocade.retrocamel.display.global.RetrocamelTooltip;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeScreen;
	import net.retrocade.retrocamel.effects.RetrocamelEffectMusicFade;
	import net.retrocade.retrocamel.locale._;
	import net.retrocade.utils.UtilsDisplay;
	import net.retrocade.utils.UtilsGraphic;

	public class TWinPause extends RetrocamelWindowFlash {
		private static var _instance:TWinPause;

		public static function get instance():TWinPause {
			if (!_instance) {
				_instance = new TWinPause();
			}

			return _instance;
		}

		public function TWinPause() {
			this._blockUnder = true;
			this._pauseGame = true;

			var textHeader:RetrocamelBitmapText = Make().text(_("Game is Paused"), 0xFFFFFF, 2);

			var buttonOptions:RetrocamelButton = Make().button(onOptions, _('Options'));
			var buttonClose:RetrocamelButton = Make().button(onClose, _('Return to Game'));
			var buttonReturnToMenu:RetrocamelButton = Make().button(onMenu, _('Return to Title Screen'));
			var buttonWalkthrough:RetrocamelButton = Make().button(onHelp, _('Walkthrough'));
			var buttonChangeLevel:RetrocamelButton = Make().button(onChangeLevel, _('Change Level'));

			addChild(textHeader);
			addChild(buttonOptions);
			addChild(buttonClose);
			addChild(buttonReturnToMenu);
			addChild(buttonWalkthrough);
			addChild(buttonChangeLevel);

			buttonClose.y = textHeader.bottom + 10;
			buttonOptions.y = buttonClose.bottom + 5;
			buttonChangeLevel.y = buttonOptions.bottom + 5;
			buttonReturnToMenu.y = buttonChangeLevel.bottom + 5;
			buttonWalkthrough.y = buttonReturnToMenu.bottom + 5;

			textHeader.alignCenterParent();
			buttonClose.alignCenterParent();
			buttonReturnToMenu.alignCenterParent();
			buttonWalkthrough.alignCenterParent();
			buttonOptions.alignCenterParent();
			buttonChangeLevel.alignCenterParent();

			buttonChangeLevel.filters = buttonOptions.filters = Pre.DROP_SHADOW_FILTER;
			buttonClose.filters = buttonWalkthrough.filters = buttonReturnToMenu.filters = Pre.DROP_SHADOW_FILTER;

			var grid:RetrocamelPreciseGrid9 = RetrocamelPreciseGrid9.getGrid('window', true);
			grid.width = width + 20;
			grid.height = buttonWalkthrough.y + buttonWalkthrough.height + 20;

			UtilsDisplay.pushChildren(this, 10, 10);

			addChildAt(grid, 0);

			centerWindow();

			UtilsGraphic.clear(this).beginFill(0, 0.5).drawRect(-x, -y, S().gameWidth, S().gameHeight);

			RetrocamelTooltip.hook(buttonReturnToMenu, _('Click loses progress'));
			RetrocamelTooltip.hook(buttonWalkthrough, _('helpTooltip'));
		}

		override public function show():void {
			super.show();

			mouseEnabled = false;
			mouseChildren = false;

			RetrocamelEffectFadeFlash.make(this).alpha(0, 1).duration(250).callback(callbackEnableMouse).run();

			TEscButton.unset();
		}


		private function onClose():void {
			if (mouseEnabled) {
				mouseEnabled = false;
				mouseChildren = false;

				RetrocamelEffectFadeFlash.make(this).alpha(1, 0).duration(250).callback(efFinClose).run();
			}
		}


		private function onMenu():void {
			RetrocamelEffectFadeFlash.make(this).alpha(1, 0).duration(250).run();

			RetrocamelEffectFadeScreen.makeOut().duration(1000).callback(efFinReturnToMenu).run();
			RetrocamelEffectMusicFade.make(0).fadeFrom(1).duration(200).run();
		}

		private static function onHelp():void {
			navigateToURL(new URLRequest("http://retrocade_old.net/article/8/walkthrough-rock-rush"), "_blank");
		}

		private static function onOptions():void {
			TWinOptions.showWindow();
		}

		private static function onChangeLevel():void {
			new TWinLevelSelection();
		}

		override public function update():void {
			if (RetrocamelInputManager.isKeyHit(KeyConst.ESCAPE)) {
				onClose();
			}

			super.update();
		}

		private function efFinClose():void {
			hide();
		}

		private function efFinReturnToMenu():void {
			hide();
			RetrocamelSoundManager.stopMusic();
			RetrocamelSoundManager.resetMusicFadeVolume();
			TStateTitle.instance.setToMe();
		}
	}
}