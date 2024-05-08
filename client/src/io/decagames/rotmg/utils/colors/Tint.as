package io.decagames.rotmg.utils.colors
{
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   
   public class Tint
   {
       
      
      public function Tint()
      {
         super();
      }
      
      public static function add(param1:DisplayObject, param2:uint, param3:Number) : void
      {
         var _loc4_:ColorTransform = param1.transform.colorTransform;
         _loc4_.color = param2;
         var _loc5_:Number = param3 / (1 - (_loc4_.redMultiplier + _loc4_.greenMultiplier + _loc4_.blueMultiplier) / 3);
         _loc4_.redOffset = _loc4_.redOffset * _loc5_;
         _loc4_.greenOffset = _loc4_.greenOffset * _loc5_;
         _loc4_.blueOffset = _loc4_.blueOffset * _loc5_;
         _loc4_.redMultiplier = _loc4_.greenMultiplier = _loc4_.blueMultiplier = 1 - param3;
         param1.transform.colorTransform = _loc4_;
      }
   }
}
