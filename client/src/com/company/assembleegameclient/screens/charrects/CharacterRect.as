package com.company.assembleegameclient.screens.charrects
{
import com.company.util.GraphicsUtil;

import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CharacterRect extends Sprite
   {
      public static const WIDTH:int = 600;
      public static const HEIGHT:int = 59;

      private var color_:uint;
      private var overColor_:uint;
      private var box_:Sprite;
      public var selectContainer:Sprite;
      
      public function CharacterRect(color:uint, overColor:uint)
      {
         super();
         this.color_ = color;
         this.overColor_ = overColor;
         this.drawBox(false);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      protected function onMouseOver(event:MouseEvent) : void
      {
         //this.drawBox(true);
      }
      
      protected function onRollOut(event:MouseEvent) : void
      {
         //this.drawBox(false);
      }
      
      private function drawBox(over:Boolean) : void
      {
         this.box_ = GraphicsUtil.drawBackground(WIDTH, HEIGHT, 12);
         addChild(box_);
      }
      
      public function makeContainer() : void
      {
         this.selectContainer = new Sprite();
         this.selectContainer.mouseChildren = false;
         this.selectContainer.buttonMode = true;
         this.selectContainer.graphics.beginFill(16711935,0);
         this.selectContainer.graphics.drawRect(0,0,WIDTH,HEIGHT);
         addChild(this.selectContainer);
      }
   }
}
