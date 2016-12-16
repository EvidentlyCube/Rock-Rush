package game.objects {
	import game.global.Gfx;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class TActiveBlob extends TGameObject {
		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 0, 168, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 12, 168, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 168, 12, 12);
			__gfx[3] = __gfx[1];
		}
		private static var __gfx:Array;
		public var mx:int = 0;
		public var my:int = -1;
		private var _goBlindly:Boolean = true;
		private var _waitTurn:Boolean = false;
		private var _frame:uint = 0;
		private var _frameTimer:uint = 0;

		public function TActiveBlob(x:uint, y:uint, mx:int, my:int) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;
			this.mx = mx;
			this.my = my;

			_gfx = __gfx[0];

			flags = CAN_KILL_BY_TOUCH | CAN_DIE_WHEN_NEAR_PLASMA;

			addSelf();

			addDefault();
		}

		override public function update():void {
			if (!movementWait) {
				extTouched(-1, 0, -1, 0);
				extTouched(1, 0, 1, 0);
				extTouched(0, -1, 0, -1);
				extTouched(0, 1, 0, 1);

				if (_goBlindly && extCanWalkInto(mx, my, mx, my)) {
					if (!_waitTurn) {
						move(mx, my);
						_goBlindly = false;
					} else {
						move(0, 0);
						_waitTurn = false;
					}

				} else {
					if (_waitTurn) {
						if (extCanWalkInto(1, 0, 1, 0)) {
							move(0, 0);
							_waitTurn = false;
							mx = 1;
							my = 0;

						} else if (extCanWalkInto(-1, 0, -1, 0)) {
							move(0, 0);
							_waitTurn = false;
							mx = -1;
							my = 0;

						} else if (extCanWalkInto(0, 1, 0, 1)) {
							move(0, 0);
							_waitTurn = false;
							mx = 0;
							my = 1;

						} else if (extCanWalkInto(0, -1, 0, -1)) {
							move(0, 0);
							_waitTurn = false;
							mx = 0;
							my = -1;
						}

					} else {
						var temp:int = 0;
						if (extCanWalkInto(my, -mx, my, -mx)) { // Can Left?
							temp = mx;
							mx = my;
							my = -temp;
							_goBlindly = true;
							move(0, 0);

						} else if (!extCanWalkInto(mx, my, mx, my)) { // Can't Forward?
							if (extCanWalkInto(-my, mx, -my, mx)) { // Can Right?
								temp = mx;
								mx = -my;
								my = temp;

								_goBlindly = true;
								move(0, 0);

							} else if (extCanWalkInto(-mx, -my, -mx, -my)) { // Can reverse? Then move Right
								temp = mx;
								mx = -my;
								my = temp;
								_goBlindly = false;
								move(0, 0);
							} else {
								_waitTurn = true;
							}
						} else {
							if (!_waitTurn) {
								move(mx, my);
								_goBlindly = false;
							} else {
								move(0, 0);
								_waitTurn = false;
							}
						}
					}
				}
			}

			super.update();

			_frameTimer++;
			if (_frameTimer == 10) {
				_frame = (_frame + 1) % 4;
				_frameTimer = 0;
				_gfx = __gfx[_frame];
			}

			if (!isAlive) {
				kill();
			}
		}

		override public function canWalkInto(object:TGameObject, tx:int, ty:int):Boolean {
			return false;
		}

		override public function touched(object:TGameObject, tx:int, ty:int):Boolean {
			if (object is TActiveBoulder && object.isFalling && ty == 1) {
				setHigher();
				kill();
				return true;
			}

			return false;
		}

		override public function kill(silent:Boolean = false):void {
			super.kill(silent);

			setCloser();
			explodeNine();
		}

		/*
		 override public function saveObject():String{
		 trace(super.saveObject() + "&" + _goBlindly + "&" + _waitTurn + "&" + mx + "&" + my + "&" + _frame + "&" + _frameTimer + "&" + prevX + "&" + prevY);
		 return super.saveObject() + "&" + _goBlindly + "&" + _waitTurn + "&" + mx + "&" + my + "&" + _frame + "&" + _frameTimer + "&" + prevX + "&" + prevY;
		 }

		 public static function load(data:Array):void{
		 var o:TActiveBlob = new TActiveBlob(data[0], data[1], 1, 0);
		 o.movementWait = data[2];
		 o._goBlindly = data[3];
		 o._waitTurn = data[4];
		 o.mx = data[5];
		 o.my = data[6];
		 o._frame = data[7];
		 o._frameTimer = data[8];
		 o.prevX = data[9];
		 o.prevY = data[10];

		 if (o._x != o.prevX || o._y != o.prevY)
		 Level.instance.level.set(o.prevX, o.prevY, OBSTRUANT);
		 }*/
	}
}