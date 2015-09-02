package Pages
{
	import com.danielfreeman.madcomponents.UILabel;
	
	import flash.display.Sprite;
	
	public class Page extends Sprite
	{
		protected var _w:int = Statics.STAGEWIDTH;
		protected var _h:int = Statics.STAGEHEIGHT;
		protected var _lblTitle:UILabel;
		public function Page(prTitle:String = '')
		{
			if (prTitle.length > 0) {
				_lblTitle = new UILabel(this,0,Statics.PADDINGTOP*0.5,prTitle,Statics.FONTSTYLES['page-title']);
				_lblTitle.x = int(_w*0.05);
				_lblTitle.fixwidth = int(_w*0.9);
			}
		}
		
	}
}