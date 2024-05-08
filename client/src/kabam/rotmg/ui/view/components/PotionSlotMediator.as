package kabam.rotmg.ui.view.components
{
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;
   import com.company.assembleegameclient.util.DisplayHierarchy;
   import flash.display.DisplayObject;
   import kabam.rotmg.constants.ItemConstants;
   import kabam.rotmg.game.model.PotionInventoryModel;
   import kabam.rotmg.game.model.UseBuyPotionVO;
   import kabam.rotmg.game.signals.UseBuyPotionSignal;
   import kabam.rotmg.messaging.impl.GameServerConnection;
   import kabam.rotmg.ui.model.HUDModel;
   import kabam.rotmg.ui.model.PotionModel;
   import kabam.rotmg.ui.signals.UpdateHUDSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class PotionSlotMediator extends Mediator
   {
       
      
      [Inject]
      public var view:PotionSlotView;
      
      [Inject]
      public var hudModel:HUDModel;
      
      [Inject]
      public var updateHUD:UpdateHUDSignal;
      
      [Inject]
      public var potionInventoryModel:PotionInventoryModel;
      
      [Inject]
      public var useBuyPotionSignal:UseBuyPotionSignal;
      
      public function PotionSlotMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.updateHUD.addOnce(this.initializeData);
         this.view.drop.add(this.onDrop);
         this.view.buyUse.add(this.onBuyUse);
         this.updateHUD.add(this.update);
      }
      
      override public function destroy() : void
      {
         this.view.drop.remove(this.onDrop);
         this.view.buyUse.remove(this.onBuyUse);
         this.updateHUD.remove(this.update);
      }
      
      private function initializeData(player:Player) : void
      {
         var potionModel:PotionModel = this.potionInventoryModel.potionModels[this.view.position];
         var count:int = player.getPotionCount(potionModel.objectId);
         this.view.setData(count,potionModel.available,potionModel.objectId);
      }
      
      private function update(player:Player) : void
      {
         var potModel:PotionModel = null;
         var count:int = 0;
         if(this.view.objectType == PotionInventoryModel.HEALTH_POTION_ID || this.view.objectType == PotionInventoryModel.MAGIC_POTION_ID)
         {
            potModel = this.potionInventoryModel.getPotionModel(this.view.objectType);
            count = player.getPotionCount(potModel.objectId);
            this.view.setData(count,potModel.available);
         }
      }
      
      private function onDrop(targetDO:DisplayObject) : void
      {
         var tile:InteractiveItemTile = null;
         var player:Player = this.hudModel.gameSprite.map.player_;
         var target:* = DisplayHierarchy.getParentWithTypeArray(targetDO,InteractiveItemTile,Map);
         if(target is Map || Parameters.isGpuRender() && target == null)
         {
            GameServerConnection.instance.invDrop(player,PotionInventoryModel.getPotionSlot(this.view.objectType),this.view.objectType);
         }
         else if(target is InteractiveItemTile)
         {
            tile = target as InteractiveItemTile;
            if(tile.getItemId() == ItemConstants.NO_ITEM && tile.ownerGrid.owner != player)
            {
               GameServerConnection.instance.invSwapPotion(player,player,PotionInventoryModel.getPotionSlot(this.view.objectType),this.view.objectType,tile.ownerGrid.owner,tile.tileId,ItemConstants.NO_ITEM);
            }
         }
      }
      
      private function onBuyUse() : void
      {
         var vo:UseBuyPotionVO = null;
         var potModel:PotionModel = this.potionInventoryModel.potionModels[this.view.position];
         if(potModel.available)
         {
            vo = new UseBuyPotionVO(potModel.objectId,UseBuyPotionVO.SHIFTCLICK);
            this.useBuyPotionSignal.dispatch(vo);
         }
      }
   }
}
