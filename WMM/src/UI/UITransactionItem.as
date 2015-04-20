package UI
{
	import com.Leo.utils.dFormat;
	
	import Managers.FileIO;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class UITransactionItem extends UITransactionMaster
	{
		private var _data:Object;
		private var _btnEdit:Sprite = new Sprite;
		public function UITransactionItem(prID:String,data:Object,sumW:int)
		{
			_data = data;
			super(prID);
			_bg.color = 0xF8F8F8;
			
			_txtDate.text = _data.category;
			_txtSum.text = dFormat(_data.amount);
			_txtSum.width = sumW;
			
			var lcPencil:Image = new Image(Texture.fromBitmap(FileIO.getImage('edit')));
			lcPencil.height = Math.round(_txtDate.height*0.4);
			lcPencil.scaleX = lcPencil.scaleY;
			_btnEdit.addChild(lcPencil);
			
			_btnEdit.y = (this.height - _btnEdit.height)*.5;
			_btnEdit.x = this.width - _btnEdit.y - _btnEdit.width;
			addChild(_btnEdit);
			
			_btnEdit.alpha = 0.5;
			
			_btnEdit.addEventListener(TouchEvent.TOUCH,tapHandler);
		}
		
		private function tapHandler(e:TouchEvent):void {
			
			var touches:Vector.<Touch> = e.getTouches(this);
			var clicked:Quad = e.currentTarget as Quad;
			if ( touches.length == 1 )
			{
				var touch:Touch = touches[0];   
				if ( touch.phase == TouchPhase.ENDED )
				{
					var frm:UITransactionForm = new UITransactionForm(_data.amount<0?false:true,null,_data,true);
					this.stage.addChildAt(frm,this.stage.numChildren-1);
				}
			}
		}
		
	}
}