package game.windows {
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelWindowFlash;
	import net.retrocade.retrocamel.locale._;
	import net.retrocade.utils.UtilsGraphic;

	public class TWinRedefiningKey extends RetrocamelWindowFlash {
		private static var _instance:TWinRedefiningKey = new TWinRedefiningKey();
		public static function get instance():TWinRedefiningKey {
			return _instance;
		}

		private var _text1:RetrocamelBitmapText;
		private var _text2:RetrocamelBitmapText;
		private var _text3:RetrocamelBitmapText;

		public function TWinRedefiningKey() {
			UtilsGraphic.draw(this).rectFill(0, 0, S().gameWidth, S().gameHeight, 0, 0.85);

			_text1 = new RetrocamelBitmapText();
			_text2 = new RetrocamelBitmapText();
			_text3 = new RetrocamelBitmapText();

			_text1.addShadow();
			_text2.addShadow();
			_text3.addShadow();

			_text1.setScale(2);
			_text2.setScale(1);
			_text3.setScale(2);

			addChild(_text1);
			addChild(_text2);
			addChild(_text3);

			_text1.text = _("redefining");
			_text3.text = _("hitNew");
		}

		public function set(key:String):void {
			_text2.text = _(key + "Desc");

			_text2.positionToCenterScreen();
			_text2.positionToMiddleScreen();

			_text1.positionToCenterScreen();
			_text3.positionToCenterScreen();

			_text1.y = _text2.y - _text1.height - 8;
			_text3.y = _text2.y + _text2.height + 8;

			show();
		}
	}
}