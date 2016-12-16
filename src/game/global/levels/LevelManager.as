package game.global.levels {
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	import game.global.*;
	import game.objects.TActiveAmoeba;
	import game.objects.TActiveBlob;
	import game.objects.TActiveBomb;
	import game.objects.TActiveBoulder;
	import game.objects.TActiveCrystaler;
	import game.objects.TActiveDiamond;
	import game.objects.TActiveSlime;
	import game.objects.TEscButton;
	import game.objects.TGameObject;
	import game.objects.THud;
	import game.objects.TInformator;
	import game.objects.TKey;
	import game.objects.TPlayer;
	import game.objects.TTileBrickWall;
	import game.objects.TTileBrickWallGrowing;
	import game.objects.TTileDirt;
	import game.objects.TTileDirtItem;
	import game.objects.TTileDoor;
	import game.objects.TTileExit;
	import game.objects.TTileMagicWall;
	import game.objects.TTileSteelWall;
	import game.states.TStateTitle;
	import game.states.TStateWin;

	import net.retrocade.helpers.RetrocamelScrollAssist;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeScreen;

	public class LevelManager {
		public static var currentRoom:uint = 1;
		private static var _levels:Dictionary = new Dictionary();
		private static var _levelsSaved:Array = [];
		private static var _playerNewEdge:uint = uint.MAX_VALUE;
		private static var _playerNewOffset:uint = 0;
		private static var _playerPower:uint = 0;
		private static var ignoreRestarts:Boolean = false;
		private static var _qfr:FileReference;

		public static function startGame():void {
			playLevel(currentRoom);
		}

		public static function restartLevel():void {
			Score.powerup = _playerPower;
			playLevel(currentRoom);
		}

		public static function levelCompleted():void {
			if (!_qfr) {
				Score.setScore(currentRoom, Score.score);
			}

			Level.instance.completed = false;

			var completed:Boolean = Score.gameCompleted();

			Score.completed[currentRoom] = true;
			Score.saveData();

			if (!completed && Score.gameCompleted()) {
				TStateWin.set();
				return;

			} else if (completed) {
				TStateTitle.instance.setToMe();
				return;
			}

			currentRoom = Score.getNextUncompleted(currentRoom);

			playLevel(currentRoom);
		}

		/*private static function loadLevelFromState(id:uint):void{
		 resetLevel();

		 loadLevelState(_levelsSaved[id]);

		 for each(var i:TGameObject in Level.instance.level.getArray()){
		 if (i) i.recalculate();
		 }
		 }*/

		public static function loadLevelFromScratch(id:uint):void {
			var level:XML = LevelList.getLevelXml(id);
			var item:XML;
			for each(item in level.level.children()) {
				switch (toID(item.@tx, item.@ty)) {
					case(1):
						new TTileDirt(item.@x, item.@y, 0);
						break;
					case(2):
						new TTileDirt(item.@x, item.@y, 1);
						break;

					case(11):
						new TTileDirtItem(item.@x, item.@y, 0, 0);
						break;
					case(12):
						new TTileDirtItem(item.@x, item.@y, 1, 0);
						break;
					case(21):
						new TTileDirtItem(item.@x, item.@y, 0, 1);
						break;
					case(22):
						new TTileDirtItem(item.@x, item.@y, 1, 1);
						break;
					case(31):
						new TTileDirtItem(item.@x, item.@y, 0, 2);
						break;
					case(32):
						new TTileDirtItem(item.@x, item.@y, 1, 2);
						break;

					case(3):
						new TTileBrickWall(item.@x, item.@y);
						break;
					case(13):
						new TTileBrickWallGrowing(item.@x, item.@y, -1, 0);
						break;
					case(23):
						new TTileBrickWallGrowing(item.@x, item.@y, 1, 0);
						break;
					case(33):
						new TTileBrickWallGrowing(item.@x, item.@y, 0, 1);
						break;
					case(43):
						new TTileBrickWallGrowing(item.@x, item.@y, 0, -1);
						break;

					case(4):
						new TTileSteelWall(item.@x, item.@y, 0);
						break;
					case(14):
						new TTileSteelWall(item.@x, item.@y, 1);
						break;
					case(24):
						new TTileSteelWall(item.@x, item.@y, 2);
						break;

					case(5):
						new TTileMagicWall(item.@x, item.@y, false);
						break;
					case(15):
						new TTileMagicWall(item.@x, item.@y, true);
						break;

					case(6):
						new TTileDoor(item.@x, item.@y, 0);
						break;
					case(16):
						new TTileDoor(item.@x, item.@y, 1);
						break;
					case(26):
						new TTileDoor(item.@x, item.@y, 2);
						break;
					case(36):
						new TTileDoor(item.@x, item.@y, 3);
						break;

					case(50):
						new TPlayer(item.@x, item.@y);
						break;
					case(51):
						new TActiveBoulder(item.@x, item.@y);
						break;
					case(61):
						new TActiveBomb(item.@x, item.@y);
						break;
					case(52):
						new TActiveDiamond(item.@x, item.@y);
						break;
					case(53):
						new TTileExit(item.@x, item.@y);
						break;

					case(54):
						new TActiveBlob(item.@x, item.@y, 1, 0);
						break;
					case(64):
						new TActiveBlob(item.@x, item.@y, 0, -1);
						break;
					case(74):
						new TActiveBlob(item.@x, item.@y, -1, 0);
						break;
					case(84):
						new TActiveBlob(item.@x, item.@y, 0, 1);
						break;

					case(55):
						new TActiveCrystaler(item.@x, item.@y, 1, 0);
						break;
					case(65):
						new TActiveCrystaler(item.@x, item.@y, 0, -1);
						break;
					case(75):
						new TActiveCrystaler(item.@x, item.@y, -1, 0);
						break;
					case(85):
						new TActiveCrystaler(item.@x, item.@y, 0, 1);
						break;

					case(56):
						new TActiveAmoeba(item.@x, item.@y);
						break;
					case(57):
						new TActiveSlime(item.@x, item.@y);
						break;

					case(76):
						new TKey(item.@x, item.@y, 0, false);
						break;
					case(77):
						new TKey(item.@x, item.@y, 1, false);
						break;
					case(78):
						new TKey(item.@x, item.@y, 2, false);
						break;
					case(79):
						new TKey(item.@x, item.@y, 3, false);
						break;
					case(86):
						new TKey(item.@x, item.@y, 0, true);
						break;
					case(87):
						new TKey(item.@x, item.@y, 1, true);
						break;
					case(88):
						new TKey(item.@x, item.@y, 2, true);
						break;
					case(89):
						new TKey(item.@x, item.@y, 3, true);
						break;

					case(90):
						new TInformator(item.@x, item.@y, 3);
						break;
					case(91):
						new TInformator(item.@x, item.@y, 1);
						break;
					case(92):
						new TInformator(item.@x, item.@y, 2);
						break;
					case(93):
						new TInformator(item.@x, item.@y, 0);
						break;
					/*
					 case(94):   new TItem(item.@x, item.@y, 0);                         break;
					 case(95):   new TItem(item.@x, item.@y, 1);                         break;
					 case(96):   new TItem(item.@x, item.@y, 2);                         break;
					 case(97):   new TItem(item.@x, item.@y, 3);                         break;
					 case(98):   new TItem(item.@x, item.@y, 4);                         break;
					 case(99):   new TItem(item.@x, item.@y, 5);                         break;
					 */
				}
			}

			Level.instance.levelWidth = parseInt(level.width.toString()) / 12;
			Level.instance.levelHeight = parseInt(level.height.toString()) / 12;

			Level.instance.amoebaGrows = level.@AmoebaGrows == "true";
			Level.instance.amoebaGrowRandom = level.@AmoebaRandom == "true";
			Level.instance.amoebaGrowthRate = parseInt(level.@AmoebaRate);
			Level.instance.amoebaUpperLimit = parseInt(level.@AmoebaUpperLimit);
			Level.instance.amoebaAlwaysBoulder = level.@AmoebaAlwaysBoulder == "true";
			Level.instance.slimeRandom = level.@SlimeRandom == "true";
			Level.instance.slimeRate = parseInt(level.@SlimeRate);
			Level.instance.magicWallCanActivate = level.@MagicWallCanActivate == "true";
			Level.instance.magicWallTimer = parseInt(level.@MagicWallTime);

			Level.instance.diamondValue = parseInt(level.@DiamondPoints);
			Level.instance.diamondExtraValue = parseInt(level.@ExtraDiamondPoints);
			Level.instance.timeValue = parseInt(level.@TimePoints);

			Level.instance.timeForLevel = parseInt(level.@Time);
			Level.instance.diamondsToGet = parseInt(level.@crystals);

			for each(var i:TGameObject in Level.instance.level.getArray()) {
				if (i) {
					i.recalculate();
				}
			}
		}

		public static function playerDied(noWait:Boolean = false):void {
			if (ignoreRestarts) {
				return;
			}

			ignoreRestarts = true;

			if (noWait) {
				RetrocamelEffectFadeScreen.makeOut().duration(250).callback(restartLevel).run();
			}
			else {
				setTimeout(playerDeadAnimation, 1000);
			}
		}

		public static function loadLevelFromFile():void {
			_qfr = new FileReference();
			_qfr.addEventListener(Event.SELECT, fLevelStartLoading);
			_qfr.addEventListener(Event.COMPLETE, fLevelLoaded);

			_qfr.browse([new FileFilter("All", "*")]);
		}

		/*public static function saveLevelState():String{
		 var lvl:String = Level.instance.levelWidth.toString();
		 lvl += "&" + Level.instance.levelHeight;
		 lvl += "&" + Level.instance.amoebaConvertTimer
		 lvl += "&" + Level.instance.amoebaCount
		 lvl += "&" + Level.instance.amoebaEnclosed;
		 lvl += "&" + Level.instance.amoebaGrowRandom
		 lvl += "&" + Level.instance.amoebaGrows
		 lvl += "&" + Level.instance.amoebaGrowthRate;
		 lvl += "&" + Level.instance.amoebaGrowTimer
		 lvl += "&" + Level.instance.amoebaUpperLimit;

		 for each(var i:TGameObject in Level.instance.level.getArray()){
		 if (i){
		 var data:String = i.saveObject();
		 if (data)
		 lvl += "|" + data;
		 }
		 }

		 return lvl;
		 }

		 public static function loadLevelState(lvl:String):void{
		 var allData:Array = lvl.split("|");

		 var metaData:Array = allData.shift().split("&");
		 Level.instance.levelWidth  = parseInt(metaData[0]);
		 Level.instance.levelHeight = parseInt(metaData[1]);

		 rScroller.instance.setCorners(0, 0, Level.instance.levelWidth * 12, Level.instance.levelHeight * 12);

		 var current:Array;
		 var cls:*;
		 for each(var elem:String in allData){
		 current = elem.split("&");

		 for(var i:String in current){
		 if (current[i] == "true")
		 current[i] = true;
		 else if (current[i] == "false")
		 current[i] = false;
		 else if (!isNaN(parseFloat(current[i])))
		 current[i] = parseFloat(current[i]);
		 }

		 cls = getDefinitionByName(current.shift()) as Class;
		 cls.load(current);
		 }

		 Level.instance.amoebaConvertTimer = parseFloat(metaData[2]);
		 Level.instance.amoebaCount = parseFloat(metaData[3]);
		 Level.instance.amoebaEnclosed = parseFloat(metaData[4]);
		 Level.instance.amoebaGrowRandom = metaData[5] == "true";
		 Level.instance.amoebaGrows = metaData[6] == "true";
		 Level.instance.amoebaGrowthRate = parseFloat(metaData[7]);
		 Level.instance.amoebaGrowTimer = parseFloat(metaData[8]);
		 Level.instance.amoebaUpperLimit = parseFloat(metaData[9]);
		 }

		 public static function levelLeave(x:int, y:int, tx:int, ty:int):void{
		 if (!S.adventureMode)
		 return;

		 _levelsSaved[currentRoom] = saveLevelState();

		 _playerPower = Score.powerup;

		 if (ty == -1){ // Go up, appear bottom
		 _playerNewEdge = 2;
		 _playerNewOffset = x;

		 } else if (ty == 1){ // Go down, appear top
		 _playerNewEdge = 0;
		 _playerNewOffset = x;

		 } else if (tx == -1){ // Go left, appear right
		 _playerNewEdge = 1;
		 _playerNewOffset = y;

		 } else if (tx == 1){ // Go right, appear left
		 _playerNewEdge = 3;
		 _playerNewOffset = y;
		 }

		 trace("THIS ROOM: " + currentRoom);
		 currentRoom = LevelOrder.getNextLevel(currentRoom, tx, ty);
		 trace("NEXT ROOM: " + currentRoom);

		 Level.instance.player.blocked = true;

		 new rEffMaskCircle(x - rScroller.x, y - rScroller.y, 500, onLevelLeft);
		 }

		 private static function onLevelLeft():void{
		 playLevel(currentRoom);
		 }*/

		public static function DEBUG_ResetLevelState():void {
			delete _levelsSaved[currentRoom];
		}

		private static function resetLevel():void {
			clearLevel();

			Level.instance.completed = false;

			Score.score = 0;

			Score.resetLevelStart();

			if (!S().adventureMode) {
				Score.powerup = 6;
			}

			Game.lBG.clear();
			Game.lMain.clear();

			THud.instance.unhook();
			THud.instance.hookTo(Game.lGame);

			Game.lBG.draw(Gfx.backgroundIngameBitmapData, 0, 0);
		}

		private static function playLevel(id:uint):void {
			ignoreRestarts = false;
			resetLevel();
			clearLevel();
			loadLevelFromScratch(id);
			RetrocamelScrollAssist.instance.setCorners(0, 0, Level.instance.levelWidth * 12, Level.instance.levelHeight * 12 + 24);
			Score.time = Level.instance.timeForLevel * 60;
			Score.diamondsToGet = Level.instance.diamondsToGet;

			RetrocamelEffectFadeScreen.makeIn().duration(250).run();

			if (!Level.instance.player) {
				var plaX:uint = _playerNewOffset;
				var plaY:uint = _playerNewOffset;
				switch (_playerNewEdge) {
					case(0):
						plaY = 0;
						break;

					case(1):
						plaX = Level.instance.levelWidth * 12 - 12;
						break;

					case(2):
						plaY = Level.instance.levelHeight * 12 - 12;
						break;

					case(3):
						plaX = 0;
						break;

				}

				new TPlayer(plaX, plaY);
			}

			THud.instance.setDefaults();

			TEscButton.set();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Level Load From File
		// ::::::::::::::::::::::::::::::::::::::::::::::

		private static function clearLevel():void {
			Level.instance.actives.clear();
			Level.instance.level.clear();
			Game.gAll.clear();
			Game.lGame.clear();

			Level.instance.collectedAdditionalDiamonds = 0;
			Level.instance.collectedDiamonds = 0;
			Level.instance.timeLeft = 0;
			Level.instance.amoebaCount = 0;
			Level.instance.amoebaEnclosed = 0;
			Level.instance.amoebaConvertTimer = 0;
			Level.instance.amoebaGrowTimer = 0;

			Level.instance.magicWallActive = false;
			Level.instance.magicWallCanActivate = true;

			Level.instance.player = null;
		}

		private static function toID(tx:uint, ty:uint):uint {
			return (tx / 12) + (ty / 12 | 0) * 10;
		}

		private static function playerDeadAnimation():void {
			RetrocamelEffectFadeScreen.makeOut().duration(1000).callback(restartLevel).run();
		}

		private static function fLevelStartLoading(e:Event):void {
			_qfr.load();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Event Listeners & Callbacks
		// ::::::::::::::::::::::::::::::::::::::::::::::

		private static function fLevelLoaded(e:Event):void {
			playLevel(0);
		}
	}
}