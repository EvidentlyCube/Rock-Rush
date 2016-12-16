package game.objects {
	import game.global.Game;
	import game.global.levels.Level;

	import net.retrocade.retrocamel.components.RetrocamelDisplayObject;
	import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;

	public class TGameObject extends RetrocamelDisplayObject {
		public static const DEFAULT_FLAGS:uint = 0x00000000;
		public static const CAN_COLLECT_CRYSTALS:uint = 0x00000001;
		public static const CAN_PUSH_ROCKS:uint = 0x00000002;
		public static const CAN_KILL_BY_FALLING:uint = 0x00000004;


		// GAMEPLAY VARIABLES
		public static const CAN_SURVIVE_EXPLOSION:uint = 0x00000008;
		public static const CAN_SURVIVE_PLASMA:uint = 0x00000010;
		public static const CAN_EAT_DIRT:uint = 0x00000020;
		public static const CAN_GO_THROUGH_DOORS:uint = 0x00000040;
		public static const CAN_OTHERS_ROLL_FROM:uint = 0x00000080;
		public static const CAN_FALL:uint = 0x00000100;
		public static const CAN_KILL_BY_TOUCH:uint = 0x00000200;
		public static const CAN_DIE_WHEN_NEAR_PLASMA:uint = 0x00000400;
		public static const CAN_EAT_HARD_DIRT:uint = 0x00000800;
		public static const CAN_CLEAN_STONES:uint = 0x00001000;
		public static const CAN_BE_SUCKED_BY_PLASMA:uint = 0x00002000;
		public var flags:uint = DEFAULT_FLAGS;
		public var movementSpeed:uint = 10;
		public var movementWait:uint = 0;
		public var isFalling:Boolean = false;
		public var prevX:uint;
		public var prevY:uint;
		public var isAlive:Boolean = true;
		public var isVisible:Boolean = true;

		public function TGameObject() {
		}

		override public function draw():void {
			if (isVisible) {
				Game.lGame.draw(_gfx, _x - (_x - prevX) * (movementWait / movementSpeed),
					_y - (_y - prevY) * (movementWait / movementSpeed));
			}
		}

		override public function update():void {
			if (movementWait) {
				movementWait--;

				if (!movementWait) {
					removeSelfFrom(prevX, prevY);
					addSelf();

					prevX = x;
					prevY = y;
				}
			}
		}

		public function getTile(x:Number, y:Number):TGameObject {
			return Level.instance.level.get(x, y);
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Local state functions called by others
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public function extGetTile(tx:int, ty:int):TGameObject {
			return Level.instance.level.get(x + tx * 12, y + ty * 12);
		}

		public function setTile(x:Number, y:Number, object:TGameObject):void {
			Level.instance.level.set(x, y, object);
		}

		public function canWalkInto(object:TGameObject, tx:int, ty:int):Boolean {
			return false;
		}

		/** Returns true if something happened **/
		public function touched(object:TGameObject, tx:int, ty:int):Boolean {
			return false;
		}

		/** Returns true if something happened **/
		public function push(object:TGameObject, tx:int, ty:int):Boolean {
			return false;
		}

		public function hitByExplosion():void {
		}

		public function walkedOn(object:TGameObject, tx:int, ty:int):void {
		}

		public function recalculate():void {
		}

		public function hasFlag(flag:uint):Boolean {
			return Boolean(flags & flag);
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Local state functions called by the object
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public function move(tx:int, ty:int):Boolean {
			if (tx * 12 + x < 0 || tx * 12 + x >= Level.instance.levelWidth * 12 || ty * 12 + y < 0 || ty * 12 + y >= Level.instance.levelHeight * 12) {
				return false;
			}

			if (!tx && !ty) {
				movementWait = movementSpeed;
				return true;
			}

			var tile:TGameObject = getTile(x + tx * 12, y + ty * 12);
			if (!tile || tile.canWalkInto(this, tx, ty)) {
				if (tile) {
					tile.walkedOn(this, tx, ty);
				}

				if (!isAlive) {
					return false;
				}

				if (getTile(x, y) == this || getTile(x, y) == null) {
					setTile(x, y, this);
				}

				prevX = x;
				prevY = y;

				x += tx * 12;
				y += ty * 12;

				addSelf();

				movementWait = movementSpeed;

				return true;
			} else if (tile) {
				tile.touched(this, tx, ty);
			}

			return false;
		}

		public function addSelf():void {
			var tile:TGameObject = Level.instance.level.get(x, y);
			if (tile == null) {
				Level.instance.level.set(x, y, this);
			}
		}

		public function removeSelf():void {
			var tile:TGameObject = Level.instance.level.get(x, y);
			if (tile == this) {
				Level.instance.level.set(x, y, null);
			}
		}

		public function removeSelfFrom(x:uint, y:uint):void {
			var tile:TGameObject = Level.instance.level.get(x, y);
			if (tile == this) {
				Level.instance.level.set(x, y, null);
			}
		}

		public function kill(silent:Boolean = false):void {
			if ((prevX != x || prevY != y)) {
				removeSelfFrom(prevX, prevY);
			}

			if (getTile(x, y) == this) {
				removeSelf();
			}

			nullifyDefault();

			isAlive = false;
		}

		public function setBack():void {
			removeSelf();
			x = prevX;
			y = prevY;
		}

		public function setFront():void {
			removeSelfFrom(prevX, prevY);
			prevX = x;
			prevY = y;
		}

		public function setCloser():void {
			if (movementWait < movementSpeed / 2) {
				setBack();
			}
			else {
				setFront();
			}
		}

		public function setHigher():void {
			if (prevY > y) {
				setFront();
			}
			else if (prevY < y) {
				setBack();
			}
			else {
				setCloser();
			}
		}

		public function setLower():void {
			if (prevY < y) {
				setFront();
			}
			else if (prevY > y) {
				setBack();
			}
			else {
				setCloser();
			}
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Functions called on external tiles
		// ::::::::::::::::::::::::::::::::::::::::::::::

		final public function extHasFlag(flag:uint, dtx:int, dty:int, def:Boolean = false):Boolean {
			if (dtx * 12 + x < 0 || dtx * 12 + x >= Level.instance.levelWidth * 12 || dty * 12 + y < 0 || dty * 12 + y >= Level.instance.levelHeight * 12) {
				return false;
			}

			var tile:TGameObject = getTile(_x + dtx * 12, _y + dty * 12);

			if (tile) {
				return Boolean(tile.flags & flag);
			}

			return def;
		}

		final public function extCanWalkInto(dtx:int, dty:int, tx:int = 0, ty:int = 0):Boolean {
			if (dtx * 12 + x < 0 || dtx * 12 + x >= Level.instance.levelWidth * 12 || dty * 12 + y < 0 || dty * 12 + y >= Level.instance.levelHeight * 12) {
				return false;
			}

			var tile:TGameObject = getTile(_x + dtx * 12, _y + dty * 12);

			if (tile) {
				return tile.canWalkInto(this, tx, ty);
			}

			return true;
		}

		final public function extIs(clss:Class, dtx:int, dty:int):Boolean {
			if (dtx * 12 + x < 0 || dtx * 12 + x >= Level.instance.levelWidth * 12 || dty * 12 + y < 0 || dty * 12 + y >= Level.instance.levelHeight * 12) {
				return false;
			}

			var tile:TGameObject = getTile(x + dtx * 12, y + dty * 12);

			if (tile) {
				return tile is clss;
			}

			return false;
		}

		final public function extIsHas(clss:Class, varName:String, varValue:*, dtx:int, dty:int):Boolean {
			var tile:TGameObject = getTile(x + dtx * 12, y + dty * 12);

			if (tile && tile is clss && tile.hasOwnProperty(varName) && tile[varName] == varValue) {
				return true;
			}

			return false;
		}

		final public function extRecalculate(dtx:int, dty:int):void {
			var tile:TGameObject = getTile(x + dtx * 12, y + dty * 12);

			if (tile) {
				tile.recalculate();
			}
		}

		/** Returns true if something happened **/
		final public function extTouched(dtx:int, dty:int, tx:int, ty:int):Boolean {
			var tile:TGameObject = getTile(x + dtx * 12, y + dty * 12);

			if (tile) {
				return tile.touched(this, tx, ty);
			}

			return false;
		}

		final public function extKill(dtx:int, dty:int):void {
			var tile:TGameObject = getTile(x + dtx * 12, y + dty * 12);

			if (tile) {
				tile.kill();
			}
		}

		final public function extCanExplode(dtx:int, dty:int):Boolean {
			var tile:TGameObject = getTile(x + dtx * 12, y + dty * 12);

			return !tile || !tile.hasFlag(CAN_SURVIVE_EXPLOSION);
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Helper calculation functions
		// ::::::::::::::::::::::::::::::::::::::::::::::

		final public function explodeNine(newTile:Class = null):void {
			for (var i:int = -1; i < 2; i++) {
				for (var j:int = -1; j < 2; j++) {
					if (extCanExplode(i, j)) {
						new TActiveExplosion(x + i * 12, y + j * 12, newTile);
					}
				}
			}

			RetrocamelEventsQueue.add(C.EVENT_EXPLOSION_OCCURED);
		}

		final protected function getFourWayAutoTileIndex(clss:Class, varName:String, varValue:*):uint {
			var index:uint = 0;
			if (extIsHas(clss, varName, varValue, 0, -1)) {
				index |= 0x08;
			}
			if (extIsHas(clss, varName, varValue, 1, 0)) {
				index |= 0x04;
			}
			if (extIsHas(clss, varName, varValue, 0, 1)) {
				index |= 0x02;
			}
			if (extIsHas(clss, varName, varValue, -1, 0)) {
				index |= 0x01;
			}
			return index;
		}

		final protected function getTwoWayAutoTileIndex(clss:Class):uint {
			var index:uint = 0;
			if (extIs(clss, 1, 0)) {
				index |= 0x02;
			}
			if (extIs(clss, -1, 0)) {
				index |= 0x01;
			}
			return index;
		}

		final protected function recalculateAround():void {
			extRecalculate(-1, 0);
			extRecalculate(1, 0);
			extRecalculate(0, 1);
			extRecalculate(0, -1);
		}

		override public function get defaultGroup():RetrocamelUpdatableGroup {
			return Level.instance.actives;
		}
	}
}