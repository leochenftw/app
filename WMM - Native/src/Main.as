package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	[SWF(backgroundColor='#1f253d', frameRate='120')]
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
			
			_preloader = new Preloader(buildUI);
			
		}
		
		private function buildUI():void {
			addChild(Statics.PAGELOGIN);
		}
		
	}
}