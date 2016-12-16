/**
 * Created with IntelliJ IDEA.
 * User: Ryc
 * Date: 28.09.13
 * Time: 17:28
 * To change this template use File | Settings | File Templates.
 */
package game.global.levels {
	import flash.utils.ByteArray;

	import net.retrocade.functions.printf;

	public class LevelList {
		CF::modeRegular{
			[Embed(source='/assets/levels/regular/001.oel', mimeType="application/octet-stream")]
			private static var _level_regular_1_:Class;
			[Embed(source='/assets/levels/regular/002.oel', mimeType="application/octet-stream")]
			private static var _level_regular_2_:Class;
			[Embed(source='/assets/levels/regular/003.oel', mimeType="application/octet-stream")]
			private static var _level_regular_3_:Class;
			[Embed(source='/assets/levels/regular/004.oel', mimeType="application/octet-stream")]
			private static var _level_regular_4_:Class;
			[Embed(source='/assets/levels/regular/005.oel', mimeType="application/octet-stream")]
			private static var _level_regular_5_:Class;
			[Embed(source='/assets/levels/regular/006.oel', mimeType="application/octet-stream")]
			private static var _level_regular_6_:Class;
			[Embed(source='/assets/levels/regular/007.oel', mimeType="application/octet-stream")]
			private static var _level_regular_7_:Class;
			[Embed(source='/assets/levels/regular/008.oel', mimeType="application/octet-stream")]
			private static var _level_regular_8_:Class;
			[Embed(source='/assets/levels/regular/009.oel', mimeType="application/octet-stream")]
			private static var _level_regular_9_:Class;
			[Embed(source='/assets/levels/regular/010.oel', mimeType="application/octet-stream")]
			private static var _level_regular_10_:Class;
			[Embed(source='/assets/levels/regular/011.oel', mimeType="application/octet-stream")]
			private static var _level_regular_11_:Class;
			[Embed(source='/assets/levels/regular/012.oel', mimeType="application/octet-stream")]
			private static var _level_regular_12_:Class;
			[Embed(source='/assets/levels/regular/013.oel', mimeType="application/octet-stream")]
			private static var _level_regular_13_:Class;
			[Embed(source='/assets/levels/regular/014.oel', mimeType="application/octet-stream")]
			private static var _level_regular_14_:Class;
			[Embed(source='/assets/levels/regular/015.oel', mimeType="application/octet-stream")]
			private static var _level_regular_15_:Class;
			[Embed(source='/assets/levels/regular/016.oel', mimeType="application/octet-stream")]
			private static var _level_regular_16_:Class;
			[Embed(source='/assets/levels/regular/017.oel', mimeType="application/octet-stream")]
			private static var _level_regular_17_:Class;
			[Embed(source='/assets/levels/regular/018.oel', mimeType="application/octet-stream")]
			private static var _level_regular_18_:Class;
			[Embed(source='/assets/levels/regular/019.oel', mimeType="application/octet-stream")]
			private static var _level_regular_19_:Class;
			[Embed(source='/assets/levels/regular/020.oel', mimeType="application/octet-stream")]
			private static var _level_regular_20_:Class;
			[Embed(source='/assets/levels/regular/021.oel', mimeType="application/octet-stream")]
			private static var _level_regular_21_:Class;
			[Embed(source='/assets/levels/regular/022.oel', mimeType="application/octet-stream")]
			private static var _level_regular_22_:Class;
			[Embed(source='/assets/levels/regular/023.oel', mimeType="application/octet-stream")]
			private static var _level_regular_23_:Class;
			[Embed(source='/assets/levels/regular/024.oel', mimeType="application/octet-stream")]
			private static var _level_regular_24_:Class
		}

		CF::modeClassic1{
			[Embed(source='/assets/levels/classic_i/001.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_1_:Class;
			[Embed(source='/assets/levels/classic_i/002.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_2_:Class;
			[Embed(source='/assets/levels/classic_i/003.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_3_:Class;
			[Embed(source='/assets/levels/classic_i/004.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_4_:Class;
			[Embed(source='/assets/levels/classic_i/005.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_5_:Class;
			[Embed(source='/assets/levels/classic_i/006.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_6_:Class;
			[Embed(source='/assets/levels/classic_i/007.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_7_:Class;
			[Embed(source='/assets/levels/classic_i/008.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_8_:Class;
			[Embed(source='/assets/levels/classic_i/009.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_9_:Class;
			[Embed(source='/assets/levels/classic_i/010.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_10_:Class;
			[Embed(source='/assets/levels/classic_i/011.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_11_:Class;
			[Embed(source='/assets/levels/classic_i/012.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_12_:Class;
			[Embed(source='/assets/levels/classic_i/013.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_13_:Class;
			[Embed(source='/assets/levels/classic_i/014.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_14_:Class;
			[Embed(source='/assets/levels/classic_i/015.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_15_:Class;
			[Embed(source='/assets/levels/classic_i/016.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_16_:Class;
			[Embed(source='/assets/levels/classic_i/017.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_17_:Class;
			[Embed(source='/assets/levels/classic_i/018.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_18_:Class;
			[Embed(source='/assets/levels/classic_i/019.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_19_:Class;
			[Embed(source='/assets/levels/classic_i/020.oel', mimeType="application/octet-stream")]
			private static var _level_classic_i_20_:Class;
		}

		CF::modeClassic2{
			[Embed(source='/assets/levels/classic_ii/001.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_1_:Class;
			[Embed(source='/assets/levels/classic_ii/002.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_2_:Class;
			[Embed(source='/assets/levels/classic_ii/003.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_3_:Class;
			[Embed(source='/assets/levels/classic_ii/004.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_4_:Class;
			[Embed(source='/assets/levels/classic_ii/005.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_5_:Class;
			[Embed(source='/assets/levels/classic_ii/006.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_6_:Class;
			[Embed(source='/assets/levels/classic_ii/007.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_7_:Class;
			[Embed(source='/assets/levels/classic_ii/008.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_8_:Class;
			[Embed(source='/assets/levels/classic_ii/009.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_9_:Class;
			[Embed(source='/assets/levels/classic_ii/010.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_10_:Class;
			[Embed(source='/assets/levels/classic_ii/011.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_11_:Class;
			[Embed(source='/assets/levels/classic_ii/012.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_12_:Class;
			[Embed(source='/assets/levels/classic_ii/013.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_13_:Class;
			[Embed(source='/assets/levels/classic_ii/014.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_14_:Class;
			[Embed(source='/assets/levels/classic_ii/015.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_15_:Class;
			[Embed(source='/assets/levels/classic_ii/016.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_16_:Class;
			[Embed(source='/assets/levels/classic_ii/017.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_17_:Class;
			[Embed(source='/assets/levels/classic_ii/018.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_18_:Class;
			[Embed(source='/assets/levels/classic_ii/019.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_19_:Class;
			[Embed(source='/assets/levels/classic_ii/020.oel', mimeType="application/octet-stream")]
			private static var _level_classic_ii_20_:Class;
		}

		CF::modeClassic3{
			[Embed(source='/assets/levels/classic_iii/001.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_1_:Class;
			[Embed(source='/assets/levels/classic_iii/002.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_2_:Class;
			[Embed(source='/assets/levels/classic_iii/003.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_3_:Class;
			[Embed(source='/assets/levels/classic_iii/004.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_4_:Class;
			[Embed(source='/assets/levels/classic_iii/005.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_5_:Class;
			[Embed(source='/assets/levels/classic_iii/006.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_6_:Class;
			[Embed(source='/assets/levels/classic_iii/007.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_7_:Class;
			[Embed(source='/assets/levels/classic_iii/008.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_8_:Class;
			[Embed(source='/assets/levels/classic_iii/009.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_9_:Class;
			[Embed(source='/assets/levels/classic_iii/010.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_10_:Class;
			[Embed(source='/assets/levels/classic_iii/011.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_11_:Class;
			[Embed(source='/assets/levels/classic_iii/012.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_12_:Class;
			[Embed(source='/assets/levels/classic_iii/013.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_13_:Class;
			[Embed(source='/assets/levels/classic_iii/014.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_14_:Class;
			[Embed(source='/assets/levels/classic_iii/015.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_15_:Class;
			[Embed(source='/assets/levels/classic_iii/016.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_16_:Class;
			[Embed(source='/assets/levels/classic_iii/017.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_17_:Class;
			[Embed(source='/assets/levels/classic_iii/018.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_18_:Class;
			[Embed(source='/assets/levels/classic_iii/019.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_19_:Class;
			[Embed(source='/assets/levels/classic_iii/020.oel', mimeType="application/octet-stream")]
			private static var _level_classic_iii_20_:Class;
		}

		CF::modeUndervaults{
			[Embed(source='/assets/levels/undervaults/001.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_1_:Class;
			[Embed(source='/assets/levels/undervaults/002.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_2_:Class;
			[Embed(source='/assets/levels/undervaults/003.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_3_:Class;
			[Embed(source='/assets/levels/undervaults/004.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_4_:Class;
			[Embed(source='/assets/levels/undervaults/005.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_5_:Class;
			[Embed(source='/assets/levels/undervaults/006.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_6_:Class;
			[Embed(source='/assets/levels/undervaults/007.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_7_:Class;
			[Embed(source='/assets/levels/undervaults/008.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_8_:Class;
			[Embed(source='/assets/levels/undervaults/009.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_9_:Class;
			[Embed(source='/assets/levels/undervaults/010.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_10_:Class;
			[Embed(source='/assets/levels/undervaults/011.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_11_:Class;
			[Embed(source='/assets/levels/undervaults/012.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_12_:Class;
			[Embed(source='/assets/levels/undervaults/013.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_13_:Class;
			[Embed(source='/assets/levels/undervaults/014.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_14_:Class;
			[Embed(source='/assets/levels/undervaults/015.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_15_:Class;
			[Embed(source='/assets/levels/undervaults/016.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_16_:Class;
			[Embed(source='/assets/levels/undervaults/017.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_17_:Class;
			[Embed(source='/assets/levels/undervaults/018.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_18_:Class;
			[Embed(source='/assets/levels/undervaults/019.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_19_:Class;
			[Embed(source='/assets/levels/undervaults/020.oel', mimeType="application/octet-stream")]
			private static var _level_undervaults_20_:Class;
		}

		public static function levelCount():uint {
			switch (CF::modeName) {
				case(C.GAME_MODE_REGULAR):
					return 24;
				default:
					return 20;
			}
		}

		public static function getLevelXml(levelIndex:int):XML {
			var levelClass:Class = getLevelClass(levelIndex);
			var levelByteArray:ByteArray = new levelClass;
			levelByteArray.position = 0;

			return new XML(levelByteArray.readUTFBytes(levelByteArray.length));
		}

		private static function getLevelClass(levelIndex:int):Class {
			var levelName:String = getLevelName(levelIndex);

			if (LevelList[levelName] && LevelList[levelName] is Class) {
				return LevelList[levelName] as Class;
			} else {
				throw new ArgumentError("No level found for name: " + levelName);
			}
		}

		private static function getLevelName(levelIndex:int):String {
			return printf(
				"_level_%%_%%_",
				levelsetName,
				levelIndex.toString()
			);
		}

		private static function get levelsetName():String {
			switch (CF::modeName) {
				case(C.GAME_MODE_REGULAR):
					return "regular";

				case(C.GAME_MODE_CLASSIC_I):
					return "classic_i";

				case(C.GAME_MODE_CLASSIC_II):
					return "classic_ii";

				case(C.GAME_MODE_CLASSIC_III):
					return "classic_iii";

				case(C.GAME_MODE_UNDERVAULTS):
					return "undervaults";

				default:
					throw new Error("Invalid game mode");
			}
		}
	}
}
