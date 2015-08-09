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

	import starling.animation.Transitions;

	import starling.animation.Tween;
	import starling.core.Starling;

	import starling.display.Button;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	public class PageFinal extends Page
	{
		//score text field
		private var _scoreTF:TextField;
		//restart button
		private var _playBtn:Button;

		/**
		 * final panel, will shown after game
		 */
		public function PageFinal(data:Object=null)
		{
			super(data);
		}

		override public function init():void
		{
			super.init();

			_scoreTF = new TextField(300,100,"your score");
			addChild(_scoreTF);
			_scoreTF.fontName = "Myriad Pro";
			_scoreTF.text = "YOUR SCORE : " + data.score;
			_scoreTF.fontSize = 32;
			_scoreTF.bold = true;
			_scoreTF.color = 0xffffff;
			_scoreTF.alpha = 0.5;
			_scoreTF.x = Main.GAME_WIDTH/2-_scoreTF.width/2;
			_scoreTF.y = Main.GAME_HEIGHT/2 - _scoreTF.height/2;
		}

		/**
		 * add button after animation
		 */
		override public function onShowComplete():void
		{
			super.onShowComplete();

			_playBtn = new Button(Assets.getTexture(Assets.BTN_PLAY));
			addChild(_playBtn);

			_playBtn.x = Main.GAME_WIDTH/2 - _playBtn.width/2;
			_playBtn.y = Main.GAME_HEIGHT;
			_playBtn.alpha = 0;

			showBtn();
		}

		/**
		 * button animation
		 */
		private function showBtn():void
		{
			var t:Tween = new Tween(_playBtn, 0.5, Transitions.EASE_IN_OUT_BACK);
			t.animate("y", Main.GAME_HEIGHT/2 - _playBtn.height/2);
			t.animate("alpha", 1);
			t.onComplete = onBtnAnimComplete;
			Starling.juggler.add(t);

			var t1:Tween = new Tween(_scoreTF, 0.5, Transitions.EASE_IN_OUT_BACK);
			t1.animate("y", Main.GAME_HEIGHT/2 - _playBtn.height/2 - _scoreTF.height);
			Starling.juggler.add(t1);
		}

		/**
		 * init button after animation
		 */
		private function onBtnAnimComplete():void
		{
			Starling.juggler.removeTweens(_scoreTF);
			Starling.juggler.removeTweens(_playBtn);
			_playBtn.addEventListener( Event.TRIGGERED, onClick);
		}

		/**
		 * restart game
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
			removeChild(_scoreTF,true);
			Starling.juggler.removeTweens(_scoreTF);
			removeChild(_playBtn,true);
			Starling.juggler.removeTweens(_playBtn);
			_playBtn.removeEventListener(Event.TRIGGERED, onClick);

			super.destroy();
		}
	}
}
