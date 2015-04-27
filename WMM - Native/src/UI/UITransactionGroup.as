package UI
{
	import com.Leo.utils.LeoBitmapResizer;
	import com.Leo.utils.UIScrollVerticalMaker;
	import com.Leo.utils.dFormat;
	import com.ruochi.shape.Rect;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import DataTypes.TypeTransaction;
	
	import Managers.AssetManager;

	public class UITransactionGroup extends UITransactionMaster
	{
		private var _triangle:Sprite = new Sprite;
		private var _btnExpand:Sprite = new Sprite;
		private var _mask:Shape = new Shape;
		private var _scroller:UIScrollVerticalMaker;
		private var _parentScroller:UIScrollVerticalMaker;
		private var _btnRealExpand:Rect;
		private var _lst:Vector.<int> = new Vector.<int>;
		public function UITransactionGroup(prID:String,parentScroller:UIScrollVerticalMaker)
		{
			super(prID);
			_parentScroller = parentScroller;
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRect(0,0,Statics.STAGEWIDTH, Math.round(Statics.STAGEHEIGHT*0.11)+1);
			_mask.graphics.endFill();
						
			var imgExpand:Bitmap = AssetManager.getImage('arrow');
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
			
			var imgTriangle:Bitmap = AssetManager.getImage('arrow-s');;
			imgTriangle = LeoBitmapResizer.resize(imgTriangle,0,Math.round(this.height*0.35));
			_triangle.addChild(imgTriangle);
			
			_triangle.rotation = -90;
			_triangle.y = this.height+_triangle.height;
			_triangle.x = Statics.STAGEWIDTH - _triangle.width*2;
			
			_scroller = new UIScrollVerticalMaker(this,Statics.STAGEWIDTH,0,0,0,'',_parentScroller);
			removeChild(_scroller);
			_scroller.y = this.height;
			_btnRealExpand = new Rect(this.width - _txtSum.x - _txtSum.width,this.height,0xffffff);
			_btnRealExpand.alpha = 0;
			_btnRealExpand.x = _txtSum.x + _txtSum.width;
			addChild(_btnRealExpand);
			_btnRealExpand.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		public function dbFeed(o:TypeTransaction):void {
			_lst.push(o.tid);
			var lcTranItem:UITransactionItem = new UITransactionItem(o.tid.toString(),o,this);
			_scroller.attachVertical(lcTranItem);
			if (_scroller.pureLayer.numChildren < 3 ) {
				_scroller.height += lcTranItem.height;
			}
			if (!stage) {
				_sum += o.amount;
				_txtSum.text = dFormat(Math.abs(_sum));
				if (_sum<0) {
					_txtSum.setTextFormat(Statics.FONTSTYLES['expense']);
					_txtSum.defaultTextFormat = Statics.FONTSTYLES['expense'];
				}else{
					_txtSum.setTextFormat(Statics.FONTSTYLES['income']);
					_txtSum.defaultTextFormat = Statics.FONTSTYLES['income'];
				}
			}else{
				update(o.amount);
			}
			
		}
		
		public function addTransaction(prAmount:Number, prCategory:String):void {
			var d:Date = new Date;
			var o:TypeTransaction = new TypeTransaction;
			o.date = int(_id.split('/')[0]);
			o.month = int(_id.split('/')[1]);
			o.year = int(_id.split('/')[2]);
			o.category = prCategory;
			o.amount = prAmount;
			o.utcstamp = d.time.toString();
			
			var lcThis:UITransactionGroup = this;
			Statics.DB.addTrans(o.category,o.amount,o.FullDate,o.description,o.utcstamp,function(tid:int):void {
				o.tid = tid;
				_lst.push(tid);
				var lcTranItem:UITransactionItem = new UITransactionItem(tid.toString(),o,lcThis);
				
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
					update(prAmount);
				}
			});
			
			
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
				_parentScroller.expand(this,ty*(_scroller.pureLayer.numChildren<3?_scroller.pureLayer.numChildren:3));
				//_parentScroller.scrollEnabled = false;
			}else{
				if (_scroller && contains(_scroller)) {
					removeChild(_scroller);
				}
				_parentScroller.collapse(this,_scroller.height);
				Statics.tLite(_btnExpand, 0.25, {rotation: 0});
				Statics.tLite(_triangle, 0.25, {y: ty+_triangle.height, onComplete:function():void {
					removeChild(_triangle);
					removeChild(_mask);
					//_parentScroller.scrollEnabled = true;
				}});
			}
		}
		
		public function update(prAmount:Number):void {
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
				_sum = tmpO.a;
				delete tmpO.a;
				tmpO = null;
			}});
		}
	}
}