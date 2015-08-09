/**
 * Created with IntelliJ IDEA.
 * User: rem
 * Date: 07.08.15
 * Time: 13:03
 * To change this template use File | Settings | File Templates.
 */
package {
	import flash.display.Sprite;

	import game.Game;

	import starling.core.Starling;

	[SWF(frameRate="60", width="760", height="670")]
	public class Main extends Sprite
	{
		public static const GAME_WIDTH:int = 760;
		public static const GAME_HEIGHT:int = 670;

		private var gameLayer:Starling;

		public function Main()
		{
			super();
			gameLayer = new Starling(Game, stage);
			gameLayer.antiAliasing = 1;
			gameLayer.start();
		}
	}
}
