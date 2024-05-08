package com.company.assembleegameclient.map.partyoverlay
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.objects.Party;
   import com.company.assembleegameclient.objects.Player;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PartyOverlay extends Sprite
   {
       
      
      public var map_:Map;
      
      public var partyMemberArrows_:Vector.<PlayerArrow> = null;
      
      public var questArrow_:QuestArrow;
      
      public function PartyOverlay(map:Map)
      {
         var playerArrow:PlayerArrow = null;
         super();
         this.map_ = map;
         this.partyMemberArrows_ = new Vector.<PlayerArrow>(Party.NUM_MEMBERS,true);
         for(var i:int = 0; i < Party.NUM_MEMBERS; i++)
         {
            playerArrow = new PlayerArrow();
            this.partyMemberArrows_[i] = playerArrow;
            addChild(playerArrow);
         }
         this.questArrow_ = new QuestArrow(this.map_);
         addChild(this.questArrow_);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         GameObjectArrow.removeMenu();
      }
      
      public function draw(camera:Camera, time:int) : void
      {
         var playerArrow:PlayerArrow = null;
         var player:Player = null;
         var j:int = 0;
         var prevArrow:PlayerArrow = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         if(this.map_.player_ == null)
         {
            return;
         }
         var party:Party = this.map_.party_;
         var myPlayer:Player = this.map_.player_;
         for(var i:int = 0; i < Party.NUM_MEMBERS; i++)
         {
            playerArrow = this.partyMemberArrows_[i];
            if(!playerArrow.mouseOver_)
            {
               if(i >= party.members_.length)
               {
                  playerArrow.setGameObject(null);
               }
               else
               {
                  player = party.members_[i];
                  if(player.drawn_ || player.map_ == null || player.dead_)
                  {
                     playerArrow.setGameObject(null);
                  }
                  else
                  {
                     playerArrow.setGameObject(player);
                     for(j = 0; j < i; j++)
                     {
                        prevArrow = this.partyMemberArrows_[j];
                        dx = playerArrow.x - prevArrow.x;
                        dy = playerArrow.y - prevArrow.y;
                        if(dx * dx + dy * dy < 64)
                        {
                           if(!prevArrow.mouseOver_)
                           {
                              prevArrow.addGameObject(player);
                           }
                           playerArrow.setGameObject(null);
                           break;
                        }
                     }
                     playerArrow.draw(time,camera);
                  }
               }
            }
         }
         if(!this.questArrow_.mouseOver_)
         {
            this.questArrow_.draw(time,camera);
         }
      }
   }
}
