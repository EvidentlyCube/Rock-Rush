package game.objects {
	import game.global.Gfx;
	import game.global.levels.LevelManager;
	import game.windows.TWinMessage;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.locale._;

	public class TInformator extends TGameObject {
		{
			__gfx = [];

			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 120, 228, 12, 12);

			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 204, 204, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 216, 204, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 228, 204, 12, 12);
			__gfx[4] = __gfx[2];

			__gfx[5] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 204, 216, 12, 12);
			__gfx[6] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 216, 216, 12, 12);
			__gfx[7] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 228, 216, 12, 12);
			__gfx[8] = __gfx[6];

			__gfx[9] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 204, 228, 12, 12);
			__gfx[10] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 216, 228, 12, 12);
			__gfx[11] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 228, 228, 12, 12);
			__gfx[12] = __gfx[10];
		}
		private static var __gfx:Array;
		private var _type:uint;
		private var _frame:uint;
		private var _frameAnim:uint;

		public function TInformator(x:uint, y:uint, type:uint) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;

			_type = type;

			flags = CAN_OTHERS_ROLL_FROM | CAN_SURVIVE_EXPLOSION | CAN_SURVIVE_PLASMA;

			addSelf();

			if (_type != 0) {
				addDefault();
			}

			_gfx = __gfx[(_type == 0 ? 0 : 4 * _type - 3)];
		}

		override public function update():void {
			_frameAnim++;

			if (_type == 3) {
				if (_frame == 0 && _frameAnim > 80) {
					_frame++;
					_frameAnim = 0;

				} else if (_frame > 0 && _frameAnim > 10) {
					_frame = (_frame + 1) % 4;
					_frameAnim = 0;
				}

				_gfx = __gfx[_frame + 9]

			} else {
				if (_frameAnim > 16) {
					_frame = (_frame + 1) % 4;
					_frameAnim = 0;
				}

				_gfx = __gfx[_frame + _type * 4 - 3]
			}
		}

		override public function touched(object:TGameObject, tx:int, ty:int):Boolean {
			if (object is TPlayer) {
				showMessage();

				return true;
			}

			return false;
		}

		private function showMessage():void {
			TWinMessage.showMessage(_("msg" + LevelManager.currentRoom + "_" + _type));
		}

		/*
		 override public function saveObject():String{
		 return super.saveObject() + "&" + _type + "&" + _frame + "&" + _frameAnim;
		 }

		 public static function load(data:Array):void{
		 var t:TInformator = new TInformator(data[0], data[1], data[3]);
		 t._frame = data[4];
		 t._frameAnim = data[5];

		 if (t._type == 0)
		 t._gfx = __gfx[0];
		 else
		 t._gfx = __gfx[t._frame + t._type * 4 - 3]
		 }
		 */
	}
}