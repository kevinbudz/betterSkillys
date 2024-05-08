package kabam.rotmg.messaging.impl.outgoing
{
   import flash.utils.IDataOutput;
   
   public class JoinGuild extends OutgoingMessage
   {
       
      
      public var guildName_:String;
      
      public function JoinGuild(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeUTF(this.guildName_);
      }
      
      override public function toString() : String
      {
         return formatToString("JOINGUILD","guildName_");
      }
   }
}
