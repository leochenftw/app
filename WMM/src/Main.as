package
{
	import Pages.PageLogin;
	import Pages.PageOverview;
	
	import UI.UINavbar;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.Slide;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Main extends Sprite
	{
		public function Main()
		{
			Statics.MAIN = this;
			super();
		}
		
		public function init():void {
			if (stage) {
				initialiser();
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE, initialiser);
			}
			
		}
		
		private function initialiser(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, initialiser);
			Statics.PADDINGTOP = Math.round(Statics.STAGEHEIGHT*0.1);
			Statics.PAGELOGIN = new PageLogin;
			Statics.PAGEOVERVIEW = new PageOverview;
			Statics.NAV = new ScreenNavigator;
			Statics.NAV.addScreen('winLogin',new ScreenNavigatorItem(Statics.PAGELOGIN));
			Statics.NAV.addScreen('winOverview',new ScreenNavigatorItem(Statics.PAGEOVERVIEW));
			addChild(Statics.NAV);
			Statics.NAV.showScreen('winLogin',Slide.createSlideUpTransition(0));
			Statics.NAV.transition = Slide.createSlideUpTransition();
			Statics.NAVBAR = new UINavbar;
		}
	}
}