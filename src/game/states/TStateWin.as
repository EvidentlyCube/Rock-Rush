package game.states {
	import flash.display.BitmapData;
	import flash.utils.setTimeout;

	import game.global.Game;
	import game.global.Gfx;
	import game.global.Make;
	import game.global.Sfx;

	import net.retrocade.retrocamel.components.RetrocamelStateBase;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.flash.RetrocamelSprite;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.effects.RetrocamelEffectMusicFade;
	import net.retrocade.retrocamel.locale._;

	public class TStateWin extends RetrocamelStateBase {
		public static function set():void {
			RetrocamelCore.setState(new TStateWin());
		}

		private var _playerY:uint;
		private var _playerFrame:uint;
		private var _playerFrameTimer:uint;
		private var _playerGfx:BitmapData;
		private var _playerFramew:Vector.<BitmapData> = new Vector.<BitmapData>(7, true);
		private var _playerSpeechText:RetrocamelBitmapText;
		private var _currentState:uint = 0;
		private var _continueButton:RetrocamelButton;
		private var _alternateGamesContainer:RetrocamelSprite;

		public function TStateWin() {
			_playerFramew[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 144, 12, 12);
			_playerFramew[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 72, 156, 12, 12);
			_playerFramew[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 84, 156, 12, 12);
			_playerFramew[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 96, 156, 12, 12);
			_playerFramew[4] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 108, 156, 12, 12);
			_playerFramew[5] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 120, 156, 12, 12);
			_playerFramew[6] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 132, 156, 12, 12);

			_playerSpeechText = Make().text("", 0x66FF66, 2);
			_playerSpeechText.align = RetrocamelBitmapText.ALIGN_MIDDLE;
			_playerSpeechText.lineSpace = 0;
		}

		override public function create():void {
			_playerY = S().gameHeight / 2 | 0;
			_playerFrame = 0;
			_playerFrameTimer = 0;
			_currentState = 0;

			Game.lGame.clear();
			Game.lBG.clear();
			Game.lMain.clear();
			Game.lMain.add(_playerSpeechText);

			Game.lBG.shapeRect(0, 0, S().gameWidth, S().gameHeight, 0xFF000000);

			RetrocamelEffectMusicFade.make(0).fadeFrom(1).duration(1000).run();
		}

		override public function update():void {
			if (_playerY > 55 && _currentState == 0) {
				_playerY -= 1;
				_playerFrameTimer++;
				if (_playerFrameTimer == 7) {
					_playerFrameTimer = 0;
					_playerFrame = (_playerFrame + 1) % 6;
				}

				if (_playerFrameTimer == 0 && _playerFrame % 3 == 0) {
					Sfx.sfxWalk.play();
				}

				_playerGfx = _playerFramew[_playerFrame + 1];

			} else {
				switch (_currentState) {
					case(0):
						_playerGfx = _playerFramew[0];
						_playerFrameTimer = 0;
						_currentState = 1;
						_playerSpeechText.text = _("win1");
						_playerSpeechText.alignCenter();
						fadeIn();
						_currentState++;
						break;

					case(3):
						_playerSpeechText.text = _("win2");
						_playerSpeechText.alignCenter();
						fadeIn();
						_currentState++;
						break;

					case(5):
						_playerSpeechText.text = _("win3");
						_playerSpeechText.alignCenter();
						fadeIn();
						_currentState++;
						break;

					case(7):
						_currentState = 11;
						break;

					case(9):
						_playerSpeechText.text = _("win5");
						_playerSpeechText.alignCenter();
						RetrocamelEffectFadeFlash.make(_playerSpeechText).alpha(0, 1).duration(500).callback(showAlts).run();
						_currentState++;
						break;

					case(11):
						_playerSpeechText.text = _("win6");
						_playerSpeechText.alignCenter();

						_continueButton = Make().button(end, _("winExit"));

						_continueButton.x = (S().gameWidth - _continueButton.width) / 2 | 0;
						_continueButton.y = S().gameHeight - _continueButton.height - 5;

						Game.lMain.add(_continueButton);

						RetrocamelEffectFadeFlash.make(_playerSpeechText).alpha(0, 1).duration(500).run();
						RetrocamelEffectFadeFlash.make(_continueButton).alpha(0, 1).duration(500).run();
						_currentState++;
						break;

					case(20):
						_playerY += 1;
						_playerFrameTimer++;
						if (_playerFrameTimer == 7) {
							_playerFrameTimer = 0;
							_playerFrame = (_playerFrame + 1) % 6;
						}

						if (_playerFrameTimer == 0 && _playerFrame % 3 == 0) {
							Sfx.sfxWalk.play();
						}

						_playerGfx = _playerFramew[_playerFrame + 1];

						if (_playerY > S().gameHeight / 2) {
							TStateTitle.instance.setToMe();
							return;
						}
						break;
				}
			}

			Game.lGame.clear();
			Game.lGame.draw(_playerGfx, S().gameWidth / 4 - 6, _playerY);
		}

		override public function destroy():void {
			Game.lMain.mouseChildren = true;
			Game.lMain.clear();
			Game.lGame.clear();
		}

		private function showAlts():void {
			Game.lMain.add(_alternateGamesContainer);
			_alternateGamesContainer.y = S().gameHeight - _alternateGamesContainer.height - 50;

			_continueButton = Make().button(end, _("winNo"));

			_continueButton.x = (S().gameWidth - _continueButton.width) / 2 | 0;
			_continueButton.y = S().gameHeight - _continueButton.height - 5;

			Game.lMain.add(_continueButton);
			RetrocamelEffectFadeFlash.make(_continueButton).alpha(0, 1).duration(600).run();
			RetrocamelEffectFadeFlash.make(_alternateGamesContainer).alpha(0, 1).duration(600).run();
		}

		private function end():void {
			RetrocamelEffectFadeFlash.make(_continueButton).alpha(1, 0).duration(1000).run();
			RetrocamelEffectFadeFlash.make(_playerSpeechText).alpha(1, 0).duration(1000).run();

			if (_alternateGamesContainer) {
				RetrocamelEffectFadeFlash.make(_alternateGamesContainer).alpha(1, 0).duration(1000).run();
			}

			_currentState = 20;

			Game.lMain.mouseChildren = false;
		}

		private function fadeIn():void {
			RetrocamelEffectFadeFlash.make(_playerSpeechText).alpha(0, 1).duration(500).callback(initTimer).run();
		}

		private function initTimer():void {
			setTimeout(fadeOut, 3000);
		}

		private function fadeOut():void {
			RetrocamelEffectFadeFlash.make(_playerSpeechText).alpha(1, 0).duration(500).callback(afterFade).run();
		}

		private function afterFade():void {
			_currentState++;
		}
	}
}