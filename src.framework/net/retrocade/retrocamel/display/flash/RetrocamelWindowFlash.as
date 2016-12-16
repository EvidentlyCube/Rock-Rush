package net.retrocade.retrocamel.display.flash {
	import flash.display.BlendMode;
	import flash.geom.Rectangle;

	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.RetrocamelDisplayManager;
	import net.retrocade.retrocamel.core.RetrocamelWindowsManager;
	import net.retrocade.retrocamel.core.retrocamel_int;
	import net.retrocade.retrocamel.interfaces.IRetrocamelWindow;

	use namespace retrocamel_int;

	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	public class RetrocamelWindowFlash extends RetrocamelSprite implements IRetrocamelWindow {
		/****************************************************************************************************************/
		/**                                                                                                  VARIABLES  */
		/****************************************************************************************************************/

		/**
		 * Should this window block input to all underlying windows?
		 */
		protected var _blockUnder:Boolean = true;

		public function get blockUnder():Boolean {
			return _blockUnder;
		}

		/**
		 * Should the game be paused when this window is displayed?
		 */
		protected var _pauseGame:Boolean = true;

		public function get pauseGame():Boolean {
			return _pauseGame;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Helpers
		// ::::::::::::::::::::::::::::::::::::::::::::::

		/**
		 * HELPER: Value of mouseChildren before block
		 */
		private var _lastMouseChildren:Boolean = true;

		/**
		 * HELPER: Value of mouseEnabled before block
		 */
		private var _lastMouseEnabled:Boolean = true;

		private var _isBlocked:Boolean = false;

		public function isBlocked():Boolean {
			return _isBlocked;
		}


		/****************************************************************************************************************/
		/**                                                                                                  FUNCTIONS  */
		/****************************************************************************************************************/
		public function RetrocamelWindowFlash() {
			super();

			blendMode = BlendMode.LAYER;
		}

		/**
		 * Adds the window to display and show it
		 */
		public function show():void {
			RetrocamelWindowsManager.addWindow(this);
		}

		/**
		 * Remove the window from the display
		 */
		public function hide():void {
			RetrocamelWindowsManager.removeWindow(this);
		}

		public function resize():void {
		}

		/**
		 * Called by windows manager when window above it blocks this one
		 */
		public function block():void {
			if (_isBlocked)
				return;

			_isBlocked = true;
			_lastMouseChildren = mouseChildren;
			_lastMouseEnabled = mouseEnabled;

			mouseChildren = false;
			mouseEnabled = false;
		}

		public function unblock():void {
			_isBlocked = false;
			mouseChildren = _lastMouseChildren;
			mouseEnabled = _lastMouseEnabled;
		}

		public function centerWindow():void {
			var bounds:Rectangle = getBounds(RetrocamelDisplayManager.flashApplication);

			x = (RetrocamelCore.settings.gameWidth - width) / 2;
			y = (RetrocamelCore.settings.gameHeight - height) / 2;
		}

		public function update():void {
		}
	}
}