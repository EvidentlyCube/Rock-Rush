package game.windows {
	import flash.display.Bitmap;

	import net.retrocade.constants.KeyConst;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelWindowFlash;
	import net.retrocade.retrocamel.effects.RetrocamelEasings;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.effects.RetrocamelEffectSolidScreen;
	import net.retrocade.retrocamel.locale._;

	public class TWinMessage extends RetrocamelWindowFlash {
		[Embed(source="/../src.assets/bgs/messageWindow.png")]
		public static var _gfx_:Class;

		private static var _instance:TWinMessage = new TWinMessage();

		public static function showMessage(text:String):void {
			_instance._showMessage(text);
		}


		private var _bg:Bitmap;
		private var _text:RetrocamelBitmapText;
		private var _notification:RetrocamelBitmapText;

		private var _hideTimer:uint;

		private var _canClose:Boolean = false;

		private var _blocker:RetrocamelEffectSolidScreen;

		public function TWinMessage() {
			_blockUnder = true;
			_pauseGame = true;

			_bg = RetrocamelBitmapManager.getB(_gfx_, false);

			_text = new RetrocamelBitmapText("", null, false);
			_notification = new RetrocamelBitmapText(_("hitSpaceToContinue"));

			_text.align = RetrocamelBitmapText.ALIGN_MIDDLE;
			_text.addShadow();

			addChild(_bg);
			addChild(_text);
			addChild(_notification);

			_text.y = 18;

			_notification.x = (_bg.width - _notification.width) / 2;
			_notification.y = _bg.height - 25;

			_notification.addShadow();

			scaleX = scaleY = 2;

			centerWindow();
		}

		private function _showMessage(text:String):void {
			_text.text = _text.getWordWrapToWidth(text, 210);

			_text.x = (_bg.width - _text.width) / 2;

			this.show();

			_canClose = false;

			_blocker = RetrocamelEffectSolidScreen.make().alpha(0.75).color(0).duration(0).run() as RetrocamelEffectSolidScreen;

			RetrocamelEffectFadeFlash.make(_blocker.flashSpriteLayer.layer).alpha(0, 1).duration(400).run();

			RetrocamelEffectFadeFlash.make(this).alpha(0, 1).duration(400).callback(onFadeIn).easing(RetrocamelEasings.quadraticOut).run();
		}

		private function onFadeIn():void {
			_canClose = true;
		}

		override public function update():void {
			if (_canClose) {
				_hideTimer = (_hideTimer + 1) % 60;
			}

			_notification.visible = _hideTimer < 30;

			if (_canClose && RetrocamelInputManager.isKeyHit(KeyConst.SPACE)) {
				_canClose = false;

				RetrocamelEffectFadeFlash.make(_blocker.flashSpriteLayer.layer).alpha(1, 0).duration(400).callback(_blocker.skip).run();
				RetrocamelEffectFadeFlash.make(this).alpha(1, 0).duration(400).callback(hide).easing(RetrocamelEasings.quadraticIn).run();
			}
		}
	}
}