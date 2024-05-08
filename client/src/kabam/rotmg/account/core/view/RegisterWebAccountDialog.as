package kabam.rotmg.account.core.view
{
   import com.company.assembleegameclient.account.ui.CheckBoxField;
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.account.ui.TextInputField;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.util.EmailValidator;
   import flash.events.MouseEvent;
   import kabam.rotmg.account.web.model.AccountData;
   import org.osflash.signals.Signal;
   
   public class RegisterWebAccountDialog extends Frame
   {
       
      
      public var register:Signal;
      
      public var cancel:Signal;
      
      private var emailInput:TextInputField;
      
      private var passwordInput:TextInputField;
      
      private var retypePasswordInput:TextInputField;
      
      private var checkbox:CheckBoxField;
      
      public function RegisterWebAccountDialog()
      {
         this.register = new Signal(AccountData);
         this.cancel = new Signal();
         super("Register a web account in order to play anywhere","Cancel","Register");
         this.emailInput = new TextInputField("Email",false,"");
         addTextInputField(this.emailInput);
         this.passwordInput = new TextInputField("Password",true,"");
         addTextInputField(this.passwordInput);
         this.retypePasswordInput = new TextInputField("Retype Password",true,"");
         addTextInputField(this.retypePasswordInput);
         this.checkbox = new CheckBoxField("I agree to the <font color=\"#7777EE\"><a href=\"" + Parameters.TERMS_OF_USE_URL + "\" target=\"_blank\">Terms of Use</a></font>.",false,"");
         addCheckBox(this.checkbox);
         leftButton_.addEventListener(MouseEvent.CLICK,this.onCancel);
         rightButton_.addEventListener(MouseEvent.CLICK,this.onRegister);
      }
      
      private function onCancel(event:MouseEvent) : void
      {
         this.cancel.dispatch();
      }
      
      private function onRegister(event:MouseEvent) : void
      {
         var data:AccountData = null;
         if(this.isEmailValid() && this.isPasswordValid() && this.isPasswordVerified() && this.isCheckboxChecked())
         {
            data = new AccountData();
            data.username = this.emailInput.text();
            data.password = this.passwordInput.text();
            this.register.dispatch(data);
         }
      }
      
      private function isCheckboxChecked() : Boolean
      {
         var isChecked:Boolean = this.checkbox.isChecked();
         if(!isChecked)
         {
            this.checkbox.setError("Must agree to register");
         }
         return isChecked;
      }
      
      private function isEmailValid() : Boolean
      {
         var isValid:Boolean = EmailValidator.isValidEmail(this.emailInput.text());
         if(!isValid)
         {
            this.emailInput.setError("Not a valid email address");
         }
         return isValid;
      }
      
      private function isPasswordValid() : Boolean
      {
         var isValid:Boolean = this.passwordInput.text().length >= 5;
         if(!isValid)
         {
            this.passwordInput.setError("Password too short");
         }
         return isValid;
      }
      
      private function isPasswordVerified() : Boolean
      {
         var isValid:Boolean = this.passwordInput.text() == this.retypePasswordInput.text();
         if(!isValid)
         {
            this.retypePasswordInput.setError("Password does not match");
         }
         return isValid;
      }
      
      public function showError(error:String) : void
      {
         this.emailInput.setError(error);
      }
   }
}
