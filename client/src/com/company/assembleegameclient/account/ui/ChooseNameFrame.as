package com.company.assembleegameclient.account.ui
{
   import com.company.assembleegameclient.game.GameSprite;
   import flash.events.MouseEvent;
   import org.osflash.signals.Signal;
   
   public class ChooseNameFrame extends Frame
   {
       
      
      public const cancel:Signal = new Signal();
      
      public const choose:Signal = new Signal(String);
      
      public var gameSprite:GameSprite;
      
      public var isPurchase:Boolean;
      
      private var nameInput:TextInputField;
      
      public function ChooseNameFrame(gs:GameSprite, buy:Boolean)
      {
         super("Choose a unique account name","Cancel","Choose");
         this.gameSprite = gs;
         this.isPurchase = buy;
         this.nameInput = new TextInputField("Name",false,"");
         this.nameInput.inputText_.restrict = "A-Za-z";
         this.nameInput.inputText_.maxChars = 10;
         addTextInputField(this.nameInput);
         addPlainText("Maximum 10 characters");
         addPlainText("No numbers, spaces or punctuation");
         addPlainText("Racism or profanity gets you banned");
         leftButton_.addEventListener(MouseEvent.CLICK,this.onCancel);
         rightButton_.addEventListener(MouseEvent.CLICK,this.onChoose);
      }
      
      private function onCancel(event:MouseEvent) : void
      {
         this.cancel.dispatch();
      }
      
      private function onChoose(event:MouseEvent) : void
      {
         this.choose.dispatch(this.nameInput.text());
         disable();
      }
      
      public function setError(errorText:String) : void
      {
         this.nameInput.setError(errorText);
      }
   }
}
