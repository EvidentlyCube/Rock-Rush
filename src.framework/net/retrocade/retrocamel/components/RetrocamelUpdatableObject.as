package net.retrocade.retrocamel.components {

	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.interfaces.IRetrocamelUpdatable;

	public class RetrocamelUpdatableObject implements IRetrocamelUpdatable {
		/**
		 * If false object is not automatically updated
		 */
		public var active:Boolean = true;

		public function update():void {
		}


		final public function addDefault():void {
			defaultGroup.add(this);
		}

		final public function addAtDefault(index:uint):void {
			defaultGroup.addAt(this, index);
		}

		final public function nullifyDefault():void {
			defaultGroup.nullify(this);
		}

		final public function removeDefault():void {
			defaultGroup.remove(this);
		}

		public function get defaultGroup():RetrocamelUpdatableGroup {
			return RetrocamelCore.currentState.defaultGroup;
		}
	}
}