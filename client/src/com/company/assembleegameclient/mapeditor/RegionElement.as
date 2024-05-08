package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.map.RegionLibrary;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.display.Shape;
   
   public class RegionElement extends Element
   {
       
      
      public var regionXML_:XML;
      
      public function RegionElement(regionXML:XML)
      {
         super(int(regionXML.@type));
         this.regionXML_ = regionXML;
         var shape:Shape = new Shape();
         shape.graphics.beginFill(RegionLibrary.getColor(type_),0.5);
         shape.graphics.drawRect(0,0,WIDTH - 8,HEIGHT - 8);
         shape.graphics.endFill();
         shape.x = WIDTH / 2 - shape.width / 2;
         shape.y = HEIGHT / 2 - shape.height / 2;
         addChild(shape);
      }
      
      override protected function getToolTip() : ToolTip
      {
         return new RegionTypeToolTip(this.regionXML_);
      }
   }
}
