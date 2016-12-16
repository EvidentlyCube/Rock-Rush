package game.states {
	import flash.display.Bitmap;

	import game.global.Game;
	import game.global.Gfx;
	import game.global.Make;
	import game.windows.TWinCredits;
	import game.windows.TWinLevelSelection;
	import game.windows.TWinOptions;

	import net.retrocade.retrocamel.components.RetrocamelStateBase;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.flash.RetrocamelWindowFlash;
	import net.retrocade.retrocamel.effects.RetrocamelEasings;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeScreen;
	import net.retrocade.retrocamel.effects.RetrocamelEffectMove;
	import net.retrocade.retrocamel.effects.RetrocamelEffectMusicFade;
	import net.retrocade.retrocamel.locale._;

	public class TStateTitle extends RetrocamelStateBase {
		private static var _instance:TStateTitle;

		public static function get instance():TStateTitle {
			if (!_instance) {
				_instance = new TStateTitle();
			}
			return _instance;
		}


		private var _logo:Bitmap;
		private var _selectLevel:RetrocamelButton;
		private var _options:RetrocamelButton;
		private var _credits:RetrocamelButton;

		public function TStateTitle() {
			_logo = Gfx.logoBitmap;
			_options = Make().button(onOptions, _("Options"), 120);
			_credits = Make().button(onCredits, _("Credits"), 120);
			_selectLevel = Make().button(onSelectLevel, _("play"));

			_logo.scaleX = 2;
			_logo.scaleY = 2;

			_logo.x = (S().gameWidth - _logo.width) / 2 | 0;
			_logo.y = 5;

			_selectLevel.alignCenter();
			_credits.alignCenter();
			_options.alignCenter();
			_selectLevel.y = 140;
			_credits.y = _selectLevel.bottom + 6;
			_options.y = _credits.bottom + 6;
		}

		private static function onSelectLevel():void {
			new TWinLevelSelection();
		}

		override public function update():void {
			Game.lGame.layer.alpha = 1;

			Game.lGame.clear();
			super.update();
		}

		override public function create():void {
			Game.lBG.clear();
			Game.lMain.clear();
			Game.lGame.clear();

			Game.lBG.draw(Gfx.backgroundTitleScreenBitmapData, 0, 0);

			Game.lMain.add(_logo);
			Game.lMain.add(_credits);
			Game.lMain.add(_options);
			Game.lMain.add(_selectLevel);

			Game.lGame.layer.alpha = 0;

			RetrocamelEffectMusicFade.make(1).fadeFrom(0).duration(1200).run();

			if (!RetrocamelSoundManager.musicIsPlaying()) {
				RetrocamelSoundManager.playMusic(Game.music, 1000);
			}

			RetrocamelEffectFadeScreen.makeIn().duration(600).run();

			RetrocamelEffectFadeFlash.make(_credits).alpha(0, 1).duration(800).run();
			RetrocamelEffectFadeFlash.make(_options).alpha(0, 1).duration(800).run();
			RetrocamelEffectFadeFlash.make(_selectLevel).alpha(0, 1).duration(800).run();

			Game.lMain.mouseChildren = false;

			_logo.y -= 150;
			RetrocamelEffectMove.make(_logo).targetY(_logo.y + 150).duration(1200).callback(reenableMouse).easing(RetrocamelEasings.quadraticOut).run();
		}

		private function reenableMouse():void {
			Game.lMain.mouseChildren = true;
		}

		override public function destroy():void {
			Game.lMain.clear();
			Game.lGame.clear();
			_defaultGroup.clear();
		}

		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: On Options
		// ::::::::::::::::::::::::::::::::::::::::::::::

		private static function onOptions():void {
			var win:RetrocamelWindowFlash = new TWinOptions();
			win.show();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: On Credits
		// ::::::::::::::::::::::::::::::::::::::::::::::

		private static function onCredits():void {
			TWinCredits.show();
		}


	}
}