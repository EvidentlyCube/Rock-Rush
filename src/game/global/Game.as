package game.global {
	import flash.events.KeyboardEvent;
	import flash.media.Sound;

	import game.states.TStateTitle;
	import game.windows.TWinFocusPause;

	import net.retrocade.constants.KeyConst;
	import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashBlit;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;
	import net.retrocade.retrocamel.global.RetrocamelSimpleSave;

	public class Game {
		[Embed(source="/../src.music/music2.mp3")]
		public static var _music_:Class;


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Game Variables
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public static var lMain:RetrocamelLayerFlashSprite;
		public static var lBG:RetrocamelLayerFlashBlit;
		public static var lGame:RetrocamelLayerFlashBlit;


		public static var gAll:RetrocamelUpdatableGroup = new RetrocamelUpdatableGroup();

		private static var musics:Array;

		public static function get music():Sound {
			if (!musics) {
				musics = [];
				musics[0] = new _music_;
			}

			return musics[musics.length * Math.random() | 0];
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Keys
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public static var keyLeft:uint;
		public static var keyRight:uint;
		public static var keyUp:uint;
		public static var keyDown:uint;
		public static var keyRestart:uint;
		public static var keyGrab:uint;
		public static var keySound:uint;
		public static var keyMusic:uint;
		public static var keySpeed1:uint;
		public static var keySpeed2:uint;
		public static var keySpeed3:uint;

		public static var allKeys:Array = ['keyLeft', 'keyRight', 'keyGrab', 'keyUp', 'keyDown', 'keyRestart', 'keySound', 'keyMusic', 'keySpeed1', 'keySpeed2', 'keySpeed3'];


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Init
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public static function init():void {
			keyLeft = RetrocamelSimpleSave.read('optkeyLeft', KeyConst.LEFT);
			keyRight = RetrocamelSimpleSave.read('optkeyRight', KeyConst.RIGHT);
			keyUp = RetrocamelSimpleSave.read('optkeyUp', KeyConst.UP);
			keyDown = RetrocamelSimpleSave.read('optkeyDown', KeyConst.DOWN);
			keyRestart = RetrocamelSimpleSave.read('optkeyRestart', KeyConst.R);
			keyGrab = RetrocamelSimpleSave.read('optkeyGrab', KeyConst.Z);
			keySound = RetrocamelSimpleSave.read('optkeySound', KeyConst.S);
			keyMusic = RetrocamelSimpleSave.read('optkeyMusic', KeyConst.M);
			keySpeed1 = RetrocamelSimpleSave.read('optkeySpeed1', KeyConst.Q);
			keySpeed2 = RetrocamelSimpleSave.read('optkeySpeed2', KeyConst.W);
			keySpeed3 = RetrocamelSimpleSave.read('optkeySpeed3', KeyConst.E);

			Game.lBG = new RetrocamelLayerFlashBlit();
			Game.lGame = new RetrocamelLayerFlashBlit();
			Game.lMain = new RetrocamelLayerFlashSprite();

			Game.lGame.setScale(2, 2);
			Game.lBG.setScale(2, 2);

			Score.loadData();

			//TStateGame.instance.set();
			//LevelManager.startGame();
			TStateTitle.instance.setToMe();
			//TStateWin.set();

			TWinFocusPause.hook();

			RetrocamelInputManager.addStageKeyDown(onKeyDown);
		}

		private static var oldSoundVolume:Number = 1;
		private static var oldMusicVolume:Number = 1;
		public static var disableQuickSFXToggle:Boolean = false;

		private static function onKeyDown(e:KeyboardEvent):void {
			if (disableQuickSFXToggle) {
				return;
			}

			if (e.keyCode == Game.keySound) {
				if (RetrocamelSoundManager.soundVolume == 0) {
					RetrocamelSoundManager.soundVolume = oldSoundVolume;
				}
				else {
					oldSoundVolume = RetrocamelSoundManager.soundVolume;
					RetrocamelSoundManager.soundVolume = 0;
				}

				RetrocamelSimpleSave.write('optVolumeSound', RetrocamelSoundManager.soundVolume);
			} else if (e.keyCode == Game.keyMusic) {
				if (RetrocamelSoundManager.musicVolume == 0) {
					RetrocamelSoundManager.musicVolume = oldMusicVolume;
				}
				else {
					oldMusicVolume = RetrocamelSoundManager.musicVolume;
					RetrocamelSoundManager.musicVolume = 0;
				}

				RetrocamelSimpleSave.write('optVolumeMusic', RetrocamelSoundManager.musicVolume);
			}
		}
	}
}