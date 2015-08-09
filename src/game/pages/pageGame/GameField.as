/**
 * Created with IntelliJ IDEA.
 * User: rem
 * Date: 07.08.15
 * Time: 18:17
 * To change this template use File | Settings | File Templates.
 */
package game.pages.pageGame {
	import assets.Assets;
	import assets.Assets;

	import flash.geom.Point;
	import flash.utils.setTimeout;

	import game.pages.pageGame.gameField.Item;
	import game.pages.pageGame.gameField.Dispatcher;
	import game.pages.pageGame.gameField.GameEvents;
	import game.pages.pageGame.gameField.GameLogic;
	import game.pages.pageGame.gameField.GameScore;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EventDispatcher;

	public class GameField extends Sprite
	{
		/**
		 * config
		 */
		public static const COLUMNS:int = 8;
		public static const ROWS:int = 8;
		public static const TYPES:int = 5;

		// main game dispatcher use it to dispatch events in game
		public static var dispatcher:Dispatcher;

		//logic methods
		private var _logic:GameLogic;
		//first selected item
		private var _currentSelected:Item;
		//second selected item
		private var _secondSelected:Item;
		// array with all atems
		private var _field:Array;
		// count of movies
		private var _actions:int;
		//users score in current game
		private var _scores:int;

		/**
		 * this is core game class
		 */
		public function GameField()
		{
			super();

			_scores = 0;
			_actions = 0;
			_currentSelected = null;
			_secondSelected = null;
			_logic = new GameLogic();

			_field = [];
			for (var i:int=0; i < ROWS; i++)
			{
				_field [i] = [];
				for (var j:int=0; j < COLUMNS; j++)
				{
					var item:Item = new Item(j,i, _logic.randomType);
					_field[i][j] = item;
					addChild(item);
				}
			}

			dispatcher = new Dispatcher();
			dispatcher.addEventListener(GameEvents.EVENT_SELECT_ITEM, onSelectItem);
		}

		/**
		 * click on item
		 */
		private function onSelectItem(event:GameEvents):void
		{
			_secondSelected = event.value as Item;

			if (_currentSelected == _secondSelected) return;

			if (_currentSelected == null)
			{
				// first selection
				_currentSelected = _secondSelected;
				_secondSelected.select();
			}
			else
			{
				//second selection
				if (_logic.isPossibleMove(_secondSelected, _currentSelected))
				{
					active(false);
					if (_logic.isMoveSuccess(_secondSelected, _currentSelected, _field))
					{
						// exchange items, destroy lines and move down new lines
						dispatcher.addEventListener(GameEvents.EVENT_ITEM_MOVE_START, onMoveStart);
						dispatcher.addEventListener(GameEvents.EVENT_ITEM_MOVE_COMPLETE, onMoveComplete);
						_secondSelected.moveTo(_currentSelected.column, _currentSelected.row);
						_currentSelected.moveTo(_secondSelected.column, _secondSelected.row);

					}
					else
					{
						// exchange items and move them back
						_secondSelected.moveToRevers(_currentSelected.column, _currentSelected.row);
						_currentSelected.moveToRevers(_secondSelected.column, _secondSelected.row);
						dispatcher.addEventListener(GameEvents.EVENT_ITEM_MOVE_REVERSE_COMPLETE, onMoveReversComplete);
					}
				}
				else
				{
					//first selection
					_currentSelected.unSelect();
					_currentSelected = _secondSelected;
					_secondSelected.select();
				}
			}

		}

		/**
		 * count of moving items
		 */
		private function onMoveStart(event:GameEvents):void
		{
			_actions += 1;
		}

		/**
		 * finish moving
		 */
		private function onMoveComplete(event:GameEvents):void
		{
			_actions -= 1;

			if (_actions <=0)
			{
				dispatcher.removeEventListener(GameEvents.EVENT_ITEM_MOVE_START, onMoveStart);
				dispatcher.removeEventListener(GameEvents.EVENT_ITEM_MOVE_COMPLETE, onMoveComplete);

				var p1:Point = new Point(_secondSelected.column, _secondSelected.row);
				var p2:Point = new Point(_currentSelected.column, _currentSelected.row);

				_field[p1.y][p1.x] = _currentSelected;
				_field[p2.y][p2.x] = _secondSelected;

				_currentSelected.setPosition(p1.x,p1.y);
				_secondSelected.setPosition(p2.x,p2.y);

				explosion();

				_currentSelected = null;
				_secondSelected = null;
			}
		}

		/**
		 * destroy lines
		 */
		private function explosion():void
		{
			var temp:Array = _logic.getExplosionItems(_currentSelected, _secondSelected, _field);

			dispatcher.addEventListener(GameEvents.EVENT_ITEM_MOVE_DOWN_COMPLETE, onMoveDownComplete);

			removeItems(temp);
			moveItemsDown();

			addScore(temp[0], temp.length);
			for each(var item:Item in temp)
			{
				var dist:int = Math.min(_logic.distance(item, _currentSelected), _logic.distance(item, _secondSelected))
				var delay:Number = 0.1 * dist;
				item.explosion(delay);
			}
		}

		/**
		 *  adding score animation
		 */
		private function addScore(item:Item, count:int):void
		{
			var text:GameScore = new GameScore(count.toString());
			addChild(text);
			text.x = item.x;
			text.y = item.y;
			text.animate();
		}

		/**
		 * on finish move down animation
		 */
		private function onMoveDownComplete(event:GameEvents):void
		{
			dispatcher.removeEventListener(GameEvents.EVENT_ITEM_MOVE_DOWN_COMPLETE, onMoveDownComplete);
			active(true);
			checkFinal();
		}

		/**
		 * clear items place in array
		 */
		private function removeItems(explosed:Array):void
		{
			for each(var item:Item in explosed)
			{
				_field[item.row][item.column] = null;
			}
		}

		/**
		 * move old items down, and create new items
		 */
		private function moveItemsDown():void
		{
			for(var j:int=0; j < COLUMNS; j++)
			{
				var count:int = 0;
				for(var i:int=ROWS-1; i >= 0; i--)
				{
					if (_field[i][j]==null)
					{
						count += 1;
					}
					else
					{
						if (count > 0)
						{
							var item:Item = (_field[i][j] as Item);
							item.moveDown(count);
							_field[i+count][j] = item;
						}

					}
				}

				for (var n:int = 0; n <count; n++)
				{
					var newItem:Item = new Item(j,-count+n, _logic.randomType);
					newItem.touchable = false;
					newItem.alpha = 0;
					_field[n][j] = newItem;
					addChild(newItem);
					newItem.moveDown(count);
				}

			}
		}

		/**
		 * on reverse animation complete
		 */
		private function onMoveReversComplete(event:GameEvents):void
		{
			dispatcher.removeEventListener(GameEvents.EVENT_ITEM_MOVE_REVERSE_COMPLETE, onMoveComplete);
			active(true);

			checkFinal();

			_currentSelected = null;
			_secondSelected = null;
		}

		/**
		 * set mouse enabled false when animated
		 */
		private function active(value:Boolean):void
		{
			this.touchable = value;
			for (var i:int = 0; i < ROWS; i++)
			{
				for (var j:int = 0; j < COLUMNS; j++)
				{
					(_field[i][j] as Item).touchable = value;
				}
			}
		}

		/**
		 * check possible continue to play
		 */
		public function checkFinal():void
		{
			var combinations:int = _logic.combinations(_field);
			dispatcher.dispatch(GameEvents.EVENT_CHANGE_COMBINATIONS, combinations);
			if (combinations == 0)
			{
				dispatcher.dispatch(GameEvents.EVENT_FINAL, _scores);
			}
		}

		/**
		 * destroy game after closing
		 */
		public function destroy():void
		{
			for (var i:int = 0; i < ROWS; i++)
			{
				for (var j:int = 0; j < COLUMNS; j++)
				{
					(_field[i][j] as Item).destroy();
				}
			}

			dispatcher.removeEventListener(GameEvents.EVENT_SELECT_ITEM, onSelectItem);
			dispatcher.removeEventListener(GameEvents.EVENT_ITEM_MOVE_START, onMoveStart);
			dispatcher.removeEventListener(GameEvents.EVENT_ITEM_MOVE_COMPLETE, onMoveComplete);
			dispatcher.removeEventListener(GameEvents.EVENT_ITEM_MOVE_DOWN_COMPLETE, onMoveDownComplete);
			dispatcher.removeEventListener(GameEvents.EVENT_ITEM_MOVE_REVERSE_COMPLETE, onMoveReversComplete);

			_currentSelected = null;
			_secondSelected = null;
			_logic = null;
			dispatcher = null;

		}
	}
}
