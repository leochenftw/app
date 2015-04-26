package
{
	import com.Leo.ui.LeoPinpad;
	import com.Leo.utils.Navigator;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	import Managers.AssetManager;
	import Managers.DBManager;
	
	import Pages.Page;
	import Pages.PageLogin;
	import Pages.PageOverview;
	
	import UI.UITopBar;
	

	public class Statics
	{
		public static var STAGE:Stage;
		public static var PADDINGTOP:int = 0;
		public static var MAIN:Main;
		public static var PAGES:Vector.<Page> = new Vector.<Page>;
		public static var PAGELOGIN:PageLogin;
		public static var PAGEOVERVIEW:PageOverview;
		public static var STAGEHEIGHT:int;
		public static var STAGEWIDTH:int;
		public static var IO:AssetManager;
		public static var NAV:Navigator;
		public static var TOPBAR:UITopBar;
		public static var FONTSTYLES:Dictionary = new Dictionary;
		public static var ASSETS:Dictionary = new Dictionary;
		public static var PINPAD:LeoPinpad;
		public static var DB:DBManager;
		
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