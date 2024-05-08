package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   public class GenericArmorComparison extends SlotComparison
   {
      
      private static const DEFENSE_STAT:String = "21";
       
      
      private var defTags:XMLList;
      
      private var otherDefTags:XMLList;
      
      public function GenericArmorComparison()
      {
         super();
         comparisonText = "";
      }
      
      override protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
         var defense:int = 0;
         var otherDefense:int = 0;
         this.defTags = itemXML.ActivateOnEquip.(@stat == DEFENSE_STAT);
         this.otherDefTags = curItemXML.ActivateOnEquip.(@stat == DEFENSE_STAT);
         if(this.defTags.length() == 1 && this.otherDefTags.length() == 1)
         {
            defense = int(this.defTags.@amount);
            otherDefense = int(this.otherDefTags.@amount);
            processedActivateOnEquipTags[this.defTags[0].toXMLString()] = this.compareDefense(defense,otherDefense);
         }
      }
      
      private function compareDefense(defense:int, otherDefense:int) : String
      {
         var textColor:String = getTextColor(defense - otherDefense);
         return wrapInColoredFont("+" + defense + " Defense",textColor);
      }
   }
}
