package io.decagames.rotmg.ui.buttons
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import io.decagames.rotmg.ui.labels.UILabel;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import io.decagames.rotmg.ui.texture.TextureParser;
   import io.decagames.rotmg.utils.colors.GreyScale;
   import io.decagames.rotmg.utils.colors.Tint;
   import org.osflash.signals.Signal;
   
   public class SliceScalingButton extends BaseButton
   {


      public var clicked:Signal;
      public var clicked2:Signal;

      public var autoLocate:Boolean;
      
      private var staticWidth:Boolean;
      
      private var _bitmapWidth:int;
      
      private var disableBitmap:SliceScalingBitmap;
      
      private var rollOverBitmap:SliceScalingBitmap;
      
      public var _label:UILabel;
      
      private var stateFactories:Dictionary;
      
      private var _bitmap:SliceScalingBitmap;
      
      private var _autoDispose:Boolean;
      
      protected var _interactionEffects:Boolean = true;
      
      protected var labelMargin:Point;
      
      public function SliceScalingButton(param1:SliceScalingBitmap, param2:SliceScalingBitmap = null, param3:SliceScalingBitmap = null, arg1:Boolean = true)
      {
         this.clicked = new Signal();
         this.clicked2 = new Signal();
         this.labelMargin = new Point();
         this._bitmap = param1;
         addChild(this._bitmap);
         this.rollOverBitmap = param3;
         this.disableBitmap = param2;
         this._label = new UILabel();
         this.autoLocate = arg1;
         this.stateFactories = new Dictionary();
         super();
      }
      
      public function setLabelMargin(param1:int, param2:int) : void
      {
         this.labelMargin.x = param1;
         this.labelMargin.y = param2;
      }
      
      override protected function onRollOverHandler(param1:MouseEvent) : void
      {
         if(this._interactionEffects && !_disabled)
         {
            Tint.add(this._bitmap,65535,0.1);
            this._bitmap.scaleX = 1;
            this._bitmap.scaleY = 1;
            this._bitmap.x = 0;
            this._bitmap.y = 0;
         }
         super.onRollOverHandler(param1);
      }
      
      override protected function onMouseDownHandler(param1:MouseEvent) : void
      {
         if(this._interactionEffects && !_disabled)
         {
            this._bitmap.scaleX = 0.9;
            this._bitmap.scaleY = 0.9;
            this._bitmap.x = this._bitmap.width * 0.1 / 2;
            this._bitmap.y = this._bitmap.height * 0.1 / 2;
         }
         super.onMouseDownHandler(param1);
      }
      
      override protected function onClickHandler(param1:MouseEvent) : void
      {
         this.clicked.dispatch();
         this.clicked2.dispatch(param1);
         if(this._interactionEffects)
         {
            this._bitmap.scaleX = 1;
            this._bitmap.scaleY = 1;
            this._bitmap.x = 0;
            this._bitmap.y = 0;
         }
         super.onClickHandler(param1);
      }
      
      override protected function onRollOutHandler(param1:MouseEvent) : void
      {
         if(this._interactionEffects)
         {
            this._bitmap.transform.colorTransform = new ColorTransform();
            this._bitmap.scaleX = 1;
            this._bitmap.scaleY = 1;
            this._bitmap.x = 0;
            this._bitmap.y = 0;
         }
         super.onRollOutHandler(param1);
      }

      public function disabledAlt(disabled:Boolean, returnTheSprite:Boolean = true) : void
      {
         super.disabled = disabled;
         var _loc2_:Function = this.stateFactories[ButtonStates.DISABLED];
         if(_loc2_ != null)
         {
            _loc2_(this._label);
         }
         if(this._interactionEffects)
         {
            if(disabled)
            {
               GreyScale.setGreyScale(this._bitmap.bitmapData);
            }
            else
            {
               if(returnTheSprite)
               {
                  this.changeBitmap(this._bitmap.sourceBitmapName,new Point(this._bitmap.marginX,this._bitmap.marginY));
               }
            }
         }
         this.render();
      }

      override public function set disabled(param1:Boolean) : void
      {
         super.disabled = param1;
         var _loc2_:Function = this.stateFactories[ButtonStates.DISABLED];
         if(_loc2_ != null)
         {
            _loc2_(this._label);
         }
         if(this._interactionEffects)
         {
            if(param1)
            {
               GreyScale.setGreyScale(this._bitmap.bitmapData);
            }
         }
         this.render();
      }
      
      public function setLabel(param1:String, param2:Function = null, param3:String = "idle") : void
      {
         if(param3 == ButtonStates.IDLE)
         {
            if(param2 != null)
            {
               param2(this._label);
            }
            this._label.text = param1;
            addChild(this._label);
            this.render();
         }
         this.stateFactories[param3] = param2;
      }
      
      override protected function onAddedToStage(param1:Event) : void
      {
         super.onAddedToStage(param1);
         this.render();
      }
      
      override public function set width(param1:Number) : void
      {
         param1 = Math.round(param1);
         this.staticWidth = true;
         this._bitmapWidth = param1;
         this.render();
      }
      
      public function render() : void
      {
         if(this.staticWidth)
         {
            this._bitmap.width = this._bitmapWidth;
         }
         if(this.autoLocate){
            this._label.x = (this._bitmapWidth - this._label.textWidth) / 2 + this._bitmap.marginX + this.labelMargin.y;
            this._label.y = (this._bitmap.height - this._label.textHeight) / 2 + this._bitmap.marginY + this.labelMargin.y;
         }

      }
      
      override public function dispose() : void
      {
         this._bitmap.dispose();
         if(this.disableBitmap)
         {
            this.disableBitmap.dispose();
         }
         if(this.rollOverBitmap)
         {
            this.rollOverBitmap.dispose();
         }
         super.dispose();
      }
      
      public function changeBitmap(param1:String, param2:Point = null) : void
      {
         removeChild(this._bitmap);
         this._bitmap.dispose();
         this._bitmap = TextureParser.instance.getSliceScalingBitmap("UI",param1);
         if(param2 != null)
         {
            this._bitmap.addMargin(param2.x,param2.y);
         }
         addChildAt(this._bitmap,0);
         this._bitmap.forceRenderInNextFrame = true;
         this.render();
      }
      
      public function get label() : UILabel
      {
         return this._label;
      }
      
      public function get autoDispose() : Boolean
      {
         return this._autoDispose;
      }
      
      public function set autoDispose(param1:Boolean) : void
      {
         this._autoDispose = param1;
      }
      
      public function get interactionEffects() : Boolean
      {
         return this._interactionEffects;
      }
      
      public function set interactionEffects(param1:Boolean) : void
      {
         this._interactionEffects = param1;
      }
      
      public function get bitmapWidth() : int
      {
         return this._bitmapWidth;
      }
      
      public function get bitmap() : SliceScalingBitmap
      {
         return this._bitmap;
      }
   }
}
