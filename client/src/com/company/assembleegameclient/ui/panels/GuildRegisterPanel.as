package com.company.assembleegameclient.ui.panels
{
   import com.company.assembleegameclient.account.ui.CreateGuildFrame;
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.FrameOverlay;
   import com.company.assembleegameclient.ui.TextButton;
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import com.company.assembleegameclient.util.Currency;
   import com.company.assembleegameclient.util.GuildUtil;
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.util.components.LegacyBuyButton;
   
   public class GuildRegisterPanel extends Panel
   {
       
      
      private var title_:SimpleText;
      
      private var button_:Sprite;
      
      public function GuildRegisterPanel(gs:GameSprite)
      {
         var rankName:String = null;
         var buyButton:LegacyBuyButton = null;
         super(gs);
         if(gs_.map == null || gs_.map.player_ == null)
         {
            return;
         }
         var p:Player = gs_.map.player_;
         this.title_ = new SimpleText(18,16777215,false,WIDTH,0);
         this.title_.setBold(true);
         this.title_.wordWrap = true;
         this.title_.multiline = true;
         this.title_.autoSize = TextFieldAutoSize.CENTER;
         this.title_.filters = [new DropShadowFilter(0,0,0)];
         if(p.guildName_ != null && p.guildName_.length > 0)
         {
            rankName = GuildUtil.rankToString(p.guildRank_);
            this.title_.htmlText = "<p align=\"center\">" + rankName + " of \n" + p.guildName_ + "</p>";
            this.title_.y = 0;
            addChild(this.title_);
            this.button_ = new TextButton(16,"Renounce");
            this.button_.addEventListener(MouseEvent.CLICK,this.onRenounceClick);
            this.button_.x = WIDTH / 2 - this.button_.width / 2;
            this.button_.y = HEIGHT - this.button_.height - 4;
            addChild(this.button_);
         }
         else
         {
            this.title_.htmlText = "<p align=\"center\">Create a Guild</p>";
            this.title_.y = 0;
            addChild(this.title_);
            buyButton = new LegacyBuyButton("Create ",16,Parameters.GUILD_CREATION_PRICE,Currency.FAME);
            buyButton.addEventListener(MouseEvent.CLICK,this.onCreateClick);
            buyButton.x = WIDTH / 2 - buyButton.width / 2;
            buyButton.y = HEIGHT - buyButton.height / 2 - 31;
            addChild(buyButton);
            this.button_ = buyButton;
         }
      }
      
      public function onRenounceClick(event:MouseEvent) : void
      {
         if(gs_.map == null || gs_.map.player_ == null)
         {
            return;
         }
         var p:Player = gs_.map.player_;
         var renounceDialog:Dialog = new Dialog("Are you sure you want to quit:\n" + p.guildName_,"Renounce Guild","No, I\'ll stay","Yes, I\'ll quit");
         renounceDialog.addEventListener(Dialog.BUTTON1_EVENT,this.onNoRenounce);
         renounceDialog.addEventListener(Dialog.BUTTON2_EVENT,this.onRenounce);
         stage.addChild(renounceDialog);
      }
      
      private function onNoRenounce(event:Event) : void
      {
         stage.removeChild(event.currentTarget as Dialog);
      }
      
      private function onRenounce(event:Event) : void
      {
         if(gs_.map == null || gs_.map.player_ == null)
         {
            return;
         }
         var p:Player = gs_.map.player_;
         gs_.gsc_.guildRemove(p.name_);
         stage.removeChild(event.currentTarget as Dialog);
         visible = false;
      }
      
      public function onCreateClick(event:MouseEvent) : void
      {
         var sprite:Sprite = new FrameOverlay(new CreateGuildFrame(gs_));
         stage.addChild(sprite);
         visible = false;
      }
   }
}
