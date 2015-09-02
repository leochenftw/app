package Managers
{
	import flash.display.Bitmap;

	public class AssetManager
	{
		[Embed(source="../Assets/bg.jpg")]
		public static const imgBG:Class;
		[Embed(source="../Assets/logo.png")]
		public static const imgLogo:Class;
		
		public function AssetManager()
		{
			
		}
		
		public static function getImage(prName:String):Bitmap {
			var bmp:Bitmap;
			switch (prName) {
				case 'bg':
					bmp = new imgBG as Bitmap;
					break;
				case 'logo':
					bmp = new imgLogo as Bitmap;
					break;
			}
			bmp.smoothing = true;
			return bmp;
		}
	}
}