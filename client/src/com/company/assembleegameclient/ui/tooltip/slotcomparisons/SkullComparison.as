package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
import kabam.rotmg.constants.ActivationType;

public class SkullComparison extends SlotComparison
   {
       
      
      public function SkullComparison()
      {
         super();
      }
      
      override protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
         var blast:XML = null;
         var otherBlast:XML = null;
         var radius:Number = NaN;
         var otherRadius:Number = NaN;
         var damage:int = 0;
         var otherDamage:int = 0;
         var avg:Number = NaN;
         var otherAvg:Number = NaN;
         blast = this.getVampireBlastTag(itemXML);
         otherBlast = this.getVampireBlastTag(curItemXML);
         comparisonText = "";
         if(blast != null && otherBlast != null)
         {
            radius = Number(blast.@radius);
            otherRadius = Number(otherBlast.@radius);
            damage = int(blast.@totalDamage);
            otherDamage = int(otherBlast.@totalDamage);
            avg = 0.5 * radius + 0.5 * damage;
            otherAvg = 0.5 * otherRadius + 0.5 * otherDamage;
            comparisonText = comparisonText + ("Steal: " + wrapInColoredFont(damage + " HP within " + radius + " sqrs\n",getTextColor(avg - otherAvg)));
            processedTags[blast.toXMLString()] = true;
         }
      }
      
      private function getVampireBlastTag(xml:XML) : XML
      {
         var matches:XMLList = null;
         matches = xml.Activate.(text() == ActivationType.VAMPIRE_BLAST);
         return matches.length() >= 1?matches[0]:null;
      }
   }
}
