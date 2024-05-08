package com.company.assembleegameclient.ui
{
   import com.company.util.GraphicsUtil;
   import flash.display.Graphics;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class Scrollbar extends Sprite
   {
      private var width_:int;
      private var height_:int;
      private var speed_:Number;
      private var indicatorRect_:Rectangle;
      private var jumpDist_:Number;
      private var background_:Sprite;
      private var upArrow_:Sprite;
      private var downArrow_:Sprite;
      private var posIndicator_:Sprite;
      private var lastUpdateTime_:int;
      private var change_:Number;
      private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      private var path_:GraphicsPath= new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[backgroundFill_,path_,GraphicsUtil.END_FILL];
      
      public function Scrollbar(widthParam:int, heightParam:int, speed:Number = 1.0)
      {
         super();
         this.background_ = new Sprite();
         this.background_.addEventListener(MouseEvent.MOUSE_DOWN,this.onBackgroundDown);
         addChild(this.background_);
         this.upArrow_ = this.getSprite(this.onUpArrowDown);
         addChild(this.upArrow_);
         this.downArrow_ = this.getSprite(this.onDownArrowDown);
         addChild(this.downArrow_);
         this.posIndicator_ = this.getSprite(this.onStartIndicatorDrag);
         addChild(this.posIndicator_);
         this.resize(widthParam,heightParam,speed);
         addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
      }
      
      public static function drawArrow(w:int, h:int, g:Graphics) : void
      {
         g.clear();
         g.beginFill(3487029,0.01);
         g.drawRect(-w / 2,-h / 2,w,h);
         g.endFill();
         g.beginFill(16777215,1);
         g.moveTo(-w / 2,-h / 2);
         g.lineTo(w / 2,0);
         g.lineTo(-w / 2,h / 2);
         g.lineTo(-w / 2,-h / 2);
         g.endFill();
      }

      protected function onAddedToStage(event:Event) : void
      {
         parent.addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
      }

      protected function onRemovedFromStage(event:Event): void
      {
         parent.removeEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
         removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
         removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
      }

      protected function onMouseWheel(event:MouseEvent):void {
         if (event.delta > 0) {
            this.jumpUp(0.2);
         }
         else {
            if (event.delta < 0) {
               this.jumpDown(0.2);
            }
         }
      }

      public function pos() : Number
      {
         return (this.posIndicator_.y - this.indicatorRect_.y) / (this.indicatorRect_.height - this.posIndicator_.height);
      }
      
      public function setIndicatorSize(windowHeight:Number, totalHeight:Number, doSetPos:Boolean = true) : void
      {
         var h:int = totalHeight == 0?int(this.indicatorRect_.height):int(windowHeight / totalHeight * this.indicatorRect_.height);
         h = Math.min(this.indicatorRect_.height,Math.max(this.width_,h));
         this.drawIndicator(this.width_,h,this.posIndicator_.graphics);
         this.jumpDist_ = windowHeight / (totalHeight - windowHeight);
         if(doSetPos)
         {
            this.setPos(0);
         }
      }
      
      public function setPos(v:Number) : void
      {
         v = Math.max(0,Math.min(1,v));
         this.posIndicator_.y = v * (this.indicatorRect_.height - this.posIndicator_.height) + this.indicatorRect_.y;
         this.sendPos();
      }
      
      public function jumpUp(mult:Number) : void
      {
         this.setPos(this.pos() - (this.jumpDist_ * mult));
      }
      
      public function jumpDown(mult:Number) : void
      {
         this.setPos(this.pos() + (this.jumpDist_ * mult));
      }
      
      private function getSprite(downFunction:Function) : Sprite
      {
         var sprite:Sprite = new Sprite();
         sprite.addEventListener(MouseEvent.MOUSE_DOWN,downFunction);
         sprite.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         sprite.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         return sprite;
      }
      
      private function onRollOver(event:MouseEvent) : void
      {
         var sprite:Sprite = event.target as Sprite;
         sprite.transform.colorTransform = new ColorTransform(1,0.8627,0.5216);
      }
      
      private function onRollOut(event:MouseEvent) : void
      {
         var sprite:Sprite = event.target as Sprite;
         sprite.transform.colorTransform = new ColorTransform(1,1,1);
      }
      
      private function onBackgroundDown(event:MouseEvent) : void
      {
         if(event.localY < this.posIndicator_.y)
         {
            this.jumpUp(1);
         }
         else
         {
            this.jumpDown(1);
         }
      }
      
      private function onUpArrowDown(event:MouseEvent) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onArrowFrame);
         addEventListener(MouseEvent.MOUSE_UP,this.onArrowUp);
         this.lastUpdateTime_ = getTimer();
         this.change_ = -this.speed_;
      }
      
      private function onDownArrowDown(event:MouseEvent) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onArrowFrame);
         addEventListener(MouseEvent.MOUSE_UP,this.onArrowUp);
         this.lastUpdateTime_ = getTimer();
         this.change_ = this.speed_;
      }
      
      private function onArrowFrame(event:Event) : void
      {
         var time:int = getTimer();
         var dt:Number = (time - this.lastUpdateTime_) / 1000;
         var dist:int = (this.height_ - this.width_ * 3) * dt * this.change_;
         this.setPos((this.posIndicator_.y + dist - this.indicatorRect_.y) / (this.indicatorRect_.height - this.posIndicator_.height));
         this.lastUpdateTime_ = time;
      }
      
      private function onArrowUp(event:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onArrowFrame);
         removeEventListener(MouseEvent.MOUSE_UP,this.onArrowUp);
      }
      
      private function onStartIndicatorDrag(event:MouseEvent) : void
      {
         this.posIndicator_.startDrag(false,new Rectangle(0,this.indicatorRect_.y,0,this.indicatorRect_.height - this.posIndicator_.height));
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onStopIndicatorDrag);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove);
         this.sendPos();
      }
      
      private function onStopIndicatorDrag(event:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStopIndicatorDrag);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove);
         this.posIndicator_.stopDrag();
         this.sendPos();
      }
      
      private function onDragMove(event:MouseEvent) : void
      {
         this.sendPos();
      }
      
      private function sendPos() : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function resize(widthParam:int, heightParam:int, speed:Number = 1.0) : void
      {
         this.width_ = widthParam;
         this.height_ = heightParam;
         this.speed_ = speed;
         var arrowHeight:int = this.width_ * 0.75;
         this.indicatorRect_ = new Rectangle(0,arrowHeight + 5,this.width_,this.height_ - arrowHeight * 2 - 10);
         var g:Graphics = this.background_.graphics;
         g.clear();
         g.beginFill(5526612,1);
         g.drawRect(this.indicatorRect_.x,this.indicatorRect_.y,this.indicatorRect_.width,this.indicatorRect_.height);
         g.endFill();
         drawArrow(arrowHeight,this.width_,this.upArrow_.graphics);
         this.upArrow_.rotation = -90;
         this.upArrow_.x = this.width_ / 2;
         this.upArrow_.y = arrowHeight / 2;
         drawArrow(arrowHeight,this.width_,this.downArrow_.graphics);
         this.downArrow_.x = this.width_ / 2;
         this.downArrow_.y = this.height_ - arrowHeight / 2;
         this.downArrow_.rotation = 90;
         this.drawIndicator(this.width_,this.height_,this.posIndicator_.graphics);
         this.posIndicator_.x = 0;
         this.posIndicator_.y = this.indicatorRect_.y;
      }
      
      private function drawIndicator(w:int, h:int, g:Graphics) : void
      {
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(0,0,w,h,4,[1,1,1,1],this.path_);
         g.clear();
         g.drawGraphicsData(this.graphicsData_);
      }
   }
}
