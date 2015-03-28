package Pages
{
	import com.Leo.ui.Rect;
	
	import UI.UITransactionForm;
	import UI.UITransactionItem;
	
	import feathers.controls.ScrollContainer;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class PageOverview extends MasterPage
	{
		private var _btnIncome:Rect = new Rect(Statics.STAGEWIDTH*0.5, Math.round(Statics.STAGEHEIGHT*0.18),0x10BEC6);
		private var _btnExpense:Rect = new Rect(Statics.STAGEWIDTH*0.5, Math.round(Statics.STAGEHEIGHT*0.18),0xE46752);
		private var _form:UITransactionForm;
		private var _scroller:ScrollContainer;
		public function PageOverview()
		{
			super();
			_btnIncome.name = 'income';
			_btnExpense.name = 'expense';
			_btnExpense.x = _btnIncome.width;
			_btnIncome.y = _btnExpense.y = Statics.PADDINGTOP;
			addChild(_btnIncome);
			addChild(_btnExpense);
			this.addEventListener(TouchEvent.TOUCH,tapHandler);
		}
		
		protected override function init(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			_scroller = new ScrollContainer;
			_scroller.y = _btnIncome.y + _btnIncome.height;
			_scroller.height = Statics.STAGEHEIGHT - _scroller.y;
			trace(_scroller.isEnabled);
			addChild(_scroller);
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
								placeInputForm(true);
								break;
							case 'expense':
								placeInputForm(false);
								break;
						}
					}
				}
			}
		}
		
		
		
		private function placeInputForm(inout:Boolean):void {
			
			if (_form&&contains(_form)) {
				removeChild(_form,true);
				_form = null;
			}else{
				var data:Object = {};
				_form = new UITransactionForm(inout,function(prAmount:Number, prCategory:String):void {
					var item:UITransactionItem = new UITransactionItem({date:'22 JAN 2015'});
					item.y = _scroller.numChildren * item.height;
					_scroller.addChild(item);
					removeChild(_form,true);
					_form = null;
				});
				_form.y = _btnIncome.y + _btnIncome.height;
				addChild(_form);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}