package
{
	import com.Leo.utils.LeoBitmapResizer;
	import com.Leo.utils.Navigator;
	import com.Leo.utils.os;
	
	import flash.text.TextFormat;
	
	import Managers.AssetManager;
	
	import Pages.PageMetIn;
	
	public class Preloader 
	{
		private var _callback:Function = null;
		public function Preloader(callback:Function)
		{
			_callback = callback;
			Statics.PADDINGTOP = Math.round(Statics.STAGEHEIGHT*0.1) + (os.isApple?40:0);
			Statics.FONTSTYLES['page-title'] = new TextFormat('Myriad Pro',Math.round(Statics.STAGEHEIGHT*0.05),0xffffff,null,null,null,null,null,'center');
			Statics.FONTSTYLES['text-in'] = new TextFormat('Myriad Pro',Math.round(Statics.STAGEHEIGHT*0.015),0x274162,null,null,null,null,null,'left');
			/*Statics.FONTSTYLES['logoin-input'] = new TextFormat('Myriad Pro',Math.round(Statics.STAGEHEIGHT*0.035*0.8),0xffffff,null,null,null,null,null,'left');
			Statics.FONTSTYLES['date-label'] = new TextFormat('Myriad Pro',Math.round(Statics.STAGEHEIGHT*0.11*0.25),0x212121,null,null,null,null,null,'left');
			Statics.FONTSTYLES['income'] = new TextFormat('Myriad Pro',Math.round(Statics.STAGEHEIGHT*0.11*0.25),0x10BEC6,null,null,null,null,null,'right');
			Statics.FONTSTYLES['expense'] = new TextFormat('Myriad Pro',Math.round(Statics.STAGEHEIGHT*0.11*0.25),0xE46752,null,null,null,null,null,'right');*/
			
			Statics.BG = LeoBitmapResizer.resize(AssetManager.getImage('bg'),0,Statics.STAGEHEIGHT);
			Statics.BG.x = int((Statics.STAGEWIDTH - Statics.BG.width)*0.5);
			Statics.BG.y = int((Statics.STAGEHEIGHT - Statics.BG.height)*0.5);
			Statics.BG.alpha = 0;
			Statics.STAGE.addChildAt(Statics.BG,0);
			
			Statics.LOGO = LeoBitmapResizer.resize(AssetManager.getImage('logo'),Math.floor(Statics.STAGEWIDTH*0.6));
			Statics.LOGO.x = int((Statics.STAGEWIDTH - Statics.LOGO.width)*0.5);
			Statics.LOGO.y = int((Statics.STAGEHEIGHT - Statics.LOGO.height)*0.5);
			Statics.LOGO.alpha = 0;
			Statics.STAGE.addChild(Statics.LOGO);
			
			Statics.PAGEIN = new PageMetIn('IN: TAF/METAR');
			Statics.PAGEIN.y = Statics.STAGEHEIGHT;
			Statics.MAIN.addChild(Statics.PAGEIN);
			
//			Statics.PINPAD = new LeoPinpad(true);
//			
//			Statics.PAGELOGIN = new PageLogin;
//			Statics.PAGEOVERVIEW = new PageOverview;
//			
			Statics.PAGES.push(Statics.PAGEIN);
//			Statics.PAGES.push(Statics.PAGEOVERVIEW);
//			
			Statics.NAV = new Navigator(Statics.STAGE,Statics.PAGES,'vertical',0.5);
//			
//			Statics.DB = new DBManager(_callback);
			
			Statics.tLite(Statics.LOGO, 0.5, {alpha: 1, onComplete:function():void {
				Statics.tLite(Statics.BG, 0.5, {delay: 1, alpha: 1, onComplete:function():void {
					_callback.call();
				}});
			}});
		}
	}
}