package DataStructures
{
	public class Forecast
	{
		public var typecode:String = '';
		public var type:String = '';
		public var location:String = '';
		public var utc:String = '';
		public var nzt:String = '';
		public var validity:String = '';
		public var stacks:Array = [];
		public var initial:Object = {
			wind: {d:'',s:'', u:'', g:{v:'',u:''},v:{from:'',to:'',s:''}},
			visibility: '',
			weather: '',
			clouds: []
		};
		
		public var varians:Array = [];
		public var presures:Array = [];
		public var altitudeWind:Array = [];
		public var runway:Array = [];
		public var vv:String = '';
		
		public var auto:Boolean = false;
		public var temp:String = '';
		public var dewpoint:String = '';
		public var slashes:String = '';
		public var closure:String = '';
		public var remark:Object;
		
		public function Forecast()
		{
		}
		
		public function destruct():void {
			stacks.length = 0;
			delete initial.wind.g;
			delete initial.wind.v;
			delete initial.wind;
			initial.clouds.length = 0;
			initial = null;
			varians.length = 0;
			presures.length = 0;
			altitudeWind.length = 0;
			runway.length = 0;
		}
	}
}