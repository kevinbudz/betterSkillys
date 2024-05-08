package kabam.rotmg.messaging.impl.data
{
   import flash.utils.IDataInput;
   
   public class TalismanData
   {
      public var type_:int;
      public var level_:int;
      public var xp_:int;
      public var goal_:int;
      public var tier_:int;
      public var active_:Boolean;

      public function TalismanData()
      {
         super();
      }
      
      public function parseFromInput(data:IDataInput) : void
      {
         this.type_ = data.readByte();
         this.level_ = data.readByte();
         this.xp_ = data.readInt();
         this.goal_ = data.readInt();
         this.tier_ = data.readByte();
         this.active_ = data.readBoolean();
      }
      
      public function toString() : String
      {
         return "Todo: Print Something If needed";
      }
   }
}
