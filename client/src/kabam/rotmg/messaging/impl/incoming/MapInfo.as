package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class MapInfo extends IncomingMessage
   {
      public var width_:int;
      public var height_:int;
      public var name_:String;
      public var displayName_:String;
      public var difficulty_:int;
      public var fp_:uint;
      public var background_:int;
      public var allowPlayerTeleport_:Boolean;
      public var showDisplays_:Boolean;
      public var music:String;
      public var disableShooting_:Boolean;
      public var disableAbilitites_:Boolean;

      public function MapInfo(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.width_ = data.readShort();
         this.height_ = data.readShort();
         this.name_ = data.readUTF();
         this.displayName_ = data.readUTF();
         this.fp_ = data.readUnsignedInt();
         this.background_ = data.readByte();
         this.difficulty_ = data.readByte();
         this.allowPlayerTeleport_ = data.readBoolean();
         this.showDisplays_ = data.readBoolean();
         this.music = data.readUTF();
         this.disableShooting_ = data.readBoolean();
         this.disableAbilitites_ = data.readBoolean();
      }
      
      override public function toString() : String
      {
         return formatToString("MAPINFO","width_","height_","name_","fp_","background_","allowPlayerTeleport_","showDisplays_");
      }
   }
}
