package game.global {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;

	import game.global.pre.Pre;
	import game.standalone.VolumeBar;
	import game.windows.TWinRedefiningKey;

	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.global.RetrocamelSimpleSave;
	import net.retrocade.retrocamel.locale._;

	public class Options extends Sprite {
		[Embed(source='/assets/global/music.png')]
		private var _gfx_music_:Class;
		[Embed(source='/assets/global/sfx.png')]
		private var _gfx_sfx_:Class;

		private var _iconMusic:Bitmap;
		private var _iconSfx:Bitmap;

		private var _info:RetrocamelBitmapText;

		private var _barMusic:VolumeBar;
		private var _barSfx:VolumeBar;

		private var _keyChangers:Array = [];
		private var _nowChanging:RetrocamelButton;

		public function Options() {
			_iconMusic = new _gfx_music_;
			_iconSfx = new _gfx_sfx_;
			_barMusic = new VolumeBar(changedMusic);
			_barSfx = new VolumeBar(changedSfx);

			_info = new RetrocamelBitmapText(_("Redefine keys:"));
			_info.scaleX = 2;
			_info.scaleY = 2;

			_iconMusic.x = 65;
			_iconSfx.x = 65;
			_iconSfx.y = 40;
			_info.x = (375 - _info.width) / 2 | 0;
			_info.y = 70;
			_info.addShadow();

			_barMusic.gfx.x = 105;
			_barSfx.gfx.x = 105;
			_barSfx.gfx.y = 40;

			reset();

			addChild(_iconMusic);
			addChild(_iconSfx);
			addChild(_barMusic.gfx);
			addChild(_barSfx.gfx);
			addChild(_info);

			for each(var s:String in Game.allKeys) {
				addKeyChanger(s);
			}
		}

		public function reset():void {
			_barMusic.value = RetrocamelSoundManager.musicVolume;
			_barSfx.value = RetrocamelSoundManager.soundVolume;
		}

		private function addKeyChanger(keyName:String):void {
			var wid:Number = 125;

			var button:RetrocamelButton = Make().button(onKeyChangeClick, _('key' + Game[keyName]), 120);
			var desc:RetrocamelBitmapText = Make().text(_(keyName + 'Desc') + ":");

			button.data.keyName = keyName;
			button.data.desc = desc;
			button.data.txt.positionToCenter();

			button.x = (_keyChangers.length % 3) * wid | 0;// + (wid - button.width) / 3 | 0;
			button.y = (_keyChangers.length / 3 | 0) * 60 + 110;

			desc.x = (_keyChangers.length % 3) * wid + (wid - desc.width) / 2 | 0;
			desc.y = button.y - 16;
			desc.addShadow();

			button.filters = Pre.DROP_SHADOW_FILTER;

			addChild(desc);
			addChild(button);
			_keyChangers.push(button);
		}

		private function onKeyChangeClick(button:RetrocamelButton):void {
			button.data.txt.text = "...";
			button.data.txt.positionToCenter();

			stage.mouseChildren = false;

			RetrocamelInputManager.addStageKeyDown(onKeyChangePress);

			_nowChanging = button;

			TWinRedefiningKey.instance.set(button.data.keyName);

			Game.disableQuickSFXToggle = true;
		}

		private function onKeyChangePress(e:KeyboardEvent):void {
			RetrocamelInputManager.removeStageKeyDown(onKeyChangePress);

			stage.mouseChildren = true;

			Game[_nowChanging.data.keyName] = e.keyCode;
			_nowChanging.data.txt.text = _('key' + e.keyCode);
			_nowChanging.data.txt.positionToCenter();

			RetrocamelSimpleSave.write('opt' + _nowChanging.data.keyName, e.keyCode);

			TWinRedefiningKey.instance.hide();

			Game.disableQuickSFXToggle = false;
			RetrocamelInputManager.flushAll();

			e.stopImmediatePropagation();
		}

		private function changedMusic(value:Number):void {
			RetrocamelSoundManager.musicVolume = value;
			RetrocamelSimpleSave.write('optVolumeMusic', value);
		}

		private function changedSfx(value:Number):void {
			RetrocamelSoundManager.soundVolume = value;
			RetrocamelSimpleSave.write('optVolumeSound', value);
		}
	}
}