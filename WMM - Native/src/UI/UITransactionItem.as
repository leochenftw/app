package UI
{
	import com.Leo.utils.LeoBitmapResizer;
	import com.Leo.utils.UIScrollVerticalMaker;
	import com.Leo.utils.dFormat;
	import com.Leo.utils.pf;
	import com.ruochi.shape.Rect;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import DataTypes.TypeTransaction;
	
	import Managers.AssetManager;

	public class UITransactionItem extends UITransactionMaster
	{
		private var _data:TypeTransaction;
		private var _btnEdit:Rect;
		private var _parentGroup:UITransactionGroup;
		private var _parentScroller:UIScrollVerticalMaker;
		public function UITransactionItem(prID:String,data:TypeTransaction,parentGroup:UITransactionGroup,parentScroller:UIScrollVerticalMaker)
		{
			_parentGroup = parentGroup;
			_parentScroller = parentScroller;
			super(prID);
			this.graphics.clear();
			this.graphics.beginFill(0xf6f6f6);
			this.graphics.drawRect(0,0,Statics.STAGEWIDTH, Math.round(Statics.STAGEHEIGHT*0.11));
			this.graphics.endFill();
			_data = data;
			_txtDate.text = _data.category;
			_txtSum.text = dFormat(Math.abs(data.amount).toFixed(2));
			
			if (data.amount<0) {
				_txtSum.setTextFormat(Statics.FONTSTYLES['expense']);
				_txtSum.defaultTextFormat = Statics.FONTSTYLES['expense'];
			}else{
				_txtSum.setTextFormat(Statics.FONTSTYLES['income']);
				_txtSum.defaultTextFormat = Statics.FONTSTYLES['income'];
			}
			
			this.graphics.lineStyle(1,0xD5D5D5);
			this.graphics.moveTo(0,this.height);
			this.graphics.lineTo(Statics.STAGEWIDTH,this.height);
			
			var imgPencil:Bitmap = AssetManager.getImage('edit');
			imgPencil = LeoBitmapResizer.resize(imgPencil,0,Math.round(this.height*0.35));
			imgPencil.y = Math.round((this.height - imgPencil.height)*0.5);
			imgPencil.x = this.width - imgPencil.width*2;
			imgPencil.alpha = 0.5;
			addChild(imgPencil);
			
			_btnEdit = new Rect(this.width - _txtSum.x - _txtSum.width,this.height,0xffffff);
			_btnEdit.alpha = 0;
			_btnEdit.x = _txtSum.x + _txtSum.width;
			addChild(_btnEdit);
			_btnEdit.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		protected function clickHandler(e:MouseEvent):void
		{
			var edit:UITransactionEditForm = new UITransactionEditForm(this);
			stage.addChild(edit);
		}
		
		public function get data():TypeTransaction {
			return _data;
		}
		
		public function update():void {
			var dif:Number = _data.amount - pf(_txtSum.text)*(_data.amount < 0?-1:1);
			_txtDate.text = _data.category;
			_txtSum.text = dFormat(Math.abs(_data.amount));
			_parentGroup.update(dif);
			
			Statics.DB.updateTrans(_data,{tid:_data.tid},function():void{
				
			});
		}
		
		public function destruct():void {
			_parentScroller.removeChild(this);
			var dif:Number = _data.amount*-1;
			_parentGroup.update(dif);
			_btnEdit.removeEventListener(MouseEvent.CLICK, clickHandler);
			_data = null;
			_parentGroup = null;
			_parentScroller = null;
			_btnEdit = null;
		}
	}
}