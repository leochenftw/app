package UI
{
	import com.Leo.ui.Rect;
	import com.Leo.utils.dFormat;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class UITransactionItem extends Sprite
	{
		private var _spOverview:Sprite;
		private const _x:Number = Math.round(Statics.STAGEWIDTH*0.05);
		private var _txtDate:TextField;
		private var _txtSum:TextField;
		private var _id:String;
		private var _sum:Number = 0;
		public function UITransactionItem(prID:String)
		{
			super();
			_id = prID;
			_spOverview = new Sprite;
			var lcSPBG:Rect = new Rect(Statics.STAGEWIDTH,Math.round(Statics.STAGEHEIGHT*0.11),0xffffff);
			_spOverview.addChild(lcSPBG);
			
			
			_txtDate = new TextField(lcSPBG.width-_x*2,lcSPBG.height,_id,'Myriad Pro',lcSPBG.height * 0.2, 0x616161);
			_txtDate.x = _x;
			_txtDate.hAlign = 'left';
			_spOverview.addChild(_txtDate);
			
			_txtSum = new TextField(lcSPBG.width-_x*2,lcSPBG.height,'$0.00','Myriad Pro',lcSPBG.height * 0.2, 0x616161);
			_txtSum.x = _x;
			_txtSum.hAlign = 'right';
			_spOverview.addChild(_txtSum);
			
			addChild(_spOverview);
		}
		
		public function get id():String {
			return _id;
		}
		
		public function addTransaction(prAmount:Number, prCategory):void {
			var o:Object = {
				amount: prAmount,
				category: prCategory
			};
			if (!stage) {
				_sum += prAmount;
				_txtSum.text = dFormat(_sum);
			}else{
				var tmpO:Object = {a:_sum};
				Statics.tlite(tmpO,1,{a:_sum+=prAmount, onUpdate:function():void {
					_txtSum.text = dFormat(tmpO.a);
				},onComplete:function():void {
					delete tmpO.a;
					tmpO = null;
				}});
				
			}
		}
		
	}
}