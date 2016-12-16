package game.objects {
	import game.global.Gfx;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class TTileBrickWall extends TGameObject {
		private static var __gfx:Array;

		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 36, 48, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 48, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 0, 48, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 12, 48, 12, 12);
		}

		public function TTileBrickWall(x:uint, y:uint) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;

			flags = CAN_SURVIVE_PLASMA | CAN_OTHERS_ROLL_FROM | CAN_OTHERS_ROLL_FROM;

			addSelf();
		}

		override public function canWalkInto(object:TGameObject, tx:int, ty:int):Boolean {
			return false;
		}

		override public function recalculate():void {
			_gfx = __gfx[getTwoWayAutoTileIndex(TTileBrickWall)];
		}


		public static function load(data:Array):void {
			var o:TTileBrickWall = new TTileBrickWall(data[0], data[1]);
		}
	}
}