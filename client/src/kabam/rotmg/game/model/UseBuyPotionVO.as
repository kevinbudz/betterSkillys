package kabam.rotmg.game.model
{
   public class UseBuyPotionVO
   {
      
      public static var SHIFTCLICK:String = "shift_click";
      
      public static var CONTEXTBUY:String = "context_buy";
       
      
      public var objectId:int;
      
      public var source:String;
      
      public function UseBuyPotionVO(objectId:int, source:String)
      {
         super();
         this.objectId = objectId;
         this.source = source;
      }
   }
}
