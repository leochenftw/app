package UI
{
	import com.Leo.ui.Rect;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class UITransactionMaster extends Sprite
	{
		protected var _spOverview:Sprite;
		protected const _x:Number = Math.round(Statics.STAGEWIDTH*0.05);
		protected var _txtDate:TextField;
		protected var _txtSum:TextField;
		protected var _id:String;
		protected var _sum:Number = 0;
		public function UITransactionMaster(prID:String)
		{
			super();
			_id = prID;
			_spOverview = new Sprite;
			var lcSPBG:Rect = new Rect(Statics.STAGEWIDTH,Math.round(Statics.STAGEHEIGHT*0.11),0xffffff);
			_spOverview.addChild(lcSPBG);
			
			
			_txtDate = new TextField(lcSPBG.width-_x*2,lcSPBG.height,_id,'Myriad Pro',lcSPBG.height * 0.2, 0x616161);
			_txtDate.x = _x;
			_txtDate.hAlign = 'left';
			_spOverview.addChild(_txtDate);
			
			_txtSum = new TextField(lcSPBG.width-_x*2,lcSPBG.height,'$0.00','Myriad Pro',lcSPBG.height * 0.2, 0x616161);
			_txtSum.x = _x;
			_txtSum.hAlign = 'right';
			_spOverview.addChild(_txtSum);
			var borderBottom:Rect = new Rect(_spOverview.width,2,0xEFEFEF);
			borderBottom.y = _spOverview.height-2;
			_spOverview.addChild(borderBottom);
			addChild(_spOverview);
		}
		
		public function get id():String {
			return _id;
		}
	}
}