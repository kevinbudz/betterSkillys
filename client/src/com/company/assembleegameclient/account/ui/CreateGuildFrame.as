package com.company.assembleegameclient.account.ui
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.game.events.GuildResultEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class CreateGuildFrame extends Frame
   {
       
      
      private var name_:TextInputField;
      
      private var gs_:GameSprite;
      
      public function CreateGuildFrame(gs:GameSprite)
      {
         super("Create a new Guild","Cancel","Create");
         this.gs_ = gs;
         this.name_ = new TextInputField("Guild Name",false,"");
         this.name_.inputText_.restrict = "A-Za-z ";
         this.name_.inputText_.maxChars = 20;
         addTextInputField(this.name_);
         addPlainText("Maximum 20 characters");
         addPlainText("No numbers or punctuation");
         addPlainText("Racism or profanity gets your guild banned");
         leftButton_.addEventListener(MouseEvent.CLICK,this.onCancel);
         rightButton_.addEventListener(MouseEvent.CLICK,this.onCreate);
      }
      
      private function onCancel(event:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function onCreate(event:MouseEvent) : void
      {
         this.gs_.addEventListener(GuildResultEvent.EVENT,this.onResult);
         this.gs_.gsc_.createGuild(this.name_.text());
         disable();
      }
      
      private function onResult(event:GuildResultEvent) : void
      {
         trace("onResult: " + event);
         this.gs_.removeEventListener(GuildResultEvent.EVENT,this.onResult);
         if(event.success_)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
         else
         {
            this.name_.setError(event.errorText_);
            enable();
         }
      }
   }
}
