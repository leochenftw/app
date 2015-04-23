package UI
{
	import com.Leo.utils.dFormat;
	public class UITransactionItem extends UITransactionMaster
	{
		private var _data:Object;
		public function UITransactionItem(prID:String,data:Object)
		{
			super(prID);
			this.graphics.clear();
			this.graphics.beginFill(0xf6f6f6);
			this.graphics.drawRect(0,0,Statics.STAGEWIDTH, Math.round(Statics.STAGEHEIGHT*0.11));
			this.graphics.endFill();
			_data = data;
			_txtDate.text = _data.category;
			_txtSum.text = dFormat(Math.abs(data.amount).toFixed(2));
			
			if (data.amount<0) {
				_txtSum.setTextFormat(Statics.FONTSTYLES['expense']);
				_txtSum.defaultTextFormat = Statics.FONTSTYLES['expense'];
			}else{
				_txtSum.setTextFormat(Statics.FONTSTYLES['income']);
				_txtSum.defaultTextFormat = Statics.FONTSTYLES['income'];
			}
			
			this.graphics.lineStyle(1,0xD5D5D5);
			this.graphics.moveTo(0,this.height);
			this.graphics.lineTo(Statics.STAGEWIDTH,this.height);
		}
	}
}