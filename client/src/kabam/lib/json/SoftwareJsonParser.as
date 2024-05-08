package kabam.lib.json
{
import com.adobe.serialization.json.JSON;
   public class SoftwareJsonParser implements JsonParser
   {
       
      
      public function SoftwareJsonParser()
      {
         super();
      }
      
      public function stringify(value:Object) : String
      {
         return com.adobe.serialization.json.JSON.encode(value);
      }
      
      public function parse(text:String) : Object
      {
         return com.adobe.serialization.json.JSON.decode(text);
      }
   }
}
