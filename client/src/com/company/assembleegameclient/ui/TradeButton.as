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
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   
   public class TradeButton extends Sprite
   {
      
      private static const WAIT_TIME:int = 2999;
      
      private static const COUNTDOWN_STATE:int = 0;
      
      private static const NORMAL_STATE:int = 1;
      
      private static const WAITING_STATE:int = 2;
      
      private static const DISABLED_STATE:int = 3;
       
      
      public var statusBar_:Sprite;
      
      public var barMask_:Shape;
      
      public var text_:SimpleText;
      
      public var w_:int;
      
      public var h_:int;
      
      private var state_:int;
      
      private var lastResetTime_:int;
      
      private var enabledFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var disabledFill_:GraphicsSolidFill = new GraphicsSolidFill(8355711,1);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[enabledFill_,path_,GraphicsUtil.END_FILL];
      
      private var barFill_:GraphicsSolidFill = new GraphicsSolidFill(12566463,1);
      
      private const barGraphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[barFill_,path_,GraphicsUtil.END_FILL];
      
      private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var lineStyle_:GraphicsStroke = new GraphicsStroke(2,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,outlineFill_);
      
      private const outlineGraphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[lineStyle_,path_,GraphicsUtil.END_STROKE];
      
      public function TradeButton(size:int, bWidth:int = 0)
      {
         super();
         this.lastResetTime_ = getTimer();
         this.text_ = new SimpleText(size,3552822,false,0,0);
         this.text_.setBold(true);
         this.text_.text = "Trade";
         this.text_.updateMetrics();
         this.w_ = bWidth != 0?int(bWidth):int(this.text_.width + 12);
         this.h_ = this.text_.textHeight + 8;
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(0,0,this.w_,this.text_.textHeight + 8,4,[1,1,1,1],this.path_);
         this.text_.x = this.w_ / 2 - this.text_.textWidth / 2 - 2;
         this.text_.y = 1;
         this.statusBar_ = this.newStatusBar();
         addChild(this.statusBar_);
         addChild(this.text_);
         this.draw();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function reset() : void
      {
         this.lastResetTime_ = getTimer();
         this.state_ = COUNTDOWN_STATE;
         this.setEnabled(false);
         this.setText("Trade");
      }
      
      public function disable() : void
      {
         this.state_ = DISABLED_STATE;
         this.setEnabled(false);
         this.setText("Trade");
      }
      
      private function setText(text:String) : void
      {
         this.text_.text = text;
         this.text_.updateMetrics();
         this.text_.x = this.w_ / 2 - this.text_.textWidth / 2 - 2;
         this.text_.y = 1;
      }
      
      private function setEnabled(enabled:Boolean) : void
      {
         if(enabled == mouseEnabled)
         {
            return;
         }
         mouseEnabled = enabled;
         mouseChildren = enabled;
         this.graphicsData_[0] = !!enabled?this.enabledFill_:this.disabledFill_;
         this.draw();
      }
      
      private function onAddedToStage(event:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.reset();
         this.draw();
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(event:Event) : void
      {
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
      
      private function onClick(event:MouseEvent) : void
      {
         this.state_ = WAITING_STATE;
         this.setEnabled(false);
         this.setText("Waiting");
      }
      
      private function newStatusBar() : Sprite
      {
         var statusBar:Sprite = new Sprite();
         var bar:Sprite = new Sprite();
         var barShape:Shape = new Shape();
         barShape.graphics.clear();
         barShape.graphics.drawGraphicsData(this.barGraphicsData_);
         bar.addChild(barShape);
         this.barMask_ = new Shape();
         bar.addChild(this.barMask_);
         bar.mask = this.barMask_;
         statusBar.addChild(bar);
         var outline:Shape = new Shape();
         outline.graphics.clear();
         outline.graphics.drawGraphicsData(this.outlineGraphicsData_);
         statusBar.addChild(outline);
         return statusBar;
      }
      
      private function drawCountDown(t:Number) : void
      {
         this.barMask_.graphics.clear();
         this.barMask_.graphics.beginFill(12566463);
         this.barMask_.graphics.drawRect(0,0,this.w_ * t,this.h_);
         this.barMask_.graphics.endFill();
      }
      
      private function draw() : void
      {
         var time:int = 0;
         var t:Number = NaN;
         time = getTimer();
         if(this.state_ == COUNTDOWN_STATE)
         {
            if(time - this.lastResetTime_ >= WAIT_TIME)
            {
               this.state_ = NORMAL_STATE;
               this.setEnabled(true);
            }
         }
         switch(this.state_)
         {
            case COUNTDOWN_STATE:
               this.statusBar_.visible = true;
               t = (time - this.lastResetTime_) / WAIT_TIME;
               this.drawCountDown(t);
               break;
            case DISABLED_STATE:
            case NORMAL_STATE:
            case WAITING_STATE:
               this.statusBar_.visible = false;
         }
         graphics.clear();
         graphics.drawGraphicsData(this.graphicsData_);
      }
   }
}
