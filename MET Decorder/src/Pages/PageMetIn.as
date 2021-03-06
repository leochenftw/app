package Pages
{
	import com.Leo.utils.LeoButton;
	import com.Leo.utils.LeoNativeText;
	
	import flash.events.MouseEvent;
	import flash.text.ReturnKeyLabel;

	public class PageMetIn extends Page
	{
		private var _btnReset:LeoButton;
		private var _btnTranslate:LeoButton;
		private var _input:LeoNativeText;
		public function PageMetIn(prTitle:String = '')
		{
			super(prTitle);
			
			_btnReset = new LeoButton(int(_h*0.1),int(_h*0.01),'CLEAR',0xffffff,0xED4337,1,0.4);
			_btnReset.width = int(_w*0.425);
			_btnReset.x = int(_w*0.05);
			_btnReset.y = _h - int(_w*0.05) - _btnReset.height;
			addChild(_btnReset);
			
			_btnTranslate = new LeoButton(int(_h*0.1),int(_h*0.01),'DECODE',0xffffff,0x009cf4,1,0.4);
			_btnTranslate.width = int(_w*0.425);
			_btnTranslate.x = int(_w*0.95) - _btnTranslate.width;
			_btnTranslate.y = _h - int(_w*0.05) - _btnTranslate.height;
			addChild(_btnTranslate);
			
			
			
			_input = new LeoNativeText(Statics.FONTSTYLES['text-in'],
											  int(_w*0.9), _h - int(_w*0.15) - (_lblTitle.y + _lblTitle.height) - _btnTranslate.height,int(_h*0.01),0xffffff,0.9,
											  int(_h*0.01),0,0xffffff,0,true,'Please copy your TAF or METAR message, and paste in here',ReturnKeyLabel.DONE);
			_input.unfreezeUponAddtoScreen = false;
			_input.y = _lblTitle.y + _lblTitle.height + int(_w*0.05);
			_input.x = int(_w*0.05);
			addChild(_input);

			_btnReset.addEventListener(MouseEvent.CLICK, reset);
			_btnTranslate.addEventListener(MouseEvent.CLICK, translate);
		}
		
		protected function reset(e:MouseEvent):void
		{
			_input.text = '';
		}		
		
		protected function translate(e:MouseEvent):void {
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