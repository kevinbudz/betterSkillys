package kabam.lib.json
{
   import com.hurlant.util.Base64;
   
   public class Base64Decoder
   {
       
      
      public function Base64Decoder()
      {
         super();
      }
      
      public function decode(encodedString:String) : String
      {
         var patternMinus:RegExp = /-/g;
         var patternUnderscore:RegExp = /_/g;
         var padding:int = 4 - encodedString.length % 4;
         while(padding--)
         {
            encodedString = encodedString + "=";
         }
         encodedString = encodedString.replace(patternMinus,"+").replace(patternUnderscore,"/");
         return Base64.decode(encodedString);
      }
   }
}
