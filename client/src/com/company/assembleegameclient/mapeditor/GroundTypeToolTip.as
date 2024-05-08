package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import com.company.ui.SimpleText;
   import flash.filters.DropShadowFilter;
   
   public class GroundTypeToolTip extends ToolTip
   {
      
      private static const MAX_WIDTH:int = 180;
       
      
      private var titleText_:SimpleText;
      
      private var descText_:SimpleText;
      
      public function GroundTypeToolTip(groundXML:XML)
      {
         super(3552822,1,10197915,1,true);
         this.titleText_ = new SimpleText(16,16777215,false,MAX_WIDTH - 4,0);
         this.titleText_.setBold(true);
         this.titleText_.wordWrap = true;
         this.titleText_.text = String(groundXML.@id);
         this.titleText_.useTextDimensions();
         this.titleText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         this.titleText_.x = 0;
         this.titleText_.y = 0;
         addChild(this.titleText_);
         var desc:String = "";
         if(groundXML.hasOwnProperty("Speed"))
         {
            desc = desc + ("Speed: " + Number(groundXML.Speed).toFixed(2) + "\n");
         }
         else
         {
            desc = desc + "Speed: 1.00\n";
         }
         if(groundXML.hasOwnProperty("NoWalk"))
         {
            desc = desc + "Unwalkable\n";
         }
         if(groundXML.hasOwnProperty("Push"))
         {
            desc = desc + "Push\n";
         }
         if(groundXML.hasOwnProperty("Sink"))
         {
            desc = desc + "Sink\n";
         }
         if(groundXML.hasOwnProperty("Sinking"))
         {
            desc = desc + "Sinking\n";
         }
         if(groundXML.hasOwnProperty("Animate"))
         {
            desc = desc + "Animated\n";
         }
         if(groundXML.hasOwnProperty("RandomOffset"))
         {
            desc = desc + "Randomized\n";
         }
         this.descText_ = new SimpleText(14,11776947,false,MAX_WIDTH,0);
         this.descText_.wordWrap = true;
         this.descText_.text = String(desc);
         this.descText_.useTextDimensions();
         this.descText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         this.descText_.x = 0;
         this.descText_.y = this.titleText_.height + 2;
         addChild(this.descText_);
      }
   }
}
