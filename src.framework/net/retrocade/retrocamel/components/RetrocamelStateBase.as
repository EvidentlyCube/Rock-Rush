package net.retrocade.retrocamel.components {
	import flash.events.EventDispatcher;

	import net.retrocade.retrocamel.core.RetrocamelCore;

	public class RetrocamelStateBase extends EventDispatcher {
		protected var _defaultGroup:RetrocamelUpdatableGroup;

		public function get defaultGroup():RetrocamelUpdatableGroup {
			return _defaultGroup;
		}

		public function RetrocamelStateBase() {
			_defaultGroup = new RetrocamelUpdatableGroup
		}


		/****************************************************************************************************************/
		/**                                                                                                  OVERRIDES  */
		/****************************************************************************************************************/

		/**
		 * Called when state is set
		 */
		public function create():void {
			resize();
		}

		final public function isSet():Boolean {
			return RetrocamelCore.currentState == this;
		}

		/**
		 * Called when state is unset
		 */
		public function destroy():void {
			_defaultGroup.clear();
		}

		/**
		 * State update
		 */
		public function update():void {
			_defaultGroup.update();
		}

		public function resize():void {

		}

		/**
		 * Sets this state, useful when you are working with State Instance variable
		 */
		final public function setToMe():void {
			RetrocamelCore.setState(this);
		}
	}
}