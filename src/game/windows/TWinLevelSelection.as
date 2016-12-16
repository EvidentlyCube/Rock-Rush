package game.windows {
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	import game.global.Make;
	import game.global.Score;
	import game.global.levels.LevelList;
	import game.global.levels.LevelManager;
	import game.global.levels.LevelPreviewRenderer;
	import game.global.pre.Pre;
	import game.states.TStateGame;

	import net.retrocade.constants.KeyConst;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.core.RetrocamelWindowsManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.flash.RetrocamelPreciseGrid9;
	import net.retrocade.retrocamel.display.flash.RetrocamelWindowFlash;
	import net.retrocade.retrocamel.display.global.RetrocamelTooltip;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeScreen;
	import net.retrocade.retrocamel.locale._;
	import net.retrocade.utils.UtilsDisplay;
	import net.retrocade.utils.UtilsGraphic;

	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	public class TWinLevelSelection extends RetrocamelWindowFlash {

		protected var _background:RetrocamelPreciseGrid9;
		protected var _header:RetrocamelBitmapText;
		protected var _score:RetrocamelBitmapText;
		protected var _preview:Bitmap;
		protected var _close:RetrocamelButton;
		protected var _submit:RetrocamelButton;

		protected var _submitModal:Shape;

		public function TWinLevelSelection() {
			this._blockUnder = true;
			this._pauseGame = false;

			_background = RetrocamelPreciseGrid9.getGrid("window", true);
			_header = Make().text(_("selectLevel"), 0xFFFFFF, 2);
			_score = Make().text("", 0xFFFFFF, 2);
			_close = Make().button(onClose, _("Close"));
			_submit = Make().button(onSubmit, _("Submit"));
			_preview = new Bitmap();

			_background.width = S().gameWidth - 40;
			_background.height = S().gameHeight - 40;
			_header.y = 8;
			_header.x = (_background.width - _header.width) / 2 | 0;
			_close.right = _background.right - 20;
			_close.bottom = _background.bottom - 8;
			_submit.x = 20;
			_submit.bottom = _background.bottom - 8;

			_score.addShadow(1);
			_header.addShadow(1);
			_close.filters = _submit.filters = Pre.DROP_SHADOW_FILTER;

			addChild(_background);
			addChild(_header);
			addChild(_preview);
			addChild(_score);
			addChild(_close);

			generateLevelButtons();

			setPreview(1);
			show();
			centerWindow();
		}

		private function generateLevelButtons():void {
			const GRID_WIDTH:uint = S().gameWidth - 40;

			const BUTTON_WIDTH:uint = 30;
			const BUTTON_HEIGHT:uint = 30;
			const BUTTON_SPACE:uint = 2;

			const LEVELS_PER_ROW:uint = LevelList.levelCount() / 2 - 1 | 0;
			const ROW_WIDTH:uint = (LEVELS_PER_ROW + 1) * (BUTTON_WIDTH + BUTTON_SPACE) - BUTTON_SPACE;

			const START_X:Number = (GRID_WIDTH - ROW_WIDTH) / 2 | 0;
			const START_Y:Number = _header.y + _header.height + 10;

			var lastX:Number = START_X;
			var lastY:Number = START_Y;


			for (var i:int = 0; i < LevelList.levelCount(); i++) {
				var levelString:String = (Score.isCompleted(i + 1) ? "•" : "◦");
				var button:RetrocamelButton = Make().button(playLevel, levelString, BUTTON_WIDTH);
				button.filters = [new DropShadowFilter(2, 45, 0, 1, 0, 0)];
				button.data.levelIndex = i + 1;
				button.data.txt.x += 1;
				button.data.txt.y -= 2;
				button.data.grid9.height = BUTTON_HEIGHT;

				if (Score.isCompleted(i + 1)) {
					button.data.txt.color = 0x00FF00;
				} else {
					button.data.txt.color = 0xFF6666;
				}

				button.addEventListener(MouseEvent.ROLL_OVER, onButtonRolledOver);
				addChild(button);

				button.x = lastX;
				button.y = lastY;

				if (i == (LevelList.levelCount() / 2 - 1 | 0)) {
					lastX = START_X;
					lastY += button.height + BUTTON_SPACE;
				} else {
					lastX += button.width + BUTTON_SPACE;
				}
			}
		}

		private function playLevel(button:RetrocamelButton):void {
			RetrocamelWindowsManager.removeAllWindowsButLast();
			LevelManager.currentRoom = button.data.levelIndex as int;

			mouseChildren = false;
			RetrocamelEffectFadeFlash.make(this).alpha(1, 0).duration(500).run();
			RetrocamelEffectFadeScreen.makeOut().duration(500).callback(onLevelPlayFade).run();
		}

		private function onLevelPlayFade():void {
			TStateGame.instance.setToMe();
			LevelManager.startGame();
			hide();
		}

		private function onClose():void {
			if (mouseEnabled) {
				mouseEnabled = false;
				mouseChildren = false;
				RetrocamelEffectFadeFlash.make(this).alpha(1, 0).duration(250).callback(onHide).run();
			}
		}

		private function onHide():void {
			hide();
		}

		private function setPreview(levelIndex:int):void {
			_preview.bitmapData = LevelPreviewRenderer.getLevelPreview(levelIndex);

			UtilsDisplay.scaleDisplayObjectDown(_preview, _background.width - 20, 190, UtilsDisplay.SHOW_ALL);

			_preview.x = (_background.width - _preview.width) / 2 | 0;
			_preview.y = 130;


			if (Score.isCompleted(levelIndex)) {
				_score.color = 0x00FF00;
			} else {
				_score.color = 0xFF0000;
			}

			_score.text = _(
				"levelSeletionScore",
				_("lvl" + levelIndex),
				Score.isCompleted(levelIndex) ?
					_("levelCompleted", Score.getScore(levelIndex)) :
					_("levelUncompleted")
			);
			_score.x = (_background.width - _score.width) / 2 | 0;
			_score.y = _preview.y + _preview.height + 10;
		}

		private function onButtonRolledOver(event:MouseEvent):void {
			var levelIndex:int = event.currentTarget.data.levelIndex;
			setPreview(levelIndex);
		}

		private function onSubmit():void {
			mouseChildren = false;

			_submitModal = new Shape();
			UtilsGraphic.clear(_submitModal).rectFill(-x, -y, S().gameWidth, S().gameHeight, 0, 0.75);

			RetrocamelTooltip.hide();

			addChild(_submitModal);
		}

		override public function show():void {
			super.show();

			mouseEnabled = false;
			mouseChildren = false;

			RetrocamelEffectFadeFlash.make(this).alpha(0, 1).duration(250).callback(callbackEnableMouse).run();
		}

		override public function update():void {
			if (RetrocamelInputManager.isKeyHit(KeyConst.ESCAPE)) {
				onClose();
			}

			super.update();
		}
	}
}