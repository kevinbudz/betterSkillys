package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import com.company.ui.SimpleText;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.utils.getTimer;
   
   public class ScoreTextLine extends Sprite
   {
      
      public static var textTooltip_:TextToolTip = new TextToolTip(3552822,10197915,null,"",150);
       
      
      public var name_:String;
      
      public var desc_:String;
      
      public var number_:int;
      
      public var numberPrefix_:String;
      
      public var unit_:String;
      
      private var startTime_:int = 0;
      
      private var nameText_:SimpleText;
      
      private var numberText_:SimpleText;
      
      private var unitIcon_:DisplayObject;
      
      public function ScoreTextLine(size:int, nameColor:uint, numColor:uint, name:String, desc:String, number:int, numberPrefix:String, unit:String, unitIcon:DisplayObject)
      {
         super();
         this.name_ = name;
         this.desc_ = desc;
         this.number_ = number;
         this.numberPrefix_ = numberPrefix;
         this.unit_ = unit;
         this.nameText_ = new SimpleText(size,nameColor,false,0,0);
         this.nameText_.setBold(true);
         this.nameText_.text = this.name_;
         this.nameText_.updateMetrics();
         this.nameText_.x = 410 - this.nameText_.textWidth;
         this.nameText_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         addChild(this.nameText_);
         if(this.number_ != -1)
         {
            this.numberText_ = new SimpleText(size,numColor,false,0,0);
            this.numberText_.setBold(true);
            this.numberText_.text = numberPrefix + "0" + " " + unit;
            this.numberText_.updateMetrics();
            this.numberText_.x = 450;
            this.numberText_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
            addChild(this.numberText_);
         }
         if(unitIcon != null)
         {
            this.unitIcon_ = unitIcon;
            if(this.numberText_ != null)
            {
               this.unitIcon_.x = this.numberText_.x + this.numberText_.width - 4;
               unitIcon.y = this.numberText_.height / 2 - this.unitIcon_.height / 2 + 2;
            }
            else
            {
               this.unitIcon_.x = 450;
               unitIcon.y = this.nameText_.height / 2 - this.unitIcon_.height / 2 + 2;
            }
            addChild(this.unitIcon_);
         }
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function skip() : void
      {
         this.startTime_ = -1000000;
      }
      
      private function onAddedToStage(event:Event) : void
      {
         if(this.startTime_ == 0)
         {
            this.startTime_ = getTimer();
         }
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         this.removeTextTooltip();
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      public function onEnterFrame(event:Event) : void
      {
         var n:int = 0;
         var t:Number = Math.min(1,(getTimer() - this.startTime_) / 500);
         if(this.numberText_ != null)
         {
            n = this.number_ * t;
            this.numberText_.text = this.numberPrefix_ + n.toString() + " " + this.unit_;
            this.numberText_.updateMetrics();
            if(this.unitIcon_ != null)
            {
               this.unitIcon_.x = this.numberText_.x + this.numberText_.width - 4;
               this.unitIcon_.y = this.numberText_.height / 2 - this.unitIcon_.height / 2 + 2;
            }
         }
         if(t == 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      public function onMouseOver(event:Event) : void
      {
         this.removeTextTooltip();
         if(this.desc_ == null)
         {
            return;
         }
         textTooltip_.setText(this.desc_);
         stage.addChild(textTooltip_);
      }
      
      public function onRollOut(event:Event) : void
      {
         this.removeTextTooltip();
      }
      
      private function removeTextTooltip() : void
      {
         if(textTooltip_.parent != null)
         {
            textTooltip_.parent.removeChild(textTooltip_);
         }
      }
   }
}
