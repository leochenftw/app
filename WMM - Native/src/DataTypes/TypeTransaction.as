package DataTypes
{
	public class TypeTransaction
	{
		private var _amount:Number;
		private var _category:String = '';
		private var _date:int;
		private var _description:String = '';
		private var _month:int;
		private var _nid:int = 0;
		private var _tid:int;
		private var _uid:int = 0;
		private var _utcstamp:String = '';
		private var _year:int;
		public function TypeTransaction(o:Object = null)
		{
			if (o) {
				_amount =  o.amount
				_category = o.category
				_date = o.date
				_description = o.description
				_month = o.month
				_nid = o.nid
				_tid = o.tid
				_uid = o.uid
				_utcstamp = o.utcstamp
				_year = o.year
			}
		}
		
		public function set utcstamp(s:String):void {
			_utcstamp = s;
		}
		
		public function get utcstamp():String {
			return _utcstamp;
		}
		
		public function set uid(i:int):void {
			_uid = i;
		}
		
		public function get uid():int {
			return _uid;
		}
		
		public function set tid(i:int):void {
			_tid = i;
		}
		
		public function get tid():int {
			return _tid;
		}
		
		public function set nid(i:int):void {
			_nid = i;
		}
		
		public function get nid():int {
			return _nid;
		}
		
		public function get amount():Number {
			return _amount;
		}
		
		public function set amount(n:Number):void {
			_amount = n;
		}
		
		public function get category():String {
			return _category;
		}
		
		public function set category(s:String):void {
			_category = s;
		}
		
		public function get description():String {
			return _description;
		}
		
		public function set description(s:String):void {
			_description = s;
		}
		
		public function get date():int {
			return _date;
		}
		
		public function set date(i:int):void {
			_date = i;
		}
		
		public function get month():int {
			return _month;
		}
		
		public function set month(i:int):void {
			_month = i;
		}
		
		public function get year():int {
			return _year;
		}
		
		public function set year(i:int):void {
			_year = i;
		}
		
		public function get FullDate():String {
			return (_date<10?'0':'') + _date.toString() + '/' + (_month<10?'0':'') + _month.toString() + '/' + _year.toString();
		}
		
		public function get dbUpdateString():String {
			return "year = '"+_year.toString()+"'," +
				"month = '"+_month.toString()+"'," +
				"date = '"+_date.toString()+"'," +
				"category = '"+_category.replace(/\'/gi,"''")+"'," +
				"amount = '"+_amount.toString()+"'," +
				"description = '"+_description.replace(/\'/gi,"''")+"'," +
				"nid = '"+_nid.toString()+"'," +
				"utcstamp = '"+_utcstamp+"'," +
				"uid = '"+_uid+"'";
		}
	}
}