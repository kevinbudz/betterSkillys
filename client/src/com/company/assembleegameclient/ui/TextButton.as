package com.company.assembleegameclient.ui
{
   import com.company.ui.SimpleText;
   import com.company.util.GraphicsUtil;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TextButton extends Sprite
   {
       
      
      public var text_:SimpleText;
      
      public var w_:int;
      
      private var enabledFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var disabledFill_:GraphicsSolidFill = new GraphicsSolidFill(8355711,1);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[enabledFill_,path_,GraphicsUtil.END_FILL];
      
      public function TextButton(size:int, text:String, bWidth:int = 0)
      {
         super();
         this.text_ = new SimpleText(size,3552822,false,0,0);
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
      
      public function setEnabled(enabled:Boolean) : void
      {
         if(enabled == mouseEnabled)
         {
            return;
         }
         mouseEnabled = enabled;
         this.graphicsData_[0] = !!enabled?this.enabledFill_:this.disabledFill_;
         this.draw();
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.enabledFill_.color = 16768133;
         this.draw();
      }
      
      private function onRollOut(event:MouseEvent) : void
      {
         this.enabledFill_.color = 16777215;
         this.draw();
      }
      
      private function draw() : void
      {
         graphics.clear();
         graphics.drawGraphicsData(this.graphicsData_);
      }
   }
}
