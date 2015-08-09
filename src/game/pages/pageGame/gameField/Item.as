/**
 * Created with IntelliJ IDEA.
 * User: rem
 * Date: 07.08.15
 * Time: 18:24
 * To change this template use File | Settings | File Templates.
 */
package game.pages.pageGame.gameField {
	import game.pages.pageGame.*;
	import assets.Assets;

	import game.pages.pageGame.gameField.GameEvents;

	import starling.animation.Transitions;

	import starling.animation.Tween;
	import starling.core.Starling;

	import starling.display.Image;
	import starling.display.Shape;

	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Item extends Sprite
	{
		public static var TYPES:Array = [Assets.ITEM1, Assets.ITEM2, Assets.ITEM3, Assets.ITEM4, Assets.ITEM5, Assets.ITEM6];

		/**
		 * config
		 */
		public static const WIDTH:int = 55;
		public static const HEIGHT:int = 55;
		public static const PADDING:int = 2;

		//position
		private var _column:int;
		private var _row:int;
		private var _type:int;

		//back
		private var _image:Image;
		//container for back
		private var _container:Sprite;
		//selecting flag
		private var _selected:Boolean = false;
		//moving flag
		private var isMove:Boolean = false;

		//position by column
		private function getX(column:int):Number
		{
			return column * (WIDTH + PADDING);
		}
		//position by row
		private function getY(row:int):Number
		{
			return row * (HEIGHT + PADDING);
		}

		public function Item(column:int, row:int, type:int)
		{
			_column = column;
			_row = row;
			_type = type;

			super();

			_image = new Image(Assets.getTexture(TYPES[type]));

			_image.width = WIDTH;
			_image.height = HEIGHT;
			_image.x = -WIDTH/2;
			_image.y = -HEIGHT/2;
			_image.pivotX = 0;
			_image.pivotY = 0;

			_container = new Sprite();
			_container.addChild(_image);

			x = getX(_column);
			y = getY(_row);

			_image.addEventListener(TouchEvent.TOUCH, onTouch);

			addChild(_container);
		}

		/**
		 * chane position after moving
		 */
		public function setPosition(column:int, row:int):void
		{
			_column = column;
			_row = row;
		}

		/**
		 * click on item
		 */
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(stage);

			if (touch)
			{
				switch(touch.phase)
				{
					case TouchPhase.ENDED:
						GameField.dispatcher.dispatch(GameEvents.EVENT_SELECT_ITEM, this);
						break;
				}
			}

			if (!_selected)
			{
				// show hover animation
				var touchHover:Touch = event.getTouch(this, TouchPhase.HOVER);
				if (touchHover)
				{
					animHower(1.2);
				}
				else
				{
					animHower(1);
				}

			}
		}

		/**
		 * over animation
		 */
		private function onHowerShow():void
		{
			if (!isMove)
			if (_container)
				Starling.juggler.removeTweens(_container);
		}

		private function animHower(scale:Number):void
		{
			if (!isMove)
			{
			Starling.juggler.removeTweens(_container);
			var t:Tween = new Tween(_container, 0.2, Transitions.EASE_OUT_BACK);
			t.animate("scaleX", scale);
			t.animate("scaleY", scale);
			//t.animate("rotation", scale);
			t.onComplete = onHowerShow;
			Starling.juggler.add(t);
			}
		}

		/**
		 * when item was selected
		 */
		public function select():void
		{
			if (!_selected)
			{
				_selected = true;
				Starling.juggler.removeTweens(_container);
				showAnimSelected();
			}
		}

		public function unSelect():void
		{
			if (_selected)
			{
				_selected = false;
				Starling.juggler.removeTweens(_container);
				_container.scaleX = _container.scaleY = 1;
				_container.x = 0;
				_container.y = 0;
			}
		}

		/**
		 * show selection animation
		 */
		private function showAnimSelected():void
		{
			if (!isMove)
			if (_selected)
			{
				Starling.juggler.removeTweens(_container);
				var t1:Tween = new Tween(_container, 0.3, Transitions.EASE_OUT);
				t1.animate("y", -6);
				t1.animate("scaleX", 1.1);
				t1.animate("scaleY", 1.1);

				var t2:Tween = new Tween(_container, 0.3, Transitions.EASE_IN);
				t2.animate("y", +3);
				t2.animate("scaleX", 0.8);
				t2.animate("scaleY", 0.8);

				t2.onComplete = showAnimSelected;
				t1.nextTween = t2;

				Starling.juggler.add(t1);
			}
		}

		/**
		 * show moving animation
		 */
		public function moveTo(column:int, row:int):void
		{
			isMove = true;
			unSelect();
			GameField.dispatcher.dispatch(GameEvents.EVENT_ITEM_MOVE_START);
			var t:Tween = new Tween(this, 0.2, Transitions.EASE_OUT_BACK);
			t.animate("x", getX(column));
			t.animate("y", getY(row));
			t.onComplete = onMove;
			Starling.juggler.add(t);
		}

		private function onMove():void
		{
			GameField.dispatcher.dispatch(GameEvents.EVENT_ITEM_MOVE_COMPLETE);
			Starling.juggler.removeTweens(this);
			isMove = false;
		}

		/**
		 * show reverse animation
		 */
		public function moveToRevers(column:int, row:int):void
		{
			isMove = true;
			unSelect();
			GameField.dispatcher.dispatch(GameEvents.EVENT_ITEM_MOVE_START);

			var t1:Tween = new Tween(this, 0.2, Transitions.EASE_OUT_BACK);
			t1.animate("x", getX(column));
			t1.animate("y", getY(row));

			var t2:Tween = new Tween(this, 0.2, Transitions.EASE_OUT_BACK);
			t2.animate("x", getX(_column));
			t2.animate("y", getY(_row));
			t2.onComplete = onMoveReverse;

			t1.nextTween = t2;

			Starling.juggler.add(t1);

		}

		private function onMoveReverse():void
		{
			GameField.dispatcher.dispatch(GameEvents.EVENT_ITEM_MOVE_REVERSE_COMPLETE);
			Starling.juggler.removeTweens(this);
			isMove = false;
		}

		/**
		 * show explosion animation
		 */
		public function explosion(delay:Number):void
		{

			Starling.juggler.removeTweens(this);
			Starling.juggler.removeTweens(_container);
			Starling.juggler.removeTweens(_image);
			_image.removeEventListener(TouchEvent.TOUCH, onTouch);

			GameField.dispatcher.dispatch(GameEvents.EVENT_ITEM_EXPLOSION);
			var t:Tween = new Tween(_container, 0.3, Transitions.EASE_IN_BACK);
			t.delay = delay + 0.01;
			t.animate("alpha", 0);
			t.animate("scaleX", 0);
			t.animate("scaleY", 0);
			t.onComplete = onExplosion;
			Starling.juggler.add(t);

		}

		private function onExplosion():void
		{
			GameField.dispatcher.dispatch(GameEvents.EVENT_ITEM_EXPLOSION_COMPLETE);
			destroy();
		}

		/**
		 * falling animation
		 */
		public function moveDown(count:int):void
		{
			isMove = true;
			unSelect();
			_row = _row + count;

			Starling.juggler.removeTweens(this);
			Starling.juggler.removeTweens(_container);
			Starling.juggler.removeTweens(_image);

			GameField.dispatcher.dispatch(GameEvents.EVENT_ITEM_MOVE_DOWN);
			var t:Tween = new Tween(this, count*0.1, Transitions.EASE_IN_BACK);
			t.delay = 0.5;
			t.animate("y", getY(_row));
			t.animate("alpha", 1);
			t.onComplete = onMoveDown;
			Starling.juggler.add(t);
		}

		private function onMoveDown():void
		{
			Starling.juggler.removeTweens(this);
			Starling.juggler.removeTweens(_container);
			Starling.juggler.removeTweens(_image);

			GameField.dispatcher.dispatch(GameEvents.EVENT_ITEM_MOVE_DOWN_COMPLETE);
			isMove = false;
		}

		public function get column():int {
			return _column;
		}

		public function get row():int {
			return _row;
		}

		public function get type():int {
			return _type;
		}

		/**
		 * destroy it
		 */
		public function destroy():void
		{
			Starling.juggler.removeTweens(this);
			Starling.juggler.removeTweens(_container);
			Starling.juggler.removeTweens(_image);

			_image.removeEventListener(TouchEvent.TOUCH, onTouch);
			_container.removeChild(_image,true);
			this.removeChild(_container,true);
			this.parent.removeChild(this, true);
		}


	}
}
