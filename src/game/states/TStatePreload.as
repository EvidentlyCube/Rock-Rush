package game.states {

	import flash.display.Sprite;

	import game.global.Preloader;
	import game.global.pre.Pre;
	import game.standalone.rAnimC64;

	import net.retrocade.retrocamel.components.RetrocamelStateBase;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeScreen;

	public class TStatePreload extends RetrocamelStateBase {
		public static var txt:RetrocamelBitmapText;
		public static var txtTimer:RetrocamelBitmapText;
		public static var parent:Sprite = new Sprite;
		public var c64:rAnimC64;
		public var preloadFinished:Function;

		public function TStatePreload(preloadFinished:Function) {
			super();

			this.preloadFinished = preloadFinished;

			txt = new RetrocamelBitmapText("", Pre.c64font);
			txt.letterSpace = 0;
			txt.lineSpace = 0;
			txt.color = 0xA5A5FF;
			switch (CF::modeName) {
				case(C.GAME_MODE_REGULAR):
					txt.text = "\n   *** RETROCADE 64 ***\n\n 64K RAM SYSTEM   0 BYTES\nREADY.\nLOAD ROCK RUSH\nSEARCHING FOR ROCK RUSH...\nLOADING\n";
					break;
				case(C.GAME_MODE_CLASSIC_I):
					txt.text = "\n   *** RETROCADE 64 ***\n\n 64K RAM SYSTEM   0 BYTES\nREADY.\nLOAD ROCK RUSH CLASSIC I\nSEARCHING FOR ROCK RUSH...\nLOADING\n";
					break;
				case(C.GAME_MODE_CLASSIC_II):
					txt.text = "\n   *** RETROCADE 64 ***\n\n 64K RAM SYSTEM   0 BYTES\nREADY.\nLOAD ROCK RUSH CLASSIC II\nSEARCHING FOR ROCK RUSH...\nLOADING\n";
					break;
				case(C.GAME_MODE_CLASSIC_III):
					txt.text = "\n   *** RETROCADE 64 ***\n\n 64K RAM SYSTEM   0 BYTES\nREADY.\nLOAD ROCK RUSH CLASSIC III\nSEARCHING FOR ROCK RUSH...\nLOADING\n";
					break;
				case(C.GAME_MODE_UNDERVAULTS):
					txt.text = "\n   *** RETROCADE 64 ***\n\n 64K RAM SYSTEM   0 BYTES\nREADY.\nLOAD ROCK RUSH UNDERVAULTS\nSEARCHING FOR ROCK RUSH...\nLOADING\n";
					break;
			}

			txt.text += "\n\n\n\n\n\n\n\n\nF11 - Toggle Full-screen\nF4 - Toggle scaling mode\nM, S - Toggle music/sfx";

			txt.x = 0;
			txt.y = 0;

			txtTimer = new RetrocamelBitmapText("", Pre.c64font);
			txtTimer.letterSpace = 0;
			txtTimer.lineSpace = 0;
			txtTimer.color = 0xA5A5FF;
			txtTimer.text = "0.00%";
			txtTimer.x = 0;
			txtTimer.y = 72;

			//desc.x = (S.SIZE_GAME_WIDTH- desc.width) / 2;
			//desc.y = 180;

			c64 = new rAnimC64(0x4242E7, 56, 56, 56, 56, 2);

			c64.add(0xFFFFFF, 2, 4, 1);
			c64.add(0xD0DC71, 2, 4, 1);
			c64.add(0xACEA88, 2, 4, 1);
			c64.add(0x7ABFC7, 2, 4, 1);

			c64.add(0xABABAB, 2, 4, 1);
			c64.add(0xBB776D, 2, 4, 1);
			c64.add(0x68A941, 2, 4, 1);
			c64.add(0x808080, 2, 4, 1);

			c64.add(0x7C70DA, 2, 4, 1);
			c64.add(0x905F25, 2, 4, 1);
			c64.add(0x8A46AE, 2, 4, 1);
			c64.add(0x555555, 2, 4, 1);

			c64.add(0x894036, 2, 4, 1);
			c64.add(0x5C4700, 2, 4, 1);
			c64.add(0x3E31A2, 2, 4, 1);
			c64.add(0x000000, 2, 4, 1);

			parent.addChild(txt);
			parent.addChild(txtTimer);

			parent.x = 56;
			parent.y = 56;
			parent.scaleX = parent.scaleY = 2;
		}

		override public function update():void {
			c64.update();

			txtTimer.text = Preloader.percent.toFixed(2) + "%";

			if (Preloader.percent >= 100) {
				if (preloadFinished != null) {
					preloadFinished();
					preloadFinished = null;
				}
			}
		}

		override public function create():void {
			Preloader.loaderLayer.add(c64.gfx);
			Preloader.loaderLayer.add(parent);
			RetrocamelEffectFadeScreen.makeIn().duration(500).run();
		}

		override public function destroy():void {

		}
	}
}