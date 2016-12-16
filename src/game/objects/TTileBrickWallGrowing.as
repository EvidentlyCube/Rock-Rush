package game.objects {
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;

	public class TTileBrickWallGrowing extends TTileBrickWall {

		public var gx:int;
		public var gy:int;

		public function TTileBrickWallGrowing(x:uint, y:uint, gx:int, gy:int) {
			super(x, y);

			this.gx = gx;
			this.gy = gy;

			movementWait = movementSpeed;

			addDefault();
		}

		override public function update():void {
			super.update();

			if (!movementWait && extCanWalkInto(gx, gy, gx, gy)) {
				var newTile:TTileBrickWallGrowing = new TTileBrickWallGrowing(x + gx * 12, y + gy * 12, gx, gy);
				RetrocamelEventsQueue.add(C.EVENT_WALL_GREW);
				newTile.recalculate();
				newTile.recalculateAround();
			}
		}
	}
}