package com.company.assembleegameclient.screens
{
   import com.company.rotmg.graphics.ScreenGraphic;
   import com.company.ui.SimpleText;
import com.gskinner.motion.GTween;

import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.ui.view.components.ScreenBase;
   
   public class LoadingScreen extends Sprite
   {
       
      
      private var text:SimpleText;
      
      public function LoadingScreen()
      {
         super();
         addChild(new ScreenBase());
         this.text = new SimpleText(30,16777215,false,0,0);
         this.text.x = 400;
         this.text.y = 300;
         this.text.setBold(true);
         this.text.htmlText = "<p align=\"center\">Loading...</p>";
         this.text.autoSize = TextFieldAutoSize.CENTER;
         this.text.updateMetrics();
         this.text.filters = [new DropShadowFilter(0,0,0,1,4,4)];
         addChild(this.text);
         new GTween(this.text, 2, {"scaleX": 1.75, "scaleY": 1.75, "alpha": 0.5});
      }
      
      public function setText(value:String) : void
      {
         this.text.htmlText = value;
         this.text.x = (stage.stageWidth - this.text.width) * 0.5;
      }
   }
}
