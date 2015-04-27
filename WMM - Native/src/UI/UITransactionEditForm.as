package UI
{
	import com.Leo.ui.LeoImageButton;
	import com.Leo.utils.LeoBitmapResizer;
	import com.Leo.utils.LeoButton;
	import com.Leo.utils.LeoInput;
	import com.Leo.utils.dFormat;
	import com.Leo.utils.pf;
	import com.Leo.utils.trim;
	import com.danielfreeman.madcomponents.UILabel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import DataTypes.TypeTransaction;
	
	import Managers.AssetManager;
	
	public class UITransactionEditForm extends Sprite
	{
		private var _data:TypeTransaction;
		private var _y:Number = Math.round(Statics.STAGEHEIGHT*0.11);
		private var _x:Number = Math.round(Statics.STAGEWIDTH*0.05);
		private var _screenBlocker:Sprite = new Sprite;
		private var _txtAmount:Sprite = new Sprite;
		private var _spCat:Sprite = new Sprite;
		private var _txtCat:LeoInput;
		private var _btnDelete:LeoImageButton;
		private var _btnEditMemo:LeoImageButton;
		private var _spMemo:Sprite = new Sprite;
		private var _btnCancel:LeoImageButton;
		private var _btnEnter:LeoButton;
		private var _btnCal:LeoButton;
		private var _fakeTransaction:Bitmap;
		private var _point:Point;
		private var _transY:Number;
		private var _txtMemo:TextField;
		private var _lblAmount:UILabel;
		private var _transaction:UITransactionItem;
		public function UITransactionEditForm(transaction:UITransactionItem)
		{
			_transaction = transaction;
			var tranBMD:BitmapData = new BitmapData(transaction.width,transaction.height,true,0x000000);
			tranBMD.draw(transaction,null,null,null,null,true);
			_fakeTransaction = new Bitmap(tranBMD,'auto',true);
			_fakeTransaction.smoothing = true;
			addChild(_fakeTransaction);
			
			_point = new Point(transaction.x,transaction.y);
			_transY = transaction.localToGlobal(_point).y;
			
			_data = transaction.data;
			this.graphics.beginFill(0xE6E6E6);
			this.graphics.drawRect(0,0,Statics.STAGEWIDTH,Statics.STAGEHEIGHT);
			this.graphics.endFill();
			
			_screenBlocker.graphics.beginFill(0xE6E6E6,0);
			_screenBlocker.graphics.drawRect(0,0,Statics.STAGEWIDTH,Statics.STAGEHEIGHT);
			_screenBlocker.graphics.endFill();
			
			_btnDelete = new LeoImageButton(Math.round(Statics.STAGEHEIGHT*0.1),Math.round(Statics.STAGEHEIGHT*0.1), 0xCDCDCD, AssetManager.getImage('trash'),0.5);
			_btnDelete.x = this.width - _x - _btnDelete.width;
			_btnDelete.y = _y + _x;
			addChild(_btnDelete);
			
			_btnEditMemo = new LeoImageButton(Math.round(Statics.STAGEHEIGHT*0.1),Math.round(Statics.STAGEHEIGHT*0.1), 0xCDCDCD, AssetManager.getImage('edit-memo'),0.5);
			_btnEditMemo.x = this.width - _x - _btnEditMemo.width;
			_btnEditMemo.y = _btnDelete.y + _btnDelete.height + _x;
			addChild(_btnEditMemo);
			
			_txtAmount.graphics.beginFill(0xffffff,1);
			_txtAmount.graphics.drawRect(0,0,Statics.STAGEWIDTH - _x*3 - _btnDelete.width,Math.round(Statics.STAGEHEIGHT*0.1));
			_txtAmount.graphics.endFill();
			_txtAmount.x = _x;
			_txtAmount.y = _y + _x;
			addChild(_txtAmount);
			
			_lblAmount = new UILabel(_txtAmount, _x,0,dFormat(Math.abs(_data.amount)), Statics.FONTSTYLES['date-label']);
			_lblAmount.y = Math.round((_txtAmount.height - _lblAmount.height*2 + _lblAmount.textHeight)*0.5);
			_lblAmount.fixwidth = _txtAmount.width - _x*2;
			
			_txtAmount.addEventListener(MouseEvent.CLICK, startPin);
			
			_spCat.graphics.beginFill(0xffffff,1);
			_spCat.graphics.drawRect(0,0,Statics.STAGEWIDTH - _x*3 - _btnEditMemo.width,Math.round(Statics.STAGEHEIGHT*0.1));
			_spCat.graphics.endFill();
			_spCat.x = _x;
			_spCat.y = _btnEditMemo.y;
			addChild(_spCat);
			
			_txtCat = new LeoInput(_spCat.width - _x*2, Math.round(_spCat.height*0.5),this,'',Statics.FONTSTYLES['date-label'],false,0,'Category');
			_txtCat.x = _x;
			_txtCat.y = Math.round((_spCat.height - _txtCat.textHeight)*0.5);
			_spCat.addChild(_txtCat);
			
			_txtCat.text = _data.category;
						
			_btnCancel = new LeoImageButton(Math.round(Statics.STAGEHEIGHT*0.1),Math.round(Statics.STAGEHEIGHT*0.1), 0xCDCDCD, AssetManager.getImage('cross'), 0.5);
			_btnCancel.x = _x;
			_btnCancel.y = Statics.STAGEHEIGHT - _x - _btnCancel.height;
			addChild(_btnCancel);
			
			_btnEnter = new LeoButton(Math.round(Statics.STAGEHEIGHT*0.1),0,'Enter',0xffffff,0xCDCDCD,1,0.5);
			addChild(_btnEnter);
			_btnEnter.width = Statics.STAGEWIDTH - _x*3 - _btnCancel.width;
			_btnEnter.x = _x*2 + _btnCancel.width;
			_btnEnter.y = _btnCancel.y;
			
			_btnCal = new LeoButton(Math.round(Statics.STAGEHEIGHT*0.1),0,_data.FullDate,0x212121,0xffffff,1,0.4);
			addChild(_btnCal);
			_btnCal.width = Statics.STAGEWIDTH - _x*2;
			_btnCal.x = _x;
			_btnCal.y = _btnEnter.y - _x - _btnCal.height;
			var imgCal:Bitmap = AssetManager.getImage('calendar');
			imgCal = LeoBitmapResizer.resize(imgCal,0,Math.round(_btnCal.height*0.5));
			imgCal.x = _btnCal.width - _x - imgCal.width;
			imgCal.y = Math.round((_btnCal.height - imgCal.height)*0.5);
			_btnCal.addChild(imgCal);
			_btnCal.labelObject.fixwidth = _btnCal.width - _x*3 - imgCal.width;
//			if (Statics.FONTSTYLES['calendar'] == undefined){
//				Statics.FONTSTYLES['calendar'] = new TextFormat("Myriad Pro", _btnCal.height*0.4,0x212121,null,null,null,null,null,'left');
//			}
			_btnCal.labelObject.defaultTextFormat = Statics.FONTSTYLES['date-label'];
			_btnCal.labelObject.setTextFormat(Statics.FONTSTYLES['date-label']);
			_btnCal.labelObject.x = _x;
			
			
			_spMemo.graphics.beginFill(0xffffff,1);
			_spMemo.graphics.drawRect(0,0,Statics.STAGEWIDTH-_x*2, _btnCal.y - (_spCat.y + _spCat.height) - _x*2);
			_spMemo.graphics.endFill();
			
			_txtMemo = new TextField;
			_txtMemo.width = _spMemo.width - _x*2;
			_txtMemo.height = _spMemo.height - _x*2;
			_txtMemo.x = _x;
			_txtMemo.y = _x;
			_txtMemo.type = 'input';
			_txtMemo.multiline = true;
			_txtMemo.defaultTextFormat = Statics.FONTSTYLES['date-label'];
			if (_data.description.length > 0) {
				_txtMemo.text = _data.description;
			}else{
				_txtMemo.htmlText = '<font size="'+Math.round(_btnCal.height*0.2)+'" color="#cdcdcd">What is this transaction about?</font>';
			}
			_spMemo.addChild(_txtMemo);
			_txtMemo.addEventListener(FocusEvent.FOCUS_IN, focIn);
			_spMemo.x = _x;
			_spMemo.y = _spCat.y + _spCat.height + _x;
			addChild(_spMemo);
			
			addEventListener(Event.ADDED_TO_STAGE, toStage);
			
			_btnCancel.addEventListener(MouseEvent.CLICK, clickCancel);
			_btnEnter.addEventListener(MouseEvent.CLICK, clickEnter);
		}
		
		protected function clickEnter(e:MouseEvent):void
		{
			clickCancel(null,true);
		}
		
		protected function startPin(e:MouseEvent):void
		{
			stage.addChild(Statics.PINPAD);
			Statics.PINPAD.label = _lblAmount;
		}
		
		protected function focIn(e:FocusEvent):void
		{
			_txtMemo.addEventListener(FocusEvent.FOCUS_OUT, focOut);
			if (_txtMemo.text == 'What is this transaction about?') {
				_txtMemo.htmlText = '';
			}
		}
		
		protected function focOut(e:FocusEvent):void
		{
			_txtMemo.removeEventListener(FocusEvent.FOCUS_OUT, focOut);
			if (trim(_txtMemo.text).length == 0) {
				_txtMemo.htmlText = '<font size="'+Math.round(_btnCal.height*0.2)+'" color="#cdcdcd">What is this transaction about?</font>';
			}
		}
		
		protected function clickCancel(e:MouseEvent = null,updateData:Boolean = false):void
		{
			var lcThis:UITransactionEditForm = this;
			Statics.tLite(this,0.25,{y:Statics.STAGEHEIGHT, onComplete:function():void {
				if (updateData) {
					_data.amount = pf(_lblAmount.text)*(_data.amount < 0?-1:1);
					_data.description = _txtMemo.text == 'What is this transaction about?'?'':trim(_txtMemo.text);
					_data.category = trim(_txtCat.text);
					_transaction.update();
				}
				removeChild(_fakeTransaction);
				stage.removeChild(_screenBlocker);
				stage.removeChild(lcThis);
			}});
		}
		
		protected function toStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, toStage);
			stage.addChildAt(_screenBlocker,stage.numChildren-1);
			addEventListener(Event.REMOVED_FROM_STAGE, offStage);
			
			this.y = Statics.STAGEHEIGHT;
			var lcThis:UITransactionEditForm = this;
			Statics.tLite(this,0.25,{y:0});
		}
		
		protected function offStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, offStage);
			_fakeTransaction.bitmapData.dispose();
			_fakeTransaction = null;
			_btnCancel.removeEventListener(MouseEvent.CLICK, clickCancel);
			_txtMemo.removeEventListener(FocusEvent.FOCUS_IN, focIn);
			_btnEnter.removeEventListener(MouseEvent.CLICK, clickEnter);
			_btnEnter = null;
			_txtMemo = null;
			_btnCancel = null;
			_point = null;
			
			_screenBlocker.graphics.clear();
			_screenBlocker = null;
			removeChild(_txtAmount);
			_txtAmount = null;
			removeChild(_spCat);
			_spCat = null;
			_txtCat = null;
			
		}
		
	}
}