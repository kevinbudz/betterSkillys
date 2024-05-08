package com.company.assembleegameclient.util
{
   public class TimeUtil
   {
      
      public static const DAY_IN_MS:int = 86400000;
      
      public static const DAY_IN_S:int = 86400;
       
      
      public function TimeUtil()
      {
         super();
      }
      
      public static function secondsToDays(time:Number) : Number
      {
         return time / DAY_IN_S;
      }
   }
}
