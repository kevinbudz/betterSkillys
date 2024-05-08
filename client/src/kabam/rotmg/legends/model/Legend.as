package kabam.rotmg.legends.model
{
   import flash.display.BitmapData;
   import kabam.rotmg.fame.model.FameVO;
   
   public class Legend implements FameVO
   {
       
      
      public var isOwnLegend:Boolean;
      
      public var place:int;
      
      public var accountId:int;
      
      public var charId:int;
      
      public var name:String;
      
      public var totalFame:int;
      
      public var equipmentSlots:Vector.<int>;
      
      public var equipment:Vector.<int>;

      public var itemDatas_:Vector.<Object>;
      
      public var character:BitmapData;
      
      public var isFocus:Boolean;
      
      public function Legend()
      {
         super();
      }
      
      public function getAccountId() : int
      {
         return this.accountId;
      }
      
      public function getCharacterId() : int
      {
         return this.charId;
      }
   }
}
