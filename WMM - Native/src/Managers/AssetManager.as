package Managers
{
	import flash.display.Bitmap;

	public class AssetManager
	{
		[Embed(source="../Assets/arrow.png")]
		public static const imgArrow:Class;
		[Embed(source="../Assets/btnedit.png")]
		public static const imgEdit:Class;
		[Embed(source="../Assets/arrow-bottom.png")]
		public static const imgArrowS:Class;
		[Embed(source="../Assets/icoEmail.png")]
		public static const imgEmail:Class;
		[Embed(source="../Assets/icoPass.png")]
		public static const imgPass:Class;
		[Embed(source="../Assets/logo.png")]
		public static const imgLogo:Class;
		[Embed(source="../Assets/trash.png")]
		public static const imgTrash:Class;
		[Embed(source="../Assets/pencilonmemo.png")]
		public static const imgEditMemo:Class;
		[Embed(source="../Assets/cross.png")]
		public static const imgCross:Class;
		[Embed(source="../Assets/calendar.png")]
		public static const imgCalendar:Class;
		
		public function AssetManager()
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
				case 'email':
					bmp = new imgEmail as Bitmap;
					break;
				case 'pass':
					bmp = new imgPass as Bitmap;
					break;
				case 'logo':
					bmp = new imgLogo as Bitmap;
					break;
				case 'trash':
					bmp = new imgTrash as Bitmap;
					break;
				case 'edit-memo':
					bmp = new imgEditMemo as Bitmap;
					break;
				case 'cross':
					bmp = new imgCross as Bitmap;
					break;
				case 'calendar':
					bmp = new imgCalendar as Bitmap;
					break;
			}
			bmp.smoothing = true;
			return bmp;
		}
	}
}