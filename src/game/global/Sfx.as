package game.global {
	import net.retrocade.sfxr.SfxrParams;
	import net.retrocade.sfxr.SfxrSynth;

	public class Sfx {
		[Embed(source="/../src.assets/sfx/diamond1.mp3")]
		private static var _diamond1:Class;
		[Embed(source="/../src.assets/sfx/diamond2.mp3")]
		private static var _diamond2:Class;
		[Embed(source="/../src.assets/sfx/diamond3.mp3")]
		private static var _diamond3:Class;
		[Embed(source="/../src.assets/sfx/diamond4.mp3")]
		private static var _diamond4:Class;
		[Embed(source="/../src.assets/sfx/diamond5.mp3")]
		private static var _diamond5:Class;
		[Embed(source="/../src.assets/sfx/diamond6.mp3")]
		private static var _diamond6:Class;
		[Embed(source="/../src.assets/sfx/diamond7.mp3")]
		private static var _diamond7:Class;
		[Embed(source="/../src.assets/sfx/diamond8.mp3")]
		private static var _diamond8:Class;

		[Embed(source="/../src.assets/sfx/collect1.mp3")]
		private static var _collect1:Class;
		[Embed(source="/../src.assets/sfx/collect2.mp3")]
		private static var _collect2:Class;
		[Embed(source="/../src.assets/sfx/collect3.mp3")]
		private static var _collect3:Class;

		[Embed(source="/../src.assets/sfx/boulder1.mp3")]
		private static var _boulder1:Class;
		[Embed(source="/../src.assets/sfx/boulder2.mp3")]
		private static var _boulder2:Class;
		[Embed(source="/../src.assets/sfx/boulder3.mp3")]
		private static var _boulder3:Class;
		[Embed(source="/../src.assets/sfx/boulder4.mp3")]
		private static var _boulder4:Class;

		[Embed(source="/../src.assets/sfx/amoeba1.mp3")]
		private static var _amoeba1:Class;
		[Embed(source="/../src.assets/sfx/amoeba2.mp3")]
		private static var _amoeba2:Class;
		[Embed(source="/../src.assets/sfx/amoeba3.mp3")]
		private static var _amoeba3:Class;
		[Embed(source="/../src.assets/sfx/amoeba4.mp3")]
		private static var _amoeba4:Class;
		[Embed(source="/../src.assets/sfx/amoeba5.mp3")]
		private static var _amoeba5:Class;

		[Embed(source="/../src.assets/sfx/explosion.mp3")]
		public static var explosion:Class;
		[Embed(source="/../src.assets/sfx/door.mp3")]
		public static var door:Class;
		[Embed(source="/../src.assets/sfx/boulderPush.mp3")]
		public static var boulderPush:Class;
		[Embed(source="/../src.assets/sfx/wallGrow.mp3")]
		public static var wallGrow:Class;
		[Embed(source="/../src.assets/sfx/magicWall.mp3")]
		public static var magicWall:Class;
		[Embed(source="/../src.assets/sfx/exitOpened.mp3")]
		public static var exitOpened:Class;


		public static function get diamondFall():Class {
			return Sfx["_diamond" + (Math.random() * 8 + 1 | 0).toString()];
		}

		public static function get boulderFall():Class {
			return Sfx["_boulder" + (Math.random() * 4 + 1 | 0).toString()];
		}

		public static function get diamondCollect():Class {
			return Sfx["_collect" + (Math.random() * 3 + 1 | 0).toString()];
		}

		public static function get amoebaGrow():Class {
			return Sfx["_amoeba" + (Math.random() * 5 + 1 | 0).toString()];
		}

		public static var sfxRollOver:SfxrSynth;
		public static var sfxClick:SfxrSynth;

		public static var sfxWalk:SfxrSynth;
		public static var sfxAlert:SfxrSynth;

		public static var sfxTimeCount:SfxrSynth;

		public static function initialize():void {
			var sfxrParams:SfxrParams = new SfxrParams();

			sfxrParams.setSettingsString("2,0.0051,0.0252,,0.21,0.29,0.0752,,,,,,0.89,0.4339,,,,,1,,,,,0.52");
			sfxRollOver = new SfxrSynth();
			sfxRollOver.params = sfxrParams.clone();

			sfxrParams.setSettingsString("2,,0.186,,0.0638,0.5582,,,,,,,,,,,,,1,,,0.1,,0.52");
			sfxClick = new SfxrSynth();
			sfxClick.params = sfxrParams.clone();

			sfxrParams.setSettingsString("3,,0.18,,,0.216,,,,,,,,,-0.62,,,,0.69,-0.4,,,1,0.30");
			sfxWalk = new SfxrSynth();
			sfxWalk.params = sfxrParams.clone();

			sfxrParams.setSettingsString("1,,0.31,0.55,0.39,0.16,,,,,,,,0.1362,,,,,1,,,0.1,,0.5");
			sfxAlert = new SfxrSynth();
			sfxAlert.params = sfxrParams.clone();

			sfxrParams.setSettingsString("0,,2,,1,0.64,,-0.0799,,0.34,0.54,,,0.58,,,,,1,,,,,0.5");
			sfxTimeCount = new SfxrSynth();
			sfxTimeCount.params = sfxrParams.clone();

			sfxRollOver.cacheSound();
			sfxClick.cacheSound();
		}

		public static function startGenerating(callback:Function):void {
			sfxWalk.cacheMutations(5, callback, 15, 0.02);
			sfxAlert.cacheSound();
		}
	}
}