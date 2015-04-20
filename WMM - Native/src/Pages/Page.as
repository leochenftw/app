package Pages
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Page extends Sprite
	{
		public function Page()
		{
			if (stage) {
				init();
			}else{
				addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
		
		protected function init(event:Event = null):void
		{
			
		}		
		
	}
}