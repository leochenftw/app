package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	[SWF(backgroundColor='#666666', frameRate='120')]
	public class WMM extends Sprite
	{
		private var _starling:Starling;
		public function WMM()
		{
			stage.quality = StageQuality.MEDIUM;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Statics.STAGEWIDTH = stage.fullScreenWidth;
			Statics.STAGEHEIGHT = stage.fullScreenHeight;
			
			_starling = new Starling(Main,stage,new Rectangle(0,0,stage.fullScreenWidth, stage.fullScreenHeight));
			_starling.antiAliasing = 1;
			_starling.addEventListener(Event.ROOT_CREATED, function():void {
				new MetalWorksMobileTheme;
				Statics.MAIN.init();
			});
			_starling.start();
			
		}
	}
}