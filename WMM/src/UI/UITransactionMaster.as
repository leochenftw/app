package UI
{	
	import starling.display.Quad;
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
		protected var _bg:Quad;
		public function UITransactionMaster(prID:String)
		{
			super();
			_id = prID;
			_spOverview = new Sprite;
			_bg = new Quad(Statics.STAGEWIDTH,Math.round(Statics.STAGEHEIGHT*0.11),0xffffff);
			_spOverview.addChild(_bg);
			
			
			_txtDate = new TextField(_bg.width-_x*2,_bg.height,_id,'Myriad Pro',_bg.height * 0.25, 0x616161);
			_txtDate.x = _x;
			_txtDate.hAlign = 'left';
			_spOverview.addChild(_txtDate);
			
			_txtSum = new TextField(_bg.width-_x*2,_bg.height,'$0.00','Myriad Pro',_bg.height * 0.25, 0x616161);
			_txtSum.x = _x;
			_txtSum.hAlign = 'right';
			_spOverview.addChild(_txtSum);
			var borderBottom:Quad = new Quad(_spOverview.width,2,0xB5B5B5);
			borderBottom.y = _spOverview.height-2;
			_spOverview.addChild(borderBottom);
			addChild(_spOverview);
		}
		
		public function get id():String {
			return _id;
		}
	}
}