package com.company.assembleegameclient.game.events
{
   import com.company.assembleegameclient.objects.Player;
   import flash.display.BitmapData;
   import flash.events.Event;
   
   public class DeathEvent extends Event
   {
      
      public static const DEATH:String = "DEATH";
       
      
      public var background_:BitmapData;
      
      public var player_:Player;
      
      public var accountId_:int;
      
      public var charId_:int;
      
      public function DeathEvent(background:BitmapData, accountId:int, charId:int)
      {
         super(DEATH);
         this.background_ = background;
         this.accountId_ = accountId;
         this.charId_ = charId;
      }
   }
}
