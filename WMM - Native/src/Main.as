package
{
	import com.Leo.events.GridEvent;
	import com.Leo.ui.AdvancedGrid;
	import com.Leo.ui.CAAGrid;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
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
			//addChild(Statics.PAGELOGIN);
//			var grid:CAAGrid = new CAAGrid(Math.round(Statics.STAGEWIDTH*0.8),Math.round(Statics.STAGEHEIGHT*0.9), Math.round(Statics.STAGEHEIGHT*0.02),15,10,1,0xffffff,Math.round(Statics.STAGEHEIGHT*0.1));
//			grid.addEventListener(GridEvent.ON_START, onStart);
//			grid.addEventListener(GridEvent.ON_UPDATE, onUpdate);
//			grid.addEventListener(GridEvent.ON_COMPLETE, onComplete);
//			grid.x = Math.round(Statics.STAGEWIDTH*0.1);
//			grid.y = Math.round(Statics.STAGEHEIGHT*0.05);
//			addChild(grid);
			var grid:AdvancedGrid = new AdvancedGrid(Math.round(Statics.STAGEWIDTH*0.8),Math.round(Statics.STAGEHEIGHT*0.9), Math.round(Statics.STAGEHEIGHT*0.02),15,10,1,0xffffff,Math.round(Statics.STAGEHEIGHT*0.1));
			grid.x = Math.round(Statics.STAGEWIDTH*0.1);
			grid.y = Math.round(Statics.STAGEHEIGHT*0.05);
			addChild(grid);
		}
		
		protected function onComplete(e:Event):void
		{
			trace(e.target.gridx);
		}
		
		protected function onUpdate(e:Event):void
		{
			trace(e.target.gridx);
		}
		
		protected function onStart(e:Event):void
		{
			trace(e.target.gridx);
		}
		
	}
}