package com.company.assembleegameclient.ui.menu
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.GameObjectListItem;
   import com.company.assembleegameclient.util.GuildUtil;
   import com.company.util.AssetLibrary;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PlayerMenu extends Menu
   {
       
      
      public var gs_:GameSprite;
      
      public var playerName_:String;
      
      public var player_:Player;
      
      public var playerPanel_:GameObjectListItem;
      
      public function PlayerMenu()
      {
         super(3552822,16777215);
      }

      public function init(gs:GameSprite, player:Player):void
      {
         var option:MenuOption = null;
         this.gs_ = gs;
         this.playerName_ = player.name_;
         this.player_ = player;
         this.playerPanel_ = new GameObjectListItem(11776947,true,this.player_);
         addChild(this.playerPanel_);
         if(this.gs_.map.allowPlayerTeleport_ && this.player_.isTeleportEligible(this.player_))
         {
            option = new TeleportMenuOption(this.gs_.map.player_);
            option.addEventListener(MouseEvent.CLICK,this.onTeleport);
            addOption(option);
         }
         if(this.gs_.map.player_.guildRank_ >= GuildUtil.OFFICER && (player.guildName_ == null || player.guildName_.length == 0))
         {
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",10),16777215,"Invite");
            option.addEventListener(MouseEvent.CLICK,this.onInvite);
            addOption(option);
         }
         if(!this.player_.starred_)
         {
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterface2",5),16777215,"Lock");
            option.addEventListener(MouseEvent.CLICK,this.onLock);
            addOption(option);
         }
         else
         {
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterface2",6),16777215,"Unlock");
            option.addEventListener(MouseEvent.CLICK,this.onUnlock);
            addOption(option);
         }
         option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",21),16777215,"Whisper");
         option.addEventListener(MouseEvent.CLICK,this.onTell);
         addOption(option);
         option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",7),16777215,"Trade");
         option.addEventListener(MouseEvent.CLICK,this.onTrade);
         addOption(option);
         if(!this.player_.isPartyMember_)
         {
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",14),16777215,"Party");
            option.addEventListener(MouseEvent.CLICK,this.onPartyInvite);
            addOption(option);
         }
         else
         {
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",14),16777215,"Remove Party");
            option.addEventListener(MouseEvent.CLICK,this.onPartyRemove);
            addOption(option);
         }
         if(!this.player_.ignored_)
         {
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",8),16777215,"Ignore");
            option.addEventListener(MouseEvent.CLICK,this.onIgnore);
            addOption(option);
         }
         else
         {
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",9),16777215,"Unignore");
            option.addEventListener(MouseEvent.CLICK,this.onUnignore);
            addOption(option);
         }
      }

      private function onPartyRemove(event:Event) : void
      {
         this.gs_.gsc_.playerText("/premove " + this.playerName_);
         remove();
      }

      private function onPartyInvite(event:Event) : void
      {
         this.gs_.gsc_.partyInvite(this.playerName_);
         remove();
      }

      private function onTell(event:Event) : void
      {
         this.gs_.textBox_.insertTellPlayerPrefix(this.playerName_);
         remove();
      }

      private function onTeleport(event:Event) : void
      {
         this.gs_.map.player_.teleportTo(this.player_);
         remove();
      }
      
      private function onInvite(event:Event) : void
      {
         this.gs_.gsc_.guildInvite(this.playerName_);
         remove();
      }
      
      private function onLock(event:Event) : void
      {
         this.gs_.map.party_.lockPlayer(this.player_);
         remove();
      }
      
      private function onUnlock(event:Event) : void
      {
         this.gs_.map.party_.unlockPlayer(this.player_);
         remove();
      }
      
      private function onTrade(event:Event) : void
      {
         this.gs_.gsc_.requestTrade(this.playerName_);
         remove();
      }
      
      private function onIgnore(event:Event) : void
      {
         this.gs_.map.party_.ignorePlayer(this.player_);
         remove();
      }
      
      private function onUnignore(event:Event) : void
      {
         this.gs_.map.party_.unignorePlayer(this.player_);
         remove();
      }
   }
}
