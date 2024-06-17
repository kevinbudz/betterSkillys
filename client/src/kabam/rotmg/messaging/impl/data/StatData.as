package kabam.rotmg.messaging.impl.data
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class StatData
{
   public static const MAX_HP_STAT:int = 0;
   public static const HP_STAT:int = 1;
   public static const SIZE_STAT:int = 2;
   public static const MAX_MP_STAT:int = 3;
   public static const MP_STAT:int = 4;
   public static const NEXT_LEVEL_EXP_STAT:int = 5;
   public static const EXP_STAT:int = 6;
   public static const LEVEL_STAT:int = 7;
   public static const ATTACK_STAT:int = 20;
   public static const DEFENSE_STAT:int = 21;
   public static const SPEED_STAT:int = 22;
   public static const INVENTORY_0_STAT:int = 8;
   public static const INVENTORY_1_STAT:int = 9;
   public static const INVENTORY_2_STAT:int = 10;
   public static const INVENTORY_3_STAT:int = 11;
   public static const INVENTORY_4_STAT:int = 12;
   public static const INVENTORY_5_STAT:int = 13;
   public static const INVENTORY_6_STAT:int = 14;
   public static const INVENTORY_7_STAT:int = 15;
   public static const INVENTORY_8_STAT:int = 16;
   public static const INVENTORY_9_STAT:int = 17;
   public static const INVENTORY_10_STAT:int = 18;
   public static const INVENTORY_11_STAT:int = 19;
   public static const VITALITY_STAT:int = 26;
   public static const WISDOM_STAT:int = 27;
   public static const DEXTERITY_STAT:int = 28;
   public static const CONDITION_STAT:int = 29;
   public static const NUM_STARS_STAT:int = 30;
   public static const NAME_STAT:int = 31;
   public static const TEX1_STAT:int = 32;
   public static const TEX2_STAT:int = 33;
   public static const MERCHANDISE_TYPE_STAT:int = 34;
   public static const CREDITS_STAT:int = 35;
   public static const MERCHANDISE_PRICE_STAT:int = 36;
   public static const ACTIVE_STAT:int = 37;
   public static const ACCOUNT_ID_STAT:int = 38;
   public static const FAME_STAT:int = 39;
   public static const MERCHANDISE_CURRENCY_STAT:int = 40;
   public static const CONNECT_STAT:int = 41;
   public static const MERCHANDISE_COUNT_STAT:int = 42;
   public static const MERCHANDISE_MINS_LEFT_STAT:int = 43;
   public static const MERCHANDISE_DISCOUNT_STAT:int = 44;
   public static const MERCHANDISE_RANK_REQ_STAT:int = 45;
   public static const MAX_HP_BOOST_STAT:int = 46;
   public static const MAX_MP_BOOST_STAT:int = 47;
   public static const ATTACK_BOOST_STAT:int = 48;
   public static const DEFENSE_BOOST_STAT:int = 49;
   public static const SPEED_BOOST_STAT:int = 50;
   public static const VITALITY_BOOST_STAT:int = 51;
   public static const WISDOM_BOOST_STAT:int = 52;
   public static const DEXTERITY_BOOST_STAT:int = 53;
   public static const OWNER_ACCOUNT_ID_STAT:int = 54;
   public static const RANK_REQUIRED_STAT:int = 55;
   public static const NAME_CHOSEN_STAT:int = 56;
   public static const CURR_FAME_STAT:int = 57;
   public static const NEXT_CLASS_QUEST_FAME_STAT:int = 58;
   public static const GLOW_COLOR:int = 59;
   public static const SINK_LEVEL_STAT:int = 60;
   public static const ALT_TEXTURE_STAT:int = 61;
   public static const GUILD_NAME_STAT:int = 62;
   public static const GUILD_RANK_STAT:int = 63;
   public static const BREATH_STAT:int = 64;
   public static const HEALTH_POTION_STACK_STAT:int = 65;
   public static const MAGIC_POTION_STACK_STAT:int = 66;
   public static const BACKPACK_0_STAT:int = 67;
   public static const BACKPACK_1_STAT:int = 68;
   public static const BACKPACK_2_STAT:int = 69;
   public static const BACKPACK_3_STAT:int = 70;
   public static const BACKPACK_4_STAT:int = 71;
   public static const BACKPACK_5_STAT:int = 72;
   public static const BACKPACK_6_STAT:int = 73;
   public static const BACKPACK_7_STAT:int = 74;
   public static const HASBACKPACK_STAT:int = 75;
   public static const TEXTURE_STAT:int = 76;
   public static const RANK:int = 77;
   public static const LD_TIMER_STAT:int = 78;
   public static const BASESTAT:int = 79;
   public static const POINTS:int = 80;
   public static const CHAT_COLOR:int = 113;
   public static const NAME_CHAT_COLOR:int = 114;
   public static const GLOW_ENEMY_COLOR:int = 115;
   public static const XP_BOOSTED:int = 116;
   public static const XP_TIMER_BOOST:int = 117;
   public static const UPGRADEENABLED:int = 119;
   public static const CONDITION_STAT_2:int = 120;
   public static const PARTYID:int = 121;
   public static const INVDATA0:int = 122;
   public static const INVDATA1:int = 123;
   public static const INVDATA2:int = 124;
   public static const INVDATA3:int = 125;
   public static const INVDATA4:int = 126;
   public static const INVDATA5:int = 127;
   public static const INVDATA6:int = 128;
   public static const INVDATA7:int = 129;
   public static const INVDATA8:int = 130;
   public static const INVDATA9:int = 131;
   public static const INVDATA10:int = 132;
   public static const INVDATA11:int = 133;
   public static const BACKPACKDATA0:int = 134;
   public static const BACKPACKDATA1:int = 135;
   public static const BACKPACKDATA2:int = 136;
   public static const BACKPACKDATA3:int = 137;
   public static const BACKPACKDATA4:int = 138;
   public static const BACKPACKDATA5:int = 139;
   public static const BACKPACKDATA6:int = 140;
   public static const BACKPACKDATA7:int = 141;
   public static const SPEEDMULT:int = 142;

   public var statType_:uint = 0;

   public var statValue_:int;

   public var strStatValue_:String;

   public function StatData()
   {
      super();
   }

   public static function statToName(stat:int) : String
   {
      switch(stat)
      {
         case MAX_HP_STAT:
            return "Maximum HP";
         case HP_STAT:
            return "HP";
         case SIZE_STAT:
            return "Size";
         case MAX_MP_STAT:
            return "Maximum MP";
         case MP_STAT:
            return "MP";
         case EXP_STAT:
            return "XP";
         case LEVEL_STAT:
            return "Level";
         case ATTACK_STAT:
            return "Attack";
         case DEFENSE_STAT:
            return "Defense";
         case SPEED_STAT:
            return "Speed";
         case VITALITY_STAT:
            return "Vitality";
         case WISDOM_STAT:
            return "Wisdom";
         case DEXTERITY_STAT:
            return "Dexterity";
         default:
            return "Unknown Stat";
      }
   }

   public function isStringStat() : Boolean
   {
      switch(this.statType_)
      {
         case NAME_STAT:
         case GUILD_NAME_STAT:
         case INVDATA0:
         case INVDATA1:
         case INVDATA2:
         case INVDATA3:
         case INVDATA4:
         case INVDATA5:
         case INVDATA6:
         case INVDATA7:
         case INVDATA8:
         case INVDATA9:
         case INVDATA10:
         case INVDATA11:
         case BACKPACKDATA0:
         case BACKPACKDATA1:
         case BACKPACKDATA2:
         case BACKPACKDATA3:
         case BACKPACKDATA4:
         case BACKPACKDATA5:
         case BACKPACKDATA6:
         case BACKPACKDATA7:
            return true;
         default:
            return false;
      }
   }

   public function parseFromInput(data:IDataInput) : void
   {
      this.statType_ = data.readUnsignedByte();
      if(!this.isStringStat())
      {
         this.statValue_ = data.readInt();
      }
      else
      {
         this.strStatValue_ = data.readUTF();
      }
   }

   public function writeToOutput(data:IDataOutput) : void
   {
      data.writeByte(this.statType_);
      if(!this.isStringStat())
      {
         data.writeInt(this.statValue_);
      }
      else
      {
         data.writeUTF(this.strStatValue_);
      }
   }

   public function toString() : String
   {
      if(!this.isStringStat())
      {
         return "[" + this.statType_ + ": " + this.statValue_ + "]";
      }
      return "[" + this.statType_ + ": \"" + this.strStatValue_ + "\"]";
   }
}
}
