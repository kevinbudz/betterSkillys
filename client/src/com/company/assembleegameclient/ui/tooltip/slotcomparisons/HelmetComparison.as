package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
import kabam.rotmg.constants.ActivationType;

public class HelmetComparison extends SlotComparison
   {
       
      
      private var berserk:XML;
      
      private var speedy:XML;
      
      private var otherBerserk:XML;
      
      private var otherSpeedy:XML;
      
      private var armored:XML;
      
      private var otherArmored:XML;
      
      public function HelmetComparison()
      {
         super();
      }
      
      override protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
         this.extractDataFromXML(itemXML,curItemXML);
         comparisonText = "";
         this.handleBerserk();
         this.handleSpeedy();
         this.handleArmored();
      }
      
      private function extractDataFromXML(itemXML:XML, curItemXML:XML) : void
      {
         this.berserk = this.getAuraTagByType(itemXML,"Berserk");
         this.speedy = this.getSelfTagByType(itemXML,"Speedy");
         this.armored = this.getSelfTagByType(itemXML,"Armored");
         this.otherBerserk = this.getAuraTagByType(curItemXML,"Berserk");
         this.otherSpeedy = this.getSelfTagByType(curItemXML,"Speedy");
         this.otherArmored = this.getSelfTagByType(curItemXML,"Armored");
      }
      
      private function getAuraTagByType(xml:XML, typeName:String) : XML
      {
         var matches:XMLList = null;
         var tag:XML = null;
         matches = xml.Activate.(text() == ActivationType.COND_EFFECT_AURA);
         for each(tag in matches)
         {
            if(tag.@effect == typeName)
            {
               return tag;
            }
         }
         return null;
      }
      
      private function getSelfTagByType(xml:XML, typeName:String) : XML
      {
         var matches:XMLList = null;
         var tag:XML = null;
         matches = xml.Activate.(text() == ActivationType.COND_EFFECT_SELF);
         for each(tag in matches)
         {
            if(tag.@effect == typeName)
            {
               return tag;
            }
         }
         return null;
      }
      
      private function handleBerserk() : void
      {
         if(this.berserk == null || this.otherBerserk == null)
         {
            return;
         }
         var range:Number = Number(this.berserk.@range);
         var otherRange:Number = Number(this.otherBerserk.@range);
         var duration:Number = Number(this.berserk.@duration);
         var otherDuration:Number = Number(this.otherBerserk.@duration);
         var avg:Number = 0.5 * range + 0.5 * duration;
         var otherAvg:Number = 0.5 * otherRange + 0.5 * otherDuration;
         var text:String = "Within " + range + " sqrs\nBerserk for " + duration + " secs\n";
         comparisonText = comparisonText + ("Party Effect: " + wrapInColoredFont(text,getTextColor(avg - otherAvg)));
         processedTags[this.berserk.toXMLString()] = true;
      }
      
      private function handleSpeedy() : void
      {
         var duration:Number = NaN;
         var otherDuration:Number = NaN;
         var text:String = null;
         if(this.speedy != null && this.otherSpeedy != null)
         {
            duration = Number(this.speedy.@duration);
            otherDuration = Number(this.otherSpeedy.@duration);
            text = "Speedy for " + duration + " secs\n";
            comparisonText = comparisonText + ("Effect on Self:\n" + wrapInColoredFont(text,getTextColor(duration - otherDuration)));
            processedTags[this.speedy.toXMLString()] = true;
         }
         else if(this.speedy != null && this.otherSpeedy == null)
         {
            comparisonText = comparisonText + ("Effect on Self:\n" + wrapInColoredFont("Speedy for " + this.speedy.@duration + " secs\n",BETTER_COLOR));
            processedTags[this.speedy.toXMLString()] = true;
         }
      }
      
      private function handleArmored() : void
      {
         if(this.armored != null)
         {
            comparisonText = comparisonText + ("Effect on Self:\n" + wrapInColoredFont("Armored for " + this.armored.@duration + " secs\n",UNTIERED_COLOR));
            processedTags[this.armored.toXMLString()] = true;
         }
      }
   }
}
