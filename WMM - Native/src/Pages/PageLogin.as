package Pages
{
	import com.Leo.utils.LeoBitmapResizer;
	import com.Leo.utils.LeoButton;
	import com.Leo.utils.LeoInput;
	import com.ruochi.shape.Rect;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import Managers.FileIO;

	public class PageLogin extends Page
	{
		private var _logo:Sprite = new Sprite;
		private var _frmLogin:Sprite = new Sprite;
		private var _wrapperUser:Sprite = new Sprite;
		private var _wrapperPass:Sprite = new Sprite;
		private var _txtUsername:LeoInput;
		private var _txtPassword:LeoInput;
		private var _icoEmail:Bitmap;
		private var _icoPass:Bitmap;
		private var _btnSubmit:LeoButton;
		public function PageLogin()
		{
			
			_icoEmail = LeoBitmapResizer.resize(FileIO.getImage('email'),0,Math.round(Statics.STAGEHEIGHT*0.035));
			_icoPass = LeoBitmapResizer.resize(FileIO.getImage('pass'),0,Math.round(Statics.STAGEHEIGHT*0.035));
			
			_icoEmail.x = Statics.STAGEWIDTH*0.02;
			_icoPass.x = _icoEmail.x + Math.round((_icoEmail.width - _icoEmail.width)*0.5);
			
			
			var logoImage:Bitmap = LeoBitmapResizer.resize(FileIO.getImage('logo'),0,Math.round(Statics.STAGEWIDTH * 0.8));
			_logo.addChild(logoImage);
			_logo.x = Math.round(Statics.STAGEWIDTH*0.1);
			
			addChild(_logo);
			
			_txtUsername = new LeoInput(int(Statics.STAGEWIDTH*0.9-_icoEmail.width-_icoEmail.x*2),int(Statics.STAGEHEIGHT*0.035),this,"", Statics.FONTSTYLES['logoin-input'],false,0,"Email address",0,'left');
			_txtPassword = new LeoInput(int(Statics.STAGEWIDTH*0.9-_icoEmail.width-_icoEmail.x*2),int(Statics.STAGEHEIGHT*0.035),this,"", Statics.FONTSTYLES['logoin-input'],false,0,"Password",0,'left');
			
			_txtPassword.displayAsPassword = true;
			
			_txtUsername.x = _txtPassword.x = Math.round(_icoEmail.width+_icoEmail.x*2);
			
			_wrapperUser.addChild(_icoEmail);
			_wrapperUser.addChild(_txtUsername);
			_wrapperPass.addChild(_icoPass);
			_wrapperPass.addChild(_txtPassword);
			var lcLine:Rect = new Rect(int(Statics.STAGEWIDTH*0.9),1,0xffffff);
			var lcLineII:Rect = new Rect(int(Statics.STAGEWIDTH*0.9),1,0xffffff);
			lcLineII.alpha = lcLine.alpha = 0.2;
			lcLineII.y = lcLine.y = _txtUsername.height*2;
			
			_wrapperUser.addChild(lcLine);
			_wrapperPass.addChild(lcLineII);
			_wrapperPass.y = _wrapperUser.height + _txtUsername.height -1;
			_frmLogin.addChild(_wrapperUser);
			_frmLogin.addChild(_wrapperPass);
			
			
			_wrapperUser.addChild(lcLine);
			_wrapperPass.addChild(lcLineII);
			_wrapperPass.y = _wrapperUser.height + _txtUsername.height -1;
			_frmLogin.addChild(_wrapperUser);
			_frmLogin.addChild(_wrapperPass);
			
			_btnSubmit = new LeoButton(Math.round(Statics.STAGEHEIGHT*0.1),Math.round(Statics.STAGEHEIGHT*0.01),'Signin',0xffffff,0x000000,0,0.4);
			_frmLogin.addChild(_btnSubmit);
			_btnSubmit.width = int(Statics.STAGEWIDTH*0.9);
			_btnSubmit.y = _wrapperPass.y + _wrapperPass.height + _txtUsername.height;
			_btnSubmit.addEventListener(MouseEvent.CLICK,loginHandler);
			
			_frmLogin.y = Math.round(Statics.STAGEHEIGHT * 0.975) - _frmLogin.height;
			_frmLogin.x = Math.round((Statics.STAGEWIDTH-_frmLogin.width)*0.5);
			_logo.y = (_frmLogin.y - _logo.height)*0.5;
			addChild(_logo);
			
			addChild(_frmLogin);
			
			_btnSubmit.alpha = _logo.alpha = _icoEmail.alpha = _icoPass.alpha = 0.6;
			
		}
		
		protected function loginHandler(event:MouseEvent):void
		{
			Statics.NAV.next();
		}		
		
		
		
		
		
	}
}