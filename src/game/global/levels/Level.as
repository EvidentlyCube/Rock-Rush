package game.global.levels {
	import game.objects.TActiveAmoeba;
	import game.objects.TActiveBoulder;
	import game.objects.TActiveDiamond;
	import game.objects.TGameObject;
	import game.objects.TPlayer;

	import net.retrocade.data.RetrocamelTileGrid;
	import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;

	/**
	 * ...
	 * @author
	 */
	public class Level {
		public static var instance:Level = new Level();
		public var level:RetrocamelTileGrid = new RetrocamelTileGrid(S().tileGridWidth, S().tileGridHeight, S().tileGridTileWidth, S().tileGridTileHeight);
		public var actives:RetrocamelUpdatableGroup = new RetrocamelUpdatableGroup();
		public var effects:RetrocamelUpdatableGroup = new RetrocamelUpdatableGroup();
		public var player:TPlayer;
		public var collectedDiamonds:uint = 0;
		public var collectedAdditionalDiamonds:uint = 0;
		public var timeLeft:uint = 0;
		public var timeForLevel:uint;
		public var diamondsToGet:uint;


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: LEVEL VARIABLES
		// ::::::::::::::::::::::::::::::::::::::::::::::
		public var levelWidth:uint = 0;
		public var levelHeight:uint = 0;
		public var amoebaCount:uint = 0;
		public var amoebaEnclosed:uint = 0;
		public var amoebaGrows:Boolean = false;
		public var amoebaGrowthRate:uint = 20;
		public var amoebaGrowRandom:Boolean = true;
		public var amoebaGrowTimer:uint = 0;
		public var amoebaConvertTimer:uint = 0;
		public var amoebaUpperLimit:uint = 1000;
		public var amoebaAlwaysBoulder:Boolean = false;
		public var slimeRandom:Boolean = false;
		public var slimeRate:Number = 0;
		public var magicWallActive:Boolean;
		public var magicWallCanActivate:Boolean;
		public var magicWallTimer:uint = 2000;
		public var diamondValue:uint;
		public var diamondExtraValue:uint;
		public var timeValue:uint;
		public var completed:Boolean = false;


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: In-level functions
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public function Level() {
		}

		public function canAmoebaGrow():Boolean {
			//trace(amoebaEnclosed + "&" + amoebaCount);
			if (amoebaEnclosed == amoebaCount) {
				if (amoebaConvertTimer == 0) {
					amoebaConvertTimer = amoebaCount * 8;
				}

				amoebaConvertTimer--;

				if (amoebaConvertTimer == 0) {
					if (amoebaAlwaysBoulder) {
						convertAmoebaTo(TActiveBoulder);
					}
					else {
						convertAmoebaTo(TActiveDiamond);
					}
				}

			} else if (amoebaCount >= amoebaUpperLimit) {
				convertAmoebaTo(TActiveBoulder);
			}

			if (amoebaGrowRandom) {
				return (Math.random() * amoebaGrowthRate) < 1;
			}

			if (amoebaGrowTimer) {
				amoebaGrowTimer--;
			}

			return amoebaGrowTimer == 0;
		}

		public function amoebaGrew():void {
			amoebaGrowTimer = amoebaCount * amoebaGrowthRate + Math.random() * amoebaCount;
		}

		public function convertAmoebaTo(cls:Class):void {
			for each(var i:TGameObject in level.getArray()) {
				if (i && i is TActiveAmoeba) {
					i.kill(false);
					new cls(i.x, i.y);
				}
			}
		}
	}
}