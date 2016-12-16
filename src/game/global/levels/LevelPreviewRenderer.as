/**
 * Created with IntelliJ IDEA.
 * User: Ryc
 * Date: 20.09.13
 * Time: 13:52
 * To change this template use File | Settings | File Templates.
 */
package game.global.levels {
	import flash.display.BitmapData;

	import game.global.*;
	import game.objects.TGameObject;

	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashBlit;

	public class LevelPreviewRenderer {
		private static var levelWidth:uint;
		private static var levelHeight:uint;

		public static function getLevelPreview(id:int):BitmapData {
			var levelXml:XML = LevelList.getLevelXml(id);

			levelWidth = parseInt(levelXml.width.toString()) / 12;
			levelHeight = parseInt(levelXml.height.toString()) / 12;

			var mockLayer:RetrocamelLayerFlashBlit = new RetrocamelLayerFlashBlit(levelWidth * 12, levelHeight * 12);
			var mockLevel:Level = new Level();

			var tempLayer:RetrocamelLayerFlashBlit = Game.lGame;
			var tempLevel:Level = Level.instance;

			Game.lGame = mockLayer;
			Level.instance = mockLevel;

			var i:int;
			var j:int;
			var bg:BitmapData = Gfx.backgroundIngameBitmapData;

			for (j = 0; j < levelHeight * 12; j += bg.height) {
				for (i = 0; i < levelWidth * 12; i += bg.width) {
					Game.lGame.draw(bg, i, j);
				}
			}

			try {
				LevelManager.loadLevelFromScratch(id);

				for (j = 0; j < levelHeight; j++) {
					for (i = 0; i < levelWidth; i++) {
						var tile:TGameObject = Level.instance.level.getTile(i, j);
						if (tile) {
							tile.draw();
						}
					}
				}
			} catch (error:Error) {

			} finally {
				Game.lGame = tempLayer;
				Level.instance = tempLevel;
				mockLayer.removeLayer();
			}

			return mockLayer.bitmapData;
		}
	}
}
