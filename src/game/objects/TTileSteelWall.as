package game.objects {
	import game.global.Gfx;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class TTileSteelWall extends TGameObject {
		private static var __gfx:Array;

		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 84, 36, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 72, 36, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 84, 0, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 72, 0, 12, 12);
			__gfx[4] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 48, 36, 12, 12);
			__gfx[5] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 60, 36, 12, 12);
			__gfx[6] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 48, 0, 12, 12);
			__gfx[7] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 60, 0, 12, 12);
			__gfx[8] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 84, 24, 12, 12);
			__gfx[9] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 72, 24, 12, 12);
			__gfx[10] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 84, 12, 12, 12);
			__gfx[11] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 72, 12, 12, 12);
			__gfx[12] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 48, 24, 12, 12);
			__gfx[13] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 60, 24, 12, 12);
			__gfx[14] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 48, 12, 12, 12);
			__gfx[15] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 60, 12, 12, 12);

			__gfx[16] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 180, 36, 12, 12);
			__gfx[17] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 168, 36, 12, 12);
			__gfx[18] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 180, 0, 12, 12);
			__gfx[19] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 168, 0, 12, 12);
			__gfx[20] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 144, 36, 12, 12);
			__gfx[21] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 156, 36, 12, 12);
			__gfx[22] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 144, 0, 12, 12);
			__gfx[23] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 156, 0, 12, 12);
			__gfx[24] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 180, 24, 12, 12);
			__gfx[25] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 168, 24, 12, 12);
			__gfx[26] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 180, 12, 12, 12);
			__gfx[27] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 168, 12, 12, 12);
			__gfx[28] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 144, 24, 12, 12);
			__gfx[29] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 156, 24, 12, 12);
			__gfx[30] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 144, 12, 12, 12);
			__gfx[31] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 156, 12, 12, 12);

			__gfx[32] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 228, 36, 12, 12);
			__gfx[33] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 216, 36, 12, 12);
			__gfx[34] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 228, 0, 12, 12);
			__gfx[35] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 216, 0, 12, 12);
			__gfx[36] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 192, 36, 12, 12);
			__gfx[37] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 204, 36, 12, 12);
			__gfx[38] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 192, 0, 12, 12);
			__gfx[39] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 204, 0, 12, 12);
			__gfx[40] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 228, 24, 12, 12);
			__gfx[41] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 216, 24, 12, 12);
			__gfx[42] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 228, 12, 12, 12);
			__gfx[43] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 216, 12, 12, 12);
			__gfx[44] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 192, 24, 12, 12);
			__gfx[45] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 204, 24, 12, 12);
			__gfx[46] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 192, 12, 12, 12);
			__gfx[47] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 204, 12, 12, 12);
		}

		public var type:uint;

		public function TTileSteelWall(x:uint, y:uint, type:uint) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;
			this.type = type;

			flags = CAN_SURVIVE_EXPLOSION | CAN_SURVIVE_PLASMA;

			addSelf();
		}

		override public function recalculate():void {
			_gfx = __gfx[getFourWayAutoTileIndex(TTileSteelWall, "type", type) + type * 16];
		}
	}
}