package com.company.assembleegameclient.ui.tooltip
{
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.CloakComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.GeneralProjectileComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.GenericArmorComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.HelmetComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.OrbComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.PoisonComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.PrismComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.QuiverComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.ScepterComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.SealComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.ShieldComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.SkullComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.SlotComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.SpellComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.TomeComparison;
   import com.company.assembleegameclient.ui.tooltip.slotcomparisons.TrapComparison;
   import kabam.rotmg.constants.ItemConstants;
   
   public class SlotComparisonFactory
   {
       
      
      private var hash:Object;
      
      public function SlotComparisonFactory()
      {
         super();
         var projectileComparison:GeneralProjectileComparison = new GeneralProjectileComparison();
         var armorComparison:GenericArmorComparison = new GenericArmorComparison();
         this.hash = {};
         this.hash[ItemConstants.SWORD_TYPE] = projectileComparison;
         this.hash[ItemConstants.DAGGER_TYPE] = projectileComparison;
         this.hash[ItemConstants.BOW_TYPE] = projectileComparison;
         this.hash[ItemConstants.TOME_TYPE] = new TomeComparison();
         this.hash[ItemConstants.SHIELD_TYPE] = new ShieldComparison();
         this.hash[ItemConstants.LEATHER_TYPE] = armorComparison;
         this.hash[ItemConstants.PLATE_TYPE] = armorComparison;
         this.hash[ItemConstants.WAND_TYPE] = projectileComparison;
         this.hash[ItemConstants.SPELL_TYPE] = new SpellComparison();
         this.hash[ItemConstants.SEAL_TYPE] = new SealComparison();
         this.hash[ItemConstants.CLOAK_TYPE] = new CloakComparison();
         this.hash[ItemConstants.ROBE_TYPE] = armorComparison;
         this.hash[ItemConstants.QUIVER_TYPE] = new QuiverComparison();
         this.hash[ItemConstants.HELM_TYPE] = new HelmetComparison();
         this.hash[ItemConstants.STAFF_TYPE] = projectileComparison;
//         this.hash[ItemConstants.POISON_TYPE] = new PoisonComparison();
         this.hash[ItemConstants.SKULL_TYPE] = new SkullComparison();
         this.hash[ItemConstants.TRAP_TYPE] = new TrapComparison();
         this.hash[ItemConstants.ORB_TYPE] = new OrbComparison();
         this.hash[ItemConstants.PRISM_TYPE] = new PrismComparison();
         this.hash[ItemConstants.SCEPTER_TYPE] = new ScepterComparison();
         this.hash[ItemConstants.KATANA_TYPE] = projectileComparison;
         this.hash[ItemConstants.SHURIKEN_TYPE] = projectileComparison;
      }
      
      public function getComparisonResults(itemXML:XML, curItemXML:XML) : SlotComparisonResult
      {
         var slotTypeId:int = int(itemXML.SlotType);
         var comparator:SlotComparison = this.hash[slotTypeId];
         var result:SlotComparisonResult = new SlotComparisonResult();
         if(comparator != null)
         {
            comparator.compare(itemXML,curItemXML);
            result.text = comparator.comparisonText;
            result.processedTags = comparator.processedTags;
            result.processedActivateOnEquipTags = comparator.processedActivateOnEquipTags;
         }
         return result;
      }
   }
}
