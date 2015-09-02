package Pages
{
	import com.Leo.utils.LeoButton;
	import com.Leo.utils.LeoNativeText;
	import flash.text.ReturnKeyLabel;
	import flash.events.MouseEvent;

	public class PageMetIn extends Page
	{
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
			

			
			_input = new LeoNativeText(Statics.FONTSTYLES['text-in'],
											  int(_w*0.9), _h - int(_w*0.15) - (_lblTitle.y + _lblTitle.height) - _btnTranslate.height,int(_h*0.01),0xffffff,0.9,
											  int(_h*0.01),0,0xffffff,0,true,'Please copy your TAF or METAR message, and pasted in here',ReturnKeyLabel.DONE);
			_input.y = _lblTitle.y + _lblTitle.height + int(_w*0.05);
			_input.x = int(_w*0.05);
			addChild(_input);
											  
			_btnTranslate.addEventListener(MouseEvent.CLICK, translate);
		}
		
		protected function translate(event:MouseEvent):void {
			Statics.PAGEOUT.result = _input.text;
			_input.freeze();
			_input.unfreezeUponAddtoScreen = false;
			Statics.NAV.next();
		}
		
		public function releaseInput():void {
			_input.unfreeze();
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}