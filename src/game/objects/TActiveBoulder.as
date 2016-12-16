package game.objects {
	import game.global.Gfx;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;

	public class TActiveBoulder extends TGameObject {
		{
			__gfx = [];

			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 0, 204, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 12, 204, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 204, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 36, 204, 12, 12);
			__gfx[4] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 48, 204, 12, 12);
			__gfx[5] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 60, 204, 12, 12);
			__gfx[6] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 72, 204, 12, 12);
			__gfx[7] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 84, 204, 12, 12);
			__gfx[8] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 96, 204, 12, 12);
			__gfx[9] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 108, 204, 12, 12);
		}
		private static var __gfx:Array;
		public var pushDir:int = 0;

		public function TActiveBoulder(x:uint, y:uint) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;

			flags = CAN_KILL_BY_FALLING | CAN_SURVIVE_PLASMA | CAN_OTHERS_ROLL_FROM | CAN_FALL | CAN_BE_SUCKED_BY_PLASMA;

			addSelf();

			_gfx = __gfx[0];

			addDefault();
		}

		override public function update():void {
			if (!movementWait && isAlive) {
				pushDir = 0;

				if (move(0, 1)) {
					isFalling = true;
					pushDir = 0;

				} else {
					if (isFalling) {
						RetrocamelEventsQueue.add(C.EVENT_BOULDER_LANDED);
					}
					isFalling = false;
					if (extHasFlag(CAN_OTHERS_ROLL_FROM, 0, 1, false)) {
						if (extCanWalkInto(-1, 0, -1) && extCanWalkInto(-1, 1, 0, 1) && !extHasFlag(CAN_FALL, -1, -1, false)) {
							if (move(-1, 0)) {
								pushDir = -1;
							}

						} else if (extCanWalkInto(1, 0, 1) && extCanWalkInto(1, 1, 0, 1) && !extHasFlag(CAN_FALL, 1, -1, false)) {
							if (move(1, 0)) {
								pushDir = 1;
							}
						}
					}
				}
			}

			super.update();

			if (pushDir == 1) {
				_gfx = __gfx[movementWait];
			}
			else if (pushDir == -1) {
				_gfx = __gfx[9 - movementWait];
			}
			else {
				_gfx = __gfx[0];
			}

			if (!isAlive) {
				kill();
			}
		}

		override public function canWalkInto(object:TGameObject, tx:int, ty:int):Boolean {
			if (!movementWait && tx && object.hasFlag(CAN_PUSH_ROCKS) && !extCanWalkInto(0, 1, 0, 1) && !isFalling) {
				if (move(tx, 0)) {
					RetrocamelEventsQueue.add(C.EVENT_BOULDER_PUSHED);
					removeSelfFrom(prevX, prevY);
					pushDir = tx;
					return true;
				}
			}

			return false;

		}

		/*
		 override public function saveObject():String{
		 return super.saveObject() + "&" + type + "&" + isFalling + "&" + prevX + "&" + prevY;
		 }

		 public static function load(data:Array):void{
		 var o:TActiveBoulder = new TActiveBoulder(data[0], data[1]);
		 o.movementWait = data[2];
		 o.type = data[3];
		 o.isFalling = data[4];
		 o.prevX = data[5];
		 o.prevY = data[6];

		 if (o._x != o.prevX || o._y != o.prevY)
		 Level.instance.level.set(o.prevX, o.prevY, OBSTRUANT);
		 }*/
	}
}