package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import com.greensock.easing.Circ;
	
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
			Statics.STAGEHEIGHT = stage.fullScreenHeight;
			Statics.MAIN = this;
			
			_preloader = new Preloader(buildUI);
		}
		
		private function buildUI():void {
			Statics.tLite(Statics.PAGEIN, 0.5, {ease: Circ.easeInOut, y: 0});
			Statics.tLite(Statics.LOGO, 0.5, {ease:Circ.easeInOut,y: Statics.LOGO.y-Statics.STAGEHEIGHT, onComplete:function():void {
			
			}});
		}
	}
}