package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
import kabam.rotmg.constants.ActivationType;

public class CloakComparison extends SlotComparison
   {
       
      
      public function CloakComparison()
      {
         super();
      }
      
      override protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
         var inv:XML = null;
         var otherInv:XML = null;
         var duration:Number = NaN;
         var otherDuration:Number = NaN;
         inv = this.getInvisibleTag(itemXML);
         otherInv = this.getInvisibleTag(curItemXML);
         comparisonText = "";
         if(inv != null && otherInv != null)
         {
            duration = Number(inv.@duration);
            otherDuration = Number(otherInv.@duration);
            comparisonText = comparisonText + this.getDurationText(duration,otherDuration);
            processedTags[inv.toXMLString()] = true;
         }
         this.handleExceptions(itemXML);
      }
      
      private function handleExceptions(itemXML:XML) : void
      {
         var teleportTag:XML = null;
         if(itemXML.@id == "Cloak of the Planewalker")
         {
            comparisonText = comparisonText + wrapInColoredFont("Teleport to Target\n",UNTIERED_COLOR);
            teleportTag = XML(itemXML.Activate.(text() == ActivationType.TELEPORT))[0];
            processedTags[teleportTag.toXMLString()] = true;
         }
      }
      
      private function getInvisibleTag(xml:XML) : XML
      {
         var matches:XMLList = null;
         var conditionTag:XML = null;
         matches = xml.Activate.(text() == ActivationType.COND_EFFECT_SELF);
         for each(conditionTag in matches)
         {
            if(conditionTag.(@effect == "Invisible"))
            {
               return conditionTag;
            }
         }
         return null;
      }
      
      private function getDurationText(duration:Number, otherDuration:Number) : String
      {
         var html:String = "";
         var textColor:String = getTextColor(duration - otherDuration);
         html = "Effect on Self:\n";
         html = html + wrapInColoredFont("Invisible for " + duration + " secs\n",textColor);
         return html;
      }
   }
}
