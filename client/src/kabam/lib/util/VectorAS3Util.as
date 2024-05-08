package kabam.lib.util
{
   public class VectorAS3Util
   {
       
      
      public function VectorAS3Util()
      {
         super();
      }
      
      public static function toArray(forEachAble:Object) : Array
      {
         var value:Object = null;
         var array:Array = [];
         for each(value in forEachAble)
         {
            array.push(value);
         }
         return array;
      }
   }
}
