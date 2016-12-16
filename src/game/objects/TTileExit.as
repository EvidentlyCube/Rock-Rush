package game.objects {
	import flash.utils.setTimeout;

	import game.global.Gfx;
	import game.global.Score;
	import game.global.Sfx;
	import game.global.levels.Level;
	import game.windows.TWinLevelCompleted;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeScreen;
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;

	public class TTileExit extends TGameObject {
		private static var __gfx:Array;

		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 108, 144, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 120, 144, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 132, 144, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 144, 144, 12, 12);
			__gfx[4] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 156, 144, 12, 12);
			__gfx[5] = __gfx[3];
			__gfx[6] = __gfx[2];
		}


		private var _frame:uint = 0;
		private var _frameTimer:uint = 0;

		private var _playerEntered:Boolean = false;


		public function TTileExit(x:uint, y:uint) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;

			flags = CAN_SURVIVE_EXPLOSION | CAN_SURVIVE_PLASMA;

			_gfx = __gfx[0];

			addSelf();

			addDefault();
		}

		override public function update():void {
			if (Level.instance.completed) {
				if (!_playerEntered) {
					nullifyDefault();
				} else if (Score.time > 0) {
					Score.time -= 60;
					Score.score += Level.instance.timeValue;
				} else {
					setTimeout(Sfx.sfxTimeCount.stop, 50);
					RetrocamelSoundManager.playSound(Sfx.diamondCollect);
					nullifyDefault();
					TWinLevelCompleted.show();
				}
				return;
			}
			if (_frame == 0 && Score.diamondsToGet == Score.diamondsGot && RetrocamelEventsQueue.occured(C.EVENT_DIAMOND_COLLECTED)) {
				RetrocamelEffectFadeScreen.makeIn().color(0xFFFFFF).duration(200).run();

				_frame = 1;
				_gfx = __gfx[1];
				RetrocamelEventsQueue.add(C.EVENT_EXIT_OPENED);

			} else if (_frame) {
				_frameTimer++;

				if (_frameTimer == 10) {
					_frame = (_frame % 6) + 1;
					_frameTimer = 0;
					_gfx = __gfx[_frame];
				}
			}
		}

		override public function canWalkInto(object:TGameObject, tx:int, ty:int):Boolean {
			return object is TPlayer && _frame;
		}

		override public function walkedOn(object:TGameObject, tx:int, ty:int):void {
			_playerEntered = true;

			Level.instance.timeLeft = Score.time / 60 | 0;
			removeSelf();

			Level.instance.player.makeInvincible();

			Level.instance.completed = true;

			Sfx.sfxTimeCount.play();
			RetrocamelSoundManager.pauseMusic();
		}
	}
}