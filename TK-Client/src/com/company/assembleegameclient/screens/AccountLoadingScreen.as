package com.company.assembleegameclient.screens
{
   import com.company.rotmg.graphics.ScreenGraphic;
   import com.company.ui.SimpleText;
import com.gskinner.motion.GTween;

import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   
   public class AccountLoadingScreen extends Sprite
   {
       
      
      private var loadingText_:SimpleText;
      
      public function AccountLoadingScreen()
      {
         super();
         this.loadingText_ = new SimpleText(36,16777215,false,0,0);
         this.loadingText_.setBold(true);
         this.loadingText_.htmlText = "<p align=\"center\">Loading...</p>";
         this.loadingText_.x = 325;
         this.loadingText_.y = 300 - (this.loadingText_.height / 2) + 10;
         this.loadingText_.updateMetrics();
         this.loadingText_.filters = [new DropShadowFilter(0,0,0,1,4,4)];
         addChild(this.loadingText_);
         trace(this.loadingText_.width + ", " + this.loadingText_.height);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      protected function onAddedToStage(event:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
   }
}
