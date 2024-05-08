package kabam.rotmg.account.web.view
{
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.ui.ClickableText;
   import com.company.ui.SimpleText;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class WebAccountDetailDialog extends Frame
   {
      public var cancel:Signal;
      
      public var change:Signal;
      
      public var logout:Signal;
      
      private var loginText:SimpleText;
      
      private var emailText:SimpleText;
      
      private var changeText:ClickableText;
      
      private var logoutText:ClickableText;
      
      public function WebAccountDetailDialog()
      {
         super("Current account","","Continue");
         this.makeLoginText();
         this.makeEmailText();
         h_ = h_ + 88;
         this.cancel = new NativeMappedSignal(rightButton_,MouseEvent.CLICK);
         this.change = new Signal();
         this.logout = new Signal();
      }
      
      public function setUserInfo(email:String) : void
      {
         this.emailText.text = email;
         this.makeChangeText();
         this.makeLogoutText();
      }
      
      private function makeChangeText() : void
      {
         this.changeText = new ClickableText(12,false,"Click here to change password");
         this.changeText.addEventListener(MouseEvent.CLICK,this.onChange);
         addNavigationText(this.changeText);
      }
      
      private function onChange(event:MouseEvent) : void
      {
         this.change.dispatch();
      }
      
      private function makeLogoutText() : void
      {
         this.logoutText = new ClickableText(12,false,"Not you?  Click here");
         this.logoutText.addEventListener(MouseEvent.CLICK,this.onLogout);
         addNavigationText(this.logoutText);
      }
      
      private function onLogout(event:MouseEvent) : void
      {
         this.logout.dispatch();
      }
      
      private function makeLoginText() : void
      {
         this.loginText = new SimpleText(18,11776947,false,0,0);
         this.loginText.setBold(true);
         this.loginText.text = "Currently logged in as:";
         this.loginText.updateMetrics();
         this.loginText.filters = [new DropShadowFilter(0,0,0)];
         this.loginText.y = h_ - 60;
         this.loginText.x = 17;
         addChild(this.loginText);
      }
      
      private function makeEmailText() : void
      {
         this.emailText = new SimpleText(16,11776947,false,238,30);
         this.emailText.updateMetrics();
         this.emailText.y = h_ - 30;
         this.emailText.x = 17;
         addChild(this.emailText);
      }
   }
}
