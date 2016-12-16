/**
 * Created with IntelliJ IDEA.
 * User: Ryc
 * Date: 28.09.13
 * Time: 18:27
 * To change this template use File | Settings | File Templates.
 */
package game.global.pre {
	import flash.display.BitmapData;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.locale.RetrocamelLocaleParserRetrocadeProperties;

	public class PreData {

		[Embed(source='/assets/languages/en.txt', mimeType='application/octet-stream')]
		private static var _lang_en_core_:Class;
		[Embed(source='/assets/languages/pl.txt', mimeType='application/octet-stream')]
		private static var _lang_pl_core_:Class;

		CF::modeRegular{
			[Embed(source='/assets/languages/en_regular.txt', mimeType='application/octet-stream')]
			private static var _lang_en_regular_:Class;
			[Embed(source='/assets/languages/pl_regular.txt', mimeType='application/octet-stream')]
			private static var _lang_pl_regular_:Class;
		}

		CF::modeClassic1{
			[Embed(source='/assets/languages/en_classic_i.txt', mimeType='application/octet-stream')]
			private static var _lang_en_classic_i_:Class;
			[Embed(source='/assets/languages/pl_classic_i.txt', mimeType='application/octet-stream')]
			private static var _lang_pl_classic_i_:Class;
		}

		CF::modeClassic2{
			[Embed(source='/assets/languages/en_classic_ii.txt', mimeType='application/octet-stream')]
			private static var _lang_en_classic_ii_:Class;
			[Embed(source='/assets/languages/pl_classic_ii.txt', mimeType='application/octet-stream')]
			private static var _lang_pl_classic_ii_:Class;
		}

		CF::modeClassic3{
			[Embed(source='/assets/languages/en_classic_iii.txt', mimeType='application/octet-stream')]
			private static var _lang_en_classic_iii_:Class;
			[Embed(source='/assets/languages/pl_classic_iii.txt', mimeType='application/octet-stream')]
			private static var _lang_pl_classic_iii_:Class;
		}

		CF::modeUndervaults{
			[Embed(source='/assets/languages/en_undervaults.txt', mimeType='application/octet-stream')]
			private static var _lang_en_undervaults_:Class;
			[Embed(source='/assets/languages/pl_undervaults.txt', mimeType='application/octet-stream')]
			private static var _lang_pl_undervaults_:Class;
		}

		[Embed(source="/assets/global/font.png", mimeType="image/png")]
		private static var _font_:Class;
		[Embed(source="/assets/global/c64font.png", mimeType="image/png")]
		private static var _font_c64_:Class;

		[Embed(source='/assets/bgs/tooltipSystem.png')]
		private static var _tooltipSystem:Class;
		[Embed(source='/assets/bgs/buttonSystem.png')]
		private static var _buttonBgSystem_:Class;
		[Embed(source='/assets/bgs/windowSystem.png')]
		private static var _windowSystem_:Class;

		public static function loadLanguageFiles():void {
			RetrocamelLocaleParserRetrocadeProperties.parse(_lang_en_core_, 'en');
			RetrocamelLocaleParserRetrocadeProperties.parse(_lang_pl_core_, 'pl');

			var subFileEn:Class;
			var subFilePl:Class;

			switch (CF::modeName) {
				case(C.GAME_MODE_REGULAR):
				CF::modeRegular{
					subFileEn = _lang_en_regular_;
					subFilePl = _lang_pl_regular_;
					break;
				}
				case(C.GAME_MODE_CLASSIC_I):
				CF::modeClassic1{
					subFileEn = _lang_en_classic_i_;
					subFilePl = _lang_pl_classic_i_;
					break;
				}
				case(C.GAME_MODE_CLASSIC_II):
				CF::modeClassic2{
					subFileEn = _lang_en_classic_ii_;
					subFilePl = _lang_pl_classic_ii_;
					break;
				}
				case(C.GAME_MODE_CLASSIC_III):
				CF::modeClassic3{
					subFileEn = _lang_en_classic_iii_;
					subFilePl = _lang_pl_classic_iii_;
					break;
				}
				case(C.GAME_MODE_UNDERVAULTS):
				CF::modeUndervaults{
					subFileEn = _lang_en_undervaults_;
					subFilePl = _lang_pl_undervaults_;
					break;
				}
				default:
					throw new Error("Invalid game mode: " + CF::modeName);
			}

			RetrocamelLocaleParserRetrocadeProperties.parse(subFileEn, 'en');
			RetrocamelLocaleParserRetrocadeProperties.parse(subFilePl, 'pl');
		}

		public static function get tooltipGrid9BitmapData():BitmapData {
			return RetrocamelBitmapManager.getBD(_tooltipSystem);
		}

		public static function get buttonGrid9BitmapData():BitmapData {
			return RetrocamelBitmapManager.getBD(_buttonBgSystem_);
		}

		public static function get windowGrid9BitmapData():BitmapData {
			return RetrocamelBitmapManager.getBD(_windowSystem_);
		}

		public static function get fontClass():Class {
			return _font_;
		}

		public static function get fontC64Class():Class {
			return _font_c64_;
		}

		public static function get fontString():String {
			return String.fromCharCode.apply(null, [
				32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51,
				52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71,
				72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91,
				92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111,
				112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 180, 196, 201, 214, 220,
				223, 225, 226, 227, 228, 231, 233, 234, 237, 243, 245, 246, 250, 252, 261, 263, 281, 321, 322, 324,
				346, 347, 378, 380, 8212, 8217, 8230, 12290, 19968, 19975, 19978, 19979, 19981, 19982, 19988, 20010, 20013, 20026, 20037, 20043,
				20048, 20102, 20110, 20154, 20171, 20174, 20182, 20197, 20204, 20247, 20250, 20294, 20303, 20307, 20316, 20320, 20351, 20415, 20572, 20687,
				20799, 20811, 20837, 20840, 20851, 20854, 20889, 20943, 20986, 20987, 20998, 20999, 21040, 21046, 21069, 21147, 21152, 21160, 21315, 21333,
				21345, 21361, 21364, 21435, 21453, 21464, 21475, 21487, 21491, 21516, 21518, 21521, 21592, 21629, 21644, 21862, 21916, 22235, 22238, 22312,
				22320, 22353, 22359, 22604, 22768, 22810, 22823, 22825, 22833, 22855, 22914, 22987, 23089, 23376, 23383, 23384, 23433, 23436, 23450, 23460,
				23494, 23547, 23558, 23567, 23601, 23613, 23621, 23679, 23707, 24038, 24050, 24102, 24180, 24182, 24207, 24211, 24213, 24320, 24377, 24378,
				24403, 24425, 24448, 24456, 24471, 24494, 24515, 24555, 24597, 24598, 24656, 24685, 24744, 24930, 25103, 25104, 25110, 25151, 25152, 25163,
				25165, 25171, 25214, 25226, 25321, 25351, 25353, 25442, 25481, 25484, 25490, 25509, 25511, 25913, 25928, 25968, 26031, 26032, 26041, 26102,
				26126, 26159, 26174, 26242, 26263, 26368, 26377, 26463, 26465, 26469, 26524, 26631, 26679, 26684, 27036, 27425, 27454, 27809, 27833, 27934,
				28034, 28040, 28145, 28165, 28216, 28304, 28459, 28857, 29289, 29609, 29616, 29983, 29992, 30011, 30028, 30340, 30424, 30456, 30475, 30528,
				30896, 31070, 31163, 31181, 31227, 31243, 31348, 31354, 31505, 32456, 32461, 32463, 32467, 32472, 32487, 32493, 32763, 32773, 32791, 32930,
				33021, 33394, 33756, 33853, 34892, 34987, 35201, 35328, 35768, 35793, 35821, 35831, 35874, 36133, 36164, 36182, 36215, 36335, 36339, 36523,
				36710, 36731, 36807, 36814, 36820, 36825, 36827, 36864, 36873, 36895, 37027, 37096, 37324, 37325, 37327, 38025, 38145, 38190, 38271, 38381,
				38383, 38388, 38500, 38505, 38754, 38899, 39033, 39068, 40657, 40736, 21457, 27491, 31245, 31561, 36830, 36865, 25991, 21734, 22269, 24230,
				25758, 27492, 27861, 35299, 377, 260, 262, 280, 323, 379, 8734, 211, 20027, 20123, 20132, 20219, 20877, 20915, 21033, 21161,
				21449, 21543, 21561, 22418, 22836, 23427, 23545, 23614, 24039, 24049, 24110, 24444, 24452, 24819, 24847, 24935, 25216, 25773, 25910, 25918,
				26080, 26234, 29255, 30097, 30422, 30495, 30742, 32447, 32852, 32988, 33258, 33719, 35206, 35760, 36733, 36793, 36816, 36890, 36947, 37117,
				38062, 38169, 38386, 38480, 38543, 38590, 39029, 65281, 65292, 224, 232, 244, 238, 249, 8226, 9702]);
		}

		public static function get fontC64String():String {
			return " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ĄĆĘŁŃÓŚŻŹąćęłńóśżź";
		}
	}
}
