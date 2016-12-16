package net.retrocade.retrocamel.interfaces {
	public interface IRetrocamelWindow extends IRetrocamelUpdatable {
		function block():void;

		function isBlocked():Boolean;

		function unblock():void;

		function get pauseGame():Boolean;

		function get blockUnder():Boolean;

		function show():void;

		function hide():void;

		function resize():void;
	}
}