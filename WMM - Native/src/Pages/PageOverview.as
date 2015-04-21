package Pages
{
	import com.Leo.utils.DateFormatter;
	import com.Leo.utils.LeoButton;
	import com.Leo.utils.UIScrollVerticalMaker;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import UI.UITopBar;
	import UI.UITransactionForm;
	import UI.UITransactionGroup;

	public class PageOverview extends Page
	{
		private var _btnIncome:LeoButton = new LeoButton(Math.round(Statics.STAGEHEIGHT*0.18),0,'+',0xffffff,0x10BEC6);
		private var _btnExpense:LeoButton = new LeoButton(Math.round(Statics.STAGEHEIGHT*0.18),0,'-',0xffffff,0xE46752);
		private var _topbar:UITopBar = new UITopBar;
		private var _scroller:UIScrollVerticalMaker;
		private var _frm:UITransactionForm;
		private var _items:Dictionary = new Dictionary;
		public function PageOverview()
		{
			this.graphics.beginFill(0xF6F6F6);
			this.graphics.drawRect(0,0,Statics.STAGEWIDTH, Statics.STAGEHEIGHT);
			this.graphics.endFill();
			
			Statics.TOPBAR = _topbar;
			addChild(_topbar);
			_btnIncome.y = _btnExpense.y = Statics.PADDINGTOP;
			addChild(_btnIncome);
			addChild(_btnExpense);
			_btnExpense.x = _btnIncome.width = _btnExpense.width = Statics.STAGEWIDTH*0.5;
			
			_scroller = new UIScrollVerticalMaker(this,Statics.STAGEWIDTH, Statics.STAGEHEIGHT-(_btnExpense.y + _btnExpense.height), 0, 0);
			_scroller.y = _btnExpense.y + _btnExpense.height;
			/*for (var i:int = 0; i < 10; i++){
				var g:UITransactionGroup = new UITransactionGroup(i.toString(),_scroller);
				_scroller.attachVertical(g);
			}*/
			
			_btnIncome.addEventListener(MouseEvent.CLICK, clickHandler);
			_btnExpense.addEventListener(MouseEvent.CLICK, clickHandler);
			
			_btnIncome.name = '+';
			_btnExpense.name = '-';
		}
		
		protected function clickHandler(e:MouseEvent):void
		{
			var nfn:String = '';
			if (_frm) {
				nfn = _frm.name;
				if (contains(_frm)) {
					removeChild(_frm);
				}
				_frm.dispose();
				_frm = null;
			}
			var fn:String = 'frm'+e.currentTarget.name;
			if (fn == nfn) return;
			var b:Boolean = false;
			switch (e.currentTarget.name) {
				case '+':
					b = true;
					break;
				case '-':
					b = false;
					break;
				
			}
			
			_frm = new UITransactionForm(b,function(prCat:String, prAmount:Number):void {
				var lcGroup:UITransactionGroup = new UITransactionGroup(DateFormatter(new Date),_scroller);
				
				var tmpID:String = DateFormatter(new Date());//+i.toString();
				
				if (_items[tmpID] === undefined) {
					var item:UITransactionGroup = new UITransactionGroup(tmpID,_scroller);
					item.addTransaction(prAmount,prCat);
					_scroller.attachVertical(item);
					_items[item.id] = item;
				}else{
					(_items[tmpID] as UITransactionGroup).addTransaction(prAmount, prCat);
				}
				removeChild(_frm);
				_frm.dispose();
				_frm = null;
			});
			_frm.name = fn;
			_frm.y = e.currentTarget.y + e.currentTarget.height;
			addChild(_frm);
		}
	}
}