package com.company.assembleegameclient.ui.panels.mediators
{
   import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid;
import com.company.assembleegameclient.ui.panels.itemgrids.InventoryGrid;

import kabam.rotmg.ui.signals.ToggleShowTierTagSignal;
import kabam.rotmg.ui.signals.UpdateHUDSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class InventoryGridMediator extends Mediator
   {
      [Inject]
      public var view:InventoryGrid;
      
      [Inject]
      public var updateHUD:UpdateHUDSignal;

      [Inject]
      public var toggleShowTierTag:ToggleShowTierTagSignal;
      
      public function InventoryGridMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.updateHUD.add(this.onUpdateHUD);
         this.toggleShowTierTag.add(this.onToggleShowTierTag);
      }
      
      override public function destroy() : void
      {
         this.updateHUD.remove(this.onUpdateHUD);
      }

      private function onToggleShowTierTag(_arg_1:Boolean) : void
      {
         this.view.toggleTierTags(_arg_1);
      }
      
      private function onUpdateHUD(player:Player) : void
      {
         this.view.draw();
      }
   }
}
