package com.company.assembleegameclient.ui.menu
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.ui.SimpleText;
   import com.company.util.AssetLibrary;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class TeleportMenuOption extends MenuOption
   {
      
      private static const inactiveCT:ColorTransform = new ColorTransform(84 / 255,84 / 255,84 / 255);
       
      
      private var player_:Player;
      
      private var mouseOver_:Boolean = false;
      
      private var barText_:SimpleText;
      
      private var barTextOrigWidth_:int;
      
      public function TeleportMenuOption(player:Player)
      {
         super(AssetLibrary.getImageFromSet("lofiInterface2",3),16777215,"Teleport");
         this.player_ = player;
         this.barText_ = new SimpleText(18,16777215,false,0,0);
         this.barText_.setBold(true);
         this.barText_.text = "Teleport";
         this.barText_.updateMetrics();
         this.barText_.x = text_.x;
         this.barText_.y = text_.y;
         this.barTextOrigWidth_ = this.barText_.width;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage(event:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(event:Event) : void
      {
         var msUtilTeleport:int = this.player_.msUtilTeleport();
         if(msUtilTeleport > 0)
         {
            if(!contains(this.barText_))
            {
               addChild(this.barText_);
            }
            this.barText_.width = this.barTextOrigWidth_ * (1 - msUtilTeleport / Player.MS_BETWEEN_TELEPORT);
            setColorTransform(inactiveCT);
         }
         else
         {
            if(contains(this.barText_))
            {
               removeChild(this.barText_);
            }
            if(this.mouseOver_)
            {
               setColorTransform(mouseOverCT);
            }
            else
            {
               setColorTransform(null);
            }
         }
      }
      
      override protected function onMouseOver(event:MouseEvent) : void
      {
         this.mouseOver_ = true;
      }
      
      override protected function onMouseOut(event:MouseEvent) : void
      {
         this.mouseOver_ = false;
      }
   }
}
