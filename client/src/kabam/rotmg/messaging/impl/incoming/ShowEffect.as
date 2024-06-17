package kabam.rotmg.messaging.impl.incoming
{
import flash.utils.IDataInput;
import kabam.rotmg.messaging.impl.data.WorldPosData;

public class ShowEffect extends IncomingMessage
{

   public static const UNKNOWN_EFFECT_TYPE:int = 0;

   public static const HEAL_EFFECT_TYPE:int = 1;

   public static const TELEPORT_EFFECT_TYPE:int = 2;

   public static const STREAM_EFFECT_TYPE:int = 3;

   public static const THROW_EFFECT_TYPE:int = 4;

   public static const NOVA_EFFECT_TYPE:int = 5;

   public static const POISON_EFFECT_TYPE:int = 6;

   public static const LINE_EFFECT_TYPE:int = 7;

   public static const BURST_EFFECT_TYPE:int = 8;

   public static const FLOW_EFFECT_TYPE:int = 9;

   public static const RING_EFFECT_TYPE:int = 10;

   public static const LIGHTNING_EFFECT_TYPE:int = 11;

   public static const COLLAPSE_EFFECT_TYPE:int = 12;

   public static const CONEBLAST_EFFECT_TYPE:int = 13;

   public static const JITTER_EFFECT_TYPE:int = 14;

   public static const FLASH_EFFECT_TYPE:int = 15;

   public static const THROW_PROJECTILE_EFFECT_TYPE:int = 16;

   public static const INSPIRED_EFFECT_TYPE:int = 17;

   public var effectType_:uint;
   public var targetObjectId_:int;
   public var pos1_:WorldPosData;
   public var pos2_:WorldPosData;
   public var color_:int;
   public var duration_:int;
   public var objectType:int;

   public function ShowEffect(id:uint, callback:Function)
   {
      this.pos1_ = new WorldPosData();
      this.pos2_ = new WorldPosData();
      super(id,callback);
   }

   override public function parseFromInput(data:IDataInput) : void
   {
      this.effectType_ = data.readUnsignedByte();
      this.targetObjectId_ = data.readInt();
      this.pos1_.parseFromInput(data);
      this.pos2_.parseFromInput(data);
      this.color_ = data.readInt();
      this.duration_ = data.readInt();
      this.objectType = data.readUnsignedShort();
   }

   override public function toString() : String
   {
      return formatToString("SHOW_EFFECT","effectType_","targetObjectId_","pos1_","pos2_","color_", "duration_", "objectType");
   }
}
}
