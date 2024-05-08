package io.decagames.rotmg.ui.spinner
{
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   
   public class FixedNumbersSpinner extends NumberSpinner
   {
       
      
      private var _numbers:Vector.<int>;
      
      public function FixedNumbersSpinner(param1:SliceScalingBitmap, param2:int, param3:Vector.<int>, param4:String = "")
      {
         super(param1,param2,0,param3.length - 1,1,param4);
         this._numbers = param3;
         this.updateLabel();
      }
      
      override protected function updateLabel() : void
      {
         label.text = this._numbers[_value] + suffix;
         label.x = -label.width / 2;
      }
      
      override public function get value() : int
      {
         return this._numbers[_value];
      }
      
      override public function set value(param1:int) : void
      {
         var _loc2_:int = _value;
         _value = this._numbers.indexOf(param1);
         if(_value < 0)
         {
            _value = 0;
         }
         if(_value != _loc2_)
         {
            valueWasChanged.dispatch(this.value);
         }
         this.updateLabel();
      }
   }
}
