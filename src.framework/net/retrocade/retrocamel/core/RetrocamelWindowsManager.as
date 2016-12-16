package net.retrocade.retrocamel.core {
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;
	import net.retrocade.retrocamel.interfaces.IRetrocamelWindow;

	use namespace retrocamel_int;

	public class RetrocamelWindowsManager extends Sprite {
		/**
		 * Array containing all currently displayed windows
		 */
		private static var _windows:Vector.<IRetrocamelWindow> = new Vector.<IRetrocamelWindow>();
		private static var _flashLayer:RetrocamelLayerFlashSprite;

		public static function get flashLayer():RetrocamelLayerFlashSprite {
			return _flashLayer;
		}

		/**
		 * True if there is a window which should pause the game
		 */
		private static var _pauseGame:Boolean = false;

		/**
		 * True if there is a window which should pause the game
		 */
		public static function get pauseGame():Boolean {
			return _pauseGame;
		}

		private static var _isBlocking:Boolean = false;

		public static function get isBlocking():Boolean {
			return _isBlocking;
		}

		public static function get numWindows():int {
			return _windows.length;
		}

		public static function hookFlashLayer(layer:RetrocamelLayerFlashSprite):void {
			_flashLayer = layer;
		}

		/**
		 * Removes last added window
		 */
		public static function removeLastWindow():void {
			var l:uint = _windows.length;
			if (l == 0) {
				return;
			}

			_windows[l - 1].hide();
		}

		/**
		 * Removes all windows
		 */
		public static function clearWindows():void {
			while (_windows.length) {
				removeLastWindow();
			}
		}

		/**
		 * Updates windows related stuff to
		 */
		private static function validateWindowsNow():void {
			_isBlocking = false;
			var window:IRetrocamelWindow;
			_pauseGame = false;

			for (var i:int = _windows.length - 1; i >= 0; --i) {
				window = _windows[i];
				if (_isBlocking) {
					window.block();

				} else {
					window.unblock();
				}

				_pauseGame = window.pauseGame || _pauseGame;
				_isBlocking = window.blockUnder || _isBlocking;
			}

			if (_isBlocking || _pauseGame) {
				RetrocamelDisplayManager.block();
			} else {
				RetrocamelDisplayManager.unblock();
			}

			if (_flashLayer) {
				_flashLayer.inputEnabled = true;
			}
		}

		/**
		 * @private
		 * Adds given window to the display
		 * @param window Window to be added
		 */
		retrocamel_int static function addWindow(window:IRetrocamelWindow):void {
			if (_windows.indexOf(window) != -1) {
				return;
			}

			if (window is DisplayObject) {
				_flashLayer.add(window as DisplayObject);
			}

			_windows.push(window);
			validateWindowsNow();
		}

		/**
		 * @private
		 * Removes given window from the display
		 * @param window Window to be removed
		 */
		retrocamel_int static function removeWindow(window:IRetrocamelWindow):void {
			var index:uint = _windows.indexOf(window);

			if (index == -1) {
				return;
			}

			if (window is DisplayObject) {
				_flashLayer.remove(window as DisplayObject);
			}

			_windows.splice(index, 1);
			validateWindowsNow();
		}

		retrocamel_int static function pushLayersToFront():void {
			if (_flashLayer) {
				RetrocamelDisplayManager.pullLayerToFront(_flashLayer);
			}
		}

		retrocamel_int static function update():void {
			if (!_windows.length) {
				return;
			}

			var window:IRetrocamelWindow;
			for (var i:int = _windows.length - 1; i >= 0; --i) {
				window = _windows[i];

				if (!window.isBlocked()) {
					window.update();
				}
			}
		}

		retrocamel_int static function onStageResize():void {
			for each(var window:IRetrocamelWindow in _windows) {
				if (window) {
					window.resize();
				}
			}
		}

		public static function removeAllWindowsButLast():void {
			while (_windows.length > 1) {
				_windows[0].hide();
			}
		}
	}
}