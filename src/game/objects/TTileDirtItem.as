package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Gfx;
	import game.global.Score;
	import game.global.Sfx;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class TTileDirtItem extends TTileDirt {
		private static var __gfx:Array;

		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 48, 48, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 72, 48, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 96, 48, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 60, 48, 12, 12);
			__gfx[4] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 84, 48, 12, 12);
			__gfx[5] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 108, 48, 12, 12);
		}

		public var itemType:uint;

		public var itemGFX:BitmapData;

		public function TTileDirtItem(x:uint, y:uint, type:uint, itemType:uint) {
			super(x, y, type);

			flags |= CAN_SURVIVE_PLASMA;

			itemGFX = __gfx[itemType + type * 3];

			this.itemType = itemType;
		}

		override public function canWalkInto(object:TGameObject, tx:int, ty:int):Boolean {
			if (itemType == 1 && object.hasFlag(CAN_EAT_HARD_DIRT)) {
				return true;
			}
			else if (itemType == 2 && object.hasFlag(CAN_EAT_DIRT) && object.hasFlag(CAN_COLLECT_CRYSTALS)) {
				return true;
			}

			return false;
		}

		override public function touched(object:TGameObject, tx:int, ty:int):Boolean {
			if (itemType == 1 && object.hasFlag(CAN_EAT_HARD_DIRT)) {
				Sfx.sfxWalk.play();
				kill();
				return true;
			} else if (itemType == 2 && object.hasFlag(CAN_EAT_DIRT) && object.hasFlag(CAN_COLLECT_CRYSTALS)) {
				Sfx.sfxWalk.play();
				Score.diamondsGot++;
				kill();
				return true;
			} else if (object.hasFlag(CAN_CLEAN_STONES)) {
				Sfx.sfxWalk.play();
				kill();
				new TActiveBoulder(x, y);
				return true;
			}

			return false;
		}

		override public function walkedOn(object:TGameObject, tx:int, ty:int):void {
			kill();
		}

		override public function hitByExplosion():void {
			kill();
		}

		override public function kill(silent:Boolean = false):void {
			super.kill(silent);

			recalculateAround();
		}

		override public function draw():void {
			Game.lGame.draw(_gfx, x, y);
			Game.lGame.draw(itemGFX, x, y);
		}
	}
}