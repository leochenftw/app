package Managers
{
	import flash.display.Bitmap;

	public class FileIO
	{
		[Embed(source="../Assets/arrow.png")]
		public static const imgArrow:Class;
		[Embed(source="../Assets/btnedit.png")]
		public static const imgEdit:Class;
		[Embed(source="../Assets/short-arrow.png")]
		public static const imgArrowS:Class;
		
		public function FileIO()
		{
			var lcArrow:Bitmap = new imgArrow as Bitmap;
			Statics.ASSETS['Arrow'] = lcArrow;
		}
		
		public static function getImage(prName:String):Bitmap {
			var bmp:Bitmap;
			switch (prName) {
				case 'arrow':
					bmp = new imgArrow as Bitmap;
					break;
				case 'arrow-s':
					bmp = new imgArrowS as Bitmap;
					break;
				case 'edit':
					bmp = new imgEdit as Bitmap;
					break;
				
			}
			return bmp;
		}
	}
}