/**
 * Created with IntelliJ IDEA.
 * User: rem
 * Date: 07.08.15
 * Time: 16:28
 * To change this template use File | Settings | File Templates.
 */
package game.pages {
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;

	public class Page extends Sprite
	{
		public var data:Object;

		/**
		 *  inherit pages from this basic class
		 */
		public function Page(data:Object=null)
		{
			this.data = data;
			super();
			init();
		}

		/**
		 * init after creation
		 */
		public function init():void
		{
			x = - Main.GAME_WIDTH;
			alpha = 0;
		}

		/**
		 * show after adding on scene
		 */
		public function show():void
		{
			var t:Tween = new Tween(this, 1, Transitions.EASE_IN_OUT_BACK);
			t.animate("x", 0);
			t.animate("alpha", 1);
			t.onComplete = onShowComplete;
			Starling.juggler.add(t);
		}

		/**
		 * hide
		 */
		public function hide():void
		{
			var t:Tween = new Tween(this, 1, Transitions.EASE_IN_OUT_BACK);
			t.animate("x", this.width);
			t.animate("alpha", 0);
			t.onComplete = onHideComplete;
			Starling.juggler.add(t);
		}

		/**
		 * calls after show animation
		 */
		public function onShowComplete():void
		{
			Starling.juggler.removeTweens(this);
		}

		/**
		 * calls after hide animation
		 */
		public function onHideComplete():void
		{
			destroy();
		}

		/**
		 * destroy this page after hiding animation
		 */
		public function destroy():void
		{
			Starling.juggler.removeTweens(this);
			this.parent.removeChild(this,true);
		}

	}
}
