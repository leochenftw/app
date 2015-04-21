package UI
{
	import com.Leo.utils.LeoBitmapResizer;
	import com.Leo.utils.UIScrollVerticalMaker;
	import com.Leo.utils.dFormat;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import Managers.FileIO;

	public class UITransactionGroup extends UITransactionMaster
	{
		private var _triangle:Sprite = new Sprite;
		private var _btnExpand:Sprite = new Sprite;
		private var _mask:Shape = new Shape;
		private var _idx:int = 0;
		private var _scroller:UIScrollVerticalMaker;
		private var _parentScroller:UIScrollVerticalMaker;
		public function UITransactionGroup(prID:String,parentScroller:UIScrollVerticalMaker)
		{
			super(prID);
			_parentScroller = parentScroller;
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRect(0,0,Statics.STAGEWIDTH, Math.round(Statics.STAGEHEIGHT*0.11)+1);
			_mask.graphics.endFill();
						
			var imgExpand:Bitmap = FileIO.getImage('arrow');
			imgExpand = LeoBitmapResizer.resize(imgExpand,0,Math.round(this.height*0.35));
			imgExpand.x = -imgExpand.width * 0.5;
			imgExpand.y = -imgExpand.height * 0.5;
			_btnExpand.addChild(imgExpand);
			
			_btnExpand.y = this.height*0.5;
			_btnExpand.x = Statics.STAGEWIDTH - Math.round(_btnExpand.height*1.5);
			addChild(_btnExpand);
			
			this.graphics.lineStyle(1,0xD5D5D5);
			this.graphics.moveTo(0,this.height);
			this.graphics.lineTo(Statics.STAGEWIDTH,this.height);
			
			var imgTriangle:Bitmap = FileIO.getImage('arrow-s');;
			imgTriangle = LeoBitmapResizer.resize(imgTriangle,0,Math.round(this.height*0.35));
			_triangle.addChild(imgTriangle);
			
			_triangle.rotation = -90;
			_triangle.y = this.height+_triangle.height;
			_triangle.x = Statics.STAGEWIDTH - _triangle.width*2;
			
			_scroller = new UIScrollVerticalMaker(this,Statics.STAGEWIDTH,this.height*3);
			removeChild(_scroller);
			_scroller.y = this.height;
			_btnExpand.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		public function addTransaction(prAmount:Number, prCategory):void {
			var o:Object = {
				amount: prAmount,
				category: prCategory
			};
			
			var lcTranItem:UITransactionItem = new UITransactionItem(_idx.toString(),o);
			_idx++;
			
			_scroller.attachVertical(lcTranItem);
			
			if (!stage) {
				_sum += prAmount;
				_txtSum.text = dFormat(Math.abs(_sum));
				if (_sum<0) {
					_txtSum.setTextFormat(Statics.FONTSTYLES['expense']);
					_txtSum.defaultTextFormat = Statics.FONTSTYLES['expense'];
				}else{
					_txtSum.setTextFormat(Statics.FONTSTYLES['income']);
					_txtSum.defaultTextFormat = Statics.FONTSTYLES['income'];
				}
			}else{
				var tmpO:Object = {a:_sum};
				Statics.tLite(tmpO,1,{a:_sum+=prAmount, onUpdate:function():void {
					_txtSum.text = dFormat(Math.abs(tmpO.a));
					if (tmpO.a<0) {
						_txtSum.setTextFormat(Statics.FONTSTYLES['expense']);
						_txtSum.defaultTextFormat = Statics.FONTSTYLES['expense'];
					}else{
						_txtSum.setTextFormat(Statics.FONTSTYLES['income']);
						_txtSum.defaultTextFormat = Statics.FONTSTYLES['income'];
					}
				},onComplete:function():void {
					delete tmpO.a;
					tmpO = null;
				}});
			}
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			var ty:Number = _mask.height;
			if (_btnExpand.rotation == 0) {
				addChild(_triangle);
				addChild(_mask);
				_triangle.mask = _mask;
				addChildAt(_scroller,0);
				Statics.tLite(_btnExpand, 0.25, {rotation: 90});
				Statics.tLite(_triangle, 0.25, {y: ty});
				_parentScroller.expand(this,ty*3);
				_parentScroller.scrollEnabled = false;
			}else{
				removeChild(_scroller);
				_parentScroller.collapse(this,ty*3);
				Statics.tLite(_btnExpand, 0.25, {rotation: 0});
				Statics.tLite(_triangle, 0.25, {y: ty+_triangle.height, onComplete:function():void {
					removeChild(_triangle);
					removeChild(_mask);
					_parentScroller.scrollEnabled = true;
				}});
			}
		}
	}
}