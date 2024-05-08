package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   public class PrismComparison extends SlotComparison
   {
       
      
      private var decoy:XMLList;
      
      private var otherDecoy:XMLList;
      
      public function PrismComparison()
      {
         super();
      }
      
      override protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
         var duration:Number = NaN;
         var otherDuration:Number = NaN;
         this.decoy = itemXML.Activate.(text() == "Decoy");
         this.otherDecoy = curItemXML.Activate.(text() == "Decoy");
         comparisonText = "";
         if(this.decoy.length() == 1 && this.otherDecoy.length() == 1)
         {
            duration = Number(this.decoy[0].@duration);
            otherDuration = Number(this.otherDecoy[0].@duration);
            comparisonText = comparisonText + ("Decoy: " + wrapInColoredFont(duration.toString() + " secs\n",getTextColor(duration - otherDuration)));
            processedTags[this.decoy[0].toXMLString()] = true;
         }
      }
   }
}
