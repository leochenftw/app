package UI
{
	import com.Leo.utils.dFormat;

	public class UITransactionItem extends UITransactionMaster
	{
		private var _data:Object;
		public function UITransactionItem(prID:String,data:Object)
		{
			_data = data;
			super(prID);
			
			_txtDate.text = _data.category;
			_txtSum.text = dFormat(_data.amount);
		}
		
		
	}
}