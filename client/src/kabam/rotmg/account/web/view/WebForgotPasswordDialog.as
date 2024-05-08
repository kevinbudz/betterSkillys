package kabam.rotmg.account.web.view
{
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.account.ui.TextInputField;
   import com.company.assembleegameclient.ui.ClickableText;
   import flash.events.MouseEvent;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class WebForgotPasswordDialog extends Frame
   {
       
      
      public var cancel:Signal;
      
      public var submit:Signal;
      
      public var register:Signal;
      
      private var emailInput:TextInputField;
      
      private var registerText:ClickableText;
      
      public function WebForgotPasswordDialog()
      {
         super("Forgot your password?  We\'ll email it.","Cancel","Submit");
         this.emailInput = new TextInputField("Email",false,"");
         addTextInputField(this.emailInput);
         this.registerText = new ClickableText(12,false,"New user?  Click here to Register");
         addNavigationText(this.registerText);
         rightButton_.addEventListener(MouseEvent.CLICK,this.onSubmit);
         this.cancel = new NativeMappedSignal(leftButton_,MouseEvent.CLICK);
         this.register = new NativeMappedSignal(this.registerText,MouseEvent.CLICK);
         this.submit = new Signal(String);
      }
      
      private function onSubmit(event:MouseEvent) : void
      {
         if(this.isEmailValid())
         {
            disable();
            this.submit.dispatch(this.emailInput.text());
         }
      }
      
      private function isEmailValid() : Boolean
      {
         var isValid:Boolean = this.emailInput.text() != "";
         if(!isValid)
         {
            this.emailInput.setError("Not a valid email address");
         }
         return isValid;
      }
      
      public function showError(error:String) : void
      {
         this.emailInput.setError(error);
      }

      public function restartInput() : void
      {
         this.emailInput.inputText_.text = "";
      }

      public function showComplete(complete:String) : void
      {
         this.emailInput.setError(complete);
      }
   }
}
