/**
 * Created with IntelliJ IDEA.
 * User: Ryc
 * Date: 06.04.13
 * Time: 19:29
 * To change this template use File | Settings | File Templates.
 */
package {
	public function ASSERT(condition:*, message:String = null):void {
		if (!condition) {
			throw new Error(message ? message : "Assertion failed!");
		}
	}
}
