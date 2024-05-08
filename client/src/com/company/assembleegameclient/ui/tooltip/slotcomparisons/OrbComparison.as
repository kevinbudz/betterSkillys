package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   public class OrbComparison extends SlotComparison
   {
       
      
      public function OrbComparison()
      {
         super();
      }
      
      override protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
         var stasisBlast:XML = null;
         var otherStasisBlast:XML = null;
         var duration:int = 0;
         var otherDuration:int = 0;
         var textColor:String = null;
         stasisBlast = this.getStasisBlastTag(itemXML);
         otherStasisBlast = this.getStasisBlastTag(curItemXML);
         comparisonText = "";
         if(stasisBlast != null && otherStasisBlast != null)
         {
            duration = int(stasisBlast.@duration);
            otherDuration = int(otherStasisBlast.@duration);
            textColor = getTextColor(duration - otherDuration);
            comparisonText = comparisonText + ("Stasis on group: " + wrapInColoredFont(duration + " secs\n",textColor));
            processedTags[stasisBlast.toXMLString()] = true;
            this.handleExceptions(itemXML);
         }
      }
      
      private function getStasisBlastTag(orbXML:XML) : XML
      {
         var matches:XMLList = null;
         matches = orbXML.Activate.(text() == "StasisBlast");
         return matches.length() == 1?matches[0]:null;
      }
      
      private function handleExceptions(itemXML:XML) : void
      {
         var selfTags:XMLList = null;
         var speedy:XML = null;
         var damaging:XML = null;
         if(itemXML.@id == "Orb of Conflict")
         {
            selfTags = itemXML.Activate.(text() == "ConditionEffectSelf");
            speedy = selfTags.(@effect == "Speedy")[0];
            damaging = selfTags.(@effect == "Damaging")[0];
            comparisonText = comparisonText + ("Effect on Self:\n" + wrapInColoredFont("Speedy for " + speedy.@duration + " secs\n",UNTIERED_COLOR));
            comparisonText = comparisonText + ("Effect on Self:\n" + wrapInColoredFont("Damaging for " + damaging.@duration + "secs\n",UNTIERED_COLOR));
            processedTags[speedy.toXMLString()] = true;
            processedTags[damaging.toXMLString()] = true;
         }
      }
   }
}
