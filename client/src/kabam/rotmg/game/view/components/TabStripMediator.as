package kabam.rotmg.game.view.components
{
   import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.panels.itemgrids.InventoryGrid;
   import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
   import kabam.rotmg.assets.services.IconFactory;
   import kabam.rotmg.constants.GeneralConstants;
   import kabam.rotmg.ui.model.HUDModel;
   import kabam.rotmg.ui.model.TabStripModel;
import kabam.rotmg.ui.signals.StatsTabHotKeyInputSignal;
import kabam.rotmg.ui.signals.UpdateBackpackTabSignal;
   import kabam.rotmg.ui.signals.UpdateHUDSignal;
   import kabam.rotmg.ui.view.PotionInventoryView;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class TabStripMediator extends Mediator
   {
       
      
      [Inject]
      public var view:TabStripView;
      
      [Inject]
      public var hudModel:HUDModel;
      
      [Inject]
      public var tabStripModel:TabStripModel;
      
      [Inject]
      public var updateHUD:UpdateHUDSignal;
      
      [Inject]
      public var updateBackpack:UpdateBackpackTabSignal;
      
      [Inject]
      public var iconFactory:IconFactory;

      [Inject]
      public var statsTabHotKeyInput:StatsTabHotKeyInputSignal;
      
      public function TabStripMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.tabSelected.add(this.onTabSelected);
         this.updateHUD.addOnce(this.addTabs);
         this.statsTabHotKeyInput.add(this.onTabHotkey);
      }
      
      override public function destroy() : void
      {
         this.view.tabSelected.remove(this.onTabSelected);
         this.updateBackpack.remove(this.onUpdateBackPack);
      }
      
      private function addTabs(player:Player) : void
      {
         this.addInventoryTab(player);
         this.addStatsTab();
         if(player.hasBackpack_)
         {
            this.addBackPackTab(player);
         }
         else
         {
            this.updateBackpack.add(this.onUpdateBackPack);
         }
         if (player.rank >= 5)
            this.AddModMenu();
      }
      
      private function onTabSelected(name:String) : void
      {
         this.tabStripModel.currentSelection = name;
      }
      
      private function onUpdateBackPack(hasBackpack:Boolean) : void
      {
         trace(hasBackpack);
         if(hasBackpack)
         {
            this.addBackPackTab(this.hudModel.gameSprite.map.player_);
            this.updateBackpack.remove(this.onUpdateBackPack);
         }
      }

      private function onTabHotkey():void
      {
         var index:int = (this.view.currentTabIndex + 1);
         index = (index % this.view.tabs.length);
         this.view.setSelectedTab(index);
      }
      
      private function addInventoryTab(player:Player) : void
      {
         var storageContent:Sprite = new Sprite();
         storageContent.name = TabStripModel.MAIN_INVENTORY;
         storageContent.x = storageContent.y = 7;
         var storage:InventoryGrid = new InventoryGrid(player,player,4);
         storageContent.addChild(storage);
         var potionsInventory:PotionInventoryView = new PotionInventoryView();
         potionsInventory.y = storage.height + 4;
         storageContent.addChild(potionsInventory);
         var icon:Bitmap = this.iconFactory.makeIconBitmap(24);
         this.view.addTab(icon,storageContent);
      }
      
      private function addStatsTab() : void
      {
         var stats:StatsView = null;
         stats = new StatsView(191,45);
         stats.name = TabStripModel.STATS;
         stats.y = (this.view.h - TabStripView.TAB_TOP_OFFSET) / 2 - stats.height / 2;
         var icon:Bitmap = this.iconFactory.makeIconBitmap(25);
         this.view.addTab(icon,stats);
      }

      private function addBackPackTab(player:Player) : void
      {
         var backpackPotionsInventory:PotionInventoryView = null;
         var backpackContent:Sprite = new Sprite();
         backpackContent.name = TabStripModel.BACKPACK;
         backpackContent.x = backpackContent.y = 7;
         var backpack:InventoryGrid = new InventoryGrid(player,player,GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS,true);
         backpackContent.addChild(backpack);
         backpackPotionsInventory = new PotionInventoryView();
         backpackPotionsInventory.y = backpack.height + 4;
         backpackContent.addChild(backpackPotionsInventory);
         var icon:Bitmap = this.iconFactory.makeIconBitmap(26);
         this.view.addTab(icon,backpackContent);
      }

      private function AddModMenu():void
      {
         var modMenuContent:Sprite = new Sprite();
         modMenuContent.name = TabStripModel.MOD_MENU;
         modMenuContent.x = modMenuContent.y = 12;
         var modMenu:ModMenu = new ModMenu(this.view.gs_);
         modMenuContent.addChild(modMenu);
         var icon:Bitmap = this.iconFactory.makeIconBitmap(30);
         this.view.addTab(icon, modMenuContent);
      }
   }
}
