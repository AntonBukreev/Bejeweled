/**
 * Created with IntelliJ IDEA.
 * User: rem
 * Date: 07.08.15
 * Time: 16:26
 * To change this template use File | Settings | File Templates.
 */
package game.pages {
	import flash.utils.setTimeout;

	import game.Game;
	import game.pages.pageGame.gameField.GameEvents;
	import game.pages.pageGame.GameField;
	import game.pages.pageGame.gameField.Item;
	import game.pages.pageGame.TopLabel;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class PageGame extends Page
	{
		//possible combination count
		private var _topLabel:TopLabel;
		//game field container with logic
		private var _gameField:GameField;

		/**
		 *  page with bejeweled game
		 */
		public function PageGame(data:Object=null)
		{
			super(data);
		}

		override public function init():void
		{
			super.init();

			_gameField = new GameField();
			this.addChild(_gameField);

			_gameField.x = Main.GAME_WIDTH/2 - _gameField.width/2 + Item.WIDTH/2;
			_gameField.y = Main.GAME_HEIGHT/2 - _gameField.height/2 + Item.HEIGHT/2;

			GameField.dispatcher.addEventListener(GameEvents.EVENT_FINAL, remove);
			GameField.dispatcher.addEventListener(GameEvents.EVENT_CHANGE_COMBINATIONS, onChangeCombinations);

			_topLabel = new TopLabel();
			addChild(_topLabel);
		}

		override public function onShowComplete():void
		{
			super.onShowComplete();
			_gameField.checkFinal();
		}

		/**
		 *  calls when need to update top label
		 */
		private function onChangeCombinations(event:GameEvents):void
		{
			_topLabel.update(int(event.value));
		}

		/**
		 * final calls when no more combinations
		 */
		private function remove():void
		{
			GameField.dispatcher.removeEventListener(GameEvents.EVENT_FINAL, remove);
			Game.showPage(Game.PAGE_FINAL, {score:10});
		}

		/**
		 * destroy this page after hiding animation
		 */
		override public function destroy():void
		{
			GameField.dispatcher.removeEventListener(GameEvents.EVENT_FINAL, remove);
			GameField.dispatcher.removeEventListener(GameEvents.EVENT_CHANGE_COMBINATIONS, onChangeCombinations);

			_topLabel.destroy();
			removeChild(_topLabel,true);

			_gameField.destroy();
			removeChild(_gameField,true);

			super.destroy();
		}

	}
}
