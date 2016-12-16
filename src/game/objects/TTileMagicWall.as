package game.objects {
	import game.global.Gfx;
	import game.global.levels.Level;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;

	public class TTileMagicWall extends TGameObject {
		public static var __gfx:Array;

		{
			__gfx = [];

			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 0, 60, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 12, 60, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 60, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 36, 60, 12, 12);
			__gfx[4] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 48, 60, 12, 12);
			__gfx[5] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 60, 60, 12, 12);
			__gfx[6] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 72, 60, 12, 12);
			__gfx[7] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 84, 60, 12, 12);
			__gfx[8] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 96, 60, 12, 12);
			__gfx[9] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 108, 60, 12, 12);
			__gfx[10] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 120, 60, 12, 12);
			__gfx[11] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 132, 60, 12, 12);

			__gfx[12] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 0, 72, 12, 12);
			__gfx[13] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 12, 72, 12, 12);
			__gfx[14] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 72, 12, 12);
			__gfx[15] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 36, 72, 12, 12);
			__gfx[16] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 48, 72, 12, 12);
			__gfx[17] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 60, 72, 12, 12);
			__gfx[18] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 72, 72, 12, 12);
			__gfx[19] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 84, 72, 12, 12);
			__gfx[20] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 96, 72, 12, 12);
			__gfx[21] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 108, 72, 12, 12);
			__gfx[22] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 120, 72, 12, 12);
			__gfx[23] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 132, 72, 12, 12);
		}


		public static var STATE_WAIT:uint = 0;
		public static var STATE_EATING:uint = 1;

		private var _steel:Boolean;

		private var _contained:TGameObject;
		private var _state:uint = 0;
		private var _leaving:TGameObject;
		private var _leavingWaiter:uint = 0;

		private var _animFrame:uint = 0;
		private var _animTimer:uint = 0;

		public function TTileMagicWall(x:uint, y:uint, steel:Boolean) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;
			_steel = steel;

			if (_steel) {
				flags = CAN_SURVIVE_EXPLOSION | CAN_SURVIVE_PLASMA;
			}
			else {
				flags = CAN_SURVIVE_PLASMA;
			}

			addSelf();
			addDefault();

			_gfx = __gfx[0];
		}

		override public function update():void {
			super.update();

			if (!movementWait) {
				if (_state == STATE_EATING) {
					makeConverted();

					_state = STATE_WAIT;
				}
			}

			if (_contained && _contained.movementWait) {
				_contained.movementWait--;
			}

			if (_leaving) {
				if (!_leaving.isAlive) {
					_leaving = null;
				}

				else {
					if (_leaving.movementWait == 0 && _leaving.y != y) {
						_leaving.isVisible = true;
						_leaving = null;
					} else if (_leavingWaiter-- == 0 && _leaving.y == y) {
						_leaving.kill(true);
						_leaving = null;
					}
				}
			}

			if (Level.instance.magicWallActive) {
				if (++_animTimer == 2) {
					_animTimer = 0;
					_animFrame = (_animFrame + 1) % 12;
					_gfx = __gfx[_animFrame + (_steel ? 12 : 0)];
				}
			} else if (_animFrame != 0) {
				_animFrame = 0;
				_gfx = __gfx[_animFrame + (_steel ? 12 : 0)];
			}
		}

		override public function draw():void {
			if (_contained) {
				_contained.draw();
			}

			if (_leaving) {
				_leaving.isVisible = true;
				_leaving.draw();
				_leaving.isVisible = false;
			}

			super.draw();
		}

		private function makeConverted():void {
			if (_leaving) {
				_contained.kill(true);
				_contained = null;
				return;
			}

			if (_contained is TActiveBoulder) {
				_leaving = new TActiveDiamond(x, y);
			}
			else {
				_leaving = new TActiveBoulder(x, y);
			}

			_leaving.isVisible = false;

			_leavingWaiter = 12;

			_contained = null;
		}

		override public function canWalkInto(object:TGameObject, tx:int, ty:int):Boolean {
			if (object.isFalling && (object is TActiveBoulder || object is TActiveDiamond)) {
				if (Level.instance.magicWallCanActivate) {
					RetrocamelEventsQueue.add(C.EVENT_MAGIC_WALL_ACTIVATED);
				}
				else if (!Level.instance.magicWallActive) {
					return false;
				}

				_contained = object;
				_contained.kill(true);

				_contained.movementWait = _contained.movementSpeed;
				_contained.prevX = _contained.x;
				_contained.prevY = _contained.y;
				_contained.x = x;
				_contained.y = y;

				_state = STATE_EATING;

				movementWait = movementSpeed;
			}

			return false;
		}
	}
}