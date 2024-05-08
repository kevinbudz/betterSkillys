package kabam.rotmg.messaging.impl.data
{
   import flash.geom.Point;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class WorldPosData
   {
       
      
      public var x_:Number;
      
      public var y_:Number;
      
      public function WorldPosData()
      {
         super();
      }
      
      public function toPoint() : Point
      {
         return new Point(this.x_,this.y_);
      }
      
      public function parseFromInput(data:IDataInput) : void
      {
         this.x_ = data.readFloat();
         this.y_ = data.readFloat();
      }
      
      public function writeToOutput(data:IDataOutput) : void
      {
         data.writeFloat(this.x_);
         data.writeFloat(this.y_);
      }
      
      public function toString() : String
      {
         return "x_: " + this.x_ + " y_: " + this.y_;
      }
   }
}
