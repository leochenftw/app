package UI
{
	import com.Leo.ui.Rect;
	
	import feathers.controls.Button;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class UINavbar extends Sprite
	{
		private var _btnMenu:Button = new Button;
		private var _bg:Rect = new Rect(Statics.STAGEWIDTH, Statics.PADDINGTOP, 0x212121);
		private var _title:TextField;
		public function UINavbar()
		{
			super();
			addChild(_bg);
			_btnMenu.label = 'Menu';
			_btnMenu.height = Math.round(_bg.height*0.6);
			_btnMenu.x = Math.round(Statics.STAGEWIDTH*0.05);
			addChild(_btnMenu);
			_btnMenu.y = Math.round((_bg.height - _btnMenu.height)*0.5);
			
			_title = new TextField(_bg.width - (_btnMenu.width + _btnMenu.x)*2, _btnMenu.height, 'Transactions','Myriad Pro',Math.round(_btnMenu.height*0.6),0xffffff);
			_title.x = _btnMenu.x + _btnMenu.width;
			_title.y = _btnMenu.y;
			
			addChild(_title);
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}
	}
}