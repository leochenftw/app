package UI
{
	import com.danielfreeman.madcomponents.UILabel;
	
	import flash.display.Sprite;
	
	public class UITransactionMaster extends Sprite
	{
		protected const _x:Number = Math.round(Statics.STAGEWIDTH*0.05);
		protected var _txtDate:UILabel;
		protected var _txtSum:UILabel;
		protected var _id:String;
		protected var _sum:Number = 0;
		public function UITransactionMaster(prID:String)
		{
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0,0,Statics.STAGEWIDTH, Math.round(Statics.STAGEHEIGHT*0.11));
			this.graphics.endFill();
			
			super();
			_id = prID;
			
			
			_txtDate = new UILabel(this,_x,0,_id,Statics.FONTSTYLES['date-label']);
			_txtDate.y = Math.round((this.height-_txtDate.height)*0.5);
			
			_txtSum =  new UILabel(this,_x,0,'$0.00',Statics.FONTSTYLES['income']);
			_txtSum.y = Math.round((this.height-_txtDate.height)*0.5);
			
			_txtDate.fixwidth = _txtSum.fixwidth = Math.round(Statics.STAGEWIDTH * 0.75);
			
		}
		
		public function get id():String {
			return _id;
		}
	}
}