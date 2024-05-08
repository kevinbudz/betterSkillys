package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import flash.utils.Dictionary;
   
   public class SlotComparison
   {
      public static const BETTER_COLOR:String = "#00ff00";
      public static const WORSE_COLOR:String = "#ff0000";
      public static const NO_DIFF_COLOR:String = "#FFFF8F";
      public static const LABEL_COLOR:String = "#B3B3B3";
      public static const UNTIERED_COLOR:String = "#8a2be2";

      public var processedTags:Dictionary;
      public var processedActivateOnEquipTags:Dictionary;
      public var comparisonText:String;
      
      public function SlotComparison()
      {
         super();
      }
      
      public function compare(itemXML:XML, curItemXML:XML) : void
      {
         this.resetFields();
         this.compareSlots(itemXML,curItemXML);
      }
      
      protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
      }
      
      private function resetFields() : void
      {
         this.processedTags = new Dictionary();
         this.processedActivateOnEquipTags = new Dictionary();
      }
      
      protected function getTextColor(difference:Number) : String
      {
         if(difference < 0)
         {
            return WORSE_COLOR;
         }
         if(difference > 0)
         {
            return BETTER_COLOR;
         }
         return NO_DIFF_COLOR;
      }
      
      protected function wrapInColoredFont(text:String, color:String = "#FFFF8F") : String
      {
         return "<font color=\"" + color + "\">" + text + "</font>";
      }
   }
}
