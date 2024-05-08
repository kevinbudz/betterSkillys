package kabam.rotmg.game.model
{
   import flash.utils.Dictionary;
   import kabam.rotmg.ui.model.PotionModel;
   import org.osflash.signals.Signal;
   
   public class PotionInventoryModel
   {
      
      public static const HEALTH_POTION_ID:int = 2594;
      
      public static const HEALTH_POTION_SLOT:int = 254;
      
      public static const MAGIC_POTION_ID:int = 2595;
      
      public static const MAGIC_POTION_SLOT:int = 255;
       
      
      public var potionModels:Dictionary;
      
      public var updatePosition:Signal;
      
      public function PotionInventoryModel()
      {
         super();
         this.potionModels = new Dictionary();
         this.updatePosition = new Signal(int);
      }
      
      public static function getPotionSlot(objectType:int) : int
      {
         switch(objectType)
         {
            case HEALTH_POTION_ID:
               return HEALTH_POTION_SLOT;
            case MAGIC_POTION_ID:
               return MAGIC_POTION_SLOT;
            default:
               return -1;
         }
      }
      
      public function initializePotionModels(xml:XML) : void
      {
         var potModel:PotionModel = null;
         var maxStackable:int = xml.MaxStackablePotions;
         potModel = new PotionModel();
         potModel.maxPotionCount = maxStackable;
         potModel.objectId = HEALTH_POTION_ID;
         potModel.position = 0;
         this.potionModels[potModel.position] = potModel;
         potModel.update.add(this.update);
         potModel = new PotionModel();
         potModel.maxPotionCount = maxStackable;
         potModel.objectId = MAGIC_POTION_ID;
         potModel.position = 1;
         this.potionModels[potModel.position] = potModel;
         potModel.update.add(this.update);
      }
      
      public function getPotionModel(objectId:uint) : PotionModel
      {
         var key:* = null;
         for(key in this.potionModels)
         {
            if(this.potionModels[key].objectId == objectId)
            {
               return this.potionModels[key];
            }
         }
         return null;
      }
      
      private function update(position:int) : void
      {
         this.updatePosition.dispatch(position);
      }
   }
}
