package
{
	import com.Leo.ui.LeoPinpad;
	import com.Leo.utils.Navigator;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	import Managers.DBManager;
	
	import Pages.PageLogin;
	import Pages.PageOverview;
	
	public class Preloader extends Sprite
	{
		private var _callback:Function = null;
		public function Preloader(callback:Function)
		{
			_callback = callback;
			Statics.PADDINGTOP = Math.round(Statics.STAGEHEIGHT*0.1);
			Statics.FONTSTYLES['logoin-input'] = new TextFormat('Myriad Pro',Math.round(Statics.STAGEHEIGHT*0.035*0.8),0xffffff,null,null,null,null,null,'left');
			Statics.FONTSTYLES['date-label'] = new TextFormat('Myriad Pro',Math.round(Statics.STAGEHEIGHT*0.11*0.25),0x212121,null,null,null,null,null,'left');
			Statics.FONTSTYLES['income'] = new TextFormat('Myriad Pro',Math.round(Statics.STAGEHEIGHT*0.11*0.25),0x10BEC6,null,null,null,null,null,'right');
			Statics.FONTSTYLES['expense'] = new TextFormat('Myriad Pro',Math.round(Statics.STAGEHEIGHT*0.11*0.25),0xE46752,null,null,null,null,null,'right');
			
			Statics.PINPAD = new LeoPinpad(true);
			
			Statics.PAGELOGIN = new PageLogin;
			Statics.PAGEOVERVIEW = new PageOverview;
			
			Statics.PAGES.push(Statics.PAGELOGIN);
			Statics.PAGES.push(Statics.PAGEOVERVIEW);
			
			Statics.NAV = new Navigator(Statics.STAGE,Statics.PAGES,'vertical',0.5);
			
			Statics.DB = new DBManager(_callback);
		}
	}
}