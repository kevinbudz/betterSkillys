package com.company.assembleegameclient.ui.menu
{
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.GameObjectListItem;
   import com.company.assembleegameclient.ui.LineBreakDesign;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.osflash.signals.Signal;
   
   public class PlayerGroupMenu extends Menu
   {
       
      
      public var map_:Map;
      
      public var players_:Vector.<Player>;
      
      public var teleportOption_:MenuOption;
      
      public var lineBreakDesign_:LineBreakDesign;
      
      private var playerPanels_:Vector.<GameObjectListItem>;
      
      public var unableToTeleport:Signal;
      
      public function PlayerGroupMenu(map:Map, players:Vector.<Player>)
      {
         var player:Player = null;
         var playerPlanel:GameObjectListItem = null;
         this.playerPanels_ = new Vector.<GameObjectListItem>();
         super(3552822,16777215);
         this.map_ = map;
         this.players_ = players.concat();
         this.unableToTeleport = new Signal();
         var yVal:int = 4;
         if(this.map_.allowPlayerTeleport_)
         {
            this.teleportOption_ = new TeleportMenuOption(this.map_.player_);
            this.teleportOption_.x = 8;
            this.teleportOption_.y = 8;
            this.teleportOption_.addEventListener(MouseEvent.CLICK,this.onTeleport);
            addChild(this.teleportOption_);
            this.lineBreakDesign_ = new LineBreakDesign(width - 24,0x151515);
            this.lineBreakDesign_.x = 6;
            this.lineBreakDesign_.y = 40;
            addChild(this.lineBreakDesign_);
            yVal = 52;
         }
         for each(player in this.players_)
         {
            playerPlanel = new GameObjectListItem(11776947,true,player);
            playerPlanel.x = 0;
            playerPlanel.y = yVal;
            addChild(playerPlanel);
            this.playerPanels_.push(playerPlanel);
            yVal = yVal + 32;
         }
      }
      
      private function onTeleport(event:Event) : void
      {
         var player:Player = null;
         var myPlayer:Player = this.map_.player_;
         var targetPlayer:Player = null;
         for each(player in this.players_)
         {
            if(myPlayer.isTeleportEligible(player))
            {
               targetPlayer = player;
               break;
            }
         }
         if(targetPlayer != null)
         {
            myPlayer.teleportTo(targetPlayer);
         }
         else
         {
            this.unableToTeleport.dispatch();
         }
         remove();
      }
   }
}
