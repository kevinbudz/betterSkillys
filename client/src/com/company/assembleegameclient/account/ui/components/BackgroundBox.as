package com.company.assembleegameclient.account.ui.components
{
   import flash.display.Shape;
   
   public class BackgroundBox extends Shape
   {
       
      
      private var _width:int;
      
      private var _height:int;
      
      private var _color:int;
      
      public function BackgroundBox()
      {
         super();
      }
      
      public function setSize(width:int, height:int) : void
      {
         this._width = width;
         this._height = height;
         this.drawFill();
      }
      
      public function setColor(color:int) : void
      {
         this._color = color;
         this.drawFill();
      }
      
      private function drawFill() : void
      {
         graphics.clear();
         graphics.beginFill(this._color);
         graphics.drawRect(0,0,this._width,this._height);
         graphics.endFill();
      }
   }
}
