package game.states {
	import game.global.Sfx;
	import game.global.pre.Pre;

	import net.retrocade.constants.KeyConst;
	import net.retrocade.retrocamel.components.RetrocamelStateBase;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.core.retrocamel_int;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeScreen;
	import net.retrocade.retrocamel.locale.RetrocamelLocale;

	use namespace retrocamel_int;

	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	public class TStateLang extends RetrocamelStateBase {
		/****************************************************************************************************************/
		/**                                                                                                  VARIABLES  */
		/****************************************************************************************************************/

		private var _langText:RetrocamelBitmapText;
		private var _startupFunction:Function;


		/****************************************************************************************************************/
		/**                                                                                                  FUNCTIONS  */
		/****************************************************************************************************************/

		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Creation
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		private var selected:TextButton;
		private var buttons:Array = [];
		private var stop:Boolean = false;

		public function TStateLang(startupFunction:Function) {
			_startupFunction = startupFunction;

			_langText = new RetrocamelBitmapText("", Pre.c64font);
			_langText.letterSpace = 0;
			_langText.lineSpace = 0;
			_langText.color = 0xA5A5FF;
			_langText.text = RetrocamelLocale.get(RetrocamelLocale.defaultLanguage, 'choseLanguage');
			_langText.y = 88;

			for (var i:uint = 0, l:uint = S().languages.length; i < l; i++) {
				var button:TextButton = new TextButton(onButtonClick, onButtonOver, null, S().languagesNames[i], S().languages[i]);
				button.y = 104 + i * 8;
				TStatePreload.parent.addChild(button);
				buttons.push(button);
			}

			selected = buttons[0];
			selected.select();

			TStatePreload.parent.addChild(_langText);
		}

		override public function update():void {
			if (stop) {
				return;
			}

			var index:int;
			if (RetrocamelInputManager.isKeyHit(KeyConst.DOWN)) {
				index = buttons.indexOf(selected);
				index = (index + 1) % buttons.length;
				selected.deselect();
				selected = buttons[index];
				selected.select();
				Sfx.sfxRollOver.play();

			} else if (RetrocamelInputManager.isKeyHit(KeyConst.UP)) {
				Sfx.sfxRollOver.play();
				index = buttons.indexOf(selected);
				index = index - 1;

				if (index < 0) {
					index += buttons.length;
				}

				selected.deselect();
				selected = buttons[index];
				selected.select();

			} else if (RetrocamelInputManager.isKeyHit(KeyConst.ENTER)) {
				Sfx.sfxClick.play();
				RetrocamelEffectFadeScreen.makeOut().duration(1000).callback(onFaded).run();

				RetrocamelLocale.selected = selected.data.code;

				TStatePreload.parent.mouseChildren = false;

				stop = true;
			}

			_langText.text = RetrocamelLocale.get(selected.data.code as String, 'choseLanguage');
			center();
		}

		private function center():void {
			var length:uint = (26 - _langText.text.length) / 2 | 0;
			_langText.x = length * 8;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Events
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		private function onFaded():void {
			_startupFunction();
		}

		private function onButtonClick(data:RetrocamelButton):void {
			RetrocamelEffectFadeScreen.makeOut().duration(1000).callback(onFaded).run();

			RetrocamelLocale.selected = data.data.code;
			TStatePreload.parent.mouseChildren = false;
			Sfx.sfxClick.play();
			stop = true;
		}

		private function onButtonOver(data:TextButton):void {
			_langText.text = RetrocamelLocale.get(data.data.code as String, 'choseLanguage');

			center();
			selected.deselect();
			selected = data;
			selected.select();

			Sfx.sfxRollOver.play();
		}
	}
}

import flash.events.MouseEvent;

import game.global.pre.Pre;

import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
import net.retrocade.retrocamel.display.flash.RetrocamelButton;
import net.retrocade.utils.UtilsGraphic;

class TextButton extends RetrocamelButton {
	public var txt:RetrocamelBitmapText;

	public function TextButton(clickCallback:Function, rollOverCallback:Function = null, rollOutCallback:Function = null, text:String = "", code:String = "") {
		super(clickCallback, rollOverCallback, rollOutCallback, true);

		txt = new RetrocamelBitmapText("", Pre.c64font);
		txt.letterSpace = 0;
		txt.lineSpace = 0;
		txt.color = 0xA5A5FF;
		txt.text = text;

		var length:uint = (26 - txt.text.length) / 2 | 0;
		txt.x = length * 8;

		data = {
			code: code
		};

		UtilsGraphic.draw(graphics).rectFill(0, 0, 208, txt.height - 1, 0, 0);

		addChild(txt);
	}

	override protected function onRollOver(e:MouseEvent):void {
		select();

		if (rollOverCallback != null) {
			if (rollOverCallback.length) {
				rollOverCallback(this);
			}
			else {
				rollOverCallback();
			}
		}
	}

	public function select():void {
		UtilsGraphic.clear(graphics).rectFill(0, 0, 208, txt.height - 1, 0xA5A5FF);
		txt.color = 0x4242E7;
	}

	public function deselect():void {
		UtilsGraphic.clear(graphics).rectFill(0, 0, 208, txt.height - 1, 0, 0);
		txt.color = 0xA5A5FF;

	}

	override protected function onRollOut(e:MouseEvent):void {
		if (rollOutCallback != null) {
			if (rollOutCallback.length) {
				rollOutCallback(this);
			}
			else {
				rollOutCallback();
			}
		}
	}

	override protected function onClick(e:MouseEvent):void {
		if (_clickDisabled) {
			return;
		}

		if (clickCallback.length) {
			clickCallback(this);
		}
		else {
			clickCallback();
		}

		if (stage) {
			stage.focus = stage;
		}
	}

}