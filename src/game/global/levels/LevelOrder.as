package game.global.levels {
	public class LevelOrder {
		private static var _order:Array;

		{
			_order = [];

			_order[1] = [];
			_order[2] = [];
			_order[3] = [];
			_order[4] = [];
			_order[5] = [];
			_order[6] = [];
			_order[7] = [];
			_order[8] = [];
			_order[9] = [];
			_order[10] = [];
			_order[11] = [];
			_order[12] = [];
			_order[13] = [];
			_order[14] = [];
			_order[15] = [];
			_order[16] = [];
			_order[17] = [];
			_order[18] = [];
			_order[19] = [];
			_order[20] = [];
			_order[21] = [];
			_order[22] = [];


			_order[1][2] = 2;

			_order[2][0] = 1;
			_order[2][1] = 4;
			_order[2][3] = 3;

			_order[3][1] = 2;

			_order[4][2] = 5;
			_order[4][3] = 2;

			_order[5][0] = 4;
			_order[5][1] = 6;
			_order[5][2] = 10;

			_order[6][1] = 8;
			_order[6][2] = 7;
			_order[6][3] = 5;

			_order[7][0] = 6;

			_order[8][3] = 6;

			_order[9][1] = 10;

			_order[10][0] = 5;
			_order[10][3] = 9;
		}

		public static function getNextLevel(currentLevel:uint, tx:int, ty:int):uint {
			var dir:uint =
				ty == -1 ? 0 :
					tx == 1 ? 1 :
						ty == 1 ? 2 :
							tx == -1 ? 3 :
								uint.MAX_VALUE;

			if (dir == uint.MAX_VALUE) {
				throw new Error("Something went wrong");
			}

			return _order[currentLevel][dir];
		}
	}
}