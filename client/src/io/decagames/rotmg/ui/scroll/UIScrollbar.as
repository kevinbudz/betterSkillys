package io.decagames.rotmg.ui.scroll
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import io.decagames.rotmg.ui.texture.TextureParser;
   
   public class UIScrollbar extends Sprite
   {
      
      public static const SCROLL_SLIDER_MINIMUM_HEIGHT:int = 39;
      
      public static const SCROLL_SLIDER_WIDTH:int = 17;
      
      public static const SCROLL_SLIDER_SCALE_FACTOR:Number = 0.5;
       
      
      private var _slider:Sprite;
      
      private var background:SliceScalingBitmap;
      
      private var sliderAsset:SliceScalingBitmap;
      
      private var _content:DisplayObject;
      
      private var _scrollObject:DisplayObject;
      
      private var contentHeight:int;
      
      private var percent:Number;
      
      private var initalPosition:int = 0;
      
      private var _mouseRollSpeedFactor:Number = 1.3;
      
      public function UIScrollbar(height:int, width:int = 0)
      {
         super();
         this.contentHeight = height;
         this.background = TextureParser.instance.getSliceScalingBitmap("UI","scrollbar_background",width == 0 ? SCROLL_SLIDER_WIDTH : width);
         this.background.height = height;
         addChild(this.background);
         this._slider = new Sprite();
         this.sliderAsset = TextureParser.instance.getSliceScalingBitmap("UI","scrollbar_slider");
         this.sliderAsset.height = 10;
         this._slider.addChild(this.sliderAsset);
         this._slider.x = 1;
         this._slider.y = 1;
         addChild(this._slider);
      }
      
      public function set content(obj:DisplayObject) : void
      {
         this._content = obj;
         this.initalPosition = this._content.y;
         this.update();
      }
      
      public function update() : void
      {
         var _loc1_:int = 0;
         if(this._content.height <= this.contentHeight)
         {
            this.sliderAsset.height = this.contentHeight;
            this._slider.y = 1;
         }
         else
         {
            this.percent = (this._content.height - this.contentHeight) / this.contentHeight;
            _loc1_ = (1 - this.percent * SCROLL_SLIDER_SCALE_FACTOR) * this.contentHeight;
            if(_loc1_ < SCROLL_SLIDER_MINIMUM_HEIGHT)
            {
               _loc1_ = SCROLL_SLIDER_MINIMUM_HEIGHT;
            }
            this.sliderAsset.height = _loc1_;
         }
      }
      
      public function updatePosition(param1:Number) : void
      {
         this._slider.y = this._slider.y + Math.round(param1);
         if(this._slider.y < 0)
         {
            this._slider.y = 0;
         }
         var _loc2_:int = this.contentHeight - this._slider.height;
         if(this._slider.y > _loc2_)
         {
            this._slider.y = _loc2_;
         }
         if(_loc2_ > 0)
         {
            this._content.y = this.initalPosition + -Math.round((this._content.height - this.contentHeight) * this._slider.y / _loc2_);
         }
      }
      
      public function get content() : DisplayObject
      {
         return this._content;
      }
      
      public function get slider() : Sprite
      {
         return this._slider;
      }
      
      public function get scrollObject() : DisplayObject
      {
         if(this._scrollObject)
         {
            return this._scrollObject;
         }
         return this._content;
      }
      
      public function set scrollObject(param1:DisplayObject) : void
      {
         this._scrollObject = param1;
      }
      
      public function dispose() : void
      {
         this.background.dispose();
         this.sliderAsset.dispose();
      }
      
      public function get mouseRollSpeedFactor() : Number
      {
         return this._mouseRollSpeedFactor;
      }
      
      public function set mouseRollSpeedFactor(param1:Number) : void
      {
         this._mouseRollSpeedFactor = param1;
      }
   }
}
