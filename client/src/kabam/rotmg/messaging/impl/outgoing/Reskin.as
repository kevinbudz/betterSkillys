package kabam.rotmg.messaging.impl.outgoing
{
   import com.company.assembleegameclient.objects.Player;
   import flash.utils.IDataOutput;
   
   public class Reskin extends OutgoingMessage
   {
       
      
      public var skinID:int;
      
      public var player:Player;
      
      public function Reskin(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function writeToOutput(data:IDataOutput) : void
      {
         data.writeInt(this.skinID);
      }
      
      override public function consume() : void
      {
         super.consume();
         this.player = null;
      }
      
      override public function toString() : String
      {
         return formatToString("RESKIN","skinID");
      }
   }
}
