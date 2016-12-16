package game.global {

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	import game.global.pre.Pre;
	import game.states.TStateLang;
	import game.states.TStatePreload;

	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.RetrocamelDisplayManager;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashBlit;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;

	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	public dynamic class Preloader extends MovieClip {
		public static var loaderLayer:RetrocamelLayerFlashSprite;
		public static var loaderLayerBG:RetrocamelLayerFlashBlit;
		public static var percent:Number = 0;

		private var _afterAd:Boolean = false;
		private var _afterLoad:Boolean = false;

		public function Preloader() {
			addEventListener(Event.ENTER_FRAME, init);
		}

		public function startup():void {
			loaderLayer.removeLayer();
			loaderLayerBG.removeLayer();

			stage.focus = stage;

			var mainClass:Class = Class(getDefinitionByName("game.global.CoreStarter"));
			addChild(new mainClass() as DisplayObject);
			stage.frameRate = 60;
		}

		private function onPreloaded():void {
			gotoAndStop(2);

			dispatchEvent(new Event("gameloaded", false, false));

			_afterLoad = true;

			if (_afterAd) {
				initLanguageSelection();
			}
		}

		private function initLanguageSelection():void {
			if (!_afterLoad) {
				_afterAd = true;
				return;
			}

			loadLanguagesState();
		}

		private function loadLanguagesState():void {
			RetrocamelCore.setState(new TStateLang(startup));
		}

		private function soundMakeFinished():void {
			stage.frameRate = 60;
		}

		private function init(e:Event):void {
			if (!stage) {
				return;
			}

			removeEventListener(Event.ENTER_FRAME, init);

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;

			Pre.preCoreInit();
			RetrocamelCore.initFlash(stage, this, S(), Make());
			RetrocamelDisplayManager.scaleToFit = true;
			RetrocamelDisplayManager.scaleToInteger = true;
			Pre.init();

			Sfx.initialize();
			Sfx.startGenerating(soundMakeFinished);


			loaderLayerBG = new RetrocamelLayerFlashBlit();
			loaderLayer = new RetrocamelLayerFlashSprite();
			loaderLayerBG.setScale(2, 2);

			RetrocamelCore.setState(new TStatePreload(onPreloaded));

			_afterAd = true;

			addEventListener(Event.ENTER_FRAME, checkFrame);
		}

		private function checkFrame(e:Event):void {
			var newPercent:Number = stage.loaderInfo.bytesLoaded * 100 / stage.loaderInfo.bytesTotal;
			percent = Math.min(percent + 5, newPercent);

			if (percent >= 100) {
				removeEventListener(Event.ENTER_FRAME, checkFrame);
			}
		}

	}

}