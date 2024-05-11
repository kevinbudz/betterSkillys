package com.company.assembleegameclient.util
{
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.util.AssetLibrary;
import com.company.util.PointUtil;

import flash.display.BitmapData;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
import flash.geom.Matrix;

public class ConditionEffect
{
   public static const NOTHING:uint = 0;
   public static const DEAD:uint = 1;
   public static const QUIET:uint = 2;
   public static const WEAK:uint = 3;
   public static const SLOWED:uint = 4;
   public static const SICK:uint = 5;
   public static const DAZED:uint = 6;
   public static const STUNNED:uint = 7;
   public static const BLIND:uint = 8;
   public static const HALLUCINATING:uint = 9;
   public static const DRUNK:uint = 10;
   public static const CONFUSED:uint = 11;
   public static const STUN_IMMUNE:uint = 12;
   public static const INVISIBLE:uint = 13;
   public static const PARALYZED:uint = 14;
   public static const SPEEDY:uint = 15;
   public static const BLEEDING:uint = 16;
   public static const ARMORBROKENIMMUNE:uint = 17;
   public static const HEALING:uint = 18;
   public static const DAMAGING:uint = 19;
   public static const BERSERK:uint = 20;
   public static const PAUSED:uint = 21;
   public static const STASIS:uint = 22;
   public static const STASIS_IMMUNE:uint = 23;
   public static const INVINCIBLE:uint = 24;
   public static const INVULNERABLE:uint = 25;
   public static const ARMORED:uint = 26;
   public static const ARMORBROKEN:uint = 27;
   public static const HEXED:uint = 28;
   public static const NINJA_SPEEDY:uint = 29;
   public static const UNSTABLE:uint = 30;
   public static const DARKNESS:uint = 31;
   public static const SLOWED_IMMUNE:uint = 32;
   public static const DAZED_IMMUNE:uint = 33;
   public static const PARALYZED_IMMUNE:uint = 34;
   public static const PETRIFIED:uint = 35;
   public static const PETRIFIED_IMMUNE:uint = 36;
   public static const PET_EFFECT_ICON:uint = 37;
   public static const CURSE:uint = 38;
   public static const CURSE_IMMUNE:uint = 39;
   public static const HP_BOOST:uint = 40;
   public static const MP_BOOST:uint = 41;
   public static const ATT_BOOST:uint = 42;
   public static const DEF_BOOST:uint = 43;
   public static const SPD_BOOST:uint = 44;
   public static const VIT_BOOST:uint = 45;
   public static const WIS_BOOST:uint = 46;
   public static const DEX_BOOST:uint = 47;
   public static const SILENCED:uint = 48;
   public static const EXPOSED:uint = 49;
   public static const ENERGIZED:uint = 50;
   public static const HP_DEBUFF:uint = 51;
   public static const MP_DEBUFF:uint = 52;
   public static const ATT_DEBUFF:uint = 53;
   public static const DEF_DEBUFF:uint = 54;
   public static const SPD_DEBUFF:uint = 55;
   public static const VIT_DEBUFF:uint = 56;
   public static const WIS_DEBUFF:uint = 57;
   public static const DEX_DEBUFF:uint = 58;
   public static const INSPIRED:uint = 59;

   public static const GROUND_DAMAGE:uint = 99;

   public static const DEAD_BIT:uint = 1 << (DEAD - 1);
   public static const QUIET_BIT:uint = 1 << (QUIET - 1);
   public static const WEAK_BIT:uint = 1 << (WEAK - 1);
   public static const SLOWED_BIT:uint = 1 << (SLOWED - 1);
   public static const SICK_BIT:uint = 1 << (SICK - 1);
   public static const DAZED_BIT:uint = 1 << (DAZED - 1);
   public static const STUNNED_BIT:uint = 1 << (STUNNED - 1);
   public static const BLIND_BIT:uint = 1 << (BLIND - 1);
   public static const HALLUCINATING_BIT:uint = 1 << (HALLUCINATING - 1);
   public static const DRUNK_BIT:uint = 1 << (DRUNK - 1);
   public static const CONFUSED_BIT:uint = 1 << (CONFUSED - 1);
   public static const STUN_IMMUNE_BIT:uint = 1 << (STUN_IMMUNE - 1);
   public static const INVISIBLE_BIT:uint = 1 << (INVISIBLE - 1);
   public static const PARALYZED_BIT:uint = 1 << (PARALYZED - 1);
   public static const SPEEDY_BIT:uint = 1 << (SPEEDY - 1);
   public static const BLEEDING_BIT:uint = 1 << (BLEEDING - 1);
   public static const ARMORBROKEN_IMMUNE_BIT:uint = 1 << (ARMORBROKENIMMUNE - 1);
   public static const HEALING_BIT:uint = 1 << (HEALING - 1);
   public static const DAMAGING_BIT:uint = 1 << (DAMAGING - 1);
   public static const BERSERK_BIT:uint = 1 << (BERSERK - 1);
   public static const PAUSED_BIT:uint = 1 << (PAUSED - 1);
   public static const STASIS_BIT:uint = 1 << (STASIS - 1);
   public static const STASIS_IMMUNE_BIT:uint = 1 << (STASIS_IMMUNE - 1);
   public static const INVINCIBLE_BIT:uint = 1 << (INVINCIBLE - 1);
   public static const INVULNERABLE_BIT:uint = 1 << (INVULNERABLE - 1);
   public static const ARMORED_BIT:uint = 1 << (ARMORED - 1);
   public static const ARMORBROKEN_BIT:uint = 1 << (ARMORBROKEN - 1);
   public static const HEXED_BIT:uint = 1 << (HEXED - 1);
   public static const NINJA_SPEEDY_BIT:uint = 1 << (NINJA_SPEEDY - 1);
   public static const UNSTABLE_BIT:uint = 1 << (UNSTABLE - 1);
   public static const DARKNESS_BIT:uint = 1 << (DARKNESS - 1);
   public static const SLOWED_IMMUNE_BIT:uint = 1 << (SLOWED_IMMUNE - NEW_CON_THREASHOLD);
   public static const DAZED_IMMUNE_BIT:uint = 1 << (DAZED_IMMUNE - NEW_CON_THREASHOLD);
   public static const PARALYZED_IMMUNE_BIT:uint = 1 << (PARALYZED_IMMUNE - NEW_CON_THREASHOLD);
   public static const PETRIFIED_BIT:uint = 1 << (PETRIFIED - NEW_CON_THREASHOLD);
   public static const PETRIFIED_IMMUNE_BIT:uint = 1 << (PETRIFIED_IMMUNE - NEW_CON_THREASHOLD);
   public static const PET_EFFECT_ICON_BIT:uint = 1 << (PET_EFFECT_ICON - NEW_CON_THREASHOLD);
   public static const CURSE_BIT:uint = 1 << (CURSE - NEW_CON_THREASHOLD);
   public static const CURSE_IMMUNE_BIT:uint = 1 << (CURSE_IMMUNE - NEW_CON_THREASHOLD);
   public static const HP_BOOST_BIT:uint = 1 << (HP_BOOST - NEW_CON_THREASHOLD);
   public static const MP_BOOST_BIT:uint = 1 << (MP_BOOST - NEW_CON_THREASHOLD);
   public static const ATT_BOOST_BIT:uint = 1 << (ATT_BOOST - NEW_CON_THREASHOLD);
   public static const DEF_BOOST_BIT:uint = 1 << (DEF_BOOST - NEW_CON_THREASHOLD);
   public static const SPD_BOOST_BIT:uint = 1 << (SPD_BOOST - NEW_CON_THREASHOLD);
   public static const VIT_BOOST_BIT:uint = 1 << (VIT_BOOST - NEW_CON_THREASHOLD);
   public static const WIS_BOOST_BIT:uint = 1 << (WIS_BOOST - NEW_CON_THREASHOLD);
   public static const DEX_BOOST_BIT:uint = 1 << (DEX_BOOST - NEW_CON_THREASHOLD);
   public static const SILENCED_BIT:uint = 1 << (SILENCED - NEW_CON_THREASHOLD);
   public static const EXPOSED_BIT:uint = 1 << (EXPOSED - NEW_CON_THREASHOLD);
   public static const ENERGIZED_BIT:uint = 1 << (ENERGIZED - NEW_CON_THREASHOLD);
   public static const HP_DEBUFF_BIT:uint = 1 << (HP_DEBUFF - NEW_CON_THREASHOLD);
   public static const MP_DEBUFF_BIT:uint = 1 << (MP_DEBUFF - NEW_CON_THREASHOLD);
   public static const ATT_DEBUFF_BIT:uint = 1 << (ATT_DEBUFF - NEW_CON_THREASHOLD);
   public static const DEF_DEBUFF_BIT:uint = 1 << (DEF_DEBUFF - NEW_CON_THREASHOLD);
   public static const SPD_DEBUFF_BIT:uint = 1 << (SPD_DEBUFF - NEW_CON_THREASHOLD);
   public static const VIT_DEBUFF_BIT:uint = 1 << (VIT_DEBUFF - NEW_CON_THREASHOLD);
   public static const WIS_DEBUFF_BIT:uint = 1 << (WIS_DEBUFF - NEW_CON_THREASHOLD);
   public static const DEX_DEBUFF_BIT:uint = 1 << (DEX_DEBUFF - NEW_CON_THREASHOLD);
   public static const INSPIRED_BIT:uint = 1 << (INSPIRED - NEW_CON_THREASHOLD);

   public static const MAP_FILTER_BITMASK:uint = DRUNK_BIT | BLIND_BIT | PAUSED_BIT;

   public static const CE_FIRST_BATCH:uint = 0;
   public static const CE_SECOND_BATCH:uint = 1;
   public static const NUMBER_CE_BATCHES:uint = 2;

   public static const NEW_CON_THREASHOLD:uint = 32;

   private static var effectIconCache:Object = null;
   private static var bitToIcon_:Object = null;
   private static var bitToIcon2_:Object = null;

   private static const GLOW_FILTER:GlowFilter = new GlowFilter(0x000000, .3, 6, 6, 2, BitmapFilterQuality.LOW, false, false)

   public static var effects_:Vector.<ConditionEffect> = new <ConditionEffect>[
      new ConditionEffect("Nothing", 0, null),
      new ConditionEffect("Dead", DEAD_BIT, null),
      new ConditionEffect("Quiet", QUIET_BIT, [0x20]),
      new ConditionEffect("Weak", WEAK_BIT, [0x22, 0x23, 0x24, 0x25]),
      new ConditionEffect("Slowed", SLOWED_BIT, [0x01]),
      new ConditionEffect("Sick", SICK_BIT, [0x27]),
      new ConditionEffect("Dazed", DAZED_BIT, [0x2c]),
      new ConditionEffect("Stunned", STUNNED_BIT, [0x2d]),
      new ConditionEffect("Blind", BLIND_BIT, [0x29]),
      new ConditionEffect("Hallucinating", HALLUCINATING_BIT, [0x2a]),
      new ConditionEffect("Drunk", DRUNK_BIT, [0x2b]),
      new ConditionEffect("Confused", CONFUSED_BIT, [0x02]),
      new ConditionEffect("Stun Immune", STUN_IMMUNE_BIT, null),
      new ConditionEffect("Invisible", INVISIBLE_BIT, null),
      new ConditionEffect("Paralyzed", PARALYZED_BIT, [0x35, 0x36]),
      new ConditionEffect("Speedy", SPEEDY_BIT, [0x00]),
      new ConditionEffect("Bleeding", BLEEDING_BIT, [0x2e]),
      new ConditionEffect("Armor Broken Immune", ARMORBROKEN_IMMUNE_BIT, null),
      new ConditionEffect("Healing", HEALING_BIT, [0x2f]),
      new ConditionEffect("Damaging", DAMAGING_BIT, [0x31]),
      new ConditionEffect("Berserk", BERSERK_BIT, [0x32]),
      new ConditionEffect("Paused", PAUSED_BIT, null),
      new ConditionEffect("Stasis", STASIS_BIT, null),
      new ConditionEffect("Stasis Immune", STASIS_IMMUNE_BIT, null),
      new ConditionEffect("Invincible", INVINCIBLE_BIT, null),
      new ConditionEffect("Invulnerable", INVULNERABLE_BIT, [0x11]),
      new ConditionEffect("Armored", ARMORED_BIT, [0x10]),
      new ConditionEffect("Armor Broken", ARMORBROKEN_BIT, [0x37]),
      new ConditionEffect("Hexed", HEXED_BIT, [0x2a]),
      new ConditionEffect("Ninja Speedy", NINJA_SPEEDY_BIT, [0x00]),
      new ConditionEffect("Unstable", UNSTABLE_BIT, [0x38]),
      new ConditionEffect("Darkness", DARKNESS_BIT, [0x39]),
      new ConditionEffect("Slowed Immune", SLOWED_IMMUNE_BIT, null),
      new ConditionEffect("Dazed Immune", DAZED_IMMUNE_BIT, null),
      new ConditionEffect("Paralyzed Immune", PARALYZED_IMMUNE_BIT, null),
      new ConditionEffect("Petrify", PETRIFIED_BIT, null),
      new ConditionEffect("Petrify Immune", PETRIFIED_IMMUNE_BIT, null),
      new ConditionEffect("Pet Disable", PET_EFFECT_ICON_BIT, [0x1B], true),
      new ConditionEffect("Curse", CURSE_BIT, [0x3a]),
      new ConditionEffect("Curse Immune", CURSE_IMMUNE_BIT, null),
      new ConditionEffect("HP Boost", HP_BOOST_BIT, [0x20], true),
      new ConditionEffect("MP Boost", MP_BOOST_BIT, [0x21], true),
      new ConditionEffect("Att Boost", ATT_BOOST_BIT, [0x22], true),
      new ConditionEffect("Def Boost", DEF_BOOST_BIT, [0x23], true),
      new ConditionEffect("Spd Boost", SPD_BOOST_BIT, [0x24], true),
      new ConditionEffect("Vit Boost", VIT_BOOST_BIT, [0x26], true),
      new ConditionEffect("Wis Boost", WIS_BOOST_BIT, [0x27], true),
      new ConditionEffect("Dex Boost", DEX_BOOST_BIT, [0x25], true),
      new ConditionEffect("Silenced", SILENCED_BIT, [0x21]),
      new ConditionEffect("Exposed", EXPOSED_BIT, [0x3b]),
      new ConditionEffect("Energized", ENERGIZED_BIT, [0x3c]),
      new ConditionEffect("HP Debuff", HP_DEBUFF_BIT, [0x30], true),
      new ConditionEffect("MP Debuff", MP_DEBUFF_BIT, [0x31], true),
      new ConditionEffect("Att Debuff", ATT_DEBUFF_BIT, [0x32], true),
      new ConditionEffect("Def Debuff", DEF_DEBUFF_BIT, [0x33], true),
      new ConditionEffect("Spd Debuff", SPD_DEBUFF_BIT, [0x34], true),
      new ConditionEffect("Vit Debuff", VIT_DEBUFF_BIT, [0x36], true),
      new ConditionEffect("Wis Debuff", WIS_DEBUFF_BIT, [0x37], true),
      new ConditionEffect("Dex Debuff", DEX_DEBUFF_BIT, [0x35], true),
      new ConditionEffect("Inspired", INSPIRED_BIT, [0x3e]),
   ];

   private static var conditionEffectFromName_:Object = null;

   public static function getConditionEffectFromName(name:String):uint
   {
      if (conditionEffectFromName_ == null)
      {
         conditionEffectFromName_ = new Object;
         for (var ce:uint = 0; ce < effects_.length; ce++)
         {
            conditionEffectFromName_[effects_[ce].name_] = ce;
         }
      }
      return conditionEffectFromName_[name];
   }

   public static function getConditionEffectIcons(condition:uint, icons:Vector.<BitmapData>, index:int):void
   {
      while (condition != 0)
      {
         var newCondition:uint = condition & (condition - 1);
         var bit:uint = condition ^ newCondition;
         var iconList:Vector.<BitmapData> = getIconsFromBit(bit);
         if (iconList != null)
         {
            icons.push(iconList[index % iconList.length]);
         }
         condition = newCondition;
      }
   }
   public static function getConditionEffectIcons2(condition:uint, icons:Vector.<BitmapData>, index:int):void
   {
      while (condition != 0)
      {
         var newCondition:uint = condition & (condition - 1);  //this exposes the last bit
         var bit:uint = condition ^ newCondition;
         var iconList:Vector.<BitmapData> = getIconsFromBit2(bit);
         if (iconList != null)
         {
            icons.push(iconList[index % iconList.length]);
         }
         condition = newCondition;
      }
   }

   public static function addConditionEffectIcon(icons:Vector.<BitmapData>, imageHex:int, is16Bit:Boolean):void{

      if (effectIconCache == null){
         effectIconCache = {};
      }

      if (effectIconCache[imageHex]){
         icon = effectIconCache[imageHex];
      }else{

         var icon:BitmapData;
         var drawMatrix:Matrix = new Matrix;
         drawMatrix.translate(4, 4);
         var drawMatrix16:Matrix = new Matrix;
         drawMatrix16.translate(1.5, 1.5);

         if (is16Bit){
            icon = new BitmapDataSpy(18, 18, true, 0x00000000);
            icon.draw(AssetLibrary.getImageFromSet("lofiInterfaceBig", imageHex), drawMatrix16);
         }
         else {
            icon = new BitmapDataSpy(16, 16, true, 0x00000000);
            icon.draw(AssetLibrary.getImageFromSet("lofiInterface2", imageHex), drawMatrix);
         }
         icon = GlowRedrawer.outlineGlow(icon, 0xFFFFFFFF);
         icon.applyFilter(icon, icon.rect, PointUtil.ORIGIN, GLOW_FILTER);

         effectIconCache[imageHex] = icon;
      }

      icons.push(icon);
   }

   private static function getIconsFromBit(bit:uint):Vector.<BitmapData>
   {
      if (bitToIcon_ == null)
      {
         bitToIcon_ = new Object;
         var drawMatrix:Matrix = new Matrix;
         drawMatrix.translate(4, 4);
         for (var ce:uint = 0; ce < 32; ce++)
         {
            var icons:Vector.<BitmapData> = null;
            if (effects_[ce].iconOffsets_ != null)
            {
               icons = new Vector.<BitmapData>;
               for (var i:int = 0; i < effects_[ce].iconOffsets_.length; i++)
               {
                  var icon:BitmapData = new BitmapDataSpy(16, 16, true, 0x00000000);
                  icon.draw(AssetLibrary.getImageFromSet("lofiInterface2", effects_[ce].iconOffsets_[i]), drawMatrix);
                  icon = GlowRedrawer.outlineGlow(icon, 0xFFFFFFFF);
                  icon.applyFilter(icon, icon.rect, PointUtil.ORIGIN, GLOW_FILTER);
                  icons.push(icon);
               }
            }
            bitToIcon_[effects_[ce].bit_] = icons;
         }
      }
      return bitToIcon_[bit];
   }

   private static function getIconsFromBit2(bit:uint):Vector.<BitmapData>{
      var icons:Vector.<BitmapData>;
      var icon:BitmapData;

      if (bitToIcon2_ == null){
         bitToIcon2_ = [];
         icons =new Vector.<BitmapData>;
         var drawMatrix:Matrix = new Matrix;
         drawMatrix.translate(4, 4);
         var drawMatrix16:Matrix = new Matrix;
         drawMatrix16.translate(1.5, 1.5);

         for (var ce:uint = 32; ce < effects_.length; ce++)
         {
            icons = null;
            if (effects_[ce].iconOffsets_ != null)
            {
               icons = new Vector.<BitmapData>;
               for (var i:int = 0; i < effects_[ce].iconOffsets_.length; i++)
               {
                  if (effects_[ce].icon16Bit_){
                     icon = new BitmapDataSpy(18, 18, true, 0x00000000);
                     icon.draw(AssetLibrary.getImageFromSet("lofiInterfaceBig", effects_[ce].iconOffsets_[i]), drawMatrix16);
                  }
                  else {
                     icon = new BitmapDataSpy(16, 16, true, 0x00000000);

                     icon.draw(AssetLibrary.getImageFromSet("lofiInterface2", effects_[ce].iconOffsets_[i]), drawMatrix);
                  }
                  icon = GlowRedrawer.outlineGlow(icon, 0xFFFFFFFF);
                  icon.applyFilter(icon, icon.rect, PointUtil.ORIGIN, GLOW_FILTER);
                  icons.push(icon);
               }
            }
            bitToIcon2_[effects_[ce].bit_] = icons;
         }
      }
      if (bitToIcon2_ != null && bitToIcon2_[bit] != null){
         return bitToIcon2_[bit];
      }
      return null;
   }

   public var name_:String;
   public var bit_:uint;
   public var iconOffsets_:Array;
   public var icon16Bit_:Boolean;

   public function ConditionEffect(name:String, bit:uint, iconOffsets:Array, icon16Bit:Boolean = false)
   {
      name_ = name;
      bit_ = bit;
      iconOffsets_ = iconOffsets;
      icon16Bit_ = icon16Bit;
   }
}
}