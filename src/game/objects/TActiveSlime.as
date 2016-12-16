package game.objects {
	import game.global.Gfx;
	import game.global.levels.Level;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;

	public class TActiveSlime extends TGameObject {
		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 108, 168, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 120, 168, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 132, 168, 12, 12);
			__gfx[3] = __gfx[1];
		}

		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 108, 168, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 120, 168, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 132, 168, 12, 12);
			__gfx[3] = __gfx[1];
		}
		private static var __gfx:Array;
		private var _frame:uint = 0;
		private var _frameTimer:uint = 0;
		private var _lastAbove:TGameObject;
		private var _fallTimer:uint;

		public function TActiveSlime(x:uint, y:uint) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;

			_gfx = __gfx[0];

			flags = CAN_SURVIVE_PLASMA;

			addSelf();

			addDefault();
		}

		override public function update():void {
			if (extGetTile(0, -1) != _lastAbove || !canPushItem()) {
				_lastAbove = extGetTile(0, -1);
				_fallTimer = 0;

				if (_lastAbove && _lastAbove.movementWait > 0) {
					_lastAbove = null;
				}
			}

			if (_lastAbove != null && _lastAbove.hasFlag(CAN_BE_SUCKED_BY_PLASMA)) {
				if (Level.instance.slimeRandom) {
					if (Math.random() * Level.instance.slimeRate < 1) {
						pushItem();
					}
				} else {
					_fallTimer++;
					if (_fallTimer >= Level.instance.slimeRate) {
						pushItem();
					}
				}
			}

			super.update();

			_frameTimer++;
			if (_frameTimer >= 20) {
				_frame = (_frame + 1) % 4;
				_frameTimer = 0;
				_gfx = __gfx[_frame];
			}
		}

		private function canPushItem():Boolean {
			if (!_lastAbove) {
				return true;
			}

			var tile:TGameObject = extGetTile(0, 1);
			if (tile) {
				return tile.canWalkInto(_lastAbove, 0, 1);
			}

			return true;
		}

		private function pushItem():void {
			if (_lastAbove.x != _lastAbove.prevX) {
				return;
			}

			if (_lastAbove.isFalling) {
				return;
			}

			if (!_lastAbove.isAlive) {
				_lastAbove = null;
				return;
			}
			_lastAbove.move(0, 2);
			_lastAbove = null;

			RetrocamelEventsQueue.add(C.EVENT_SLIME_PASSED);
		}
	}
} 