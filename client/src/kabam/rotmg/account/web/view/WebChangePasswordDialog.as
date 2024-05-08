package kabam.rotmg.account.web.view
{
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.account.ui.TextInputField;
   import flash.events.MouseEvent;
   import kabam.rotmg.account.web.model.ChangePasswordData;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class WebChangePasswordDialog extends Frame
   {
       
      
      public var cancel:Signal;
      
      public var change:Signal;
      
      public var password_:TextInputField;
      
      public var newPassword_:TextInputField;
      
      public var retypeNewPassword_:TextInputField;
      
      public function WebChangePasswordDialog()
      {
         super("Change your password","Cancel","Submit");
         this.password_ = new TextInputField("Password",true,"");
         addTextInputField(this.password_);
         this.newPassword_ = new TextInputField("New Password",true,"");
         addTextInputField(this.newPassword_);
         this.retypeNewPassword_ = new TextInputField("Retype New Password",true,"");
         addTextInputField(this.retypeNewPassword_);
         this.cancel = new NativeMappedSignal(leftButton_,MouseEvent.CLICK);
         this.change = new NativeMappedSignal(rightButton_,MouseEvent.CLICK);
      }
      
      private function onChange(event:MouseEvent) : void
      {
         var data:ChangePasswordData = null;
         if(this.isCurrentPasswordValid() && this.isNewPasswordValid() && this.isNewPasswordVerified())
         {
            disable();
            data = new ChangePasswordData();
            data.currentPassword = this.password_.text();
            data.newPassword = this.newPassword_.text();
            this.change.dispatch(data);
         }
      }
      
      private function isCurrentPasswordValid() : Boolean
      {
         var isValid:Boolean = this.password_.text().length >= 5;
         if(!isValid)
         {
            this.password_.setError("Incorrect password");
         }
         return isValid;
      }
      
      private function isNewPasswordValid() : Boolean
      {
         var isValid:Boolean = this.newPassword_.text().length >= 5;
         if(!isValid)
         {
            this.newPassword_.setError("Password too short");
         }
         return isValid;
      }
      
      private function isNewPasswordVerified() : Boolean
      {
         var isValid:Boolean = this.newPassword_.text() == this.retypeNewPassword_.text();
         if(!isValid)
         {
            this.retypeNewPassword_.setError("Password does not match");
         }
         return isValid;
      }
      
      public function setError(error:String) : void
      {
         this.password_.setError(error);
      }
   }
}
