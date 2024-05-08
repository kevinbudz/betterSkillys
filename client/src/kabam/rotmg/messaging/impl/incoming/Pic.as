package kabam.rotmg.messaging.impl.incoming
{
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class Pic extends IncomingMessage
   {
       
      
      public var bitmapData_:BitmapData = null;
      
      public function Pic(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         var width:int = data.readInt();
         var height:int = data.readInt();
         var picData:ByteArray = new ByteArray();
         data.readBytes(picData,0,width * height * 4);
         this.bitmapData_ = new BitmapData(width,height);
         this.bitmapData_.setPixels(this.bitmapData_.rect,picData);
      }
      
      override public function toString() : String
      {
         return formatToString("PIC","bitmapData_");
      }
   }
}
