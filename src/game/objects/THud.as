package game.objects {
	import flash.display.Sprite;

	import game.global.Game;
	import game.global.Score;
	import game.global.levels.LevelManager;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableObject;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashBlit;
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;
	import net.retrocade.retrocamel.locale._;

	/**
	 * ...
	 * @author
	 */
	public class THud extends RetrocamelUpdatableObject {
		[Embed(source="/assets/bgs/hud.png")]
		public static var _bg_:Class;
		private static var _instance:THud = new THud;

		public static function get instance():THud {
			return _instance;
		}

		private var diamonds:RetrocamelBitmapText;
		private var keyText1:RetrocamelBitmapText;
		private var keyText2:RetrocamelBitmapText;
		private var keyText3:RetrocamelBitmapText;
		private var keyText4:RetrocamelBitmapText;
		private var _layer:RetrocamelLayerFlashBlit;
		private var gfx:Sprite;
		private var time:RetrocamelBitmapText;
		private var score:RetrocamelBitmapText;

		public function THud() {
			gfx = new Sprite();

			gfx.addChild(RetrocamelBitmapManager.getB(_bg_, false));

			diamonds = new RetrocamelBitmapText();
			keyText1 = new RetrocamelBitmapText();
			keyText2 = new RetrocamelBitmapText();
			keyText3 = new RetrocamelBitmapText();
			keyText4 = new RetrocamelBitmapText();
			time = new RetrocamelBitmapText();
			score = new RetrocamelBitmapText();

			gfx.addChild(diamonds);
			gfx.addChild(keyText1);
			gfx.addChild(keyText2);
			gfx.addChild(keyText3);
			gfx.addChild(keyText4);
			gfx.addChild(time);
			gfx.addChild(score);

			gfx.scaleX = gfx.scaleY = 2;

			diamonds.y = 5;
			keyText1.y = 1;
			keyText2.y = 9;
			keyText3.y = 1;
			keyText4.y = 9;
			time.y = 5;
			score.y = 5;

			diamonds.x = 22;
			keyText1.x = 72;
			keyText2.x = 72;
			keyText3.x = 100;
			keyText4.x = 100;
			time.x = 140;
			score.x = 180;

			diamonds.addShadow();
			keyText1.addShadow();
			keyText2.addShadow();
			keyText3.addShadow();
			keyText4.addShadow();
			time.addShadow();
			score.addShadow();
		}

		override public function update():void {
			if (RetrocamelEventsQueue.occured(C.EVENT_DIAMOND_COLLECTED)) {
				diamonds.text = Score.diamondsGot + "/" + Score.diamondsToGet;
			}

			if (RetrocamelEventsQueue.occured(C.EVENT_EXIT_OPENED)) {
				diamonds.color = 0xAAFFAA;
			}

			if (RetrocamelEventsQueue.occuredArray([C.EVENT_KEY_COLLECTED, C.EVENT_KEY_USED])) {
				keyText1.text = (Score.keys[0] == -1 ? _("infinite") : "x" + Score.keys[0]);
				keyText2.text = (Score.keys[1] == -1 ? _("infinite") : "x" + Score.keys[1]);
				keyText3.text = (Score.keys[2] == -1 ? _("infinite") : "x" + Score.keys[2]);
				keyText4.text = (Score.keys[3] == -1 ? _("infinite") : "x" + Score.keys[3]);
			}

			time.text = ((Score.time / 60) | 0).toString();

			score.text = Score.score + " (" + Score.getScore(LevelManager.currentRoom) + ") " + _("Points");
			score.x = S().levelWidth - 6 - score.width;
		}

		public function setDefaults():void {
			diamonds.text = Score.diamondsGot + "/" + Score.diamondsToGet;

			diamonds.color = 0xFFAAAA;

			keyText1.text = (Score.keys[0] == -1 ? _("infinite") : "x" + Score.keys[0]);
			keyText2.text = (Score.keys[1] == -1 ? _("infinite") : "x" + Score.keys[1]);
			keyText3.text = (Score.keys[2] == -1 ? _("infinite") : "x" + Score.keys[2]);
			keyText4.text = (Score.keys[3] == -1 ? _("infinite") : "x" + Score.keys[3]);
		}

		public function hookTo(layer:RetrocamelLayerFlashBlit):void {
			RetrocamelCore.groupAfter.add(this);
			_layer = layer;

			Game.lMain.add(gfx);

			gfx.y = S().gameHeight - gfx.height;
		}

		public function unhook():void {
			RetrocamelCore.groupAfter.nullify(this);
			Game.lMain.clear();
		}
	}
}