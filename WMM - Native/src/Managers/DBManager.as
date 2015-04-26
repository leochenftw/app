package Managers
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	

	public class DBManager
	{
		private var sqlc:SQLConnection = new SQLConnection();
		private var sqls:SQLStatement = new SQLStatement();
		private var db:File = File.applicationStorageDirectory.resolvePath("localStorage.db");
		private var _callback:Function = null;
		
		public function DBManager(cbf:Function)
		{
			_callback = cbf;
			sqlc.openAsync(db);
			sqlc.addEventListener(SQLEvent.OPEN, db_opened);
			sqlc.addEventListener(SQLErrorEvent.ERROR, error);
			sqls.addEventListener(SQLErrorEvent.ERROR, error);
			sqls.addEventListener(SQLEvent.RESULT, resault);
		}
		
		private function db_opened(e:SQLEvent):void
		{
			sqls.sqlConnection = sqlc;
			sqls.text = "CREATE TABLE IF NOT EXISTS trans ( " +
				"tid INTEGER PRIMARY KEY AUTOINCREMENT, " +
				"year INTEGER, " +
				"month INTEGER, " +
				"date INTEGER, " +
				"category TEXT, " + 
				"amount NUMERIC," +
				"description TEXT," +
				"nid INTEGER," +
				"utcstamp TEXT);";
			sqls.execute();
		}
		
		private function error(e:SQLErrorEvent):void
		{
			trace(e.toString());
		}
		
		private function resault(e:SQLEvent):void
		{
			sqls.removeEventListener(SQLEvent.RESULT, resault);
			_callback.call();
			
		}
		
		public function addTrans(prCategory:String, prValue:Number, prDate:String, prDesc:String, utc:String, func:Function,nid:String = '0'):void {
			var lcDate:Array = prDate.split('/');
			var lcSQL:SQLStatement = new SQLStatement;
			lcSQL.sqlConnection = sqlc;
			lcSQL.text = "INSERT INTO trans (year,month,date,category,amount,description,nid,utcstamp) " +
				"VALUES ('"+lcDate[2]+"','"+lcDate[1]+"','"+lcDate[0]+"','"+prCategory+"','"+prValue+"','"+prDesc+"','"+nid+"','"+utc+"');";
			lcSQL.addEventListener(SQLEvent.RESULT,function(e:SQLEvent):void {
				func(e.target.sqlConnection.lastInsertRowID);
			});
			lcSQL.execute();
		}
		
		public function updateTrans(o:Object,conditions:Object,func:Function):void {
			var lcSQL:SQLStatement = new SQLStatement;
			lcSQL.sqlConnection = sqlc;
			var strMid:String = '';
			for (var key:String in o) {
				if (strMid.length > 0) strMid += ","
				strMid += key;
				strMid += "='";
				strMid += o[key].toString();
				strMid += "'";
			}
			
			var strCon:String = '';
			for (var condition:String in conditions) {
				if (strCon.length > 0) strCon += ","
				strCon += condition;
				strCon += "='";
				strCon += conditions[condition].toString();
				strCon += "'";
			}
			
			lcSQL.text = "UPDATE trans SET "+strMid+" WHERE " + strCon;
			lcSQL.addEventListener(SQLEvent.RESULT,function(e:SQLEvent):void {
				for (var thisKey:String in o) {
					delete o[thisKey];
				}
				for (var thatKey:String in conditions) {
					delete conditions[thatKey];
				}
				
				o = null;
				condition = null;
				
				if (func) func();
			});
			lcSQL.execute();
		}
		
		public function deleteTrans(tid:int, callback:Function = null):void {
			var lcSQL:SQLStatement = new SQLStatement;
			lcSQL.sqlConnection = sqlc;
			lcSQL.text = "DELETE FROM trans WHERE tid=" + tid.toString() + ';';
			lcSQL.addEventListener(SQLEvent.RESULT,function(e:SQLEvent):void {
				if (callback) callback(1);
			});
			lcSQL.addEventListener(SQLErrorEvent.ERROR,function(e:SQLErrorEvent):void{
				if (callback) callback(0);
			});
			lcSQL.execute();
		}
		
		public function listTable(tn:String, callback:Function = null, condition:Array = null, desc:String = ''):void {
			var lcSQL:SQLStatement = new SQLStatement;
			lcSQL.sqlConnection = sqlc;
			lcSQL.addEventListener(SQLEvent.RESULT,function(e:SQLEvent):void {
				if (callback) callback(e.target.getResult().data);
			},false,0,true);
			
			if (!condition) {
				lcSQL.text = "SELECT * FROM " + tn + (desc.length>0?(" ORDER BY "+desc+" DESC;"):";");
			}else{
				var conditionString:String = '';
				for each (var o:Object in condition) {
					conditionString += o.name;
					conditionString += (' ' + o.operator + ' ');
					conditionString += o.value;
					if (o.relation) {
						conditionString += (' ' + o.relation + ' ');
					}
				}
				lcSQL.text = "SELECT * FROM " + tn + " WHERE " + conditionString + (desc.length>0?(" ORDER BY "+desc+" DESC;"):";");
			}
			lcSQL.execute();
		}
		
	}
}