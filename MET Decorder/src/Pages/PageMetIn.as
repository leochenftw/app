package Pages
{
	import com.Leo.utils.LeoButton;
	import com.Leo.utils.LeoNativeText;
	import com.ruochi.shape.RoundRect;

	public class PageMetIn extends Page
	{
		private var _tray:RoundRect;
		private var _btnTranslate:LeoButton;
		private var _input:LeoNativeText;
		public function PageMetIn(prTitle:String = '')
		{
			super(prTitle);
			
			_btnTranslate = new LeoButton(int(_h*0.1),int(_h*0.01),'DECODE',0xffffff,0x009cf4);
			_btnTranslate.width = int(_w*0.9);
			_btnTranslate.x = int(_w*0.05);
			_btnTranslate.y = _h - int(_w*0.05) - _btnTranslate.height;
			addChild(_btnTranslate);			
			
			_tray = new RoundRect(int(_w*0.9), _h - int(_w*0.15) - (_lblTitle.y + _lblTitle.height) - _btnTranslate.height,int(_h*0.01),0xffffff,0.9);
			_tray.y = _lblTitle.y + _lblTitle.height + int(_w*0.05);
			_tray.x = int(_w*0.05);
			addChild(_tray);
			
//			LeoNativeText = new LeoNativeText(Statics.FONTSTYLES['text-in'],
			
		}
	}
}