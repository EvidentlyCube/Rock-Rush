package net.retrocade.retrocamel.core {

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;

	import net.retrocade.retrocamel.components.RetrocamelStateBase;
	import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;
	import net.retrocade.retrocamel.interfaces.IRetrocamelMake;
	import net.retrocade.retrocamel.interfaces.IRetrocamelSettings;
	import net.retrocade.retrocamel.locale.RetrocamelLocale;

	use namespace retrocamel_int;

	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	public class RetrocamelCore {

		/**
		 * Global updates group which is always updated before anything else
		 */
		private static var _groupBefore:RetrocamelUpdatableGroup = new RetrocamelUpdatableGroup();

		/**
		 * Retrieves global updates group which is always updated before everything else
		 */
		public static function get groupBefore():RetrocamelUpdatableGroup {
			return _groupBefore;
		}

		/**
		 * Global updates group which is always updated after anything else
		 */
		private static var _groupAfter:RetrocamelUpdatableGroup = new RetrocamelUpdatableGroup();

		/**
		 * Retrieves global updates group which is always updated after everything else
		 */
		public static function get groupAfter():RetrocamelUpdatableGroup {
			return _groupAfter;
		}


		/**
		 * The settings object
		 */
		retrocamel_int static var settings:IRetrocamelSettings;

		/**
		 * The make object
		 */
		retrocamel_int static var make:IRetrocamelMake;

		/**
		 * Currently displayed state
		 */
		private static var _currentState:RetrocamelStateBase;

		/**
		 * Retrieves current state
		 */
		public static function get currentState():RetrocamelStateBase {
			return _currentState;
		}

		/**
		 * A function to call if an error is found (only during enter frame execution).
		 * The error will be passed as the first argument.
		 * If not set, the error handling will work as default in flash.
		 */
		public static var errorCallback:Function;

		/**
		 * Initialzes the whole game
		 */
		public static function initFlash(stage:Stage, main:DisplayObjectContainer, settingsInstance:IRetrocamelSettings, makeInstance:IRetrocamelMake):void {
			settings = settingsInstance;
			make = makeInstance;

			stage.frameRate = 60;

			RetrocamelLocale.initialize();
			RetrocamelInputManager.initialize(stage);
			RetrocamelDisplayManager.initializeFlash(main, stage);

			RetrocamelEventsQueue.initialize();

			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}


		/**
		 * Changes the current state
		 * @param state State to be set
		 */
		public static function setState(state:RetrocamelStateBase):void {
			if (_currentState) {
				_currentState.destroy();
			}

			_currentState = state;
			_currentState.create();
		}

		private static function onEnterFrame(e:Event = null):void {
			if (errorCallback != null) {
				try {
					onEnterFrameSub();
				} catch (error:Error) {
					errorCallback(error);
				}
			} else {
				onEnterFrameSub();
			}
		}

		private static function onEnterFrameSub():void {
			if (RetrocamelDisplayManager.flashStage.focus && !RetrocamelDisplayManager.flashStage.focus.stage) {
				RetrocamelDisplayManager.flashStage.focus = null;
			}

			if (RetrocamelEventsQueue.autoClear) {
				RetrocamelEventsQueue.clear();
			}

			RetrocamelWindowsManager.update();

			_groupBefore.update();
			if (_currentState && !RetrocamelWindowsManager.pauseGame) {
				_currentState.update();
			}
			_groupAfter.update();

			RetrocamelInputManager.onEnterFrameUpdate();
		}

		retrocamel_int static function onStageResized():void {
			if (_currentState) {
				_currentState.resize();
			}
		}
	}
}