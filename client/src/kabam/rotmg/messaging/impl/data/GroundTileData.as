package kabam.rotmg.messaging.impl.data
{
   import flash.utils.IDataInput;
   
   public class GroundTileData
   {
       
      
      public var x_:int;
      
      public var y_:int;
      
      public var type_:uint;
      
      public function GroundTileData()
      {
         super();
      }
      
      public function parseFromInput(data:IDataInput) : void
      {
         this.x_ = data.readShort();
         this.y_ = data.readShort();
         this.type_ = data.readInt();
      }
      
      public function toString() : String
      {
         return "x_: " + this.x_ + " y_: " + this.y_ + " type_:" + this.type_;
      }
   }
}
