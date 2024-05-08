package kabam.rotmg.account.web.view
{
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.ui.SimpleText;
import com.gskinner.motion.GTween;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import kabam.rotmg.account.core.view.AccountInfoView;
import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class WebAccountInfoView extends Sprite implements AccountInfoView
{

   private static const LOG_IN:String = "log in";

   private static const LOG_OUT:String = "log out";

   private static const LOGGED_IN_TEXT:String = "logged in as ${userName} - ";

   private static const REGISTER:String = "register";
   private static const LOGIN:String = "log in";

   private static const FONT_SIZE:int = 18;


   private var _login:Signal;

   private var _register:Signal;

   private var userName:String = "";

   private var isRegistered:Boolean;

   private var accountText:SimpleText;

   private var registerButton:TitleMenuOption;

   private var dividerText:SimpleText;

   private var loginButton:TitleMenuOption;

   private var fadeIn_:Boolean;

   public function WebAccountInfoView()
   {
      this.addFade();
      super();
      this.makeUIElements();
      this.makeSignals();
   }

   public function get login() : Signal
   {
      return this._login;
   }

   public function addFade():void{
      fadeIn_ = true;
      alpha = 0;
   }

   public function get register() : Signal
   {
      return this._register;
   }

   private function makeUIElements() : void
   {
      this.makeAccountText();
      this.makeLoginButton();
      this.makeDividerText();
      this.makeRegisterButton();
      this.accountText.y = 6;
      this.loginButton.y = 3;
      if(fadeIn_){
         new GTween(this, 0.1, {"alpha": 1});
      }
   }

   private function makeSignals() : void
   {
      this._login = new NativeMappedSignal(this.loginButton,MouseEvent.CLICK);
      this._register = new NativeMappedSignal(this.registerButton,MouseEvent.CLICK);
   }

   private function makeAccountText() : void
   {
      this.accountText = new SimpleText(FONT_SIZE,11776947,false,0,0);
      this.accountText.filters = [new DropShadowFilter(0,0,0,1,4,4)];
   }

   private function makeLoginButton() : void
   {
      this.loginButton = new TitleMenuOption(LOGIN,FONT_SIZE,false);
   }

   private function makeRegisterButton() : void
   {
      this.registerButton = new TitleMenuOption(REGISTER,FONT_SIZE,false);
   }

   private function makeDividerText() : void
   {
      this.dividerText = new SimpleText(FONT_SIZE,11776947,false,0,0);
      this.dividerText.filters = [new DropShadowFilter(0,0,0,1,4,4)];
      this.dividerText.text = " - ";
      this.dividerText.updateMetrics();
   }

   public function setInfo(userName:String, isRegistered:Boolean) : void
   {
      this.userName = userName;
      this.isRegistered = isRegistered;
      this.updateUI();
   }

   private function updateUI() : void
   {
      this.removeUIElements();
      if(this.isRegistered)
      {
         this.showUIForRegisteredAccount();
      }
      else
      {
         this.showUIForGuestAccount();
      }
   }

   private function removeUIElements() : void
   {
      while(numChildren)
      {
         removeChildAt(0);
      }
   }

   private function showUIForRegisteredAccount():void {
      this.accountText.text = LOGGED_IN_TEXT.replace("${userName}",this.userName);
      this.accountText.updateMetrics();
      this.loginButton.setText(LOG_OUT);
      this.addAndAlignHorizontally(this.accountText,this.loginButton);
   }

   private function showUIForGuestAccount() : void
   {
      this.accountText.text = "Not Signed in - ";
      this.accountText.updateMetrics();
      this.loginButton.setText(LOG_IN);
      if(Parameters.TESTING_SERVER){
         this.addAndAlignHorizontally(this.accountText,this.registerButton,this.dividerText,this.loginButton);
      }
      else{
         this.addAndAlignHorizontally(this.accountText, this.loginButton);
      }
   }

   private function addAndAlignHorizontally(... uiElements) : void
   {
      var ui:DisplayObject = null;
      var x:int = 0;
      var i:int = uiElements.length;
      while(i--)
      {
         ui = uiElements[i];
         x = x - ui.width;
         ui.x = x;
         addChild(ui);
      }
   }
}
}
