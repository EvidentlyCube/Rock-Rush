package game.windows {
	import flash.events.Event;

	import game.global.Make;

	import net.retrocade.retrocamel.core.RetrocamelDisplayManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.retrocamel.core.retrocamel_int;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelWindowFlash;
	import net.retrocade.retrocamel.locale._;
	import net.retrocade.utils.UtilsNumber;

	public class TWinFocusPause extends RetrocamelWindowFlash {
		private static var _instance:TWinFocusPause = new TWinFocusPause();

		public static function get instance():TWinFocusPause {
			return _instance;
		}


		private static var _initialVolume:Number = 0;

		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Hooking device
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public static function hook():void {
			RetrocamelDisplayManager.flashStage.addEventListener(Event.ACTIVATE, onActivate);
			RetrocamelDisplayManager.flashStage.addEventListener(Event.DEACTIVATE, onDeactivate);
		}

		public static function unhook():void {
			RetrocamelDisplayManager.flashStage.removeEventListener(Event.ACTIVATE, onActivate);
			RetrocamelDisplayManager.flashStage.removeEventListener(Event.DEACTIVATE, onDeactivate);
		}

		private static function onDeactivate(e:Event):void {
			if (instance.parent) {
				return;
			}

			_initialVolume = RetrocamelSoundManager.retrocamel_int::musicFadeVolume;

			instance.show();

			if (_initialVolume != 0) {
				RetrocamelSoundManager.pauseMusic();
			}
		}

		private static function onActivate(e:Event):void {
			if (instance.parent) {
				instance.hide();

				if (_initialVolume != 0) {
					RetrocamelSoundManager.resumeMusic()
				}
			}
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Normal WIndow Stuff
		// ::::::::::::::::::::::::::::::::::::::::::::::

		private var _hue:Number = 0;
		private var _sat:Number = 0;
		private var _wave:Number = 0;

		private var _focusOff:RetrocamelBitmapText;
		private var _focusInstruction:RetrocamelBitmapText;

		public function TWinFocusPause() {
			this._blockUnder = true;
			this._pauseGame = true;

			_focusOff = Make().text(_("Pause - Game lost focus"), 0xFF0000, 2);
			_focusInstruction = Make().text(_("Click to continue"), 0x00FF00, 2, 0, 50);

			_focusOff.y = S().gameHeight / 2 - _focusOff.height - 10;
			_focusInstruction.y = S().gameHeight / 2 + 10;

			_focusOff.cache = true;
			_focusInstruction.cache = true;

			addChild(_focusOff);
			addChild(_focusInstruction);

			graphics.beginFill(0, 0.8);
			graphics.drawRect(0, _focusOff.y - 15, S().gameWidth, _focusOff.height + _focusInstruction.height + 50);

			update();
		}

		override public function update():void {
			_focusOff.forceRedraw();
			_focusInstruction.forceRedraw();
			_focusOff.color = UtilsNumber.hsvToRGB(_hue, Math.cos(_sat++ * Math.PI / 30) * 0.5 + 0.5, 1);
			_focusInstruction.color = UtilsNumber.hsvToRGB(_hue + 180, Math.cos(_sat * Math.PI / 30) * 0.5 + 0.5, 1);

			_focusOff.x = Math.sin(_sat * Math.PI / 60) * 20 + (width - _focusOff.width) / 2;
			_focusInstruction.x = Math.sin(-_sat * Math.PI / 60) * 20 + (width - _focusInstruction.width) / 2;

			if (_sat % 60 == 30) {
				_hue += 60;
			}
		}
	}
}