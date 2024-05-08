package kabam.rotmg.account.web.view
{
   import com.company.assembleegameclient.account.ui.CheckBoxField;
   import com.company.assembleegameclient.account.ui.Frame;
   import com.company.assembleegameclient.parameters.Parameters;
import com.company.ui.SimpleText;
import com.company.util.EmailValidator;
import com.gskinner.motion.GTween;

import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.account.ui.components.DateField;
   import kabam.rotmg.account.web.model.AccountData;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class WebRegisterDialog extends Frame
   {
      private const CHECK_BOX_TEXT:String = "Sign me up to receive special offers, updates,<br>and early access to Kabam games";
      private const TOS_TEXT:String = "By clicking \'Register\', you are indicating that you have<br>read and agreed to the <font color=\"#7777EE\"><a href=\"" + Parameters.TERMS_OF_USE_URL + "\" target=\"_blank\">Terms of Use</a></font> and " + "<font color=\"#7777EE\"><a href=\"" + Parameters.PRIVACY_POLICY_URL + "\" target=\"_blank\">Privacy Policy</a></font>";
      private const SIGN_IN_TEXT:String = "Already registered? <font color=\"#7777EE\"><a href=\"event:flash.events.TextEvent\">here</a></font> to sign in!";
      private const REGISTER_IMPERATIVE:String = "Register in order to save your progress";
      private const MULTIPLE_ERRORS_MESSAGE:String = "Please fix the errors below";
      private const PASSWORDS_DONT_MATCH:String = "The password did not match";
      private const PASSWORD_TOO_SHORT:String = "The password is too short";
      private const INVALID_EMAIL_ADDRESS:String = "Not a valid email address";
      private const INELIGIBLE_AGE:String = "We are sorry, but you are not eligible for an account at this time.";
      private const INVALID_BIRTHDATE:String = "Birthdate is not a valid date.";
      
      public var register:Signal;
      public var signIn:Signal;
      public var cancel:Signal;
      private const errors:Array = [];
      private var playerNameInput:LabeledField;
      private var emailInput:LabeledField;
      private var passwordInput:LabeledField;
      private var retypePasswordInput:LabeledField;
      private var signInText:SimpleText;
      private var tosText:SimpleText;
      private var fadeIn_:Boolean;
      
      public function WebRegisterDialog()
      {
         super(this.REGISTER_IMPERATIVE,"Cancel","Register", 326);
         this.addFade();
         this.makeUIElements();
         this.makeSignals();
      }
      
      private function makeUIElements() : void
      {
         this.playerNameInput = new LabeledField("Player Name", false, 275);
         this.playerNameInput.inputText_.maxChars = 10;
         this.playerNameInput.inputText_.restrict = "A-Za-z";
         this.emailInput = new LabeledField("Email",false,275);
         this.passwordInput = new LabeledField("Password",true,275);
         this.retypePasswordInput = new LabeledField("Retype Password",true,275);
         this.tosText = new SimpleText(12,11776947,false,0,0,true);
         this.tosText.setBold(true);
         this.tosText.multiline = true;
         this.tosText.htmlText = this.TOS_TEXT;
         this.tosText.updateMetrics();
         this.tosText.filters = [new DropShadowFilter(0,0,0)];
         this.signInText = new SimpleText(12,11776947,false,0,0,true);
         this.signInText.setBold(true);
         this.signInText.htmlText = this.SIGN_IN_TEXT;
         this.signInText.updateMetrics();
         this.signInText.filters = [new DropShadowFilter(0,0,0)];
         this.signInText.addEventListener(TextEvent.LINK,this.linkEvent);
         addLabeledField(this.playerNameInput);
         addLabeledField(this.emailInput);
         addLabeledField(this.passwordInput);
         addLabeledField(this.retypePasswordInput);
         addSpace(8);
         addComponent(this.tosText,14);
         addSpace(8);
         addComponent(this.signInText,14);
         if(fadeIn_){
            new GTween(this, 0.1, {"alpha": 1});
         }
      }

      private function addFade():void{
         this.fadeIn_ = true;
         alpha = 0;
      }
      
      private function linkEvent(event_:TextEvent) : void
      {
         this.signIn.dispatch();
      }
      
      private function makeSignals() : void
      {
         this.cancel = new NativeMappedSignal(leftButton_,MouseEvent.CLICK);
         rightButton_.addEventListener(MouseEvent.CLICK,this.onRegister);
         this.register = new Signal(AccountData);
         this.signIn = new Signal();
      }
      
      private function onRegister(event:MouseEvent) : void
      {
         var areValid:Boolean = this.areInputsValid();
         this.displayErrors();
         if(areValid)
         {
            this.sendData();
         }
      }
      
      private function areInputsValid() : Boolean
      {
         this.errors.length = 0;
         var isValid:Boolean = true;
         isValid = this.isEmailValid() && isValid;
         isValid = this.isPasswordValid() && isValid;
         isValid = this.isPasswordVerified() && isValid;
         isValid = this.isPlayerNameValid() && isValid;
         return isValid;
      }

      private function isPlayerNameValid():Boolean
      {
         var _local1:Boolean = ((!((this.playerNameInput.text() == ""))) && ((this.playerNameInput.text().length <= 10)));
         this.playerNameInput.setErrorHighlight(!(_local1));
         if (!_local1){
            this.errors.push("Invalid Player Name");
         };
         return (_local1);
      }

      private function isEmailValid() : Boolean
      {
         var isValid:Boolean = EmailValidator.isValidEmail(this.emailInput.text());
         this.emailInput.setErrorHighlight(!isValid);
         if(!isValid)
         {
            this.errors.push(this.INVALID_EMAIL_ADDRESS);
         }
         return isValid;
      }
      
      private function isPasswordValid() : Boolean
      {
         var isValid:Boolean = this.passwordInput.text().length >= 5;
         this.passwordInput.setErrorHighlight(!isValid);
         if(!isValid)
         {
            this.errors.push(this.PASSWORD_TOO_SHORT);
         }
         return isValid;
      }
      
      private function isPasswordVerified() : Boolean
      {
         var isValid:Boolean = this.passwordInput.text() == this.retypePasswordInput.text();
         this.retypePasswordInput.setErrorHighlight(!isValid);
         if(!isValid)
         {
            this.errors.push(this.PASSWORDS_DONT_MATCH);
         }
         return isValid;
      }
      
      public function displayErrors() : void
      {
         if(this.errors.length == 0)
         {
            this.clearErrors();
         }
         else
         {
            this.displayErrorText(this.errors.length == 1?this.errors[0]:this.MULTIPLE_ERRORS_MESSAGE);
         }
      }
      
      public function displayServerError(value:String) : void
      {
         this.displayErrorText(value);
      }
      
      private function clearErrors() : void
      {
         titleText_.text = this.REGISTER_IMPERATIVE;
         titleText_.updateMetrics();
         titleText_.setColor(11776947);
      }
      
      private function displayErrorText(value:String) : void
      {
         titleText_.text = value;
         titleText_.updateMetrics();
         titleText_.setColor(16549442);
      }
      
      private function sendData() : void
      {
         var data:AccountData = new AccountData();
         data.username = this.emailInput.text();
         data.password = this.passwordInput.text();
         data.name = this.playerNameInput.text();
         this.register.dispatch(data);
      }
   }
}
