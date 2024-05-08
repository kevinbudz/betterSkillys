package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   public class TomeComparison extends SlotComparison
   {
       
      
      public function TomeComparison()
      {
         super();
      }
      
      override protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
         var nova:XMLList = null;
         var otherNova:XMLList = null;
         var tag:XML = null;
         var range:int = 0;
         var otherRange:int = 0;
         var amount:int = 0;
         var otherAmount:int = 0;
         var wavg:Number = NaN;
         var otherWavg:Number = NaN;
         var effectText:String = null;
         nova = itemXML.Activate.(text() == "HealNova");
         otherNova = curItemXML.Activate.(text() == "HealNova");
         comparisonText = "";
         if(nova.length() == 1 && otherNova.length() == 1)
         {
            range = int(itemXML.Activate.@range);
            otherRange = int(curItemXML.Activate.@range);
            amount = int(itemXML.Activate.@amount);
            otherAmount = int(curItemXML.Activate.@amount);
            wavg = 0.5 * range + 0.5 * amount;
            otherWavg = 0.5 * otherRange + 0.5 * otherAmount;
            if(itemXML.@id == "Tome of Purification")
            {
               range = 6;
            }
            effectText = amount + " HP within " + range + " sqrs\n";
            comparisonText = comparisonText + ("Party Heal: " + wrapInColoredFont(effectText,getTextColor(wavg - otherWavg)));
            processedTags[nova.toXMLString()] = true;
         }
         if(itemXML.@id == "Tome of Purification")
         {
            tag = itemXML.Activate.(text() == "RemoveNegativeConditions")[0];
            comparisonText = comparisonText + wrapInColoredFont("Removes negative conditions\n",UNTIERED_COLOR);
            processedTags[tag.toXMLString()] = true;
         }
         else if(itemXML.@id == "Tome of Holy Protection")
         {
            tag = itemXML.Activate.(text() == "ConditionEffectSelf")[0];
            comparisonText = comparisonText + ("Effect on Self:\n" + wrapInColoredFont("Armored for " + tag.@duration + " secs\n",UNTIERED_COLOR));
            processedTags[tag.toXMLString()] = true;
         }
      }
   }
}
