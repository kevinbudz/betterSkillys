package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class File extends IncomingMessage
   {
       
      
      public var filename_:String;
      
      public var file_:String;
      
      public function File(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.filename_ = data.readUTF();
         var fileLen:int = data.readInt();
         this.file_ = data.readUTFBytes(fileLen);
      }
      
      override public function toString() : String
      {
         return formatToString("CLIENTSTAT","filename_","file_");
      }
   }
}
