package
{
	import feathers.controls.ScreenNavigator;
	
	import starling.display.Sprite;
	
	public class Main extends Sprite
	{
		public function Main()
		{
			Statics.MAIN = this;
			super();
		}
		
		public function init():void {
			Statics.NAV = new ScreenNavigator;
			
		}
	}
}