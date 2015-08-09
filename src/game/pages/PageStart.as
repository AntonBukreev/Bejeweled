/**
 * Created with IntelliJ IDEA.
 * User: rem
 * Date: 07.08.15
 * Time: 16:26
 * To change this template use File | Settings | File Templates.
 */
package game.pages {
	import assets.Assets;

	import game.Game;

	import starling.display.Button;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class PageStart extends Page
	{
		//play button
		private var _playBtn:Button;

		/**
		 * start page
		 */
		public function PageStart(data:Object=null)
		{
			super(data);
		}

		override public function init():void
		{
			super.init();

			 _playBtn = new Button(Assets.getTexture(Assets.BTN_PLAY));
			addChild(_playBtn);

			_playBtn.x = Main.GAME_WIDTH/2 - _playBtn.width/2;
			_playBtn.y = Main.GAME_HEIGHT/2 - _playBtn.height/2;

			_playBtn.addEventListener( Event.TRIGGERED, onClick);

		}

		/**
		 * start bejeweled game
		 */
		private function onClick(event:Event):void
		{
			Game.showPage(Game.PAGE_GAME);
		}

		/**
		 * destroy this page after hiding animation
		 */
		override public function destroy():void
		{
			removeChild(_playBtn,true);
			_playBtn.removeEventListener(Event.TRIGGERED, onClick);

			super.destroy();
		}
	}
}
