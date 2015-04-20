package Pages
{
	import com.Leo.utils.LeoButton;
	import com.Leo.utils.UIScrollVerticalMaker;
	
	import UI.UITopBar;
	import UI.UITransactionGroup;

	public class PageOverview extends Page
	{
		private var _btnIncome:LeoButton = new LeoButton(Math.round(Statics.STAGEHEIGHT*0.18),0,'+',0xffffff,0x10BEC6);
		private var _btnExpense:LeoButton = new LeoButton(Math.round(Statics.STAGEHEIGHT*0.18),0,'-',0xffffff,0xE46752);
		private var _topbar:UITopBar = new UITopBar;
		private var _scroller:UIScrollVerticalMaker;
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
			for (var i:int = 0; i < 10; i++){
				var g:UITransactionGroup = new UITransactionGroup(i.toString());
				_scroller.attachVertical(g);
			}
		}
	}
}