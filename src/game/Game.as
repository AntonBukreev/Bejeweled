/**
 * Created with IntelliJ IDEA.
 * User: rem
 * Date: 07.08.15
 * Time: 13:09
 * To change this template use File | Settings | File Templates.
 */
package game {
	import assets.Assets;

	import flash.utils.Dictionary;

	import game.pages.Page;

	import game.pages.PageFinal;

	import game.pages.PageGame;

	import game.pages.PageStart;

	import starling.animation.Tween;
	import starling.display.DisplayObjectContainer;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Game extends Sprite
	{
		public static var PAGE_START:String = "PAGE_START";
		public static var PAGE_GAME:String = "PAGE_GAME";
		public static var PAGE_FINAL:String = "PAGE_FINAL";


		//main container
		private static var _container:Sprite;
		//showing page
		private static var _currentPage:Page;
		//all pages Classes
		private static var pages:Dictionary = new Dictionary();

		/**
		 * page manager and parent for all sprites in game
		 */
		public function Game()
		{
			super();
			_container = new Sprite();
			this.addChild(_container);

			registerPages();

			var img:Image = new Image(Assets.getTexture(Assets.BACK));
			_container.addChild(img);

			addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}

		/**
		 * start game -> show start page
		 */
		private function onAddToStage(event:Event):void
		{
			showPage(PAGE_START);
		}

		/**
		 * register all possible pages
		 */
		private function registerPages():void
		{
			pages[PAGE_START] = PageStart;
			pages[PAGE_GAME] = PageGame;
			pages[PAGE_FINAL] = PageFinal;
		}

		/**
		 * show new page
		 * @param name - page name
		 * @param data - init page data
		 */
		public static function showPage(name:String, data:Object=null):void
		{
			if (_currentPage)
			{
				_currentPage.hide();
			}

			var PageClass:Class = pages[name];
			var page:Page = new PageClass(data);
			_container.addChild(page);
			page.show();
			_currentPage = page;
		}
	}
}
