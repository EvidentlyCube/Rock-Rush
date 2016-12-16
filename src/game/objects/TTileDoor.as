package game.objects {
	import game.global.Gfx;
	import game.global.Score;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;

	public class TTileDoor extends TGameObject {
		private static var __gfx:Array;

		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 0, 84, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 12, 84, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 84, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 36, 84, 12, 12);
		}

		private var _color:uint;

		public function TTileDoor(x:uint, y:uint, color:uint) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;
			_color = color;

			flags = CAN_SURVIVE_EXPLOSION | CAN_SURVIVE_PLASMA;

			_gfx = __gfx[_color];

			addSelf();
		}

		override public function canWalkInto(object:TGameObject, tx:int, ty:int):Boolean {
			return false;
		}

		override public function touched(object:TGameObject, tx:int, ty:int):Boolean {
			if (object is TPlayer && Score.keys[_color]) {
				if (object.extCanWalkInto(tx * 2, ty * 2, tx, ty)) {
					if (Score.keys[_color] != -1) {
						Score.keys[_color]--;
					}

					RetrocamelEventsQueue.add(C.EVENT_KEY_USED);
					RetrocamelEventsQueue.add(C.EVENT_DOOR_CROSSED);

					object.move(tx * 2, ty * 2);

					return true;
				}
			}

			return false;
		}
	}
}