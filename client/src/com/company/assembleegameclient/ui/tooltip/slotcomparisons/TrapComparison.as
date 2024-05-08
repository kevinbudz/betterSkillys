package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   public class TrapComparison extends SlotComparison
   {
       
      
      public function TrapComparison()
      {
         super();
      }
      
      private function getTrapTag(xml:XML) : XML
      {
         var matches:XMLList = null;
         matches = xml.Activate.(text() == "Trap");
         if(matches.length() >= 1)
         {
            return matches[0];
         }
         return null;
      }
      
      override protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
         var trap:XML = null;
         var otherTrap:XML = null;
         var tag:XML = null;
         var text:String = null;
         var radius:Number = NaN;
         var otherRadius:Number = NaN;
         var damage:int = 0;
         var otherDamage:int = 0;
         var duration:int = 0;
         var otherDuration:int = 0;
         var avg:Number = NaN;
         var otherAvg:Number = NaN;
         var textColor:String = null;
         var compositeHtml:String = null;
         trap = this.getTrapTag(itemXML);
         otherTrap = this.getTrapTag(curItemXML);
         comparisonText = "";
         if(trap != null && otherTrap != null)
         {
            if(itemXML.@id == "Coral Venom Trap")
            {
               tag = itemXML.Activate.(text() == "Trap")[0];
               text = tag.@totalDamage + " HP within " + tag.@radius + " sqrs\n" + "Paralyzed for " + tag.@condDuration + " seconds\n";
               comparisonText = comparisonText + ("Trap: " + wrapInColoredFont(text,UNTIERED_COLOR));
               processedTags[tag.toXMLString()] = true;
            }
            else
            {
               radius = Number(trap.@radius);
               otherRadius = Number(otherTrap.@radius);
               damage = int(trap.@totalDamage);
               otherDamage = int(otherTrap.@totalDamage);
               duration = int(trap.@condDuration);
               otherDuration = int(otherTrap.@condDuration);
               avg = 0.33 * radius + 0.33 * damage + 0.33 * duration;
               otherAvg = 0.33 * otherRadius + 0.33 * otherDamage + 0.33 * otherDuration;
               textColor = getTextColor(avg - otherAvg);
               compositeHtml = damage + " HP within " + radius + " sqrs\n" + " Slowed for " + duration + " seconds\n";
               comparisonText = comparisonText + ("Trap: " + wrapInColoredFont(compositeHtml,textColor));
               processedTags[trap.toXMLString()] = true;
            }
         }
      }
   }
}
