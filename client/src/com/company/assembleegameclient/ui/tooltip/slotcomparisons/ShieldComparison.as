package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   public class ShieldComparison extends SlotComparison
   {
       
      
      private var projectileComparison:GeneralProjectileComparison;
      
      public function ShieldComparison()
      {
         super();
         this.projectileComparison = new GeneralProjectileComparison();
      }
      
      override protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
         var key:* = null;
         this.projectileComparison.compare(itemXML,curItemXML);
         comparisonText = this.projectileComparison.comparisonText;
         for(key in this.projectileComparison.processedTags)
         {
            processedTags[key] = this.projectileComparison.processedTags[key];
         }
         this.handleException(itemXML);
      }
      
      private function handleException(itemXML:XML) : void
      {
         var tag:XML = null;
         var str:String = null;
         if(itemXML.@id == "Shield of Ogmur")
         {
            tag = itemXML.ConditionEffect.(text() == "Armor Broken")[0];
            str = "Armor Broken for " + tag.@duration + " secs\n";
            str = "Mob Damage Effect: " + wrapInColoredFont(str,UNTIERED_COLOR);
            comparisonText = comparisonText + str;
            processedTags[tag.toXMLString()] = str;
         }
      }
   }
}
