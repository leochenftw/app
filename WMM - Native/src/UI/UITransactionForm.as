package UI
{
	import com.Leo.utils.LeoButton;
	import com.Leo.utils.LeoInput;
	import com.Leo.utils.pf;
	import com.danielfreeman.madcomponents.UILabel;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class UITransactionForm extends Sprite
	{
		private var _bgc:uint = 0;
		private var _txtAmount:Sprite = new Sprite;
		private var _spCat:Sprite = new Sprite;
		private var _txtCat:LeoInput;
		private var _btnFullmode:LeoButton;
		private var _btnSubmit:LeoButton;
		private const _x:Number = Math.round(Statics.STAGEWIDTH*0.05);
		private var _callback:Function;
		private var _txtMemo:LeoInput;
		private var _prefix:int = 1;
		private var _lblAmount:UILabel;
		private var _y:int = 0;
		private var _h:int = 0;
		private var _fh:int = Statics.STAGEHEIGHT - Math.round(Statics.STAGEHEIGHT*0.11);
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
			
			//this.alpha = 0;
		}
		
		public override function set height(value:Number):void {
			this.graphics.clear();
			this.graphics.beginFill(_bgc,1);
			this.graphics.drawRect(0,0,Statics.STAGEWIDTH,value);
			this.graphics.endFill();
		}
		
		protected function createFullUI(e:Event = null):void
		{
			if (!_txtMemo) {
				_txtMemo = new LeoInput(Statics.STAGEWIDTH*0.62,Math.round(_spCat.height*0.5),this,'',Statics.FONTSTYLES['date-label'],false,0,'e.g. what did you spend');
				_txtMemo.alpha = 0;
				_txtMemo.y = _spCat.y + _spCat.height + _x;
			}
			
			if (this.y > 0){
				Statics.tLite(this,0.25,{y: 0, height: _fh, onComplete:updateLayout});
				Statics.tLite([_btnSubmit,_btnFullmode],0.25,{y: _fh -_btnFullmode.height - _x});
			}else{
				Statics.tLite(this,0.25,{y:_y, height: _h, onComplete:updateLayout});
				Statics.tLite([_btnSubmit,_btnFullmode],0.25,{y: _h -_btnFullmode.height - _x});
			}
		}
		
		protected function updateLayout():void {
			
		}
		
		protected function createMinUI(event:Event):void
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
			
			_spCat.graphics.beginFill(0xffffff,1);
			_spCat.graphics.drawRect(0,0,Statics.STAGEWIDTH - _x*2,Math.round(Statics.STAGEHEIGHT*0.1));
			_spCat.graphics.endFill();
			
			_txtCat = new LeoInput(Statics.STAGEWIDTH*0.62,Math.round(_spCat.height*0.5),this,'',Statics.FONTSTYLES['date-label'],false,0,'Category');
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
	}
}