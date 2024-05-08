package com.company.assembleegameclient.game.events
{
   import flash.events.Event;
   
   public class GuildResultEvent extends Event
   {
      
      public static const EVENT:String = "GUILDRESULTEVENT";
       
      
      public var success_:Boolean;
      
      public var errorText_:String;
      
      public function GuildResultEvent(success:Boolean, errorText:String)
      {
         super(EVENT);
         this.success_ = success;
         this.errorText_ = errorText;
      }
      
      override public function toString() : String
      {
         return formatToString("GUILDRESULTEVENT","success_","errorText_");
      }
   }
}
