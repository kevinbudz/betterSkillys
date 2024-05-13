package com.company.assembleegameclient.ui
{
   import com.company.ui.SimpleText;
   import com.company.util.GraphicsUtil;

import flash.display.CapsStyle;
import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TextButton extends Sprite
   {
       
      
      public var text_:SimpleText;
      
      public var w_:int;

      private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(0x484848,1);

      private var lineStyle_:GraphicsStroke = new GraphicsStroke(2,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,outlineFill_);
      
      private var enabledFill_:GraphicsSolidFill = new GraphicsSolidFill(0x323232,1);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());

      private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[lineStyle_,enabledFill_,path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
      
      public function TextButton(size:int, text:String, bWidth:int = 0)
      {
         super();
         this.text_ = new SimpleText(size,0xbbbbbb,false,0,0);
         this.text_.setBold(true);
         this.text_.text = text;
         this.text_.updateMetrics();
         addChild(this.text_);
         this.w_ = bWidth != 0?int(bWidth):int(this.text_.width + 12);
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(0,0,this.w_,this.text_.textHeight + 8,4,[1,1,1,1],this.path_);
         this.draw();
         this.text_.x = this.w_ / 2 - this.text_.textWidth / 2 - 2;
         this.text_.y = 1;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      public function setText(text:String) : void
      {
         this.text_.text = text;
         this.text_.updateMetrics();
         this.text_.x = this.w_ / 2 - this.text_.textWidth / 2 - 2;
         this.text_.y = 1;
      }
      
      /*public function setEnabled(enabled:Boolean) : void
      {
         if(enabled == mouseEnabled)
         {
            return;
         }
         mouseEnabled = enabled;
         this.graphicsData_[0] = !!enabled?this.enabledFill_:this.disabledFill_;
         this.draw();
      }*/
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.enabledFill_.color = 0x484848;
         this.draw();
      }
      
      private function onRollOut(event:MouseEvent) : void
      {
         this.enabledFill_.color = 0x323232;
         this.draw();
      }
      
      private function draw() : void
      {
         graphics.clear();
         graphics.drawGraphicsData(this.graphicsData_);
      }
   }
}
