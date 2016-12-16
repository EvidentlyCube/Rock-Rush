package game.objects {
	import game.global.Gfx;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;

	public class TActiveBomb extends TGameObject {
		{
			__gfx = [];

			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 168, 144, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 180, 144, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 192, 144, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 204, 144, 12, 12);
			__gfx[4] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 216, 144, 12, 12);

		}
		private static var __gfx:Array;
		private var _fallingFor:uint = 0;

		public function TActiveBomb(x:uint, y:uint) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;

			flags = CAN_KILL_BY_FALLING | CAN_SURVIVE_PLASMA | CAN_OTHERS_ROLL_FROM | CAN_FALL;

			addSelf();

			_gfx = __gfx[0];

			addDefault();
		}

		override public function update():void {
			if (!movementWait) {
				if (move(0, 1)) {
					if (isFalling) {
						_fallingFor++;
					}

					isFalling = true;

				} else {
					if (isFalling) {
						kill(false);
						return;
					}

					_fallingFor = 0;
					isFalling = false;
					if (extHasFlag(CAN_OTHERS_ROLL_FROM, 0, 1, false)) {
						if (extCanWalkInto(-1, 0, -1) && extCanWalkInto(-1, 1, 0, 1) && !extHasFlag(CAN_FALL, -1, -1, false)) {
							move(-1, 0)

						} else if (extCanWalkInto(1, 0, 1) && extCanWalkInto(1, 1, 0, 1) && !extHasFlag(CAN_FALL, 1, -1, false)) {
							move(1, 0);
						}
					}
				}
			}

			_gfx = __gfx[Math.ceil(movementWait * 4 / movementSpeed)];

			super.update();

			if (!isAlive) {
				kill();
			}
		}

		override public function kill(silent:Boolean = false):void {
			if (!silent && isAlive) {
				super.kill(false);

				setCloser();
				explodeNine();
			} else {
				super.kill(false);
			}
		}

		override public function setBack():void {
			super.setBack();
			if (_fallingFor == 0) {
				isFalling = false;
			}
		}

		override public function canWalkInto(object:TGameObject, tx:int, ty:int):Boolean {
			if (!movementWait && tx && object.hasFlag(CAN_PUSH_ROCKS) && !extCanWalkInto(0, 1, 0, 1) && !isFalling) {
				if (move(tx, 0)) {
					RetrocamelEventsQueue.add(C.EVENT_BOULDER_PUSHED);
					removeSelfFrom(prevX, prevY);
					return true;
				}
			}

			if (object is TActiveBoulder && ty == 1 && object.isFalling) {
				kill(false);
				return false;
			}

			return false;

		}

		/*
		 override public function saveObject():String{
		 return super.saveObject() + "&" + isFalling + "&" + prevX + "&" + prevY;
		 }

		 public static function load(data:Array):void{
		 var o:TActiveBomb = new TActiveBomb(data[0], data[1]);
		 o.movementWait = data[2];
		 o.isFalling = data[4];
		 o.prevX = data[5];
		 o.prevY = data[6];

		 if (o._x != o.prevX || o._y != o.prevY)
		 Level.instance.level.set(o.prevX, o.prevY, OBSTRUANT);
		 }*/
	}
}