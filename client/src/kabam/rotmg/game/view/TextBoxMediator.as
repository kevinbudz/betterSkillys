package kabam.rotmg.game.view
{
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.TextBox;
import flash.events.Event;
import flash.events.MouseEvent;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
import kabam.rotmg.account.web.view.WebRegisterDialog;
import kabam.rotmg.application.api.ApplicationSetup;
import kabam.rotmg.chat.ParseChatMessageSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.game.model.AddTextLineVO;
import kabam.rotmg.game.model.ChatFilter;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.game.signals.SetTextBoxVisibilitySignal;
import robotlegs.bender.bundles.mvcs.Mediator;

public class TextBoxMediator extends Mediator
{


   [Inject]
   public var chatFilter:ChatFilter;

   [Inject]
   public var addTextLine:AddTextLineSignal;

   [Inject]
   public var setTextBoxVisibility:SetTextBoxVisibilitySignal;

   [Inject]
   public var view:TextBox;

   [Inject]
   public var account:Account;

   [Inject]
   public var openDialog:OpenDialogSignal;

   [Inject]
   public var updateAccount:UpdateAccountInfoSignal;

   [Inject]
   public var setup:ApplicationSetup;

   [Inject]
   public var parseChatMessage:ParseChatMessageSignal;

   public function TextBoxMediator()
   {
      super();
   }

   override public function initialize() : void
   {
      this.addTextLine.add(this.onAddTextLine);
      this.setTextBoxVisibility.add(this.onSetTextBoxVisibility);
      this.updateAccount.add(this.onUpdateAccount);
      this.view.message.add(this.onMessage);
      this.view.setInputTextAllowed(this.account.isRegistered());
      this.view.inputTextClicked.add(this.onInputTextClicked);
      this.view.speechBubbleClicked.add(this.onInputTextClicked);
      this.view.addText(Parameters.CLIENT_CHAT_NAME,this.getChatLabel());
   }

   private function getChatLabel() : String
   {
      var text:String = this.setup.getBuildLabel();
      text = text.replace(/<font .+>(.+)<\/font>/g,"$1");
      return text;
   }

   override public function destroy() : void
   {
      this.addTextLine.remove(this.onAddTextLine);
      this.setTextBoxVisibility.remove(this.onSetTextBoxVisibility);
      this.updateAccount.remove(this.onUpdateAccount);
      this.view.message.add(this.onMessage);
      this.view.inputTextClicked.remove(this.onInputTextClicked);
      this.view.speechBubbleClicked.remove(this.onInputTextClicked);
   }

   private function onMessage(_arg1:String):void {
      this.parseChatMessage.dispatch(_arg1);
      this.view.stage.focus = null;
   }

   private function onAddTextLine(vo:AddTextLineVO) : void
   {
      if(this.account.isRegistered() || this.chatFilter.guestChatFilter(vo.name))
      {
         this.view.addTextFull(vo.name,vo.objectId,vo.numStars,vo.recipient,vo.text, vo.nameColor, vo.textColor);
      }
   }

   private function onSetTextBoxVisibility(visible:Boolean) : void
   {
      this.view.textSprite_.visible = visible;
   }

   private function onInputTextClicked(e:Event) : void
   {
      if(!this.account.isRegistered())
      {
         this.openDialog.dispatch(new WebRegisterDialog());
      }
      else
      {
         this.view.stage.focus = null;
      }
   }

   private function onUpdateAccount() : void
   {
      this.view.setInputTextAllowed(this.account.isRegistered());
   }
}
}
