package game.objects {
	import game.global.Gfx;
	import game.global.Sfx;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class TTileDirt extends TGameObject {
		private static var __gfx:Array;

		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 36, 36, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 36, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 36, 0, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 0, 12, 12);
			__gfx[4] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 0, 36, 12, 12);
			__gfx[5] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 12, 36, 12, 12);
			__gfx[6] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 0, 0, 12, 12);
			__gfx[7] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 12, 0, 12, 12);
			__gfx[8] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 36, 24, 12, 12);
			__gfx[9] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 24, 12, 12);
			__gfx[10] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 36, 12, 12, 12);
			__gfx[11] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 12, 12, 12);
			__gfx[12] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 0, 24, 12, 12);
			__gfx[13] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 12, 24, 12, 12);
			__gfx[14] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 0, 12, 12, 12);
			__gfx[15] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 12, 12, 12, 12);

			__gfx[16] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 132, 36, 12, 12);
			__gfx[17] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 120, 36, 12, 12);
			__gfx[18] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 132, 0, 12, 12);
			__gfx[19] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 120, 0, 12, 12);
			__gfx[20] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 96, 36, 12, 12);
			__gfx[21] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 108, 36, 12, 12);
			__gfx[22] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 96, 0, 12, 12);
			__gfx[23] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 108, 0, 12, 12);
			__gfx[24] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 132, 24, 12, 12);
			__gfx[25] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 120, 24, 12, 12);
			__gfx[26] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 132, 12, 12, 12);
			__gfx[27] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 120, 12, 12, 12);
			__gfx[28] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 96, 24, 12, 12);
			__gfx[29] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 108, 24, 12, 12);
			__gfx[30] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 96, 12, 12, 12);
			__gfx[31] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 108, 12, 12, 12);
		}

		public var type:uint;

		public function TTileDirt(x:uint, y:uint, type:uint) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;
			this.type = type;

			this.flags = DEFAULT_FLAGS;

			addSelf();
		}

		override public function canWalkInto(object:TGameObject, tx:int, ty:int):Boolean {
			return (object.flags & CAN_EAT_DIRT) > 0;
		}

		override public function touched(object:TGameObject, tx:int, ty:int):Boolean {
			if (object.hasFlag(CAN_EAT_DIRT)) {
				Sfx.sfxWalk.play();
				kill();
				return true;
			}

			return false;

		}

		override public function walkedOn(object:TGameObject, tx:int, ty:int):void {
			Sfx.sfxWalk.play();
			kill();
		}

		override public function hitByExplosion():void {
			kill();
		}

		override public function recalculate():void {
			_gfx = __gfx[getFourWayAutoTileIndex(TTileDirt, "type", type) + (type ? 16 : 0)];
		}

		override public function kill(silent:Boolean = false):void {
			super.kill(silent);

			recalculateAround();
		}
	}
}