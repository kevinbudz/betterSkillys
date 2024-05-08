package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import com.company.ui.SimpleText;
   import flash.filters.DropShadowFilter;
   
   public class RegionTypeToolTip extends ToolTip
   {
      
      private static const MAX_WIDTH:int = 180;
       
      
      private var titleText_:SimpleText;
      
      public function RegionTypeToolTip(regionXML:XML)
      {
         super(3552822,1,10197915,1,true);
         this.titleText_ = new SimpleText(16,16777215,false,MAX_WIDTH - 4,0);
         this.titleText_.setBold(true);
         this.titleText_.wordWrap = true;
         this.titleText_.text = String(regionXML.@id);
         this.titleText_.useTextDimensions();
         this.titleText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         this.titleText_.x = 0;
         this.titleText_.y = 0;
         addChild(this.titleText_);
      }
   }
}
