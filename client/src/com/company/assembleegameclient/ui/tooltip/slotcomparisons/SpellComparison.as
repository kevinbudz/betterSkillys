package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   public class SpellComparison extends SlotComparison
   {
       
      
      private var itemXML:XML;
      
      private var curItemXML:XML;
      
      private var projXML:XML;
      
      private var otherProjXML:XML;
      
      public function SpellComparison()
      {
         super();
      }
      
      override protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
         this.itemXML = itemXML;
         this.curItemXML = curItemXML;
         this.projXML = itemXML.Projectile[0];
         this.otherProjXML = curItemXML.Projectile[0];
         comparisonText = this.getDamageText();
         comparisonText = comparisonText + this.getRangeText();
         processedTags[this.projXML.toXMLString()] = true;
      }
      
      private function getDamageText() : String
      {
         if (this.projXML == null)
             return "";
         var minDamage:int = int(this.projXML.MinDamage);
         var maxDamage:int = int(this.projXML.MaxDamage);
         var otherMinDamage:int = int(this.otherProjXML.MinDamage);
         var otherMaxDamage:int = int(this.otherProjXML.MaxDamage);
         var average:Number = (minDamage + maxDamage) / 2;
         var otherAverage:Number = (otherMinDamage + otherMaxDamage) / 2;
         var textColor:String = getTextColor(average - otherAverage);
         var dmgStr:String = minDamage == maxDamage?maxDamage.toString():minDamage + " - " + maxDamage;
         return "Damage: <font color=\"" + textColor + "\">" + dmgStr + "</font>\n";
      }
      
      private function getRangeText() : String
      {
         if (this.projXML == null)
            return "";
         var range:Number = Number(this.projXML.Speed) * Number(this.projXML.LifetimeMS) / 10000;
         var otherRange:Number = Number(this.otherProjXML.Speed) * Number(this.otherProjXML.LifetimeMS) / 10000;
         var textColor:String = getTextColor(range - otherRange);
         return "Range: <font color=\"" + textColor + "\">" + range + "</font>\n";
      }
   }
}
