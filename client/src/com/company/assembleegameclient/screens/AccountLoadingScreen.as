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
         this.loadingText_.htmlText = "Loading...";
         this.loadingText_.x = 325;
         this.loadingText_.y = 300 - (this.loadingText_.height / 2) + 10;
         this.loadingText_.updateMetrics();
         this.loadingText_.filters = [new DropShadowFilter(0,0,0,1,4,4)];
         addChild(this.loadingText_);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         new GTween(this.loadingText_, 2, {"x": 325 - 40.75, "y": 260 - 11.25, "scaleX": 1.5, "scaleY": 1.5, "alpha": 0.5});
      }
      
      protected function onAddedToStage(event:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
   }
}
