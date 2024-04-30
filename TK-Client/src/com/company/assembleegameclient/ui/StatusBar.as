package com.company.assembleegameclient.ui
{
import com.company.ui.SimpleText;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

public class StatusBar extends Sprite
{


   public var w_:int;

   public var h_:int;

   public var color_:uint;

   public var backColor_:uint;

   public var pulseBackColor:uint;

   public var textColor_:uint;

   public var val_:int = -1;

   public var max_:int = -1;

   public var boost_:int = -1;

   public var maxMax_:int = -1;

   public var labelText_:SimpleText;

   public var valueText_:SimpleText;

   public var boostText_:SimpleText;

   private var colorSprite:Sprite;

   private var defaultForegroundColor:Number;

   private var defaultBackgroundColor:Number;

   public var mouseOver_:Boolean = false;

   private var isPulsing:Boolean = false;

   private var repetitions:int;

   private var direction:int = -1;

   private var speed:Number = 0.1;

   public function StatusBar(w:int, h:int, color:uint, backColor:uint, label:String = null)
   {
      this.colorSprite = new Sprite();
      super();
      addChild(this.colorSprite);
      this.w_ = w;
      this.h_ = h;
      this.defaultForegroundColor = this.color_ = color;
      this.defaultBackgroundColor = this.backColor_ = backColor;
      this.textColor_ = 16777215;
      if(label != null && label.length != 0)
      {
         this.labelText_ = new SimpleText(14,this.textColor_,false,0,0);
         this.labelText_.setBold(true);
         this.labelText_.text = label;
         this.labelText_.updateMetrics();
         this.labelText_.y = -3;
         this.labelText_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.labelText_);
      }
      this.valueText_ = new SimpleText(14,16777215,false,0,0);
      this.valueText_.setBold(true);
      this.valueText_.filters = [new DropShadowFilter(0,0,0)];
      this.valueText_.y = -3;
      this.boostText_ = new SimpleText(14,this.textColor_,false,0,0);
      this.boostText_.setBold(true);
      this.boostText_.alpha = 0.6;
      this.boostText_.y = -3;
      this.boostText_.filters = [new DropShadowFilter(0,0,0)];
      addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
      addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
   }

   private function onMultiplierOver(event:MouseEvent) : void
   {
      dispatchEvent(new Event("MULTIPLIER_OVER"));
   }

   private function onMultiplierOut(event:MouseEvent) : void
   {
      dispatchEvent(new Event("MULTIPLIER_OUT"));
   }

   public function draw(val:int, max:int, boost:int, maxMax:int = -1) : void
   {
      if(max > 0)
      {
         val = Math.min(max,Math.max(0,val));
      }
      if(val == this.val_ && max == this.max_ && boost == this.boost_ && maxMax == this.maxMax_)
      {
         return;
      }
      this.val_ = val;
      this.max_ = max;
      this.boost_ = boost;
      this.maxMax_ = maxMax;
      this.internalDraw();
   }

   private function setTextColor(textColor:uint) : void
   {
      this.textColor_ = textColor;
      if(this.boostText_ != null)
      {
         this.boostText_.setColor(this.textColor_);
      }
      this.valueText_.setColor(this.textColor_);
   }

   private function internalDraw() : void
   {
      graphics.clear();
      this.colorSprite.graphics.clear();
      var textColor:uint = 16777215;
      if(this.maxMax_ > 0 && this.max_ - this.boost_ == this.maxMax_)
      {
         textColor = 16572160;
      }
      else if(this.boost_ > 0)
      {
         textColor = 6206769;
      }
      if(this.textColor_ != textColor)
      {
         this.setTextColor(textColor);
      }
      graphics.beginFill(this.backColor_);
      graphics.drawRect(0,0,this.w_,this.h_);
      graphics.endFill();
      if(this.isPulsing)
      {
         this.colorSprite.graphics.beginFill(this.pulseBackColor);
         this.colorSprite.graphics.drawRect(0,0,this.w_,this.h_);
      }
      this.colorSprite.graphics.beginFill(this.color_);
      if(this.max_ > 0)
      {
         this.colorSprite.graphics.drawRect(0,0,this.w_ * (this.val_ / this.max_),this.h_);
      }
      else
      {
         this.colorSprite.graphics.drawRect(0,0,this.w_,this.h_);
      }
      this.colorSprite.graphics.endFill();
      if(this.mouseOver_ && this.h_ > 4)
      {
         if(this.max_ > 0)
         {
            this.valueText_.text = "" + this.val_ + "/" + this.max_;
         }
         else
         {
            this.valueText_.text = "" + this.val_;
         }
         this.valueText_.updateMetrics();
         if(!contains(this.valueText_))
         {
            addChild(this.valueText_);
         }
         if(this.boost_ != 0)
         {
            this.boostText_.text = " (" + (this.boost_ > 0?"+":"") + this.boost_.toString() + ")";
            this.boostText_.updateMetrics();
            this.valueText_.x = this.w_ / 2 - (this.valueText_.width + this.boostText_.width) / 2;
            this.boostText_.x = this.valueText_.x + this.valueText_.width;
            if(!contains(this.boostText_))
            {
               addChild(this.boostText_);
            }
         }
         else
         {
            this.valueText_.x = this.w_ / 2 - this.valueText_.width / 2;
            if(contains(this.boostText_))
            {
               removeChild(this.boostText_);
            }
         }
      }
      else
      {
         if(contains(this.valueText_))
         {
            removeChild(this.valueText_);
         }
         if(contains(this.boostText_))
         {
            removeChild(this.boostText_);
         }
      }
   }

   public function startPulse(repetitions:Number, foregroundColor:Number, backgroundColor:Number) : void
   {
      this.isPulsing = true;
      this.color_ = foregroundColor;
      this.pulseBackColor = backgroundColor;
      this.repetitions = repetitions;
      this.internalDraw();
      addEventListener(Event.ENTER_FRAME,this.onPulse);
   }

   private function onPulse(event:Event) : void
   {
      if(this.colorSprite.alpha > 1 || this.colorSprite.alpha < 0)
      {
         this.direction = this.direction * -1;
         if(this.colorSprite.alpha > 1)
         {
            this.repetitions--;
            if(!this.repetitions)
            {
               this.isPulsing = false;
               this.color_ = this.defaultForegroundColor;
               this.backColor_ = this.defaultBackgroundColor;
               this.colorSprite.alpha = 1;
               this.internalDraw();
               removeEventListener(Event.ENTER_FRAME,this.onPulse);
            }
         }
      }
      this.colorSprite.alpha = this.colorSprite.alpha + this.speed * this.direction;
   }

   private function onMouseOver(event:MouseEvent) : void
   {
      this.mouseOver_ = true;
      this.internalDraw();
   }

   private function onMouseOut(event:MouseEvent) : void
   {
      this.mouseOver_ = false;
      this.internalDraw();
   }
}
}
