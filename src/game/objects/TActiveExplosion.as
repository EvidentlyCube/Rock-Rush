package game.objects {
	import game.global.Game;
	import game.global.Gfx;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class TActiveExplosion extends TGameObject {
		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 0, 180, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 12, 180, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 180, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 36, 180, 12, 12);
			__gfx[4] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 48, 180, 12, 12);
			__gfx[5] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 60, 180, 12, 12);
			__gfx[6] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 72, 180, 12, 12);
			__gfx[7] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 84, 180, 12, 12);
			__gfx[8] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 96, 180, 12, 12);
		}
		private static var __gfx:Array;
		private var _frame:uint = 0;
		private var _frameTimer:uint = 0;
		private var _createClass:Class;
		private var _under:TGameObject;

		public function TActiveExplosion(x:uint, y:uint, newTile:Class) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;

			_createClass = newTile;

			flags = CAN_SURVIVE_PLASMA;

			_under = extGetTile(0, 0);
			if (!_under || !_under.hasFlag(CAN_SURVIVE_EXPLOSION)) {
				if (parseUnder()) {
					addSelf();
					addDefault();
				}
			}

			_gfx = __gfx[0];


		}

		override public function draw():void {
			if (_under && _under.movementWait) {
				_under.movementWait--;
				_under.isVisible = true;
				_under.draw();
				_under.isVisible = false;
			}

			if (_createClass && _createClass.hasOwnProperty('defaultGfx')) {
				Game.lGame.draw(_createClass.defaultGfx, x, y);
			}

			super.draw();
		}

		override public function update():void {
			_frameTimer++;
			if (_frameTimer == 5) {
				_frame++;
				_frameTimer = 0;

				_gfx = __gfx[_frame];
			}

			if (movementWait-- == 0 && _under) {
				var underTemp:TGameObject = _under;
				_under = null;

				underTemp.kill();
			}

			if (_frame == 7) {
				kill();
			}
		}

		override public function kill(silent:Boolean = false):void {
			super.kill(silent);

			if (!silent && _createClass) {
				new _createClass(x, y);
			}

			if (_under) {
				_under.kill(silent);
			}
		}

		private function killedByExplosion():void {
			if (_under) {
				_under.kill(false);
			}

			super.kill(true);
		}

		private function parseUnder():Boolean {
			if (_under) {
				if ((_under.x != x || _under.y != y) && _under.movementWait < _under.movementSpeed / 2) {
					_under.removeSelfFrom(x, y);
					_under = null;
					return true;
				}

				if ((_under.prevX == x && _under.prevY == y) && _under.movementWait >= _under.movementSpeed / 2) {
					_under.setBack();
				}

				_under.removeSelf();
				_under.removeSelfFrom(_under.prevX, _under.prevY);
				_under.nullifyDefault();

				if (_under is TActiveExplosion) {
					var explo:TActiveExplosion = _under as TActiveExplosion;

					if (explo._under) {
						_under = explo._under;
						movementWait = explo.movementWait;

					} else {
						explo.kill(true);
						_under = null;
						return true;
					}
				} else {
					movementWait = movementSpeed;
				}
			}

			return true;
		}

		/*
		 override public function saveObject():String{
		 return super.saveObject() + "&" + (_createClass ? getQualifiedClassName(_createClass) : 'null') + "&" + _frame + "&" + _frameTimer;
		 }

		 public static function load(data:Array):void{
		 var cls:Class = (data[3] == "null" ? null : Class(getDefinitionByName(data[3])));

		 var o:TActiveExplosion = new TActiveExplosion(data[0], data[1], cls);
		 o.movementWait = data[2];
		 o._frame = data[4];
		 o._frameTimer = data[5];

		 o._gfx = __gfx[o._frame];
		 }*/
	}
}