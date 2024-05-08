package com.company.util
{
   import flash.utils.ByteArray;
   
   public class MoreStringUtil
   {
       
      
      public function MoreStringUtil()
      {
         super();
      }
      
      public static function hexStringToByteArray(hexString:String) : ByteArray
      {
         var byteArray:ByteArray = new ByteArray();
         for(var i:int = 0; i < hexString.length; i = i + 2)
         {
            byteArray.writeByte(parseInt(hexString.substr(i,2),16));
         }
         return byteArray;
      }
      
      public static function cmp(s1:String, s2:String) : Number
      {
         return s1.localeCompare(s2);
      }
   }
}
