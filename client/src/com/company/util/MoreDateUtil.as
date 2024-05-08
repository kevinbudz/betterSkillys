package com.company.util
{
   
   public class MoreDateUtil
   {
       
      
      public function MoreDateUtil()
      {
         super();
      }
      
      public static function getDayStringInPT() : String
      {
         var date:Date = new Date();
         var num:Number = date.getTime();
         num = num + (date.timezoneOffset - 420) * 60 * 1000;
         date.setTime(num);
         var df:DateFormatterReplacement = new DateFormatterReplacement();
         df.formatString = "MMMM D, YYYY";
         return df.format(date);
      }
   }
}
