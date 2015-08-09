/**
 * Created with IntelliJ IDEA.
 * User: rem
 * Date: 08.08.15
 * Time: 17:06
 * To change this template use File | Settings | File Templates.
 */
package game.pages.pageGame.gameField {
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.text.TextField;

	/**
	 * animated lable in game shows score
	 */
	public class GameScore extends Sprite
	{
		private var _scoreTF:TextField;

		public function GameScore(value:String)
		{
			super();

			_scoreTF = new TextField(300,100,"+");
			addChild(_scoreTF);
			_scoreTF.fontName = "Myriad Pro";
			_scoreTF.text = "+" + value;
			_scoreTF.fontSize = 30;
			_scoreTF.bold = true;
			_scoreTF.color = 0xffffff;
			_scoreTF.x = -_scoreTF.width/2;
			_scoreTF.y = -_scoreTF.height/2;
			alpha = 0.0;
		}

		/**
		 * start animation
		 */
		public function animate():void
		{
			var t:Tween = new Tween(this, 0.2, Transitions.LINEAR);
			t.delay = 0.1;
			t.animate("alpha", 1);
			t.animate("y", this.y - 20);
			t.animate("scaleX", 1.5);
			t.animate("scaleY", 1.5);

			var t2:Tween = new Tween(this, 0.5, Transitions.LINEAR);
			t2.animate("y", this.y - 200);
			t2.animate("alpha", 0);
			t2.animate("scaleX", 0.5);
			t2.animate("scaleY", 0.5);

			 t.nextTween = t2;
			t2.onComplete = onMoveComplete;
			Starling.juggler.add(t);
		}

		/**
		 * destroy it
		 */
		private function onMoveComplete():void
		{
			Starling.juggler.removeTweens(this);
			this.removeChild(_scoreTF, true);
			this.parent.removeChild(this,true);
		}
	}
}
