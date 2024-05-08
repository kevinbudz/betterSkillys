package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.map.Map;
   import com.company.util.PointUtil;
   import flash.utils.Dictionary;
   import kabam.rotmg.messaging.impl.incoming.AccountList;
   
   public class Party
   {
      
      public static const NUM_MEMBERS:int = 6;
      
      private static const SORT_ON_FIELDS:Array = ["starred_","distSqFromThisPlayer_","objectId_"];
      
      private static const SORT_ON_PARAMS:Array = [Array.NUMERIC | Array.DESCENDING,Array.NUMERIC,Array.NUMERIC];
      
      private static const PARTY_DISTANCE_SQ:int = 50 * 50;
       
      
      public var map_:Map;
      
      public var members_:Array;
      
      private var starred_:Dictionary;
      
      private var ignored_:Dictionary;
      
      private var lastUpdate_:int = -2147483648;
      
      public function Party(map:Map)
      {
         this.members_ = [];
         this.starred_ = new Dictionary(true);
         this.ignored_ = new Dictionary(true);
         super();
         this.map_ = map;
      }
      
      public function update(time:int, dt:int) : void
      {
         var go:GameObject = null;
         var oPlayer:Player = null;
         if(time < this.lastUpdate_ + 500)
         {
            return;
         }
         this.lastUpdate_ = time;
         this.members_.length = 0;
         var player:Player = this.map_.player_;
         if(player == null)
         {
            return;
         }
         for each(go in this.map_.goDict_)
         {
            oPlayer = go as Player;
            if(!(oPlayer == null || oPlayer == player))
            {
               if(this.starred_[oPlayer.accountId_] != undefined)
               {
                  oPlayer.starred_ = true;
               }
               oPlayer.ignored_ = this.ignored_[oPlayer.accountId_] != undefined;
               oPlayer.distSqFromThisPlayer_ = PointUtil.distanceSquaredXY(player.x_,player.y_,oPlayer.x_,oPlayer.y_);
               if(!(oPlayer.distSqFromThisPlayer_ > PARTY_DISTANCE_SQ && !oPlayer.starred_))
               {
                  this.members_.push(oPlayer);
               }
            }
         }
         this.members_.sortOn(SORT_ON_FIELDS,SORT_ON_PARAMS);
         if(this.members_.length > NUM_MEMBERS)
         {
            this.members_.length = NUM_MEMBERS;
         }
      }
      
      public function lockPlayer(player:Player) : void
      {
         this.starred_[player.accountId_] = 1;
         this.lastUpdate_ = int.MIN_VALUE;
         this.map_.gs_.gsc_.editAccountList(0,true,player.objectId_);
      }
      
      public function unlockPlayer(player:Player) : void
      {
         delete this.starred_[player.accountId_];
         player.starred_ = false;
         this.lastUpdate_ = int.MIN_VALUE;
         this.map_.gs_.gsc_.editAccountList(0,false,player.objectId_);
      }
      
      public function setStars(starList:AccountList) : void
      {
         var accountId:int = 0;
         for(var i:int = 0; i < starList.accountIds_.length; i++)
         {
            accountId = starList.accountIds_[i];
            this.starred_[accountId] = 1;
            this.lastUpdate_ = int.MIN_VALUE;
         }
      }
      
      public function ignorePlayer(player:Player) : void
      {
         this.ignored_[player.accountId_] = 1;
         this.lastUpdate_ = int.MIN_VALUE;
         this.map_.gs_.gsc_.editAccountList(1,true,player.objectId_);
      }
      
      public function unignorePlayer(player:Player) : void
      {
         delete this.ignored_[player.accountId_];
         player.ignored_ = false;
         this.lastUpdate_ = int.MIN_VALUE;
         this.map_.gs_.gsc_.editAccountList(1,false,player.objectId_);
      }
      
      public function setIgnores(ignoreList:AccountList) : void
      {
         var accountId:int = 0;
         this.ignored_ = new Dictionary(true);
         for(var i:int = 0; i < ignoreList.accountIds_.length; i++)
         {
            accountId = ignoreList.accountIds_[i];
            this.ignored_[accountId] = 1;
            this.lastUpdate_ = int.MIN_VALUE;
         }
      }
   }
}
