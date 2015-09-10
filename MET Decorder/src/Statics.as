package
{
	import com.Leo.utils.Navigator;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	import Managers.AssetManager;
	
	import Pages.Page;
	import Pages.PageMetIn;
	import Pages.PageMetOut;
	

	public class Statics
	{
		public static var STAGE:Stage;
		public static var PADDINGTOP:int = 0;
		public static var MAIN:Main;
		public static var LOGO:Bitmap;
		public static var BG:Bitmap;
		public static var PAGEIN:PageMetIn;
		public static var PAGEOUT:PageMetOut;
		public static var PAGES:Vector.<Page> = new Vector.<Page>;
		public static var STAGEHEIGHT:int;
		public static var STAGEWIDTH:int;
		public static var IO:AssetManager;
		public static var NAV:Navigator;
		public static var FONTSTYLES:Dictionary = new Dictionary;
		public static var ASSETS:Dictionary = new Dictionary;
		
		public static var HOURSAHEAD:Number = ((new Date).timezoneOffset / 60);
		
		public function Statics()
		{
			
		}
		
		public static function tKill(o:*):void {
			TweenLite.killTweensOf(o);
		}
		
		public static function tKillMax(o:*):void {
			TweenMax.killTweensOf(o);
		}
		
		public static function tLite(o:*, duration:Number, params:Object):TweenLite {
			return TweenLite.to(o,duration,params);
		}
		
		public static function tMax(o:*, duration:Number, params:Object):TweenMax {
			return TweenMax.to(o,duration,params);
		}
	}
}