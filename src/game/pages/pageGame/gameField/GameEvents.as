/**
 * Created with IntelliJ IDEA.
 * User: rem
 * Date: 07.08.15
 * Time: 13:33
 * To change this template use File | Settings | File Templates.
 */
package game.pages.pageGame.gameField {
	import starling.events.Event;

	public class GameEvents extends Event
	{
		//when click item
		public static const EVENT_SELECT_ITEM:String = "SELECT_ITEM";
		//when selected item moves
		public static const EVENT_ITEM_MOVE_START:String = "EVENT_ITEM_MOVE_START";
		//when item animation complete
		public static const EVENT_ITEM_MOVE_COMPLETE:String = "EVENT_ITEM_MOVE_COMPLETE";
		//when selected item moves back
		public static const EVENT_ITEM_MOVE_REVERSE_COMPLETE:String = "EVENT_ITEM_MOVE_REVERSE_COMPLETE";
		//when item explose
		public static const EVENT_ITEM_EXPLOSION:String = "EVENT_ITEM_EXPLOSION";
	    //when item animation explosion complete
		public static const EVENT_ITEM_EXPLOSION_COMPLETE:String = "EVENT_ITEM_EXPLOSION_COMPLETE";
		//when item falling
		public static const EVENT_ITEM_MOVE_DOWN:String = "EVENT_ITEM_MOE_DOWN";
		//when item animation falling complete
		public static const EVENT_ITEM_MOVE_DOWN_COMPLETE:String = "EVENT_ITEM_MOE_DOWN_COMPLETE";

		//game over
		public static const EVENT_FINAL:String = "EVENT_FINAL";
		//change label
		public static const EVENT_CHANGE_COMBINATIONS:String = "EVENT_CHANGE_COMBINATIONS";


		public var value:Object;

		public function GameEvents(type:String, value:Object=null)
		{
			this.value = value;
			super(type, true);
		}
	}
}
