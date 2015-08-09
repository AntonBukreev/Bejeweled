/**
 * Created with IntelliJ IDEA.
 * User: rem
 * Date: 09.08.15
 * Time: 22:58
 * To change this template use File | Settings | File Templates.
 */
package game.pages.pageGame {
	import game.Game;

	import starling.display.Sprite;
	import starling.text.TextField;

	public class TopLabel extends Sprite
	{
		private var _textField:TextField;

		/**
		 * label on game page shows possible combinations
		 */
		public function TopLabel()
		{
			super();

			_textField = new TextField(300,100,"combinations 0");
			addChild(_textField);
			_textField.fontName = "Myriad Pro";

			_textField.fontSize = 30;
			_textField.bold = true;
			_textField.color = 0xffffff;
			_textField.x = -_textField.width/2;
			_textField.y = 0;


			this.x = Main.GAME_WIDTH/2;
			this.y = 10;
			alpha = 0.5;
		}

		public function update(value:int):void
		{
			_textField.text = "combinations "+value ;
		}

		public function destroy():void
		{
			this.removeChild(_textField, true);
		}
	}
}
