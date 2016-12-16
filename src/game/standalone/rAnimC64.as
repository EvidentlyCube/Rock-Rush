package game.standalone {

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableObject;
	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.retrocamel_int;

	use namespace retrocamel_int;

	public class rAnimC64 extends RetrocamelUpdatableObject {
		private var _all:Array = [];
		private var _effect:Shape = new Shape();
		private var _padding:Shape = new Shape();
		private var _gfx:Sprite;

		public function get gfx():Sprite {
			return _gfx;
		}
		private var _scale:uint;

		public function rAnimC64(padColor:uint, padTop:Number = NaN, padLeft:Number = NaN, padRight:Number = NaN, padBottom:Number = NaN,
		                         scale:Number = 1) {
			_scale = scale;

			_gfx = new Sprite();
			Sprite(_gfx).addChild(_effect);

			if (!isNaN(padTop) && !isNaN(padLeft) && !isNaN(padRight) && !isNaN(padBottom)) {
				_padding.graphics.beginFill(padColor);
				_padding.graphics.drawRect(padLeft, padTop, RetrocamelCore.settings.gameWidth - padLeft - padRight,
					RetrocamelCore.settings.gameHeight - padTop - padBottom);
				Sprite(_gfx).addChild(_padding);
			}
		}

		override public function update():void {
			var hei:Number = 0;
			var max:Object = _all[0];
			var thick:Number;
			var o:Object;
			var g:Graphics = _effect.graphics;
			g.clear();

			while (hei < RetrocamelCore.settings.gameHeight) {
				for each(o in _all) {
					o.count += Math.random() * o.probability;
					if (o.count > max.count) {
						max = o;
					}
				}

				max.count = 0;

				thick = (max.max - max.min) * Math.random() + max.min;
				thick *= _scale;
				g.beginFill(max.color);
				g.drawRect(0, hei, RetrocamelCore.settings.gameWidth, thick);
				hei += thick;
			}
		}

		public function kill():void {
			if (_gfx.parent) {
				_gfx.parent.removeChild(_gfx);
			}

			nullifyDefault();
		}

		public function add(color:uint, minThick:Number, maxThick:Number, probability:Number):void {
			_all.push({
				color: color,
				min: minThick,
				max: maxThick,
				probability: probability,
				count: 0.0
			});
		}
	}
}