package UI
{
	import com.Leo.utils.DateFormatter;
	import com.Leo.utils.LeoBitmapResizer;
	import com.Leo.utils.LeoButton;
	import com.Leo.utils.LeoDatepicker;
	import com.Leo.utils.LeoInput;
	import com.Leo.utils.LeoNativeText;
	import com.Leo.utils.LeoSprite;
	import com.Leo.utils.pf;
	import com.danielfreeman.madcomponents.UILabel;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import Managers.AssetManager;
	
	public class UITransactionForm extends Sprite
	{
		private var _bgc:uint = 0;
		private var _txtAmount:Sprite = new Sprite;
		private var _spCat:LeoSprite = new LeoSprite;
		private var _txtCat:LeoInput;
		private var _btnFullmode:LeoButton;
		private var _btnSubmit:LeoButton;
		private const _x:Number = Math.round(Statics.STAGEWIDTH*0.05);
		private var _callback:Function;
		private var _txtMemo:LeoNativeText;
		private var _prefix:int = 1;
		private var _lblAmount:UILabel;
		private var _y:int = 0;
		private var _h:int = 0;
		private var _fh:int = Statics.STAGEHEIGHT - Math.round(Statics.STAGEHEIGHT*0.11);
		private var _btnCal:Sprite = new Sprite;
		private var _Cal:LeoDatepicker;
		private var _lblCal:UILabel;
		private var _date:Date = new Date;
		private var _btnEditCat:LeoButton;
		private var _btnEditCatMask:Shape = new Shape;
		private var _btnMenu:Sprite = new Sprite;
		public function UITransactionForm(inout:Boolean, callback:Function, fullMode:Boolean = false)
		{
			_prefix = inout?1:-1;
			_bgc = inout?0x10BEC6:0xE46752;
			_callback = callback;
			
			if (!fullMode) {
				this.addEventListener(Event.ADDED_TO_STAGE, createMinUI);
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE, createFullUI);
			}
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, offStage);
		}
		
		protected function offStage(e:Event):void
		{
			if (_txtMemo) _txtMemo.freeze();
		}
		
		public override function set height(value:Number):void {
			this.graphics.clear();
			this.graphics.beginFill(_bgc,1);
			this.graphics.drawRect(0,0,Statics.STAGEWIDTH,value);
			this.graphics.endFill();
		}
		
		protected function createFullUI(e:Event = null):void
		{
			if (this.y > 0){
				addChild(_btnEditCat);
				addChild(_btnEditCatMask);
				_btnEditCat.mask = _btnEditCatMask;
				Statics.tLite(this,0.25,{y: 0, height: _fh, onComplete:updateLayout});
				Statics.tLite([_btnSubmit,_btnFullmode],0.25,{y: _fh -_btnFullmode.height - _x});
				Statics.tLite(_spCat,0.25,{width: Statics.STAGEWIDTH - 3*_x - _spCat.height, onUpdate:function():void {
					_btnMenu.x = _spCat.width - _btnMenu.width;
					_txtCat.width = _btnMenu.x - _x;
					_btnEditCatMask.graphics.clear();
					_btnEditCatMask.graphics.beginFill(0x000000,1);
					_btnEditCatMask.graphics.drawRect(_btnEditCat.width, 0, -(Statics.STAGEWIDTH - 2*_x - _spCat.width), _btnEditCat.height);
					_btnEditCatMask.graphics.endFill();
				}});
				_txtCat.noJig = true;
			}else{
				var lcThis:UITransactionForm = this;
				if (_txtMemo) {
					_txtMemo.freeze();
					Statics.tLite([_txtMemo,_btnCal],0.25,{alpha: 0, onComplete:function():void {
						removeChild(_txtMemo);
						removeChild(_btnCal);
						Statics.tLite(lcThis,0.25,{y:_y, height: _h});
						Statics.tLite([_btnSubmit,_btnFullmode],0.25,{y: _h -_btnFullmode.height - _x});
						Statics.tLite(_spCat,0.25,{width: Statics.STAGEWIDTH - 2*_x, onUpdate:function():void {
							_btnMenu.x = _spCat.width - _btnMenu.width;
							_txtCat.width = _btnMenu.x - _x;
							_btnEditCatMask.graphics.clear();
							_btnEditCatMask.graphics.beginFill(0x000000,1);
							_btnEditCatMask.graphics.drawRect(_btnEditCat.width, 0, -(Statics.STAGEWIDTH - 2*_x - _spCat.width), _btnEditCat.height);
							_btnEditCatMask.graphics.endFill();
						},onComplete:function():void{
							_txtCat.noJig = false;
						}});
					}});
				}else{
					Statics.tLite(lcThis,0.25,{y:_y, height: _h});
					Statics.tLite([_btnSubmit,_btnFullmode],0.25,{y: _h -_btnFullmode.height - _x});
					Statics.tLite(_spCat,0.25,{width: Statics.STAGEWIDTH - 2*_x, onUpdate:function():void {
						_btnMenu.x = _spCat.width - _btnMenu.width;
						_txtCat.width = _btnMenu.x - _x;
						_btnEditCatMask.graphics.clear();
						_btnEditCatMask.graphics.beginFill(0x000000,1);
						_btnEditCatMask.graphics.drawRect(_btnEditCat.width, 0, -(Statics.STAGEWIDTH - 2*_x - _spCat.width), _btnEditCat.height);
						_btnEditCatMask.graphics.endFill();
						removeChild(_btnEditCatMask);
						removeChild(_btnEditCat);
					},onComplete:function():void{
						_txtCat.noJig = false;
					}});
				}
			}
		}
		
		protected function updateLayout():void {
			if (!_txtMemo) {
				var h:int = Math.abs(_btnFullmode.y - _btnFullmode.height*2 - 3*_x - _spCat.y);
				_txtMemo = new LeoNativeText(Statics.FONTSTYLES['date-label'],Math.round(Statics.STAGEWIDTH-_x*2),h,0,0xffffff,1,_x,0,0x000000,1,true,'e.g. what did you spend');
				_txtMemo.alpha = 0;
				_txtMemo.x = _x;
				_txtMemo.y = _spCat.y + _spCat.height + _x;
				_btnCal.y = _txtMemo.y + _txtMemo.height + _x;
				_btnCal.x = _x;
				_btnCal.alpha = 0;
			}
			if (!contains(_txtMemo)) {
				addChild(_txtMemo);
				addChild(_btnCal);
				Statics.tLite([_txtMemo,_btnCal],0.25,{alpha: 1});
			}
		}
		
		protected function createMinUI(event:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, createMinUI);
			_y = this.y;
			_txtAmount.graphics.beginFill(0xffffff,1);
			_txtAmount.graphics.drawRect(0,0,Statics.STAGEWIDTH - _x*2,Math.round(Statics.STAGEHEIGHT*0.1));
			_txtAmount.graphics.endFill();
			
			_lblAmount = new UILabel(_txtAmount, _x,0,'$0.00', Statics.FONTSTYLES['date-label']);
			_lblAmount.y = Math.round((_txtAmount.height - _lblAmount.height*2 + _lblAmount.textHeight)*0.5);
			_lblAmount.fixwidth = _txtAmount.width - _x*2;
			
			_txtAmount.addEventListener(MouseEvent.CLICK, startPin);
			
			/*_spCat.graphics.beginFill(0xffffff,1);
			_spCat.graphics.drawRect(0,0,Statics.STAGEWIDTH - _x*2,Math.round(Statics.STAGEHEIGHT*0.1));
			_spCat.graphics.endFill();*/
			_spCat.width = Statics.STAGEWIDTH - _x*2;
			_spCat.height = Math.round(Statics.STAGEHEIGHT*0.1);
			
			_btnMenu.graphics.beginFill(0xffffff,0);
			_btnMenu.graphics.drawRect(0,0,_spCat.height,_spCat.height);
			_btnMenu.graphics.endFill();
			
			var imgMenu:Bitmap = AssetManager.getImage('menu');
			imgMenu = LeoBitmapResizer.resize(imgMenu,0,Math.round(_spCat.height*0.4));
			imgMenu.x = Math.round((_btnMenu.width - imgMenu.width)*0.5);
			imgMenu.y = Math.round((_btnMenu.height - imgMenu.height)*0.5);
			_btnMenu.addChild(imgMenu);
			_btnMenu.x = _spCat.width - _btnMenu.width;
			
			_btnCal.graphics.beginFill(0xffffff,1);
			_btnCal.graphics.drawRect(0,0,Statics.STAGEWIDTH - _x*2,Math.round(Statics.STAGEHEIGHT*0.1));
			_btnCal.graphics.endFill();
			
			_lblCal = new UILabel(_btnCal,_x,_x,DateFormatter(new Date()),Statics.FONTSTYLES['date-label']);
			_lblCal.y = Math.round((_btnCal.height - _lblCal.textHeight)*0.5);
			
			var imgCal:Bitmap = AssetManager.getImage('calendar');
			imgCal = LeoBitmapResizer.resize(imgCal,0,Math.round(_btnCal.height*0.6));
			imgCal.x = _btnCal.width - _x - imgCal.width;
			imgCal.y = Math.round((_btnCal.height - imgCal.height)*0.5);
			_btnCal.addChild(imgCal);
			_lblCal.fixwidth = _btnCal.width - _x*3 - imgCal.width;
			
			_txtCat = new LeoInput(_btnMenu.x - _x,Math.round(_spCat.height*0.5),this,'',Statics.FONTSTYLES['date-label'],false,0,'Category');
			_txtCat.x = _x;
			_txtCat.y = Math.round((_spCat.height - _txtCat.textHeight)*0.5);
			_spCat.x = _x;
			_spCat.addChild(_txtCat);
			_btnFullmode = new LeoButton(_txtAmount.height,0,'...',0xffffff,0x000000,0.2,0.4);
			addChild(_btnFullmode);
			_btnFullmode.width = _btnFullmode.height;
			
			_btnSubmit = new LeoButton(_btnFullmode.height,0,'Enter',0xffffff,0x000000,0.2);
			addChild(_btnSubmit);
			_btnSubmit.width = _txtAmount.width - _x - _btnFullmode.width;
			
			addChild(_txtAmount);
			addChild(_spCat);
			
			_spCat.addChild(_btnMenu);
			
			_txtAmount.y = _x;
			_spCat.y = _txtAmount.y + _txtAmount.height + _x;
			_txtAmount.x = _txtAmount.y = _txtCat.x = _btnFullmode.x = _x;
			
			_btnSubmit.y = _btnFullmode.y = _spCat.y + _spCat.height + _x;
			_btnSubmit.x = 2*_x + _btnFullmode.width;
			
			_h = _btnFullmode.y + _btnFullmode.height + _x;
			
			this.graphics.beginFill(_bgc,1);
			this.graphics.drawRect(0,0,Statics.STAGEWIDTH,_h);
			this.graphics.endFill();
			
			//this.addEventListener(Event.ENTER_FRAME, layoutMin);
			_btnFullmode.addEventListener(MouseEvent.CLICK, toggleFullmode);
			_btnSubmit.addEventListener(MouseEvent.CLICK, submitHandler);
			_btnCal.addEventListener(MouseEvent.CLICK, callCal);
			
			_btnEditCat = new LeoButton(_spCat.height,0,'',0xffffff, 0x000000,0.2);
			addChild(_btnEditCat);
			_btnEditCat.width = _spCat.height;
			var imgEditCat:Bitmap = AssetManager.getImage('edit-memo');
			imgEditCat = LeoBitmapResizer.resize(imgEditCat,0,Math.round(_btnEditCat.height*0.6));
			imgEditCat.x = Math.round((_btnEditCat.width - imgEditCat.width)*0.55);
			imgEditCat.y = Math.round((_btnEditCat.height - imgEditCat.height)*0.5);
			_btnEditCat.addChild(imgEditCat);
			_btnEditCatMask.y = _btnEditCat.y = _spCat.y;
			_btnEditCatMask.x = _btnEditCat.x = _spCat.width - _btnEditCat.width + _x;
			removeChild(_btnEditCat);
		}
		
		protected function callCal(e:MouseEvent):void
		{
			if (_txtMemo) _txtMemo.freeze();
			if (!_Cal) {
				_Cal = new LeoDatepicker(Statics.STAGEWIDTH, Statics.STAGEHEIGHT, Math.round(Statics.STAGEHEIGHT*0.01), null, function(o:Object):void {
					_Cal.withDrawCal();
					if (_txtMemo) _txtMemo.unfreeze();
					_date = new Date(o.year,o.month-1,o.date);
					_lblCal.text = DateFormatter(_date);
				});
				_Cal.btnClose.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void {
					_Cal.withDrawCal();
					if (_txtMemo) _txtMemo.unfreeze();
				});
			}
			addChild(_Cal);
		}
		
		protected function toggleFullmode(e:MouseEvent):void
		{
			createFullUI();
		}
		
		protected function startPin(e:MouseEvent):void
		{
			stage.addChild(Statics.PINPAD);
			Statics.PINPAD.label = _lblAmount;
		}
		
		protected function submitHandler(e:MouseEvent):void
		{
			_callback(_txtCat.text,pf(_lblAmount.text)*_prefix);
		}
		
		public function dispose():void {
			_btnSubmit.removeEventListener(MouseEvent.CLICK, submitHandler);
			this.graphics.clear();
			_txtAmount = null;
			_spCat = null;
			_txtCat  = null;
			_btnFullmode = null;
			_btnSubmit = null;
			_txtMemo = null;
		}
		
		public function get FormDate():Date {
			return _date;
		}
	}
}