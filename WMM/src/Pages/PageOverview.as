package Pages
{
	import com.Leo.ui.Rect;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class PageOverview extends MasterPage
	{
		private var _btnIncome:Rect = new Rect(Statics.STAGEWIDTH, Statics.STAGEHEIGHT*0.5-0.5,0x2ECC71,0.8);
		private var _btnExpense:Rect = new Rect(Statics.STAGEWIDTH, Statics.STAGEHEIGHT*0.5-0.5,0xE74C3C,0.8);
		public function PageOverview()
		{
			super();
			_btnIncome.name = 'income';
			_btnExpense.name = 'expense';
			addChild(_btnIncome);
			_btnExpense.y = Statics.STAGEHEIGHT*0.5+0.5;
			addChild(_btnExpense);
			this.addEventListener(TouchEvent.TOUCH,tapHandler);
		}
		
		protected override function init(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function tapHandler(e:TouchEvent):void {
			var touches:Vector.<Touch> = e.getTouches(this);
			var clicked:Rect = e.currentTarget as Rect;
			if ( touches.length == 1 )
			{
				var touch:Touch = touches[0];   
				if ( touch.phase == TouchPhase.ENDED )
				{
					var clickedObject:Rect;
					if (e.target is Image) {
						clickedObject = ((e.target as Image).parent as Rect);
					}else if (e.target is Rect) {
						clickedObject = e.target as Rect;
					}
					if (clickedObject) {
						switch(clickedObject.name) {
							case 'income':
								expendIncome();
								break;
							case 'expense':
								break;
						}
					}
				}
			}
		}
		
		private function expendIncome():void {
			Statics.tlite(_btnIncome,0.25, {height:Statics.STAGEHEIGHT*0.1});
			Statics.tlite(_btnExpense,0.25, {y:Statics.STAGEHEIGHT});
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}