package UI
{
	import com.Leo.utils.LeoButton;
	import com.Leo.utils.LeoInput;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import feathers.controls.Button;
	import feathers.controls.TextInput;
	
	import starling.events.Event;
	
	public class UITransactionForm extends Sprite
	{
		private var _bgc:uint = 0;
		private var _txtAmount:Sprite = new Sprite;
		private var _txtCat:LeoInput;
		private var _btnFullmode:LeoButton;
		private var _btnSubmit:LeoButton;
		private var _data:Object;
		private const _x:Number = Math.round(Statics.STAGEWIDTH*0.05);
		private var _callback:Function;
		private var _txtMemo:LeoInput;
		public function UITransactionForm(inout:Boolean, callback:Function, data:Object = null,fullMode:Boolean = false)
		{
			_bgc = inout?0x10BEC6:0xE46752;
			_callback = callback;
			_data = data;
			
			if (!_data){
				if (!fullMode) {
					this.addEventListener(Event.ADDED_TO_STAGE, createMinUI);
				}
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE, createFullUI);
			}
			
			this.alpha = 0;
		}
		
		protected function createFullUI(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function createMinUI(event:Event):void
		{
			_txtAmount.graphics.beginFill(0xffffff,1);
			_txtAmount.graphics.drawRect(0,0,Statics.STAGEWIDTH - _x*2,Math.round(Statics.STAGEHEIGHT*0.1));
			_txtAmount.graphics.endFill();
			
			_txtCat = new LeoInput(;
			_btnFullmode = new Button;
			_btnSubmit = new Button;
			addChild(_txtAmount);
			addChild(_txtCat);
			addChild(_btnFullmode);
			addChild(_btnSubmit);
			_txtAmount.y = _x;
			_txtAmount.prompt = 'Amount';
			_txtCat.prompt = 'Category';
			_btnFullmode.label = '...';
			_btnSubmit.label = 'Enter';
			_txtAmount.width = _txtCat.width = Statics.STAGEWIDTH - _x*2;
			_txtCat.y = _txtAmount.y + _txtAmount.height + _x;
			_txtAmount.x = _txtAmount.y = _txtCat.x = _btnFullmode.x = _x;
			
			this.addEventListener(Event.ENTER_FRAME, layoutMin);
			_btnSubmit.addEventListener(Event.TRIGGERED, submitHandler);
		}
	}
}