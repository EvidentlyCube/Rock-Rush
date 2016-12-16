package game.objects {
	import game.global.Game;
	import game.global.Gfx;
	import game.global.Score;
	import game.global.levels.Level;
	import game.global.levels.LevelManager;
	import game.windows.TWinMessage;

	import net.retrocade.constants.KeyConst;
	import net.retrocade.helpers.RetrocamelScrollAssist;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.global.RetrocamelEventsQueue;
	import net.retrocade.retrocamel.global.RetrocamelSimpleSave;
	import net.retrocade.retrocamel.locale._;

	public class TPlayer extends TGameObject {
		private static var __gfx:Array;

		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 144, 12, 12);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 0, 144, 12, 12);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 12, 144, 12, 12);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 72, 156, 12, 12);
			__gfx[4] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 84, 156, 12, 12);
			__gfx[5] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 96, 156, 12, 12);
			__gfx[6] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 108, 156, 12, 12);
			__gfx[7] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 120, 156, 12, 12);
			__gfx[8] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 132, 156, 12, 12);
			__gfx[9] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 60, 156, 12, 12);
			__gfx[10] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 48, 156, 12, 12);
			__gfx[11] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 36, 156, 12, 12);
			__gfx[12] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 24, 156, 12, 12);
			__gfx[13] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 12, 156, 12, 12);
			__gfx[14] = RetrocamelBitmapManager.getBDExt(Gfx.tilesetClass, 0, 156, 12, 12);
		}

		private var _animState:uint = 0;
		private var _frame:uint = 0;
		private var _frameTimer:uint = 0;
		private var _dir:int = 0;

		private var _animIsMoving:Boolean = false;

		public var invincible:Boolean = false;

		public var blocked:Boolean = false;

		public function TPlayer(x:uint, y:uint) {
			this.prevX = this.x = x;
			this.prevY = this.y = y;

			resetSkills();

			addSelf();

			_gfx = __gfx[0];

			addAtDefault(0);

			Level.instance.player = this;
		}

		override public function update():void {
			/*if (!rInput.isCtrlDown && rInput.isKeyDown(Key.SPACE)){
			 rInput.flushAll();

			 if (Score.powerup < 6)
			 Score.powerup++;
			 resetSkills();
			 }

			 if (rInput.isCtrlDown && rInput.isKeyDown(Key.SPACE)){
			 rInput.flushAll();

			 if (Score.powerup > 0)
			 Score.powerup--;
			 resetSkills();
			 }*/

			if (Level.instance.completed == false && RetrocamelInputManager.isKeyHit(Game.keyRestart)) {
				LevelManager.playerDied(true);
				return;
			}

			if (RetrocamelInputManager.isKeyHit(KeyConst.P) && S().debug) {
				RetrocamelInputManager.flushAll();

				LevelManager.levelCompleted();
			}

			if (RetrocamelInputManager.isShiftDown() && RetrocamelInputManager.isMouseHit() && S().debug) {
				removeSelf();
				x = ((RetrocamelInputManager.mouseX + RetrocamelScrollAssist.x * 2) / 24 | 0) * 12;
				y = ((RetrocamelInputManager.mouseY + RetrocamelScrollAssist.y * 2) / 24 | 0) * 12;
				extKill(0, 0);
				addSelf();
			}

			if (RetrocamelInputManager.isKeyHit(KeyConst.EQUAL) && S().debug) {
				RetrocamelEventsQueue.add(C.EVENT_DIAMOND_COLLECTED);
				Score.diamondsGot++;
			}

			if (RetrocamelInputManager.isKeyHit(KeyConst.BACKSPACE) && S().debug) {
				makeInvincible();
			}

			if (RetrocamelInputManager.isKeyHit(KeyConst.DELETE) && S().debug) {
				LevelManager.DEBUG_ResetLevelState();
			}


			if (Level.instance.completed == false && !movementWait && !blocked) {
				_animIsMoving = true;

				if (RetrocamelInputManager.isKeyDown(Game.keyLeft)) {
					moveOrTouch(-1, 0);
					_dir = -1;

				} else if (RetrocamelInputManager.isKeyDown(Game.keyRight)) {
					moveOrTouch(1, 0);
					_dir = 1;

				} else if (RetrocamelInputManager.isKeyDown(Game.keyUp)) {
					moveOrTouch(0, -1);

				} else if (RetrocamelInputManager.isKeyDown(Game.keyDown)) {
					moveOrTouch(0, 1);

				} else {
					_animIsMoving = false;
				}
			}

			super.update();

			RetrocamelScrollAssist.instance.scrollTo(_x - (_x - prevX) * (movementWait / movementSpeed), _y - (_y - prevY) * (movementWait / movementSpeed));

			if (!movementWait && Score.powerup < 2 && extHasFlag(CAN_KILL_BY_FALLING, 0, -1, false)) {
				kill(false);
			}

			if (_animIsMoving || Level.instance.completed == true) {
				if (_animState != 2) {
					_animState = 2;
					_frame = 0;
					_frameTimer = 0;
				}

				_frameTimer++;

				if (_frameTimer == 7) {
					_frameTimer = 0;
					_frame = (_frame + 1) % 6;
				}

				_gfx = __gfx[3 + _frame + (_dir == -1 ? 6 : 0)];

			} else {
				if (extHasFlag(CAN_KILL_BY_FALLING, 0, -1, false)) {
					if (_animState != 1) {
						_animState = 1;
						_frame = 0;
						_frameTimer = 0;
					}

					_frameTimer++;

					if (_frameTimer == 25) {
						_frameTimer = 0;
						_frame = 1 - _frame;
					}

					_gfx = __gfx[1 + _frame];

				} else {
					_animState = 0;
					_frame = 0;
					_gfx = __gfx[0];
				}
			}
		}

		protected function moveOrTouch(tx:int, ty:int):void {
			if (RetrocamelSimpleSave.read('firstPlay', true)) {
				RetrocamelSimpleSave.write('firstPlay', false);

				TWinMessage.showMessage(_("megahelp"));
				return;
			}

			if (RetrocamelInputManager.isKeyDown(Game.keyGrab) && Score.powerup > 2) {
				extTouched(tx, ty, tx, ty);

			} else {
				move(tx, ty);
			}
		}

		override public function move(tx:int, ty:int):Boolean {
			if (super.move(tx, ty)) {
				removeSelfFrom(prevX, prevY);
				return true;
			}

			return false;
		}

		override public function touched(object:TGameObject, tx:int, ty:int):Boolean {
			if (object.hasFlag(CAN_KILL_BY_FALLING) && object.isFalling && ty == 1 && !invincible) {
				kill();
				return true;

			} else if (object.hasFlag(CAN_KILL_BY_TOUCH) && !invincible) {
				kill();
				return true;
			}

			return false;
		}

		override public function walkedOn(object:TGameObject, tx:int, ty:int):void {
			if (object.hasFlag(CAN_KILL_BY_FALLING) && object.isFalling && ty == 1 && !invincible) {
				kill();
			}
			else {
				throw new Error("INVALID");
			}
		}

		override public function canWalkInto(object:TGameObject, tx:int, ty:int):Boolean {
			return object.hasFlag(CAN_KILL_BY_FALLING) && object.isFalling && !invincible;
		}

		override public function kill(silent:Boolean = false):void {
			if (Level.instance.completed == true) {
				return;
			}

			super.kill(silent);

			setHigher();
			explodeNine();

			LevelManager.playerDied();
		}


		public function resetSkills():void {
			flags = CAN_COLLECT_CRYSTALS | CAN_GO_THROUGH_DOORS | CAN_SURVIVE_PLASMA;

			if (Score.powerup > 0) {
				flags |= CAN_EAT_DIRT;
			}

			if (Score.powerup > 3) {
				flags |= CAN_PUSH_ROCKS;
			}

			if (Score.powerup > 4) {
				flags |= CAN_EAT_HARD_DIRT;
			}

			if (Score.powerup > 5) {
				flags |= CAN_CLEAN_STONES;
			}
		}

		public function makeInvincible():void {
			flags |= CAN_SURVIVE_EXPLOSION;
			invincible = true;
		}
	}
}