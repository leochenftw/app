package UI
{
	import com.Leo.utils.dFormat;
	
	import Managers.FileIO;
	
	import feathers.controls.ScrollContainer;
	import feathers.events.FeathersEventType;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class UITransactionGroup extends UITransactionMaster
	{
		private var _parentScroller:ScrollContainer;
		private var _idx:int = 0;
		private var _list:ScrollContainer = new ScrollContainer;
		private var _toggler:Sprite = new Sprite;
		private var _triangle:Sprite = new Sprite;
		public function UITransactionGroup(prID:String,scroller:ScrollContainer)
		{
			_parentScroller = scroller;
			super(prID);
			var lcArrowImage:Image = new Image(Texture.fromBitmap(FileIO.getImage('arrow')));
			
			lcArrowImage.height = Math.round(_txtDate.height*0.4);
			lcArrowImage.scaleX = lcArrowImage.scaleY;
			_toggler.pivotX = lcArrowImage.width * 0.5;
			_toggler.pivotY = lcArrowImage.height * 0.5;
			_toggler.addChild(lcArrowImage);
			_toggler.y = this.height*0.5;
			_toggler.x = this.width - _toggler.y
			
			_txtSum.width-= (_toggler.y+lcArrowImage.height * 0.5);
			
			var lcUpArrow:Image = new Image(Texture.fromBitmap(FileIO.getImage('arrow-s')));
			
			lcUpArrow.height = _toggler.height;
			lcUpArrow.scaleX = lcUpArrow.scaleY;
			lcUpArrow.rotation = -0.5*Math.PI;
			_triangle.addChild(lcUpArrow);
			
			_triangle.y = this.height;
			_triangle.x = _toggler.x - _triangle.width*0.5;
			_triangle.visible = false;
			
			_list.height = this.height*3;
			_list.width = Statics.STAGEWIDTH;
			_list.y = this.height;
			_list.addEventListener(FeathersEventType.SCROLL_START, onScrollBegin);
			_list.addEventListener(FeathersEventType.SCROLL_COMPLETE, onScrollEnd);
			addChild(_toggler);
			_toggler.addEventListener(TouchEvent.TOUCH,popScroller);
			
			addChild(_triangle);
		}
		
		private function onScrollBegin(e:Event):void
		{
			//this.removeEventListener(TouchEvent.TOUCH,popScroller);
		}	
		
		private function onScrollEnd(e:Event):void
		{
			//this.addEventListener(TouchEvent.TOUCH,popScroller);
		}	
		
		
		private function popScroller(e:TouchEvent):void {
			
			if (e.touches[0].phase == TouchPhase.ENDED) {
				if (!_parentScroller.isScrolling) {
					if (!contains(_list)) {
						addChild(_list);
						_toggler.rotation = 0.5*Math.PI;
						_triangle.visible = true;
					}else{
						removeChild(_list);
						_toggler.rotation = 0;
						_triangle.visible = false;
					}
				}
			}
		}
		
		public function addTransaction(prAmount:Number, prCategory):void {
			var o:Object = {
				amount: prAmount,
				category: prCategory
			};
			
			var lcTranItem:UITransactionItem = new UITransactionItem(_idx.toString(),o,_txtSum.width);
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