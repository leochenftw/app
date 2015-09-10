package Pages
{
	import com.Leo.utils.LeoButton;
	import com.Leo.utils.UIScrollVerticalMaker;
	import com.danielfreeman.madcomponents.UILabel;
	import com.ruochi.shape.RoundRect;
	
	import flash.events.MouseEvent;
	
	import Classes.ClsTranslate;

	public class PageMetOut extends Page
	{
		private var _btnBack:LeoButton;
		private var _scroller:UIScrollVerticalMaker;
		private var _tray:RoundRect;
		private var _output:UILabel;
		private var _translator:ClsTranslate = new ClsTranslate;
		public function PageMetOut(prTitle:String="")
		{
			super(prTitle);
			_btnBack = new LeoButton(int(_h*0.1),int(_h*0.01),'BACK',0xffffff,0xED4337);
			_btnBack.width = int(_w*0.9);
			_btnBack.x = int(_w*0.05);
			_btnBack.y = _h - int(_w*0.05) - _btnBack.height;
			addChild(_btnBack);
			
			_tray = new RoundRect(int(_w*0.9), _h - int(_w*0.15) - (_lblTitle.y + _lblTitle.height) - _btnBack.height,int(_h*0.01),0xffffff,0.9);
			_tray.y = _lblTitle.y + _lblTitle.height + int(_w*0.05);
			_tray.x = int(_w*0.05);
			addChild(_tray);
			
			_scroller = new UIScrollVerticalMaker(_tray,int(_tray.width*0.96),int(_tray.height*0.96));
			_scroller.x = int(_tray.width*0.02);
			_scroller.y = int(_tray.height*0.02);
			
			_output = new UILabel(this,0,0,'',Statics.FONTSTYLES['text-in']);
			_output.fixwidth = _scroller.width;
			_output.multiline = true;
			_scroller.attachVertical(_output);
			
			_btnBack.addEventListener(MouseEvent.CLICK,goback);
		}
		
		protected function goback(event:MouseEvent):void
		{
			Statics.NAV.prev(null,Statics.PAGEIN.releaseInput);
		}
		
		public function set result(s:String):void {
			_translator.translate(s,updateText);
			
		}
		
		private function updateText(s:String):void {
			while (s.indexOf('<br><br><br>') >= 0) {
				s = s.replace(/<br><br><br>/gi,'<br><br>');
			}
			_output.htmlText = s;
			_scroller.attention()
		}
		
	}
}