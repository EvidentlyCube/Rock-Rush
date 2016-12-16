package game.states {
	import game.global.Game;
	import game.global.Score;
	import game.global.Sfx;
	import game.global.levels.Level;
	import game.objects.TGameObject;
	import game.objects.THud;
	import game.windows.TWinPause;

	import net.retrocade.constants.KeyConst;
	import net.retrocade.helpers.RetrocamelScrollAssist;
	import net.retrocade.retrocamel.components.RetrocamelStateBase;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.retrocamel.core.RetrocamelWindowsManager;
	import net.retrocade.retrocamel.effects.RetrocamelEffectQuake;
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;

	public class TStateGame extends RetrocamelStateBase {
		private static var _instance:TStateGame = new TStateGame();
		public static function get instance():TStateGame {
			return _instance;
		}


		private var _updateFrame:uint = 0;

		override public function create():void {
			_defaultGroup = Game.gAll;
		}

		override public function destroy():void {
			_defaultGroup.clear();
			THud.instance.unhook();
			Game.lGame.clear();
			Game.lBG.clear();
			Game.lMain.clear();
		}

		override public function update():void {
			if (RetrocamelInputManager.isKeyHit(KeyConst.ESCAPE)) {
				TWinPause.instance.show();
				return;
			}

			RetrocamelScrollAssist.instance.displayWidth = S().levelWidth;
			RetrocamelScrollAssist.instance.displayHeight = S().levelHeight;

			var repeats:uint = 1;
			if (RetrocamelInputManager.isKeyDown(Game.keySpeed1)) {
				repeats = 4;
			}

			if (RetrocamelInputManager.isKeyDown(Game.keySpeed2)) {
				repeats = 16;
			}

			if (RetrocamelInputManager.isKeyDown(Game.keySpeed3)) {
				repeats = 64;
			}

			Game.lGame.clear();
			Game.gAll.update();

			var i:int;
			var j:int;

			var l:int;
			var k:int;

			var tile:TGameObject;

			while (repeats--) {
				if (RetrocamelWindowsManager.pauseGame) {
					break;
				}

				if (Level.instance.magicWallActive) {
					Level.instance.magicWallTimer--;
				}

				if (Level.instance.magicWallTimer == 0) {
					RetrocamelEventsQueue.add(C.EVENT_MAGIC_WALL_DISACTIVATED);
					Level.instance.magicWallActive = false;
				}

				if (Level.instance.player && !Level.instance.completed && Score.time > 0) {
					Score.time -= 1;

					if (Score.time <= 600 && Score.time % 60 == 0) {
						Sfx.sfxAlert.play();
					}

					if (Score.time == 0) {
						Level.instance.player.kill();
					}
				}

				_updateFrame++;

				Level.instance.actives.update();
			}

			RetrocamelScrollAssist.instance.update();
			Game.lGame.scrollX = -RetrocamelScrollAssist.x;
			Game.lGame.scrollY = -RetrocamelScrollAssist.y;

			i = Math.floor(RetrocamelScrollAssist.x / 12) - 1;
			j = Math.floor(RetrocamelScrollAssist.y / 12) - 1;

			l = i + 24;
			k = j + 19;

			Level.instance.effects.update();

			for (j = k - 19; j < k; j++) {
				for (i = l - 24; i < l; i++) {
					tile = Level.instance.level.get(i * 12, j * 12);

					if (tile) {
						tile.draw();
					}
				}
			}

			if (RetrocamelEventsQueue.occured(C.EVENT_MAGIC_WALL_ACTIVATED)) {
				Level.instance.magicWallActive = true;
				Level.instance.magicWallCanActivate = false;
			}

			// Sound Effects

			if (Level.instance.magicWallTimer % 15 == 1 || RetrocamelEventsQueue.occured(C.EVENT_MAGIC_WALL_ACTIVATED)) {
				RetrocamelSoundManager.playSound(Sfx.magicWall);
			}

			if (RetrocamelEventsQueue.occured(C.EVENT_DIAMOND_LANDED)) {
				RetrocamelSoundManager.playSound(Sfx.diamondFall);
			}

			if (RetrocamelEventsQueue.occuredArray([C.EVENT_DIAMOND_COLLECTED, C.EVENT_KEY_COLLECTED])) {
				RetrocamelSoundManager.playSound(Sfx.diamondCollect);
			}

			if (RetrocamelEventsQueue.occured(C.EVENT_EXPLOSION_OCCURED)) {
				RetrocamelSoundManager.playSound(Sfx.explosion);
				RetrocamelEffectQuake.make().power(5, 5).duration(200).run();
			}

			if (RetrocamelEventsQueue.occured(C.EVENT_DOOR_CROSSED)) {
				RetrocamelSoundManager.playSound(Sfx.door);
			}

			if (RetrocamelEventsQueue.occured(C.EVENT_BOULDER_LANDED)) {
				RetrocamelSoundManager.playSound(Sfx.boulderFall);
			}

			if (RetrocamelEventsQueue.occured(C.EVENT_BOULDER_PUSHED)) {
				RetrocamelSoundManager.playSound(Sfx.boulderPush);
			}

			if (RetrocamelEventsQueue.occured(C.EVENT_WALL_GREW)) {
				RetrocamelSoundManager.playSound(Sfx.wallGrow);
			}

			if (RetrocamelEventsQueue.occuredArray([C.EVENT_AMOEBA_GREW, C.EVENT_SLIME_PASSED])) {
				RetrocamelSoundManager.playSound(Sfx.amoebaGrow);
			}

			if (RetrocamelEventsQueue.occured(C.EVENT_EXIT_OPENED)) {
				RetrocamelSoundManager.playSound(Sfx.exitOpened);
			}
		}

		public function TStateGame() {
		}
	}
}