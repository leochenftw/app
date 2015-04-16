package Managers
{
	import flash.display.Bitmap;

	public class FileIO
	{
		[Embed(source="../Assets/arrow.png")]
		public static const imgArrow:Class;
		
		public function FileIO()
		{
			var lcArrow:Bitmap = new imgArrow as Bitmap;
			Statics.ASSETS['Arrow'] = lcArrow;
		}
	}
}