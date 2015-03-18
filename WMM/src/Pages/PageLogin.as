package Pages
{
	import feathers.controls.Button;
	import feathers.controls.TextInput;
	
	import starling.events.Event;

	public class PageLogin extends MasterPage
	{
		private var _txtEmail:TextInput = new TextInput,_txtPass:TextInput = new TextInput;
		private var _btnSignin:Button = new Button;
		public function PageLogin()
		{
			super();
		}
		
		protected override function init(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_txtEmail.prompt = 'Email';
			_txtPass.prompt = 'Password';
			_txtPass.displayAsPassword = true;
			
			_btnSignin.width = _txtPass.width = _txtEmail.width = int(Statics.STAGEWIDTH*0.8);
			_btnSignin.height = _txtPass.height = _txtEmail.height = int(Statics.STAGEHEIGHT*0.08);
			
			addChild(_txtEmail);
			addChild(_txtPass);
			
			_txtEmail.y = Statics.STAGEHEIGHT*0.5;
			_txtPass.y = _txtEmail.y + int(_txtEmail.height*1.5);
			
			_btnSignin.y = _txtPass.y + int(_txtPass.height*1.5);
			
			_btnSignin.label = 'Sign in';
			addChild(_btnSignin);
			
			_btnSignin.x = _txtPass.x = _txtEmail.x = int((Statics.STAGEWIDTH-_txtEmail.width)*0.5); 
			
			_btnSignin.addEventListener(Event.TRIGGERED, touchedSignin);
		}
		
		private function touchedSignin(e:Event):void {
			Statics.NAV.showScreen('winOverview');
		}
		
		protected override function touchHanlder(e:Event):void {
			trace(e.target);
		}
		
	}
}