package Pages
{
	import feathers.controls.Screen;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MasterPage extends Screen
	{
		protected var _stage:Sprite = new Sprite;
		public function MasterPage()
		{
			super();
			super.addChild(_stage);
			addEventListener(Event.ADDED_TO_STAGE, init);
			_stage.addEventListener(Event.TRIGGERED,touchHanlder);
		}
		
		protected function init(e:Event):void {
			
		}
		
		protected function touchHanlder(e:Event):void
		{
			
		}
		
		public override function addChild(child:DisplayObject):DisplayObject {
			_stage.addChild(child);
			return child;
		}
	}
}