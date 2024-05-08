package com.company.assembleegameclient.util
{
   public class RandomUtil
   {
       
      
      public function RandomUtil()
      {
         super();
      }
      
      public static function plusMinus(range:Number) : Number
      {
         return Math.random() * range * 2 - range;
      }
   }
}
