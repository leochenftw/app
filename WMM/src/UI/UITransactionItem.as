package UI
{
	public class UITransactionItem extends UITransactionMaster
	{
		private var _data:Object;
		public function UITransactionItem(prID:String,data:Object)
		{
			_data = data;
			super(prID);
		}
		
		
	}
}