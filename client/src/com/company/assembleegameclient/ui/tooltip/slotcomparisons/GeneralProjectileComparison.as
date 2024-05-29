package com.company.assembleegameclient.ui.tooltip.slotcomparisons
{
   import com.company.assembleegameclient.ui.tooltip.TooltipHelper;
   
   public class GeneralProjectileComparison extends SlotComparison
   {
       
      
      private var itemXML:XML;
      
      private var curItemXML:XML;
      
      private var projXML:XML;
      
      private var otherProjXML:XML;
      
      public function GeneralProjectileComparison()
      {
         super();
      }
      
      override protected function compareSlots(itemXML:XML, curItemXML:XML) : void
      {
         var text:String = null;
         this.itemXML = itemXML;
         this.curItemXML = curItemXML;
         text = "";
         comparisonText = "";
         if(itemXML.hasOwnProperty("NumProjectiles"))
         {
            text = this.getNumProjectileText();
            comparisonText = comparisonText + text;
            processedTags[itemXML.NumProjectiles.toXMLString()] = text;
         }
         if(itemXML.hasOwnProperty("Projectile"))
         {
            text = this.getProjectileText();
            comparisonText = comparisonText + text;
            processedTags[itemXML.Projectile.toXMLString()] = text;
         }
      }
      
      private function getProjectileText() : String
      {
         var html:String = this.getDamageText();
         var range:Number = Number(this.projXML.Speed) * Number(this.projXML.LifetimeMS) / 10000;
         var otherRange:Number = Number(this.otherProjXML.Speed) * Number(this.otherProjXML.LifetimeMS) / 10000;
         var rangeStr:String = TooltipHelper.getFormattedRangeStr(range);
         html = html + (wrapInColoredFont("Range: ",LABEL_COLOR) + wrapInColoredFont(rangeStr + "\n",getTextColor(range - otherRange)));
         if(this.projXML.hasOwnProperty("MultiHit"))
         {
            html = html + wrapInColoredFont("Shots hit multiple targets\n",NO_DIFF_COLOR);
         }
         if(this.projXML.hasOwnProperty("PassesCover"))
         {
            html = html + wrapInColoredFont("Shots pass through obstacles\n",NO_DIFF_COLOR);
         }
         if(this.projXML.hasOwnProperty("ArmorPiercing"))
         {
            html = html + wrapInColoredFont("Ignores defense of the target\n",NO_DIFF_COLOR);
         }
         if(this.itemXML.Projectile.hasOwnProperty("ConditionEffect"))
         {
            html = html + "Shot Effect: " + wrapInColoredFont(this.itemXML.Projectile.ConditionEffect + " for " + this.itemXML.Projectile.ConditionEffect.@duration + " secs\n", NO_DIFF_COLOR);
         }
         return html;
      }
      
      private function getNumProjectileText() : String
      {
         var numProjectiles:int = int(this.itemXML.NumProjectiles);
         var otherNumProjectiles:int = int(this.curItemXML.NumProjectiles);
         var textColor:String = getTextColor(numProjectiles - otherNumProjectiles);
         return wrapInColoredFont("Shots: ",LABEL_COLOR) + wrapInColoredFont(numProjectiles.toString(),textColor) + "\n";
      }
      
      private function getDamageText() : String
      {
         var html:String = "";
         this.projXML = XML(this.itemXML.Projectile);
         var minD:int = int(this.projXML.MinDamage);
         var maxD:int = int(this.projXML.MaxDamage);
         var average:Number = (maxD + minD) / 2;
         this.otherProjXML = XML(this.curItemXML.Projectile);
         var otherMinD:int = int(this.otherProjXML.MinDamage);
         var otherMaxD:int = int(this.otherProjXML.MaxDamage);
         var otherAverage:Number = (otherMaxD + otherMinD) / 2;
         var damageStr:String = (minD == maxD?minD:minD + " - " + maxD).toString();
         html = wrapInColoredFont("Damage: ",LABEL_COLOR) + wrapInColoredFont(damageStr,getTextColor(average - otherAverage)) + "\n";
         return html;
      }
   }
}
