/**
 * Created with IntelliJ IDEA.
 * User: Ryc
 * Date: 28.09.13
 * Time: 17:11
 * To change this template use File | Settings | File Templates.
 */
package game.global {
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class Gfx {

		[Embed(source="/../src.assets/tiles/tileset.png", mimeType="image/png")]
		private static var _tileset_:Class;
		[Embed(source='/../src.assets/bgs/backgroundTitleScreen.png', mimeType="image/png")]
		private static var _background_titleScreen_:Class;
		[Embed(source='/../src.assets/bgs/backgroundIngame.png', mimeType="image/png")]
		private static var _background_ingame_:Class;
		[Embed(source="/../src.assets/bgs/logo_regular.png")]
		private static var _logo_regular_:Class;
		[Embed(source="/../src.assets/bgs/logo_classic_i.png")]
		private static var _logo_classic_i_:Class;
		[Embed(source="/../src.assets/bgs/logo_classic_ii.png")]
		private static var _logo_classic_ii_:Class;
		[Embed(source="/../src.assets/bgs/logo_classic_iii.png")]
		private static var _logo_classic_iii_:Class;
		[Embed(source="/../src.assets/bgs/logo_undervaults.png")]
		private static var _logo_undervaults_:Class;

		public static function get tilesetClass():Class {
			return _tileset_;
		}

		public static function get logoBitmap():Bitmap {
			switch (CF::modeName) {
				case(C.GAME_MODE_REGULAR):
				CF::modeRegular{
					return new _logo_regular_;
				}

				case(C.GAME_MODE_CLASSIC_I):
				CF::modeClassic1{
					return new _logo_classic_i_;
				}

				case(C.GAME_MODE_CLASSIC_II):
				CF::modeClassic2{
					return new _logo_classic_ii_;
				}

				case(C.GAME_MODE_CLASSIC_III):
				CF::modeClassic3{
					return new _logo_classic_iii_;
				}

				case(C.GAME_MODE_UNDERVAULTS):
				CF::modeUndervaults{
					return new _logo_undervaults_;
				}

				default:
					throw new Error("No logo found for current game mode: " + CF::modeName);
			}
		}

		public static function get backgroundTitleScreenBitmapData():BitmapData {
			return RetrocamelBitmapManager.getBD(_background_titleScreen_);
		}

		public static function get backgroundIngameBitmapData():BitmapData {
			return RetrocamelBitmapManager.getBD(_background_ingame_);
		}
	}
}
