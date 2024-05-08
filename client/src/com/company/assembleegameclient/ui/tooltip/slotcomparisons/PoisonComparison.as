package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   public class PoisonComparison extends SlotComparison
   {


      public function PoisonComparison()
      {
         super();
      }

      override protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
         var activate:XMLList;
         var otherActivate:XMLList;
         var damage:int;
         var otherDamage:int;
         var radius:Number;
         var otherRadius:Number;
         var duration:Number;
         var otherDuration:Number;
         var avg:Number;
         var otherAvg:Number;
         var text:String;
         var itemXML:XML = itemXML;
         var curItemXML:XML = curItemXML;
         activate = itemXML.Activate.(text() == "PoisonGrenade");
         otherActivate = curItemXML.Activate.(text() == "PoisonGrenade");
         comparisonText = "";
         if ((((activate.length() == 1)) && ((otherActivate.length() == 1)))){
            damage = int(activate[0].@totalDamage);
            otherDamage = int(otherActivate[0].@totalDamage);
            radius = Number(activate[0].@radius);
            otherRadius = Number(otherActivate[0].@radius);
            duration = Number(activate[0].@duration);
            otherDuration = Number(otherActivate[0].@duration);
            avg = (((0.33 * damage) + (0.33 * radius)) + (0.33 * duration));
            otherAvg = (((0.33 * otherDamage) + (0.33 * otherRadius)) + (0.33 * otherDuration));
            text = (((((damage + " HP over ") + duration) + " secs within ") + radius) + " sqrs\n");
            comparisonText = (comparisonText + ("Poison Grenade: " + wrapInColoredFont(text, getTextColor((avg - otherAvg)))));
            processedTags[activate[0].toXMLString()] = true;
         }
      }
   }
}
