package com.company.assembleegameclient.ui.tooltip {
import com.company.util.MathUtil2;

import kabam.rotmg.constants.ItemConstants;

public class TooltipHelper {

   public static const BETTER_COLOR:String = "#00ff00";
   public static const WORSE_COLOR:String = "#ff0000";
   public static const NO_DIFF_COLOR:String = "#FFFF8F";
   public static const SPECIAL_COLOR:String = "#8A2BE2";
   public static const WISMOD_COLOR:String = "#4063E3";
   public static const UNTIERED_COLOR:uint = 0x8A2BE2;
   public static const SET_COLOR:uint = 0xFF9900;
   public static const SET_COLOR_INACTIVE:String = "6835752";

   public static function wrapInFontTag(text:String, color:String):String {
      var tagStr:String = "<font color=\"" + color + "\">" + text + "</font>";
      return tagStr;
   }

   public static function getFormattedRangeString(range:Number):Number {
      return MathUtil2.roundTo(range, 2);
   }

   public static function getFormattedRangeStr(_arg_1:Number):String {
      var _local_2:Number = (_arg_1 - int(_arg_1));
      return ((int((_local_2 * 10)) == 0) ? int(_arg_1).toString() : _arg_1.toFixed(1));
   }

   public static function getTextColor(difference:Number):String {
      if (difference < 0) {
         return WORSE_COLOR;
      }
      if (difference > 0) {
         return BETTER_COLOR;
      }
      return NO_DIFF_COLOR;
   }

   /*public static function getSpecialityColor(itemData:ItemData):uint {
      if (itemData.Tier != -1)
         return 16777215;
      if (ItemConstants.isEquippable(itemData.SlotType))
         return UNTIERED_COLOR;
      return 16777215;
   }

   public static function getSpecialityText(itemData:ItemData):String {
      if (itemData.Tier != -1)
         return "Tiered";
      if (itemData.Potion)
         return "Potion";
      if (ItemConstants.isEquippable(itemData.SlotType))
         return "Untiered";
      return "Miscellaneous";
   }*/
}
}
