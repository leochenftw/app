package UI
{
	import com.Leo.ui.Rect;
	import com.Leo.utils.pf;
	import com.Leo.utils.trim;
	
	import feathers.controls.Button;
	import feathers.controls.TextInput;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class UITransactionForm extends Sprite
	{
		private var _bgc:uint = 0;
		private var _txtAmount:TextInput;
		private var _txtCat:TextInput;
		private var _btnFullmode:Button;
		private var _btnSubmit:Button;
		private var _data:Object;
		private const _x:Number = Math.round(Statics.STAGEWIDTH*0.05);
		private var _bg:Rect;
		private var _callback:Function;
		public function UITransactionForm(inout:Boolean, callback:Function, data:Object = null,fullMode:Boolean = false)
		{
			super();
			_bgc = inout?0x10BEC6:0xE46752;
			_callback = callback;
			_data = data;
			
			if (!_data){
				if (!fullMode) {
					this.addEventListener(Event.ADDED_TO_STAGE, createMinUI);
				}
			}
			
			this.alpha = 0;
		}
		
		private function createMinUI(e:Event = null):void {
			
			_txtAmount = new TextInput;
			_txtAmount.restrict = '\.0-9';
			_txtCat = new TextInput;
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
		
		private function submitHandler(e:Event):void {
			var lcAmount:Number = pf(_txtAmount.text);
			var lcCategory:String = trim(_txtCat.text);
			_callback(lcAmount,lcCategory);
		}
		
		private function layoutMin(e:Event):void {
			if (_btnFullmode.height > 0 && _btnSubmit.height > 0) {
				this.removeEventListener(Event.ENTER_FRAME, layoutMin);
				_btnFullmode.y = _btnSubmit.y = _txtCat.y + _txtCat.height + _x;
				_btnSubmit.x = _x*2 + _btnFullmode.width;
				_btnSubmit.width = Statics.STAGEWIDTH - _x*3 - _btnFullmode.width;
				
				_bg = new Rect(Statics.STAGEWIDTH,_btnFullmode.y + _btnFullmode.height + _x,_bgc);
				addChildAt(_bg,0);
				this.alpha = 1;
			}
		}
	}
}