package io.decagames.rotmg.ui.spinner
{
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import io.decagames.rotmg.ui.buttons.SliceScalingButton;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.labels.UILabel;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import org.osflash.signals.Signal;
   
   public class NumberSpinner extends Sprite
   {
       
      
      private var _upArrow:SliceScalingButton;
      
      private var _downArrow:SliceScalingButton;
      
      private var startValue:int;
      
      private var minValue:int;
      
      private var maxValue:int;
      
      protected var suffix:String;
      
      protected var label:UILabel;
      
      protected var _value:int;
      
      private var _step:int;
      
      public var valueWasChanged:Signal;
      
      public function NumberSpinner(param1:SliceScalingBitmap, param2:int, param3:int, param4:int, param5:int, param6:String = "")
      {
         super();
         this._upArrow = new SliceScalingButton(param1);
         this.startValue = param2;
         this.minValue = param3;
         this.maxValue = param4;
         this.suffix = param6;
         this._step = param5;
         this.valueWasChanged = new Signal();
         this.label = new UILabel();
         DefaultLabelFormat.numberSpinnerLabel(this.label);
         this.label.autoSize = TextFieldAutoSize.LEFT;
         this.label.text = param2.toString() + param6;
         this.label.x = -this.label.width / 2;
         this._upArrow.x = -this._upArrow.width / 2;
         this._upArrow.y = 6;
         this.label.y = this._upArrow.height + 4;
         addChild(this.label);
         addChild(this._upArrow);
         this._downArrow = new SliceScalingButton(param1.clone());
         this._downArrow.rotation = 180;
         this._downArrow.x = this._downArrow.width / 2;
         this._downArrow.y = this.label.y + this.label.height + 6;
         addChild(this._downArrow);
         this._value = param2;
      }
      
      protected function updateLabel() : void
      {
         this.label.text = this._value.toString() + this.suffix;
         this.label.x = -this.label.width / 2;
      }
      
      public function addToValue(param1:int) : void
      {
         var _loc2_:int = this._value;
         this._value = this._value + param1;
         if(this._value > this.maxValue)
         {
            this._value = this.maxValue;
         }
         if(this._value < this.minValue)
         {
            this._value = this.minValue;
         }
         if(this._value != _loc2_)
         {
            this.valueWasChanged.dispatch(this.value);
         }
         this.updateLabel();
      }
      
      public function setValue(param1:int) : void
      {
         var _loc2_:int = this._value;
         this._value = param1;
         if(this._value != _loc2_)
         {
            this.valueWasChanged.dispatch(this.value);
         }
         this.updateLabel();
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      public function set value(param1:int) : void
      {
         this._value = param1;
      }
      
      public function get upArrow() : SliceScalingButton
      {
         return this._upArrow;
      }
      
      public function get downArrow() : SliceScalingButton
      {
         return this._downArrow;
      }
      
      public function get step() : int
      {
         return this._step;
      }
      
      public function dispose() : void
      {
         this._upArrow.dispose();
         this._downArrow.dispose();
         this.valueWasChanged.removeAll();
      }
   }
}
