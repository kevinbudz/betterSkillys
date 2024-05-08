package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.map.AnimateProperties;
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.GroundLibrary;
   import com.company.assembleegameclient.map.SquareFace;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.display.BitmapData;
   import flash.display.IGraphicsData;
   import flash.display.Shape;
   import flash.geom.Rectangle;
   
   internal class GroundElement extends Element
   {
      
      private static const VIN:Vector.<Number> = new <Number>[0,0,0,1,0,0,1,1,0,0,1,0];
      
      private static const SCALE:Number = 0.6;
       
      
      public var groundXML_:XML;
      
      private var tileShape_:Shape;
      
      function GroundElement(groundXML:XML)
      {
         super(int(groundXML.@type));
         this.groundXML_ = groundXML;
         var graphicsData:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
         var camera:Camera = new Camera();
         camera.configure(0.5,0.5,12,Math.PI / 4,new Rectangle(-100,-100,200,200),false);
         var tileBD:BitmapData = GroundLibrary.getBitmapData(type_);
         var squareFace:SquareFace = new SquareFace(tileBD,VIN,0,0,AnimateProperties.NO_ANIMATE,0,0);
         squareFace.draw(graphicsData,camera,0);
         this.tileShape_ = new Shape();
         this.tileShape_.graphics.drawGraphicsData(graphicsData);
         this.tileShape_.scaleX = this.tileShape_.scaleY = SCALE;
         this.tileShape_.x = WIDTH / 2;
         this.tileShape_.y = HEIGHT / 2;
         addChild(this.tileShape_);
      }
      
      override protected function getToolTip() : ToolTip
      {
         return new GroundTypeToolTip(this.groundXML_);
      }
   }
}
