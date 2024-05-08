package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   public class SealComparison extends SlotComparison
   {
       
      
      private var healingTag:XML;
      
      private var damageTag:XML;
      
      private var otherHealingTag:XML;
      
      private var otherDamageTag:XML;
      
      public function SealComparison()
      {
         super();
      }
      
      override protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
         var tag:XML = null;
         comparisonText = "";
         this.healingTag = this.getEffectTag(itemXML,"Healing");
         this.damageTag = this.getEffectTag(itemXML,"Damaging");
         this.otherHealingTag = this.getEffectTag(curItemXML,"Healing");
         this.otherDamageTag = this.getEffectTag(curItemXML,"Damaging");
         if(this.canCompare())
         {
            this.handleHealingText();
            this.handleDamagingText();
            if(itemXML.@id == "Seal of Blasphemous Prayer")
            {
               tag = itemXML.Activate.(text() == "ConditionEffectSelf")[0];
               comparisonText = comparisonText + ("Effect on Self:\n" + wrapInColoredFont("Invulnerable for " + tag.@duration + " secs\n",UNTIERED_COLOR));
               processedTags[tag.toXMLString()] = true;
            }
         }
      }
      
      private function canCompare() : Boolean
      {
         return this.healingTag != null && this.damageTag != null && this.otherHealingTag != null && this.otherDamageTag != null;
      }
      
      private function getEffectTag(xml:XML, effectName:String) : XML
      {
         var matches:XMLList = null;
         var tag:XML = null;
         matches = xml.Activate.(text() == "ConditionEffectAura");
         for each(tag in matches)
         {
            if(tag.@effect == effectName)
            {
               return tag;
            }
         }
         return null;
      }
      
      private function handleHealingText() : void
      {
         var duration:int = int(this.healingTag.@duration);
         var otherDuration:int = int(this.otherHealingTag.@duration);
         var range:Number = Number(this.healingTag.@range);
         var otherRange:Number = Number(this.otherHealingTag.@range);
         var avg:Number = 0.5 * duration * 0.5 * range;
         var otherAvg:Number = 0.5 * otherDuration * 0.5 * otherRange;
         var str:String = "Within " + this.healingTag.@range + " sqrs\nHealing for " + duration + " seconds\n";
         comparisonText = comparisonText + ("Party Effect: " + wrapInColoredFont(str,getTextColor(avg - otherAvg)));
         processedTags[this.healingTag.toXMLString()] = true;
      }
      
      private function handleDamagingText() : void
      {
         var duration:int = int(this.damageTag.@duration);
         var otherDuration:int = int(this.otherDamageTag.@duration);
         var range:Number = Number(this.damageTag.@range);
         var otherRange:Number = Number(this.otherDamageTag.@range);
         var avg:Number = 0.5 * duration * 0.5 * range;
         var otherAvg:Number = 0.5 * otherDuration * 0.5 * otherRange;
         var str:String = "Within " + this.damageTag.@range + " sqrs\nDamaging for " + duration + " seconds\n";
         comparisonText = comparisonText + ("Party Effect: " + wrapInColoredFont(str,getTextColor(avg - otherAvg)));
         processedTags[this.damageTag.toXMLString()] = true;
      }
   }
}
