package net.retrocade.retrocamel.interfaces {
	public interface IRetrocamelSound {
		function play(loop:uint = 0, volumeModifier:Number = 1, pan:Number = 0):void;

		function pause():void;

		function stop():void;

		function resume():void;

		function get pauseTime():Number;

		function get loops():uint;

		function set loops(value:uint):void;

		function get volume():Number;

		function set volume(value:Number):void;

		function get pan():Number;

		function set pan(value:Number):void;

		function get isPlaying():Boolean;

		function get position():Number;

		function get length():Number;

		function dispose():void;

	}
}