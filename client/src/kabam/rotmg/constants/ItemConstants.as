package kabam.rotmg.constants {
public class ItemConstants {

   public static const NO_ITEM:int = -1;
   public static const ALL_TYPE:int = 0;
   public static const SWORD_TYPE:int = 1;
   public static const DAGGER_TYPE:int = 2;
   public static const BOW_TYPE:int = 3;
   public static const TOME_TYPE:int = 4;
   public static const SHIELD_TYPE:int = 5;
   public static const LEATHER_TYPE:int = 6;
   public static const PLATE_TYPE:int = 7;
   public static const WAND_TYPE:int = 8;
   public static const RING_TYPE:int = 9;
   public static const POTION_TYPE:int = 10;
   public static const SPELL_TYPE:int = 11;
   public static const SEAL_TYPE:int = 12;
   public static const CLOAK_TYPE:int = 13;
   public static const ROBE_TYPE:int = 14;
   public static const QUIVER_TYPE:int = 15;
   public static const HELM_TYPE:int = 16;
   public static const STAFF_TYPE:int = 17;
   public static const POISON_TYPE:int = 18;
   public static const SKULL_TYPE:int = 19;
   public static const TRAP_TYPE:int = 20;
   public static const ORB_TYPE:int = 21;
   public static const PRISM_TYPE:int = 22;
   public static const SCEPTER_TYPE:int = 23;
   public static const KATANA_TYPE:int = 24;
   public static const SHURIKEN_TYPE:int = 25;
   public static const EGG_TYPE:int = 26;
   public static const NEW_ABIL_TYPE:int = 27;
   public static const LUTE_TYPE:int = 28;

   public static function itemTypeToName(type:int):String {
      switch (type) {
         case ALL_TYPE:
            return "Any";
         case SWORD_TYPE:
            return "Sword";
         case DAGGER_TYPE:
            return "Dagger";
         case BOW_TYPE:
            return "Bow";
         case TOME_TYPE:
            return "Tome";
         case SHIELD_TYPE:
            return "Shield";
         case LEATHER_TYPE:
            return "Leather Armor";
         case PLATE_TYPE:
            return "Armor";
         case WAND_TYPE:
            return "Wand";
         case RING_TYPE:
            return "Accessory";
         case POTION_TYPE:
            return "Potion";
         case SPELL_TYPE:
            return "Spell";
         case SEAL_TYPE:
            return "Holy Seal";
         case CLOAK_TYPE:
            return "Cloak";
         case ROBE_TYPE:
            return "Robe";
         case QUIVER_TYPE:
            return "Quiver";
         case HELM_TYPE:
            return "Helm";
         case STAFF_TYPE:
            return "Staff";
         case POISON_TYPE:
            return "Poison";
         case SKULL_TYPE:
            return "Skull";
         case TRAP_TYPE:
            return "Trap";
         case ORB_TYPE:
            return "Orb";
         case PRISM_TYPE:
            return "Prism";
         case SCEPTER_TYPE:
            return "Scepter";
         case KATANA_TYPE:
            return "Katana";
         case SHURIKEN_TYPE:
            return "Shuriken";
         case EGG_TYPE:
            return ("Any");
         case NEW_ABIL_TYPE:
            return ("Wakizashi");
         case LUTE_TYPE:
            return ("Lute");
         default:
            return "Invalid Type!";
      }
   }

   public static function isEquippable(slotType:int):Boolean{
      return ItemConstants.itemTypeToName(slotType) != "Invalid Type!";
   }
}
}
