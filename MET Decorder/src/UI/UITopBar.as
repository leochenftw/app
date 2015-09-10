package UI
{
	import flash.display.Sprite;
	
	public class UITopBar extends Sprite
	{
		public function UITopBar()
		{
			this.graphics.beginFill(0x212121);
			this.graphics.drawRect(0,0,Statics.STAGEWIDTH, Statics.PADDINGTOP);
			this.graphics.endFill();
		}
	}
}