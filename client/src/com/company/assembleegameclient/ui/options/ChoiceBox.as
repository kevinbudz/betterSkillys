package com.company.assembleegameclient.ui.options
{
   import com.company.ui.SimpleText;
   import com.company.util.GraphicsUtil;
   import flash.display.CapsStyle;
   import flash.display.Graphics;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.IGraphicsFill;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class ChoiceBox extends Sprite
   {
      
      public static const WIDTH:int = 80;
      
      public static const HEIGHT:int = 32;
       
      
      public var labels_:Vector.<String>;
      
      public var values_:Array;
      
      public var selectedIndex_:int = -1;
      
      private var labelText_:SimpleText = null;
      
      private var over_:Boolean = false;
      
      private var internalFill_:GraphicsSolidFill = new GraphicsSolidFill(3355443,1);
      
      private var overLineFill_:GraphicsSolidFill = new GraphicsSolidFill(11776947,1);
      
      private var normalLineFill_:GraphicsSolidFill = new GraphicsSolidFill(4473924,1);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private var lineStyle_:GraphicsStroke = new GraphicsStroke(2,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,normalLineFill_);
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[internalFill_,lineStyle_,path_,GraphicsUtil.END_STROKE,GraphicsUtil.END_FILL];
      
      public function ChoiceBox(labels:Vector.<String>, values:Array, value:Object)
      {
         super();
         this.labels_ = labels;
         this.values_ = values;
         this.labelText_ = new SimpleText(16,16777215,false,0,0);
         this.labelText_.setBold(true);
         this.labelText_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         addChild(this.labelText_);
         this.setValue(value);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function setValue(value:*) : void
      {
         for(var i:int = 0; i < this.values_.length; i++)
         {
            if(value == this.values_[i])
            {
               if(i == this.selectedIndex_)
               {
                  return;
               }
               this.selectedIndex_ = i;
               break;
            }
         }
         if(this.selectedIndex_ != -1){
            this.setSelected(this.selectedIndex_);
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function value() : *
      {
         return this.values_[this.selectedIndex_];
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.over_ = true;
         this.drawBackground();
      }
      
      private function onRollOut(event:MouseEvent) : void
      {
         this.over_ = false;
         this.drawBackground();
      }
      
      private function onClick(event:MouseEvent) : void
      {
         this.setSelected((this.selectedIndex_ + 1) % this.values_.length);
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function drawBackground() : void
      {
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,[1,1,1,1],this.path_);
         this.lineStyle_.fill = !!this.over_?this.overLineFill_:this.normalLineFill_;
         graphics.drawGraphicsData(this.graphicsData_);
         var g:Graphics = graphics;
         g.clear();
         g.drawGraphicsData(this.graphicsData_);
      }
      
      private function setSelected(index:int) : void
      {
         this.selectedIndex_ = index;
         this.setText(this.labels_[this.selectedIndex_]);
      }
      
      private function setText(text:String) : void
      {
         this.labelText_.text = text;
         this.labelText_.updateMetrics();
         this.labelText_.x = WIDTH / 2 - this.labelText_.width / 2;
         this.labelText_.y = HEIGHT / 2 - this.labelText_.height / 2 - 2;
         this.drawBackground();
      }
   }
}
