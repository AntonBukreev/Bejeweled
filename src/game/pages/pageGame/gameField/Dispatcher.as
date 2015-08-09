/**
 * Created with IntelliJ IDEA.
 * User: rem
 * Date: 08.08.15
 * Time: 11:26
 * To change this template use File | Settings | File Templates.
 */
package game.pages.pageGame.gameField {
	import game.pages.pageGame.*;
	import starling.events.EventDispatcher;

	public class Dispatcher extends EventDispatcher
	{
		// main game dispatcher use it to dispatch events in game
		public function Dispatcher()
		{
			super();
		}

		//method to dispatch event
		public function dispatch(type:String, data:Object=null):void
		{
			this.dispatchEvent(new GameEvents(type, data));
		}

	}
}
