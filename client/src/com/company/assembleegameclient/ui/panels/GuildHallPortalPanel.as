package com.company.assembleegameclient.ui.panels
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.GuildHallPortal;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.TextBox;
   import com.company.assembleegameclient.ui.TextButton;
   import com.company.ui.SimpleText;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   
   public class GuildHallPortalPanel extends Panel
   {
      private var owner_:GuildHallPortal;
      private var nameText_:SimpleText;
      private var enterButton_:TextButton;
      private var noGuildText_:SimpleText;
      
      public function GuildHallPortalPanel(gs:GameSprite, owner:GuildHallPortal)
      {
         super(gs);
         this.owner_ = owner;
         if(gs_.map == null || gs_.map.player_ == null)
         {
            return;
         }
         var p:Player = gs_.map.player_;
         this.nameText_ = new SimpleText(18,16777215,false,WIDTH,0);
         this.nameText_.setBold(true);
         this.nameText_.htmlText = "<p align=\"center\">Guild Hall</p>";
         this.nameText_.wordWrap = true;
         this.nameText_.multiline = true;
         this.nameText_.autoSize = TextFieldAutoSize.CENTER;
         this.nameText_.filters = [new DropShadowFilter(0,0,0)];
         this.nameText_.y = 6;
         addChild(this.nameText_);
         if(p.guildName_ != null && p.guildName_.length > 0)
         {
            this.enterButton_ = new TextButton(16,"Enter");
            this.enterButton_.addEventListener(MouseEvent.CLICK,this.onEnterSpriteClick);
            this.enterButton_.x = WIDTH / 2 - this.enterButton_.width / 2;
            this.enterButton_.y = HEIGHT - this.enterButton_.height - 4;
            addChild(this.enterButton_);
            addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
            addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         }
         else
         {
            this.noGuildText_ = new SimpleText(18,16711680,false,WIDTH,0);
            this.noGuildText_.setBold(true);
            this.noGuildText_.htmlText = "<p align=\"center\">Not In Guild</p>";
            this.noGuildText_.autoSize = TextFieldAutoSize.CENTER;
            this.noGuildText_.filters = [new DropShadowFilter(0,0,0)];
            this.noGuildText_.y = HEIGHT - this.noGuildText_.height - 12;
            addChild(this.noGuildText_);
         }
      }
      
      private function onAdded(event:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }

      private function onRemovedFromStage(event:Event) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onEnterSpriteClick(event:MouseEvent) : void
      {
         this.enterPortal();
      }
      
      private function onKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Parameters.data_.interact && !TextBox.isInputtingText)
         {
            this.enterPortal();
         }
      }
      
      private function enterPortal() : void
      {
         gs_.gsc_.usePortal(this.owner_.objectId_);
      }
   }
}
