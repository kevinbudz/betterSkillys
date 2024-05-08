package kabam.rotmg.characters.reskin.control
{
   import kabam.lib.net.api.MessageProvider;
   import kabam.lib.net.impl.SocketServer;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.messaging.impl.GameServerConnection;
   import kabam.rotmg.messaging.impl.outgoing.Reskin;
   
   public class ReskinCharacterCommand
   {
       
      
      [Inject]
      public var skin:CharacterSkin;
      
      [Inject]
      public var messages:MessageProvider;
      
      [Inject]
      public var server:SocketServer;
      
      public function ReskinCharacterCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var reskin:Reskin = this.messages.require(GameServerConnection.RESKIN) as Reskin;
         reskin.skinID = this.skin.id;
         this.server.sendMessage(reskin);
      }
   }
}
