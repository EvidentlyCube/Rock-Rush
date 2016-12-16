package game.objects {
	import game.global.Gfx;
	import game.global.Score;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;

	public class TKey extends TGameObject {

		private static var __gfx:Array;

		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 144, 156, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 156, 156, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 168, 156, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 180, 156, 12, 12);
			__gfx[4] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 144, 168, 12, 12);
			__gfx[5] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 156, 168, 12, 12);
			__gfx[6] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 168, 168, 12, 12);
			__gfx[7] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 180, 168, 12, 12);
		}

		private var _type:uint;
		private var _color:uint;
		private var _infinite:Boolean;

		public function TKey(x:uint, y:uint, color:uint, infinite:Boolean) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;
			_color = color;
			_infinite = infinite;

			flags = CAN_SURVIVE_PLASMA;

			_gfx = __gfx[_color + (_infinite ? 4 : 0)];

			addSelf();
		}

		override public function canWalkInto(object:TGameObject, tx:int, ty:int):Boolean {
			if (object is TPlayer) {
				collect();
				return true;
			}

			return false;
		}

		override public function touched(object:TGameObject, tx:int, ty:int):Boolean {
			if (object is TPlayer) {
				collect();
				return true;
			}
			return false;
		}

		private function collect():void {
			kill();

			RetrocamelEventsQueue.add(C.EVENT_KEY_COLLECTED);

			if (Score.keys[_color] != -1) {
				Score.keys[_color] = (_infinite ? -1 : Score.keys[_color] + 1);
			}
		}

		/*
		 override public function saveObject():String{
		 return super.saveObject() + "&" + _type;
		 }

		 public static function load(data:Array):void{
		 var t:TItem = new TItem(data[0], data[1], data[3]);
		 }*/
	}
}