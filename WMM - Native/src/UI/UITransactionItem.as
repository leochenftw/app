package UI
{
	import com.Leo.utils.kmark;
	public class UITransactionItem extends UITransactionMaster
	{
		private var _data:Object;
		public function UITransactionItem(prID:String,data:Object)
		{
			super(prID);
			_data = data;
			_txtSum.text = kmark(Math.abs(data.amount).toFixed(2));
		}
	}
}