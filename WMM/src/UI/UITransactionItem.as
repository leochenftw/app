package UI
{
	import com.Leo.utils.dFormat;
	
	import Managers.FileIO;
	
	import starling.display.Image;
	import starling.display.Sprite;
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
			
			
		}
		
		
	}
}