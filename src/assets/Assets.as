/**
 * Created with IntelliJ IDEA.
 * User: rem
 * Date: 07.08.15
 * Time: 15:43
 * To change this template use File | Settings | File Templates.
 */
package assets {
	import flash.display.Bitmap;
	import flash.utils.Dictionary;

	import starling.textures.Texture;

	import starling.textures.TextureAtlas;

	public class Assets
	{
		public static const BTN_PLAY:String = "play0000";
		public static const BACK:String = "back0000";
		public static const ITEM1:String = "item10000";
		public static const ITEM2:String = "item20000";
		public static const ITEM3:String = "item30000";
		public static const ITEM4:String = "item40000";
		public static const ITEM5:String = "item50000";
		public static const ITEM6:String = "item60000";


		[Embed(source="assets.png")]
		public static const PngTexture:Class;
		[Embed(source="assets.xml", mimeType="application/octet-stream") ]
		public static const XmlAtlas:Class;

		private static var _atlas:TextureAtlas;

		private static function getAtlas():TextureAtlas
		{
			if (_atlas == null)
			{
				var bitmap:Bitmap = new PngTexture();
				var texture:Texture = Texture.fromBitmap(bitmap);
				var xml:XML = new XML(new XmlAtlas());
				_atlas = new TextureAtlas(texture, xml);
			}
			return _atlas;
		}

		public static function getTexture(name:String):Texture
		{
			return getAtlas().getTexture(name);
		}

		public function Assets()
		{

		}
	}
}
