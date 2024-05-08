package com.company.assembleegameclient.util
{
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.util.AssetLibrary;
   import com.company.util.PointUtil;

import flash.concurrent.Condition;
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
      public static const NOT_USED:uint = 17;
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
      public static const CURSE:uint = 31;
      public static const DARKNESS:uint = 32;
      public static const PETRIFY:uint = 33;
      public static const SLOWEDIMMUNE:uint = 34;
      public static const DAZEDIMMUNE:uint = 35;
      public static const PARALYZEIMMUNE:uint = 36;
      public static const PETRIFYIMMUNE:uint = 37;
      public static const CURSEIMMUNE:uint = 38;
      public static const ARMORBREAKIMMUNE:uint = 39;
      public static const HP_BOOST:uint = 40;
      public static const MP_BOOST:uint = 41;
      public static const ATT_BOOST:uint = 42;
      public static const DEF_BOOST:uint = 43;
      public static const SPD_BOOST:uint = 44;
      public static const DEX_BOOST:uint = 45;
      public static const VIT_BOOST:uint = 46;
      public static const WIS_BOOST:uint = 47;
      public static const HIDDEN:uint = 48;
      public static const REGENERATION:uint = 49;
      public static const MPTREGENERATION:uint = 50;
      public static const NINJABERSERK:uint = 51;
      public static const NINJADAMAGING:uint = 52;
      public static const SILENCED:uint = 53;
      public static const UNSTABLEIMMUNE:uint = 54;

      public static const DEAD_BIT:uint = 1 << DEAD - 1;
      public static const QUIET_BIT:uint = 1 << QUIET - 1;
      public static const WEAK_BIT:uint = 1 << WEAK - 1;
      public static const SLOWED_BIT:uint = 1 << SLOWED - 1;
      public static const SICK_BIT:uint = 1 << SICK - 1;
      public static const DAZED_BIT:uint = 1 << DAZED - 1;
      public static const STUNNED_BIT:uint = 1 << STUNNED - 1;
      public static const BLIND_BIT:uint = 1 << BLIND - 1;
      public static const HALLUCINATING_BIT:uint = 1 << HALLUCINATING - 1;
      public static const DRUNK_BIT:uint = 1 << DRUNK - 1;
      public static const CONFUSED_BIT:uint = 1 << CONFUSED - 1;
      public static const STUN_IMMUNE_BIT:uint = 1 << STUN_IMMUNE - 1;
      public static const INVISIBLE_BIT:uint = 1 << INVISIBLE - 1;
      public static const PARALYZED_BIT:uint = 1 << PARALYZED - 1;
      public static const SPEEDY_BIT:uint = 1 << SPEEDY - 1;
      public static const BLEEDING_BIT:uint = 1 << BLEEDING - 1;
      public static const NOT_USED_BIT:uint = 1 << NOT_USED - 1;
      public static const HEALING_BIT:uint = 1 << HEALING - 1;
      public static const DAMAGING_BIT:uint = 1 << DAMAGING - 1;
      public static const BERSERK_BIT:uint = 1 << BERSERK - 1;
      public static const PAUSED_BIT:uint = 1 << PAUSED - 1;
      public static const STASIS_BIT:uint = 1 << STASIS - 1;
      public static const STASIS_IMMUNE_BIT:uint = 1 << STASIS_IMMUNE - 1;
      public static const INVINCIBLE_BIT:uint = 1 << INVINCIBLE - 1;
      public static const INVULNERABLE_BIT:uint = 1 << INVULNERABLE - 1;
      public static const ARMORED_BIT:uint = 1 << ARMORED - 1;
      public static const ARMORBROKEN_BIT:uint = 1 << ARMORBROKEN - 1;
      public static const HEXED_BIT:uint = 1 << HEXED - 1;
      public static const NINJA_SPEEDY_BIT:uint = 1 << NINJA_SPEEDY - 1;
      public static const UNSTABLE_BIT:uint = 1 << UNSTABLE - 1;
      public static const CURSE_BIT:uint = 1 << CURSE - 1;
      public static const DARKNESS_BIT:uint = 1 << DARKNESS - 32;
      public static const PETRIFY_BIT:uint = 1 << PETRIFY - 32;
      public static const SLOWEDIMMUNE_BIT:uint = 1 << SLOWEDIMMUNE - 32;
      public static const DAZEDIMMUNE_BIT:uint = 1 << DAZEDIMMUNE - 32;
      public static const PARALYZEIMMUNE_BIT:uint = 1 << PARALYZEIMMUNE - 32;
      public static const PETRIFYIMMUNE_BIT:uint = 1 << PETRIFYIMMUNE - 32;
      public static const CURSEIMMUNE_BIT:uint = 1 << CURSEIMMUNE - 32;
      public static const ARMORBREAKIMMUNE_BIT:uint = 1 << ARMORBREAKIMMUNE - 32;
      public static const HP_BOOST_BIT:uint = 1 << HP_BOOST - 32;
      public static const MP_BOOST_BIT:uint = 1 << MP_BOOST - 32;
      public static const ATT_BOOST_BIT:uint = 1 << ATT_BOOST - 32;
      public static const DEF_BOOST_BIT:uint = 1 << DEF_BOOST - 32;
      public static const SPD_BOOST_BIT:uint = 1 << SPD_BOOST - 32;
      public static const DEX_BOOST_BIT:uint = 1 << DEX_BOOST - 32;
      public static const VIT_BOOST_BIT:uint = 1 << VIT_BOOST - 32;
      public static const WIS_BOOST_BIT:uint = 1 << WIS_BOOST - 32;
      public static const HIDDEN_BIT:uint = 1 << (HIDDEN - 32);
      public static const REGENERATION_BIT:uint = 1 << REGENERATION - 32;
      public static const MPTREGENERATION_BIT:uint = 1 << (MPTREGENERATION - 32);
      public static const NINJABERSERK_BIT:uint = 1 << (NINJABERSERK - 32);
      public static const NINJADAMAGING_BIT:uint = 1 << (NINJADAMAGING - 32);
      public static const SILENCED_BIT:uint = 1 << (SILENCED - 32);
      public static const UNSTABLEIMMUNE_BIT:uint = 1 << (UNSTABLEIMMUNE - 32);

      public static const MAP_FILTER_BITMASK:uint = DRUNK_BIT | BLIND_BIT | PAUSED_BIT;
      
      public static var effects_:Vector.<ConditionEffect> = new <ConditionEffect>[
         new ConditionEffect("Nothing",0,null),
         new ConditionEffect("Dead",DEAD_BIT,null),
         new ConditionEffect("Quiet",QUIET_BIT,[32]),
         new ConditionEffect("Weak",WEAK_BIT,[34,35,36,37]),
         new ConditionEffect("Slowed",SLOWED_BIT,[1]),
         new ConditionEffect("Sick",SICK_BIT,[39]),
         new ConditionEffect("Dazed",DAZED_BIT,[44]),
         new ConditionEffect("Stunned",STUNNED_BIT,[45]),
         new ConditionEffect("Blind",BLIND_BIT,[41]),
         new ConditionEffect("Hallucinating",HALLUCINATING_BIT, [42]),
         new ConditionEffect("Drunk",DRUNK_BIT,[43]),
         new ConditionEffect("Confused",CONFUSED_BIT,[2]),
         new ConditionEffect("Stun Immune",STUN_IMMUNE_BIT,null),
         new ConditionEffect("Invisible",INVISIBLE_BIT,null),
         new ConditionEffect("Paralyzed",PARALYZED_BIT,[53,54]),
         new ConditionEffect("Speedy",SPEEDY_BIT,[0]),
         new ConditionEffect("Bleeding",BLEEDING_BIT,[46]),
         new ConditionEffect("Not Used",NOT_USED_BIT,null),
         new ConditionEffect("Healing",HEALING_BIT,[47]),
         new ConditionEffect("Damaging",DAMAGING_BIT,[49]),
         new ConditionEffect("Berserk",BERSERK_BIT,[50]),
         new ConditionEffect("Paused",PAUSED_BIT,null),
         new ConditionEffect("Stasis",STASIS_BIT,null),
         new ConditionEffect("Stasis Immune",STASIS_IMMUNE_BIT,null),
         new ConditionEffect("Invincible",INVINCIBLE_BIT,null),
         new ConditionEffect("Invulnerable",INVULNERABLE_BIT,[17]),
         new ConditionEffect("Armored",ARMORED_BIT,[16]),
         new ConditionEffect("Armor Broken",ARMORBROKEN_BIT,[55]),
         new ConditionEffect("Hexed",HEXED_BIT,[42]),
         new ConditionEffect("Ninja Speedy",NINJA_SPEEDY_BIT,[0]),
         new ConditionEffect("Unstable", UNSTABLE_BIT, [56]),
         new ConditionEffect("Curse", CURSE_BIT, [58]),
         new ConditionEffect("Darkness", DARKNESS_BIT, [57]),
         new ConditionEffect("Petrify", PETRIFY_BIT, null),
         new ConditionEffect("Silenced", SILENCED_BIT, [59]),
         new ConditionEffect("Hidden", HIDDEN_BIT, [27], true),
         new ConditionEffect("Ninja Berserk", NINJABERSERK_BIT, [50]),
         new ConditionEffect("Ninja Damaging", NINJADAMAGING_BIT, [49]),
         new ConditionEffect("Slowed Immune", SLOWEDIMMUNE_BIT, null),
         new ConditionEffect("Dazed Immune", DAZEDIMMUNE_BIT, null),
         new ConditionEffect("Paralyze Immune", PARALYZEIMMUNE_BIT, null),
         new ConditionEffect("Petrify Immune", PETRIFYIMMUNE_BIT, null),
         new ConditionEffect("Curse Immune", CURSEIMMUNE_BIT, null),
         new ConditionEffect("Armor Break Immune", ARMORBREAKIMMUNE_BIT, null),
         new ConditionEffect("HP Boost", HP_BOOST_BIT, [32], true),
         new ConditionEffect("MP Boost", MP_BOOST_BIT, [33], true),
         new ConditionEffect("Attack Boost", ATT_BOOST_BIT, [34], true),
         new ConditionEffect("Defense Boost", DEF_BOOST_BIT, [35], true),
         new ConditionEffect("Speed Boost", SPD_BOOST_BIT, [36], true),
         new ConditionEffect("Dexterity Boost", DEX_BOOST_BIT, [37], true),
         new ConditionEffect("Vitality Boost", VIT_BOOST_BIT, [38], true),
         new ConditionEffect("Wisdom Boost", WIS_BOOST_BIT, [39], true),
         new ConditionEffect("Regeneration", REGENERATION_BIT, null),
         new ConditionEffect("MPTRegeneration", MPTREGENERATION_BIT, null),
         new ConditionEffect("Unstable Immune", UNSTABLEIMMUNE_BIT, null)];


      private static var conditionEffectFromName_:Object = null;
      private static var effectIconCache:Object = null;
      private static var bitToIcon_:Object = null;
      private static var bitToIcon2_:Object = null;
      private static const GLOW_FILTER:GlowFilter = new GlowFilter(0,0.3,6,6,2,BitmapFilterQuality.LOW,false,false);
       
      
      public var name_:String;
      public var bit_:uint;
      public var iconOffsets_:Array;
      public var icon16Bit_:Boolean;
      
      public function ConditionEffect(name:String, bit:uint, iconOffsets:Array, icon16:Boolean = false)
      {
         super();
         this.name_ = name;
         this.bit_ = bit;
         this.iconOffsets_ = iconOffsets;
         this.icon16Bit_ = icon16;
      }


      public static function getConditionEffectFromName(name:String):uint {
         var _local2:uint;
         if (conditionEffectFromName_ == null) {
            conditionEffectFromName_ = new Object();
            _local2 = 0;
            while (_local2 < effects_.length) {
               conditionEffectFromName_[effects_[_local2].name_] = _local2;
               _local2++;
            }
         }
         return (conditionEffectFromName_[name]);
      }

      public static function getConditionEffectEnumFromName(name:String):ConditionEffect {
         var _local2:ConditionEffect;
         for each (_local2 in effects_) {
            if (_local2.name_ == name) {
               return (_local2);
            }
         }
         return null;
      }

      public static function getConditionEffectIcons(ce:uint, icons:Vector.<BitmapData>, index:int):void {
         var _local4:uint;
         var _local5:uint;
         var _local6:Vector.<BitmapData>;
         while (ce != 0) {
            _local4 = (ce & (ce - 1));
            _local5 = (ce ^ _local4);
            _local6 = getIconsFromBit(_local5);
            if (_local6 != null) {
               icons.push(_local6[(index % _local6.length)]);
            }
            ce = _local4;
         }
      }

      public static function getConditionEffectIcons2(ce:uint, icons:Vector.<BitmapData>, index:int):void {
         var _local4:uint;
         var _local5:uint;
         var _local6:Vector.<BitmapData>;
         while (ce != 0) {
            _local4 = (ce & (ce - 1));
            _local5 = (ce ^ _local4);
            _local6 = getIconsFromBit2(_local5);
            if (_local6 != null) {
               icons.push(_local6[(index % _local6.length)]);
            }
            ce = _local4;
         }
      }

      private static function getIconsFromBit(_arg1:uint):Vector.<BitmapData> {
         var matrix:Matrix;
         var ce:uint;
         var icons:Vector.<BitmapData>;
         var i:int;
         var icon:BitmapData;
         if (bitToIcon_ == null) {
            bitToIcon_ = new Object();
            matrix = new Matrix();
            matrix.translate(4, 4);
            ce = 0;
            while (ce < 32) {
               icons = null;
               if (effects_[ce].iconOffsets_ != null) {
                  icons = new Vector.<BitmapData>();
                  i = 0;
                  while (i < effects_[ce].iconOffsets_.length) {
                     icon = new BitmapDataSpy(16, 16, true, 0);
                     icon.draw(AssetLibrary.getImageFromSet("lofiInterface2", effects_[ce].iconOffsets_[i]), matrix);
                     icon = GlowRedrawer.outlineGlow(icon, 0xFFFFFFFF);
                     icon.applyFilter(icon, icon.rect, PointUtil.ORIGIN, GLOW_FILTER);
                     icons.push(icon);
                     i++;
                  }
               }
               bitToIcon_[effects_[ce].bit_] = icons;
               ce++;
            }
         }
         return (bitToIcon_[_arg1]);
      }

      private static function getIconsFromBit2(_arg1:uint):Vector.<BitmapData> {
         var icons:Vector.<BitmapData>;
         var icon:BitmapData;
         var matrix1:Matrix;
         var matrix2:Matrix;
         var ce:uint;
         var i:int;
         if (bitToIcon2_ == null) {
            bitToIcon2_ = [];
            icons = new Vector.<BitmapData>();
            matrix1 = new Matrix();
            matrix1.translate(4, 4);
            matrix2 = new Matrix();
            matrix2.translate(1.5, 1.5);
            ce = 32;
            while (ce < effects_.length) {
               icons = null;
               if (effects_[ce].iconOffsets_ != null) {
                  icons = new Vector.<BitmapData>();
                  i = 0;
                  while (i < effects_[ce].iconOffsets_.length) {
                     if (effects_[ce].icon16Bit_) {
                        icon = new BitmapDataSpy(18, 18, true, 0);
                        icon.draw(AssetLibrary.getImageFromSet("lofiInterfaceBig", effects_[ce].iconOffsets_[i]), matrix2);
                     }
                     else {
                        icon = new BitmapDataSpy(16, 16, true, 0);
                        icon.draw(AssetLibrary.getImageFromSet("lofiInterface2", effects_[ce].iconOffsets_[i]), matrix1);
                     }
                     icon = GlowRedrawer.outlineGlow(icon, 0xFFFFFFFF);
                     icon.applyFilter(icon, icon.rect, PointUtil.ORIGIN, GLOW_FILTER);
                     icons.push(icon);
                     i++;
                  }
               }
               bitToIcon2_[effects_[ce].bit_] = icons;
               ce++;
            }
         }
         if (((!((bitToIcon2_ == null))) && (!((bitToIcon2_[_arg1] == null))))) {
            return (bitToIcon2_[_arg1]);
         }
         return null;
      }
   }
}
