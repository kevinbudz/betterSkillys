package com.company.assembleegameclient.ui.guild
{
   import flash.events.Event;
   
   public class GuildPlayerListEvent extends Event
   {
      
      public static const SET_RANK:String = "SET_RANK";
      
      public static const REMOVE_MEMBER:String = "REMOVE_MEMBER";
       
      
      public var name_:String;
      
      public var rank_:int;
      
      public function GuildPlayerListEvent(type:String, name:String, rank:int = -1)
      {
         super(type,true);
         this.name_ = name;
         this.rank_ = rank;
      }
   }
}
