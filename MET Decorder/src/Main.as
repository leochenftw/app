package
{
	import com.Leo.utils.os;
	import com.greensock.easing.Circ;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	[SWF(backgroundColor='#274162', frameRate='120')]
	public class Main extends Sprite
	{
		private var _preloader:Preloader;
		public function Main()
		{
			stage.quality = StageQuality.MEDIUM;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Statics.STAGE = stage;
			Statics.STAGEWIDTH = stage.fullScreenWidth;
			Statics.STAGEHEIGHT = stage.fullScreenHeight - ((os.OS == 'Android')?50:0) ;
			Statics.MAIN = this;
			
			if (os.OS == 'Android') {
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			}
			
			_preloader = new Preloader(buildUI);
		}
		
		private  function onKeyPress(ev:KeyboardEvent):void {
			switch(ev.keyCode){
				case Keyboard.BACK: // user hit the back button on Android device
					// case 94: // was hard-coded for older build of SDK supporting eclair
				{  
					ev.preventDefault();
					ev.stopImmediatePropagation();
					Statics.NAV.prev(null,Statics.PAGEIN.releaseInput);
				}
				break;
				
			}
		}
		
		private function buildUI():void {
			Statics.tLite(Statics.PAGEIN, 0.5, {ease: Circ.easeInOut, y: 0});
			Statics.tLite(Statics.LOGO, 0.5, {ease:Circ.easeInOut,y: Statics.LOGO.y-Statics.STAGEHEIGHT, onComplete:function():void {
				Statics.PAGEIN.releaseInput();
			}});
		}
	}
}