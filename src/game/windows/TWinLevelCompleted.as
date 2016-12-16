package game.windows {
	import flash.display.BlendMode;

	import game.global.Make;
	import game.global.Score;
	import game.global.levels.Level;
	import game.global.levels.LevelManager;
	import game.global.pre.Pre;

	import net.retrocade.constants.KeyConst;
	import net.retrocade.helpers.RetrocamelScrollAssist;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.flash.RetrocamelPreciseGrid9;
	import net.retrocade.retrocamel.display.flash.RetrocamelSprite;
	import net.retrocade.retrocamel.display.flash.RetrocamelWindowFlash;
	import net.retrocade.retrocamel.effects.RetrocamelEasings;
	import net.retrocade.retrocamel.effects.RetrocamelEffectCircleMask;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.effects.RetrocamelEffectMusicFade;
	import net.retrocade.retrocamel.locale._;

	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	public class TWinLevelCompleted extends RetrocamelWindowFlash {
		public static function show():void {
			new TWinLevelCompleted();
		}


		private var _header:RetrocamelBitmapText;
		private var _levelName:RetrocamelBitmapText;
		private var _scoring:RetrocamelSprite;
		private var _background:RetrocamelPreciseGrid9;
		private var _nextLevelButton:RetrocamelButton;

		private var _isClosing:Boolean = false;

		public function TWinLevelCompleted() {
			const PADDING:uint = 5;

			this._blockUnder = true;
			this._pauseGame = false;

			_background = RetrocamelPreciseGrid9.getGrid("window", true);
			_header = Make().text(_("Level completed"), 0xFFFFFF, 2);
			_levelName = Make().text(_("lvl" + LevelManager.currentRoom), 0xFFFFFF, 2);
			_scoring = getScoreSprite(400 - PADDING * 6, PADDING);
			_nextLevelButton = Make().button(onClose, _("playNextLevel"));

			_background.width = 400;
			_background.height = 340;

			_header.addShadow(1);
			_levelName.addShadow(1);

			addChild(_background);
			addChild(_header);
			addChild(_levelName);
			addChild(_scoring);
			addChild(_nextLevelButton);

			_header.alignCenterParent();
			_levelName.alignCenterParent();
			_scoring.alignCenterParent();
			_nextLevelButton.alignCenterParent();
			_header.y = PADDING;
			_levelName.y = _header.bottom + PADDING;
			_scoring.y = _levelName.bottom + PADDING;
			_nextLevelButton.bottom = _background.bottom - PADDING * 2;

			show();

			centerWindow();

			RetrocamelEffectFadeFlash.make(this).alpha(0, 1).duration(250);

			_nextLevelButton.filters = Pre.DROP_SHADOW_FILTER;

			blendMode = BlendMode.LAYER;
		}

		private function getScoreSprite(width:Number, padding:Number):RetrocamelSprite {
			var container:RetrocamelSprite = new RetrocamelSprite();
			var columnTitles:RetrocamelBitmapText = getScoreText(_("levelFinishScoreColumnTitles"));
			var columnCollected:RetrocamelBitmapText = getScoreText(_("levelFinishScoreColumnValues", Level.instance.collectedDiamonds, Level.instance.collectedAdditionalDiamonds, Level.instance.timeLeft));
			var columnX:RetrocamelBitmapText = getScoreText(_("levelFinishScoreColumnX"));
			var columnValues:RetrocamelBitmapText = getScoreText(_("levelFinishScoreColumnValues", Level.instance.diamondValue, Level.instance.diamondExtraValue, Level.instance.timeValue));
			var columnEquals:RetrocamelBitmapText = getScoreText(_("levelFinishScoreColumnEquals"));
			var columnTotals:RetrocamelBitmapText = getScoreText(_("levelFinishScoreColumnTotalValues",
				Level.instance.collectedDiamonds * Level.instance.diamondValue,
				Level.instance.collectedAdditionalDiamonds * Level.instance.diamondExtraValue,
				Level.instance.timeLeft * Level.instance.timeValue,
				Score.score
			));

			container.addChild(columnTitles);
			container.addChild(columnCollected);
			container.addChild(columnX);
			container.addChild(columnValues);
			container.addChild(columnEquals);
			container.addChild(columnTotals);

			columnTitles.align = RetrocamelBitmapText.ALIGN_LEFT;
			columnCollected.align = RetrocamelBitmapText.ALIGN_RIGHT;
			columnValues.align = RetrocamelBitmapText.ALIGN_RIGHT;
			columnTotals.align = RetrocamelBitmapText.ALIGN_RIGHT;

			columnTotals.right = width;
			columnEquals.right = columnTotals.x - padding;
			columnValues.right = columnEquals.x - padding;
			columnX.right = columnValues.x - padding;
			columnCollected.right = columnX.x - padding;

			return container;
		}

		private static function getScoreText(text:*):RetrocamelBitmapText {
			var bitext:RetrocamelBitmapText = Make().text(text, 0xFFFFFF, 2);
			bitext.addShadow(1);

			return bitext;
		}

		private function onClose():void {
			_isClosing = true;

			mouseChildren = false;

			RetrocamelEffectFadeFlash.make(this).alpha(1, 0).duration(300).callback(fadeOutCallback).run();
		}

		private function fadeOutCallback():void {
			RetrocamelEffectCircleMask.make()
				.x(Level.instance.player.x * 2 - RetrocamelScrollAssist.x * 2 + S().tileGridTileWidth)
				.y(Level.instance.player.y * 2 - RetrocamelScrollAssist.y * 2 + S().tileGridTileHeight)
				.duration(1200).callback(LevelManager.levelCompleted).easing(RetrocamelEasings.cubicOut).run();

			RetrocamelEffectMusicFade.make(1).fadeFrom(0).duration(1000).run();
			RetrocamelSoundManager.resumeMusic();

			hide();
		}

		override public function update():void {
			if (!_isClosing && RetrocamelInputManager.isKeyDown(KeyConst.SPACE)) {
				onClose();
			}
		}
	}
}