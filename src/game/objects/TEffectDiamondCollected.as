package game.objects {
	import game.global.Game;
	import game.global.Gfx;
	import game.global.levels.Level;

	import net.retrocade.retrocamel.components.RetrocamelDisplayObject;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class TEffectDiamondCollected extends RetrocamelDisplayObject {
		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 0, 192, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 12, 192, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 192, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 36, 192, 12, 12);
			__gfx[4] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 48, 192, 12, 12);
		}
		private static var __gfx:Array;
		private var _frame:uint = 0;
		private var _frameTimer:uint = 0;

		public function TEffectDiamondCollected(x:uint, y:uint) {
			_x = x;
			_y = y;

			_gfx = __gfx[0];

			Level.instance.effects.add(this);
		}

		override public function update():void {
			_frameTimer++;
			if (_frameTimer == 2) {
				_frameTimer = 0;
				_frame++;

				if (_frame == 5) {
					Level.instance.effects.nullify(this);
					return;
				}

				_gfx = __gfx[_frame];
			}

			Game.lGame.draw(_gfx, x, y);
		}
	}
}