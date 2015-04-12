package UI
{
	import com.Leo.utils.dFormat;
	
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class UITransactionGroup extends UITransactionMaster
	{
		private var _parentScroller:ScrollContainer;
		private var _idx:int = 0;
		private var _list:ScrollContainer = new ScrollContainer;
		public function UITransactionGroup(prID:String,scroller:ScrollContainer)
		{
			_parentScroller = scroller;
			super(prID);
			_list.height = Math.round(Statics.STAGEHEIGHT*0.11)*3;
			_list.width = Statics.STAGEWIDTH;
			_list.y = Math.round(Statics.STAGEHEIGHT*0.11);
			_list.addEventListener(FeathersEventType.SCROLL_START, onScrollBegin);
			_list.addEventListener(FeathersEventType.SCROLL_COMPLETE, onScrollEnd);
			this.addEventListener(TouchEvent.TOUCH,popScroller);
		}
		
		private function onScrollBegin(e:Event):void
		{
			this.removeEventListener(TouchEvent.TOUCH,popScroller);
		}	
		
		private function onScrollEnd(e:Event):void
		{
			this.addEventListener(TouchEvent.TOUCH,popScroller);
		}	
		
		
		private function popScroller(e:TouchEvent):void {
			
			if (e.touches[0].phase == TouchPhase.ENDED) {
				if (!_parentScroller.isScrolling) {
					if (!contains(_list)) {
						addChild(_list);
					}else{
						removeChild(_list);
					}
				}
			}
		}
		
		public function addTransaction(prAmount:Number, prCategory):void {
			var o:Object = {
				amount: prAmount,
				category: prCategory
			};
			
			var lcTranItem:UITransactionItem = new UITransactionItem(_idx.toString(),o);
			_idx++;
			
			lcTranItem.y = _list.numChildren * lcTranItem.height;
			_list.addChild(lcTranItem);
			
			if (!stage) {
				_sum += prAmount;
				_txtSum.text = dFormat(_sum);
			}else{
				var tmpO:Object = {a:_sum};
				Statics.tlite(tmpO,1,{a:_sum+=prAmount, onUpdate:function():void {
					_txtSum.text = dFormat(tmpO.a);
				},onComplete:function():void {
					delete tmpO.a;
					tmpO = null;
				}});
			}
		}
		
	}
}