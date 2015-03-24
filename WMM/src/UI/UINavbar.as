package UI
{
	import com.Leo.ui.Rect;
	
	import feathers.controls.Button;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class UINavbar extends Sprite
	{
		private var _btnMenu:Button = new Button;
		private var _bg:Rect = new Rect(Statics.STAGEWIDTH, Math.round(Statics.STAGEHEIGHT*0.1), 0x212121);
		public function UINavbar()
		{
			super();
			addChild(_bg);
			_btnMenu.label = 'Menu';
			_btnMenu.x = Math.round(Statics.STAGEWIDTH*0.05);
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(_btnMenu);
			/*addEventListener(Event.ENTER_FRAME,function(e:Event):void {
				trace(_btnMenu.height);
				_btnMenu.y = Math.round((_bg.height - _btnMenu.height)*0.5);
			});*/
			_btnMenu.y = Math.round((_bg.height - _btnMenu.height)*0.5);
		}
	}
}