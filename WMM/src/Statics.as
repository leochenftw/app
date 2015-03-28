package
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import Pages.PageLogin;
	import Pages.PageOverview;
	
	import UI.UINavbar;
	
	import feathers.controls.ScreenNavigator;
	
	import starling.core.Starling;

	public class Statics
	{
		public static var PADDINGTOP:int = 0;
		public static var MAIN:Main;
		public static var NAV:ScreenNavigator;
		public static var PAGELOGIN:PageLogin;
		public static var PAGEOVERVIEW:PageOverview;
		public static var STAGEHEIGHT:int;
		public static var STAGEWIDTH:int;
		public static var STARLING:Starling;
		public static var NAVBAR:UINavbar;
		
		public function Statics()
		{
			
		}
		
		public static function tkill(o:*):void {
			TweenLite.killTweensOf(o);
		}
		
		public static function tkillMax(o:*):void {
			TweenMax.killTweensOf(o);
		}
		
		public static function tlite(o:*, duration:Number, params:Object):TweenLite {
			return TweenLite.to(o,duration,params);
		}
		
		public static function tMax(o:*, duration:Number, params:Object):TweenMax {
			return TweenMax.to(o,duration,params);
		}
	}
}