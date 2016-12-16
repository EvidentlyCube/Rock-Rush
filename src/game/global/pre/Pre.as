package game.global.pre {

	import flash.filters.DropShadowFilter;
	import flash.system.Security;

	import net.retrocade.constants.KeyConst;
	import net.retrocade.retrocamel.core.RetrocamelDisplayManager;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.retrocamel.core.RetrocamelWindowsManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapFont;
	import net.retrocade.retrocamel.display.flash.RetrocamelPreciseGrid9;
	import net.retrocade.retrocamel.display.global.RetrocamelTooltip;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;
	import net.retrocade.retrocamel.global.RetrocamelSimpleSave;
	import net.retrocade.retrocamel.locale.RetrocamelLocale;

	public class Pre {
		public static const DROP_SHADOW_FILTER:Array = [new DropShadowFilter(2, 45, 0, 1, 0, 0)];
		public static var font:RetrocamelBitmapFont;
		public static var c64font:RetrocamelBitmapFont;

		public static function preCoreInit():void {
			loadFont();
		}

		public static function init():void {
			RetrocamelTooltip.init();

			loadLanguages();
			loadGrid();
			loadOptions();
			initKeyboardShortcuts();

			RetrocamelWindowsManager.hookFlashLayer(new RetrocamelLayerFlashSprite());

			RetrocamelTooltip.setPadding(5, 6, 6, 10);
		}

		private static function initKeyboardShortcuts():void {
			RetrocamelInputManager.keyDownSignal.add(function (keyCode:int):void {
				switch (keyCode) {
					case(KeyConst.F4):
						if (RetrocamelDisplayManager.scaleToFit && RetrocamelDisplayManager.scaleToInteger) {
							RetrocamelDisplayManager.scaleToFit = false;
							RetrocamelDisplayManager.scaleToInteger = false;

						} else if (RetrocamelDisplayManager.scaleToFit && !RetrocamelDisplayManager.scaleToInteger) {
							RetrocamelDisplayManager.scaleToFit = true;
							RetrocamelDisplayManager.scaleToInteger = true;

						} else {
							RetrocamelDisplayManager.scaleToFit = true;
							RetrocamelDisplayManager.scaleToInteger = false;
						}
						break;
					case(KeyConst.F11):
						RetrocamelDisplayManager.toggleFullScreen();
						break;
				}
			});
		}

		private static function loadOptions():void {
			RetrocamelSimpleSave.setStorage(S().saveStorageName);

			RetrocamelSoundManager.musicVolume = RetrocamelSimpleSave.read('optVolumeMusic', 1.0);
			RetrocamelSoundManager.soundVolume = RetrocamelSimpleSave.read('optVolumeSound', 1.0);
		}

		private static function loadFont():void {
			font = new RetrocamelBitmapFont(PreData.fontClass, 15, 13, false, 5, PreData.fontString);

			c64font = new RetrocamelBitmapFont(PreData.fontC64Class, 8, 8, true, 8, PreData.fontC64String);
		}

		private static function loadGrid():void {
			RetrocamelPreciseGrid9.make('tooltip', PreData.tooltipGrid9BitmapData, 1, 1, 24, 24);
			RetrocamelPreciseGrid9.make('window', PreData.windowGrid9BitmapData, 4, 4, 24, 24);
			RetrocamelPreciseGrid9.make('buttonBG', PreData.buttonGrid9BitmapData, 6, 6, 20, 20);

			RetrocamelTooltip.setBackground(RetrocamelPreciseGrid9.getGrid('tooltip', true));
		}

		private static function loadLanguages():void {
			PreData.loadLanguageFiles();

			RetrocamelLocale.checkLangAgainstLang('en', 'pl');
		}
	}
}