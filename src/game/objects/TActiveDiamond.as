package game.objects {
	import flash.display.BitmapData;

	import game.global.Gfx;
	import game.global.Score;
	import game.global.levels.Level;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;

	public class TActiveDiamond extends TGameObject {
		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 36, 144, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 48, 144, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 60, 144, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 72, 144, 12, 12);
			__gfx[4] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 84, 144, 12, 12);
			__gfx[5] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 96, 144, 12, 12);

			defaultGfx = __gfx[0];
		}
		public static var defaultGfx:BitmapData;
		private static var __gfx:Array;

		public function TActiveDiamond(x:uint, y:uint) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;

			flags = CAN_KILL_BY_FALLING | CAN_SURVIVE_PLASMA | CAN_OTHERS_ROLL_FROM | CAN_FALL | CAN_BE_SUCKED_BY_PLASMA;

			addSelf();

			_gfx = __gfx[0];

			addDefault();
		}

		override public function update():void {
			if (!movementWait && isAlive) {
				if (move(0, 1)) {
					isFalling = true;

				} else {
					if (isFalling) {
						RetrocamelEventsQueue.add(C.EVENT_DIAMOND_LANDED);
					}
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

			super.update();

			_gfx = __gfx[Math.ceil(movementWait * 5 / movementSpeed)];

			if (!isAlive) {
				kill();
			}
		}

		override public function touched(object:TGameObject, tx:int, ty:int):Boolean {
			if (isFalling && ty == -1) {
				return false;
			}

			if (object.hasFlag(CAN_COLLECT_CRYSTALS) && !movementWait) {
				collected();
				return true;
			}

			return false;
		}

		override public function canWalkInto(object:TGameObject, tx:int, ty:int):Boolean {
			return !isFalling && object.hasFlag(CAN_COLLECT_CRYSTALS);
		}

		override public function walkedOn(object:TGameObject, tx:int, ty:int):void {
			if (object.hasFlag(CAN_COLLECT_CRYSTALS)) {
				collected();
			}
		}

		public function collected():void {
			RetrocamelEventsQueue.add(C.EVENT_DIAMOND_COLLECTED);
			Score.diamondsGot++;
			if (Score.diamondsGot <= Score.diamondsToGet) {
				Level.instance.collectedDiamonds++;
				Score.score += Level.instance.diamondValue;
			} else {
				Level.instance.collectedAdditionalDiamonds++;
				Score.score += Level.instance.diamondExtraValue;
			}

			kill();

			new TEffectDiamondCollected(x, y);
		}

		/*

		 override public function saveObject():String{
		 return super.saveObject() + "&" + isFalling + "&" + _frame + "&" + _frameWait + "&" + prevX + "&" + prevY;
		 }

		 public static function load(data:Array):void{
		 var o:TActiveDiamond = new TActiveDiamond(data[0], data[1]);
		 o.movementWait = data[2];
		 o.isFalling = data[3];
		 o._frame = data[4];
		 o._frameWait = data[5];
		 o.prevX = data[6];
		 o.prevY = data[7];

		 if (o._x != o.prevX || o._y != o.prevY)
		 Level.instance.level.set(o.prevX, o.prevY, OBSTRUANT);
		 }*/
	}
}