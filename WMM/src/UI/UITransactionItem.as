package UI
{
	import com.Leo.ui.Rect;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class UITransactionItem extends Sprite
	{
		private var _spOverview:Sprite;
		private const _x:Number = Math.round(Statics.STAGEWIDTH*0.05);
		private var _txtDate:TextField;
		public function UITransactionItem(data:Object)
		{
			super();
			_spOverview = new Sprite;
			var lcSPBG:Rect = new Rect(Statics.STAGEWIDTH,Math.round(Statics.STAGEHEIGHT*0.11),0xffffff);
			_spOverview.addChild(lcSPBG);
			
			_txtDate = new TextField(lcSPBG.width-_x*2,lcSPBG.height,data.date,'Myriad Pro',lcSPBG.height * 0.2, 0x616161);
			_txtDate.x = _x;
			_txtDate.hAlign = 'left';
			_spOverview.addChild(_txtDate);
			
			addChild(_spOverview);
		}
	}
}