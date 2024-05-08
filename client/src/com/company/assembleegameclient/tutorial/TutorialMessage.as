package com.company.assembleegameclient.tutorial
{
   import com.company.assembleegameclient.ui.TextButton;
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
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class TutorialMessage extends Sprite
   {
      
      public static const BORDER:int = 8;
       
      
      private var tutorial_:Tutorial;
      
      private var rect_:Rectangle;
      
      private var messageText_:SimpleText;
      
      private var nextButton_:TextButton = null;
      
      private var startTime_:int;
      
      private var fill_:GraphicsSolidFill= new GraphicsSolidFill(3552822,1);
      
      private var lineStyle_:GraphicsStroke = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,new GraphicsSolidFill(16777215));
      
      private var path_:GraphicsPath= new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[lineStyle_,fill_,path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
      
      public function TutorialMessage(tutorial:Tutorial, message:String, nextButton:Boolean, rect:Rectangle)
      {
         super();
         this.tutorial_ = tutorial;
         this.rect_ = rect.clone();
         x = this.rect_.x;
         y = this.rect_.y;
         this.rect_.x = 0;
         this.rect_.y = 0;
         this.messageText_ = new SimpleText(15,16777215,false,this.rect_.width - 4 * BORDER,0);
         this.messageText_.text = "\t" + message;
         this.messageText_.wordWrap = true;
         this.messageText_.multiline = true;
         this.messageText_.x = 2 * BORDER;
         this.messageText_.y = 2 * BORDER;
         if(nextButton)
         {
            this.nextButton_ = new TextButton(18,"Next");
            this.nextButton_.addEventListener(MouseEvent.CLICK,this.onNextButton);
            this.nextButton_.x = this.rect_.width - this.nextButton_.width - 20;
            this.nextButton_.y = this.rect_.height - this.nextButton_.height - 10;
         }
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function drawRect() : void
      {
         var t:Number = Math.min(1,0.1 + 0.9 * (getTimer() - this.startTime_) / 200);
         if(t == 1)
         {
            addChild(this.messageText_);
            if(this.nextButton_ != null)
            {
               addChild(this.nextButton_);
            }
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         var rect:Rectangle = this.rect_.clone();
         rect.inflate(-(1 - t) * this.rect_.width / 2,-(1 - t) * this.rect_.height / 2);
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(rect.x,rect.y,rect.width,rect.height,4,[1,1,1,1],this.path_);
         graphics.clear();
         graphics.drawGraphicsData(this.graphicsData_);
      }
      
      private function onAddedToStage(event:Event) : void
      {
         this.startTime_ = getTimer();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(event:Event) : void
      {
         this.drawRect();
      }
      
      private function onNextButton(event:MouseEvent) : void
      {
         this.tutorial_.doneAction(Tutorial.NEXT_ACTION);
      }
   }
}
