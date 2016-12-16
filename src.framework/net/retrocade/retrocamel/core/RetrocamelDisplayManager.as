package net.retrocade.retrocamel.core {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import net.retrocade.retrocamel.display.global.RetrocamelTooltip;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayer;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlash;
	import net.retrocade.retrocamel.events.RetrocamelEvent;

	use namespace retrocamel_int;

	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	public class RetrocamelDisplayManager {
		private static const _eventDispatcher:EventDispatcher = new EventDispatcher();
		retrocamel_int static var _flashStage:Stage;

		public static function get flashStage():Stage {
			return _flashStage;
		}
		retrocamel_int static var _flashLayers:Vector.<RetrocamelLayerFlash>;
		private static var _shadingLayer:Sprite;

		private static var _offsetX:Number = 0;

		public static function get offsetX():Number {
			return _offsetX;
		}

		private static var _offsetY:Number = 0;

		public static function get offsetY():Number {
			return _offsetY;
		}

		private static var _scaleX:Number = 1;

		public static function get scaleX():Number {
			return _scaleX;
		}

		private static var _scaleY:Number = 1;

		public static function get scaleY():Number {
			return _scaleY;
		}

		private static var _scaleToFit:Boolean = false;

		public static function get scaleToFit():Boolean {
			return _scaleToFit;
		}

		public static function set scaleToFit(value:Boolean):void {
			_scaleToFit = value;
			onStageResize(null);
		}

		private static var _scaleToInteger:Boolean = false;

		public static function get scaleToInteger():Boolean {
			return _scaleToInteger;
		}

		public static function set scaleToInteger(value:Boolean):void {
			_scaleToInteger = value;
			onStageResize(null);
		}
		retrocamel_int static var _tooltip:RetrocamelTooltip;
		retrocamel_int static var _smoothing:Boolean;

		/**
		 * Shortcut to the instance of the main application
		 */
		retrocamel_int static var _flashApplication:DisplayObjectContainer;

		public static function get flashApplication():DisplayObjectContainer {
			return _flashApplication;
		}

		retrocamel_int static function initializeFlash(main:DisplayObjectContainer, stage:Stage):void {
			_flashStage = stage;
			_flashApplication = main;

			_flashLayers = new Vector.<RetrocamelLayerFlash>();

			_flashStage.addEventListener(Event.RESIZE, onStageResize);

			_shadingLayer = new Sprite();
			_flashApplication.addChild(_shadingLayer);
		}

		/**
		 * Adds layer to the game display
		 * @param layer Layer to be added
		 */
		public static function addLayer(layer:RetrocamelLayer):void {
			if (layer is RetrocamelLayerFlash) {
				addLayerAt(layer, _flashApplication.numChildren);
			}
		}

		/**
		 * Adds layer to the game display
		 * @param layer Layer to be added
		 * @param index Index at which the layer should be added
		 */
		public static function addLayerAt(layer:RetrocamelLayer, index:int = 0):void {
			if (layer is RetrocamelLayerFlash) {
				_flashApplication.addChildAt(RetrocamelLayerFlash(layer).layer, index);
				_flashLayers.push(layer as RetrocamelLayerFlash);
			}

			RetrocamelWindowsManager.pushLayersToFront();

			if (_tooltip) {
				_flashApplication.setChildIndex(_tooltip, _flashApplication.numChildren - 1);
			}

			_flashApplication.setChildIndex(_shadingLayer, _flashApplication.numChildren - 1);
		}

		/**
		 * Removes layer from the display
		 * @param layer Layer to be removed from the game's display
		 */
		public static function removeLayer(layer:RetrocamelLayer):void {
			if (layer is RetrocamelLayerFlash) {
				_flashApplication.removeChild(RetrocamelLayerFlash(layer).layer);
			}
		}

		retrocamel_int static function pullLayerToFront(layer:RetrocamelLayer):void {
			if (layer is RetrocamelLayerFlash) {
				_flashApplication.setChildIndex(RetrocamelLayerFlash(layer).layer, _flashApplication.numChildren - 1);
			}
		}

		/**
		 * Blocks all input on the game layers, primarily used by rWindows
		 */
		retrocamel_int static function block():void {
			for each(var flashLayer:RetrocamelLayerFlash in _flashLayers) {
				flashLayer.inputEnabled = false;
			}
		}

		//noinspection JSUnusedGlobalSymbols

		/**
		 * Enables the input on the game layers, primarily used by rWindows
		 */
		retrocamel_int static function unblock():void {
			for each(var flashLayer:RetrocamelLayerFlash in _flashLayers) {
				flashLayer.inputEnabled = true;
			}
		}

		retrocamel_int static function onStageResize(e:Event):void {
			RetrocamelCore.onStageResized();
			RetrocamelWindowsManager.onStageResize();

			var hSpacing:Number = 0;
			var vSpacing:Number = 0;

			if (_scaleToFit) {
				var maxScaleX:Number = _flashStage.stageWidth / RetrocamelCore.settings.gameWidth;
				var maxScaleY:Number = _flashStage.stageHeight / RetrocamelCore.settings.gameHeight;

				var maxScale:Number = Math.min(maxScaleX, maxScaleY);
				if (_scaleToInteger) {
					maxScale = Math.floor(maxScale);
				}

				setScale(maxScale, maxScale);

				var newWidth:Number = maxScale * RetrocamelCore.settings.gameWidth;
				var newHeight:Number = maxScale * RetrocamelCore.settings.gameHeight;

				hSpacing = (_flashStage.stageWidth - newWidth) / 2;
				vSpacing = (_flashStage.stageHeight - newHeight) / 2;
			} else {
				_shadingLayer.graphics.clear();
				setScale(1, 1);

				hSpacing = (_flashStage.stageWidth - RetrocamelCore.settings.gameWidth) / 2;
				vSpacing = (_flashStage.stageHeight - RetrocamelCore.settings.gameHeight) / 2;
			}

			setOffset(hSpacing, vSpacing);

			_shadingLayer.graphics.clear();
			_shadingLayer.graphics.beginFill(0);
			_shadingLayer.graphics.drawRect(-hSpacing, -vSpacing, _flashStage.stageWidth, vSpacing);
			_shadingLayer.graphics.beginFill(0);
			_shadingLayer.graphics.drawRect(-hSpacing, RetrocamelCore.settings.gameHeight, _flashStage.stageWidth, vSpacing);
			_shadingLayer.graphics.beginFill(0);
			_shadingLayer.graphics.drawRect(-hSpacing, 0, hSpacing, RetrocamelCore.settings.gameHeight);
			_shadingLayer.graphics.beginFill(0);
			_shadingLayer.graphics.drawRect(RetrocamelCore.settings.gameWidth, 0, hSpacing, RetrocamelCore.settings.gameHeight);
			_shadingLayer.graphics.endFill();
		}

		public static function setOffset(x:Number, y:Number):void {
			_offsetX = x;
			_offsetY = y;

			_flashApplication.x = _offsetX;
			_flashApplication.y = _offsetY;
		}

		public static function setScale(scaleX:Number, scaleY:Number):void {
			_scaleX = scaleX;
			_scaleY = scaleY;

			_flashApplication.scaleX = _scaleX;
			_flashApplication.scaleY = _scaleY;
		}

		public static function setSmoothing(smoothing:Boolean):void {
			if (_smoothing != smoothing) {
				_smoothing = smoothing;

				_eventDispatcher.dispatchEvent(new RetrocamelEvent(RetrocamelEvent.SMOOTHING_CHANGED));
			}
		}

		public static function addEventListener(eventType:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			_eventDispatcher.addEventListener(eventType, listener, useCapture, priority, useWeakReference)
		}

		public static function removeEventListener(eventType:String, listener:Function, useCapture:Boolean = false):void {
			_eventDispatcher.removeEventListener(eventType, listener, useCapture);
		}

		public static function toggleFullScreen():void {
			try {
				if (_flashStage.displayState === StageDisplayState.NORMAL) {
					_flashStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE
				} else {
					_flashStage.displayState = StageDisplayState.NORMAL;
				}
			} catch (e:Error) {
				trace(e.message);
				// Silently consume
			}
		}
	}
}