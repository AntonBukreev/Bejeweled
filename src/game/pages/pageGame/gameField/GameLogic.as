/**
 * Created with IntelliJ IDEA.
 * User: rem
 * Date: 08.08.15
 * Time: 13:20
 * To change this template use File | Settings | File Templates.
 */
package game.pages.pageGame.gameField {
	import game.pages.pageGame.*;
	import game.pages.pageGame.GameField;
	import game.pages.pageGame.GameField;
	import game.pages.pageGame.GameField;

	public class GameLogic
	{


		public function GameLogic()
		{
		}

		/**
		 * when select two items, check them combinations
		 */
		public function isMoveSuccess(item1:Item, item2:Item, field:Array):Boolean
		{
			var temp:Array = copy(field);

			temp[item2.row][item2.column] = item1.type;
			temp[item1.row][item1.column] = item2.type;

			return findCombination(item2.column, item2.row, temp) || findCombination(item1.column, item1.row, temp);
		}

		/**
		 * move only nearest items
		 */
		public function isPossibleMove(item1:Item, item2:Item):Boolean
		{
			var d:int = Math.abs(item1.column - item2.column) + Math.abs(item1.row - item2.row);
			return d == 1;
		}

		/**
		 * if find combination on select position return true
		 */
		public function findCombination(column:int, row:int, temp:Array):Boolean
		{
			var type:int = temp[row][column];
			var count:int = 1;

			var i:int = row;
			for(var j:int = column+1; j < GameField.COLUMNS; j++)
			{
				if (type == temp[i][j])
					count += 1;
				else
					break;
			}

			for(j = column-1; j >=0; j--)
			{
				if (type == temp[i][j])
					count += 1;
				else
					break;
			}

			if (count > 2) return true;

			count = 1;
			j = column;
			for( i = row + 1; i < GameField.ROWS; i++)
			{
				if (type == temp[i][j])
					count += 1;
				else
					break;
			}

			for( i = row - 1; i >=0; i--)
			{
				if (type == temp[i][j])
					count += 1;
				else
					break;
			}
			return count > 2;

		}

		/**
		 *   debug
		 */
		public function traceField(field:Array):void
		{
			trace("------------------------------");
			var temp:Array = [];
			for(var i:int = 0; i < GameField.ROWS; i++)
			{
				temp[i] = [];
				for(var j:int = 0; j < GameField.COLUMNS; j++)
				{
					temp[i][j] = (field[i][j] as Item)?(field[i][j] as Item).type:"-";
				}
				trace(temp[i]);
			}

		}

		/**
		 * explose line with selected items
		 */
		public function getExplosionItems(currentSelected:Item, selected:Item, field:Array):Array
		{
			var temp:Array = [];
			temp = temp.concat(getItems(currentSelected, field));
			temp = temp.concat(getItems(selected, field));

			var out:Array = [];
			for each(var item:Item in temp)
			{
				if (!find(item, out))
				{
					out.push(item);
				}
			}
			return out;
		}

		/**
		 *  find items to explose
		 */
		private function getItems(item:Item, field:Array):Array
		{
			var outH:Array = [item];
			var i:int = item.row;
			for(var j:int = item.column + 1; j < GameField.COLUMNS; j++)
			{
				if (item.type == (field[i][j] as Item).type)
				{
					outH.push(field[i][j]);
				}
				else
					break;
			}

			for(j = item.column - 1; j >= 0; j--)
			{
				if (item.type == (field[i][j] as Item).type)
				{
					outH.push(field[i][j]);
				}
				else
					break;
			}

			var outV:Array = [item];
			j = item.column;

			for(i = item.row + 1; i < GameField.ROWS; i++)
			{
				if (item.type == (field[i][j] as Item).type)
				{
					outV.push(field[i][j]);
				}
				else
					break;
			}

			for(i = item.row - 1; i >=0; i--)
			{
				if (item.type == (field[i][j] as Item).type)
				{
					outV.push(field[i][j]);
				}
				else
					break;
			}

			var out:Array = [];
			if (outH.length > 2)
				out = out.concat (outH);
			if (outV.length > 2)
				out = out.concat (outV);

			return out;
		}

		/**
		 *  find item in array
		 */
		private function find(item:Item, out:Array):Boolean
		{
			for each(var i:Item in out)
			{
				if (i.column == item.column && i.row == item.row) return true;
			}
			return false;
		}

		/**
		 * count of possible combinations
		 */
		public function combinations(field:Array):int
		{
			//traceField(field);
			var count:int = 0;
			for(var i:int = 0; i < GameField.ROWS; i++)
			{
				for(var j:int = 0; j < GameField.COLUMNS; j++)
				{
					var temp:Array = copy(field);

					if (findCombination(j, i, exchange(i,j,i+1,j,temp))) count+=1;
					temp = copy(field);
					if (findCombination(j, i, exchange(i,j,i-1,j,temp))) count+=1;
					temp = copy(field);
					if (findCombination(j, i, exchange(i,j,i,j+1,temp))) count+=1;
					temp = copy(field);
					if (findCombination(j, i, exchange(i,j,i,j-1,temp))) count+=1;
				}
			}
			return count;
		}

		private function exchange(i:int,j:int,i1:int,j1:int,arr:Array):Array
		{
			if (i1 >= 0 && j1 >= 0)
				if (i1 < GameField.ROWS && j1 < GameField.COLUMNS)
				{
					var temp:int = arr[i][j];
					arr[i][j] = arr[i1][j1];
					arr[i1][j1] = temp;
				}

			return arr;
		}

		private function copy(field:Array):Array
		{
			var temp:Array = [];
			for(var i:int = 0; i < GameField.ROWS; i++)
			{
				temp[i] = [];
				for(var j:int = 0; j < GameField.COLUMNS; j++)
				{
					temp[i][j] = (field[i][j] as Item).type;
				}
			}
			return temp;
		}

		public function distance(i1:Item,i2:Item):int
		{
			return Math.abs(i1.column-i2.column) + Math.abs(i1.row-i2.row);
		}

		public function get randomType():int
		{
			var value:int = Math.random()*(Number(GameField.TYPES - 0.01));
			return value;
		}

	}
}
