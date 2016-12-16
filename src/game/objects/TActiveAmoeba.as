package game.objects {
	import game.global.Gfx;
	import game.global.levels.Level;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;

	public class TActiveAmoeba extends TGameObject {
		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 72, 168, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 84, 168, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 96, 168, 12, 12);
			__gfx[3] = __gfx[1];
		}
		private static var __gfx:Array;
		private var _frame:uint = 0;
		private var _frameTimer:uint = 0;
		private var _isEnclosed:Boolean = false;

		public function TActiveAmoeba(x:uint, y:uint) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;

			_gfx = __gfx[0];

			flags = CAN_SURVIVE_PLASMA | CAN_EAT_DIRT;

			addSelf();

			Level.instance.amoebaCount++;

			recalculate();
			recalculateAround();

			addDefault();
		}

		override public function update():void {
			if (!Level.instance.amoebaGrows) {
				_isEnclosed = true;

			} else if (!movementWait && Level.instance.canAmoebaGrow()) {
				grow();
				movementWait = movementSpeed;
			}

			super.update();

			_frameTimer++;
			if (_frameTimer >= (_isEnclosed ? 50 : 20)) {
				_frame = (_frame + 1) % 4;
				_frameTimer = 0;
				_gfx = __gfx[_frame];
			}
		}

		override public function recalculate():void {
			if (extHasFlag(CAN_SURVIVE_PLASMA, -1, 0, false) &&
				extHasFlag(CAN_SURVIVE_PLASMA, 1, 0, false) &&
				extHasFlag(CAN_SURVIVE_PLASMA, 0, -1, false) &&
				extHasFlag(CAN_SURVIVE_PLASMA, 0, 1, false)) {
				if (!_isEnclosed) {
					Level.instance.amoebaEnclosed++;
					_isEnclosed = true;
				}
			} else if (_isEnclosed) {
				Level.instance.amoebaEnclosed--;
				_isEnclosed = false;
			}
		}

		override public function kill(silent:Boolean = false):void {
			super.kill(silent);

			if (_isEnclosed) {
				Level.instance.amoebaEnclosed--;
			}

			Level.instance.amoebaCount--;

			recalculateAround();
		}

		override public function touched(object:TGameObject, tx:int, ty:int):Boolean {
			if (object.hasFlag(CAN_DIE_WHEN_NEAR_PLASMA)) {
				object.kill();
				return true;
			}

			return false;
		}

		private function grow():Boolean {
			var order:Array = [];
			order[0] = Math.random() * 4 | 0;
			order[1] = (order[0] + 1) % 4;
			order[2] = (order[1] + 1) % 4;
			order[3] = (order[2] + 1) % 4;

			var tx:int;
			var ty:int;

			var i:uint = Math.random() * 4 | 0;
			var j:uint = i;

			do {
				tx = i == 2 ? -1 : i == 3 ? 1 : 0;
				ty = i == 0 ? -1 : i == 1 ? 1 : 0;

				if (!extHasFlag(CAN_SURVIVE_PLASMA, tx, ty, false)) {
					extKill(tx, ty);

					if (!getTile(x + tx * 12, y + ty * 12)) {
						new TActiveAmoeba(x + tx * 12, y + ty * 12);
					}

					Level.instance.amoebaGrew();

					recalculate();

					RetrocamelEventsQueue.add(C.EVENT_AMOEBA_GREW);

					return true;
				}

				i = (i + 1) % 4;
			} while (i != j); // I increased by 1 and modulo-wrapped at 4 is not equal to j

			if (!_isEnclosed) {
				Level.instance.amoebaEnclosed++;
				_isEnclosed = true;
			}

			return false;
		}

		/*
		 override public function saveObject():String{
		 return super.saveObject() + "&" + _frame + "&" + _frameTimer + "&" + _isEnclosed;
		 }

		 public static function load(data:Array):void{
		 var o:TActiveAmoeba = new TActiveAmoeba(data[0], data[1]);
		 o.movementWait = data[2];
		 o._frame = data[3];
		 o._frameTimer = data[4];
		 o._isEnclosed = data[5];
		 }*/
	}
}