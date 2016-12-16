package net.retrocade.retrocamel.interfaces {

	public interface IRetrocamelSettings {

		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Game Settings
		// ::::::::::::::::::::::::::::::::::::::::::::::	

		function get debug():Boolean;

		function get eventsCount():uint;

		function get languages():Array;

		function get gameWidth():uint;

		function get gameHeight():uint;
	}
}