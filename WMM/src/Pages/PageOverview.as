package Pages
{
	import com.Leo.utils.DateFormatter;
	
	import flash.utils.Dictionary;
	
	import UI.UITransactionForm;
	import UI.UITransactionGroup;
	
	import feathers.controls.ScrollContainer;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class PageOverview extends MasterPage
	{
		private var _btnIncome:Quad = new Quad(Statics.STAGEWIDTH*0.5, Math.round(Statics.STAGEHEIGHT*0.18),0x10BEC6);
		private var _btnExpense:Quad = new Quad(Statics.STAGEWIDTH*0.5, Math.round(Statics.STAGEHEIGHT*0.18),0xE46752);
		private var _form:UITransactionForm;
		private var _scroller:ScrollContainer;
		private var _items:Dictionary = new Dictionary;
		private var _isScrolling:Boolean = false;
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
			addChild(_scroller);
		}
		
		
		private function tapHandler(e:TouchEvent):void {
			
			var touches:Vector.<Touch> = e.getTouches(this);
			var clicked:Quad = e.currentTarget as Quad;
			if ( touches.length == 1 )
			{
				var touch:Touch = touches[0];   
				if ( touch.phase == TouchPhase.ENDED )
				{
					var clickedObject:Quad;
					if (e.target is Image) {
						clickedObject = ((e.target as Image).parent as Quad);
					}else if (e.target is Quad) {
						clickedObject = e.target as Quad;
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
					//for (var i:int = 0; i<10;i++){
						var tmpID:String = DateFormatter(new Date());//+i.toString();
						if (_items[tmpID] === undefined) {
							var item:UITransactionGroup = new UITransactionGroup(tmpID,_scroller);
							item.addTransaction(prAmount,prCategory);
							item.y = _scroller.numChildren * item.height;
							_scroller.addChild(item);
							_items[item.id] = item;
						}else{
							(_items[tmpID] as UITransactionGroup).addTransaction(prAmount, prCategory);
						}
					//}
					removeChild(_form,true);
					_form = null;
					
				});
				_form.y = _btnIncome.y + _btnIncome.height;
				addChild(_form);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}