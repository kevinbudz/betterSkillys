package com.company.assembleegameclient.ui.panels.mediators
{
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.objects.Container;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.ObjectProperties;
import com.company.assembleegameclient.objects.OneWayContainer;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.sound.SoundEffectLibrary;
import com.company.assembleegameclient.ui.panels.itemgrids.ContainerGrid;
import com.company.assembleegameclient.ui.panels.itemgrids.InventoryGrid;
import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTileEvent;
import com.company.assembleegameclient.util.DisplayHierarchy;

import kabam.rotmg.constants.GeneralConstants;

import kabam.rotmg.constants.ItemConstants;
import kabam.rotmg.core.model.MapModel;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.game.model.PotionInventoryModel;
import kabam.rotmg.game.view.components.TabStripMediator;
import kabam.rotmg.game.view.components.TabStripView;
import kabam.rotmg.messaging.impl.GameServerConnection;
import kabam.rotmg.ui.model.HUDModel;
import kabam.rotmg.ui.model.TabStripModel;

import org.hamcrest.text.containsString;

import robotlegs.bender.bundles.mvcs.Mediator;

public class ItemGridMediator extends Mediator
   {

      [Inject]
      public var view:ItemGrid;

      [Inject]
      public var mapModel:MapModel;

      [Inject]
      public var playerModel:PlayerModel;

      [Inject]
      public var potionInventoryModel:PotionInventoryModel;

      [Inject]
      public var hudModel:HUDModel;

      [Inject]
      public var tabStripModel:TabStripModel;


      public function ItemGridMediator()
      {
         super();
      }

      override public function initialize() : void
      {
         this.view.addEventListener(ItemTileEvent.ITEM_MOVE,this.onTileMove);
         this.view.addEventListener(ItemTileEvent.ITEM_SHIFT_CLICK,this.onShiftClick);
         this.view.addEventListener(ItemTileEvent.ITEM_DOUBLE_CLICK,this.onDoubleClick);
         this.view.addEventListener(ItemTileEvent.ITEM_CTRL_CLICK,this.onCtrlClick);
         this.view.addEventListener(ItemTileEvent.ITEM_RIGHT_CTRL_CLICK,this.onRightCtrlClick);
      }

      override public function destroy() : void
      {
         super.destroy();
      }

      private function onTileMove(e:ItemTileEvent) : void
      {
         var targetTile:InteractiveItemTile = null;
         var tsv:TabStripView = null;
         var slot:int = 0;
         var sourceTile:InteractiveItemTile = e.tile;
         if(sourceTile.getItemId() == PotionInventoryModel.HEALTH_POTION_ID || sourceTile.getItemId() == PotionInventoryModel.MAGIC_POTION_ID)
         {
            this.onPotionMove(e);
            return;
         }
         var target:* = DisplayHierarchy.getParentWithTypeArray(sourceTile.getDropTarget(),TabStripView,InteractiveItemTile,Map);
         if(target is InteractiveItemTile)
         {
            targetTile = target as InteractiveItemTile;
            if(canSwapItems(sourceTile,targetTile))
            {
               this.swapItemTiles(sourceTile,targetTile);
            }
            else{
               SoundEffectLibrary.play("error");
            }
         }
         else if(target is Map || this.hudModel.gameSprite.map.mouseX < 300)
         {
            this.dropItem(sourceTile);
         }
         else if(target is TabStripView)
         {
            slot = sourceTile.ownerGrid.curPlayer.nextAvailableInventorySlot();
            if (slot != -1) {
               GameServerConnection.instance.invSwap(this.view.curPlayer, sourceTile.ownerGrid.owner, sourceTile.tileId, sourceTile.itemSprite.itemId, this.view.curPlayer, slot, ItemConstants.NO_ITEM);
               sourceTile.setItem(ItemConstants.NO_ITEM, null);
               sourceTile.updateUseability(this.view.curPlayer);
            }
         }
         sourceTile.resetItemPosition();
      }

      private function onPotionMove(e:ItemTileEvent) : void
      {
         var sourceTile:InteractiveItemTile = e.tile;
         var target:* = DisplayHierarchy.getParentWithTypeArray(sourceTile.getDropTarget(),TabStripView,Map);
         if(target is Map)
         {
            this.dropItem(sourceTile);
         }
         else if(target is TabStripView)
         {
            this.addToPotionStack(sourceTile);
         }
         sourceTile.resetItemPosition();
      }

      private function addToPotionStack(sourceTile:InteractiveItemTile) : void
      {
         if(!GameServerConnection.instance || !this.view.interactive || !sourceTile || this.potionInventoryModel.getPotionModel(sourceTile.getItemId()).maxPotionCount <= this.hudModel.gameSprite.map.player_.getPotionCount(sourceTile.getItemId()))
         {
            return;
         }
         GameServerConnection.instance.invSwapPotion(this.view.curPlayer,this.view.owner,sourceTile.tileId,sourceTile.itemSprite.itemId,this.view.curPlayer,PotionInventoryModel.getPotionSlot(sourceTile.getItemId()),ItemConstants.NO_ITEM);
         sourceTile.setItem(ItemConstants.NO_ITEM, null);
         sourceTile.updateUseability(this.view.curPlayer);
      }

      private static function canSwapItems(sourceTile:InteractiveItemTile, targetTile:InteractiveItemTile) : Boolean
      {

         if(ItemGrid(targetTile.parent).owner is Player)
         {
            if(!sourceTile.canHoldItemPlayer(ItemGrid(targetTile.parent).owner as Player, targetTile.getItemId()))
            {
               return false;
            }
            if(!targetTile.canHoldItemPlayer(ItemGrid(targetTile.parent).owner as Player, sourceTile.getItemId()))
            {
               return false;
            }
         }
         else {
            if (!sourceTile.canHoldItem(targetTile.getItemId())) {
               return false;
            }
            if (!targetTile.canHoldItem(sourceTile.getItemId())) {
               return false;
            }
         }
         if(ItemGrid(targetTile.parent).owner is OneWayContainer)
         {
            return false;
         }

         return true;
      }

      private function dropItem(itemTile:InteractiveItemTile) : void
      {
         var groundContainer:Container = null;
         var equipment:Vector.<int> = null;
         var equipCount:int = 0;
         var openIndex:int = 0;
         var isSoulbound:Boolean = ObjectLibrary.isSoulbound(itemTile.itemSprite.itemId);
         var container:Container = this.view.owner as Container;
         if(this.view.owner == this.view.curPlayer || container && container.ownerId_ == this.view.curPlayer.accountId_ && !isSoulbound)
         {
            groundContainer = this.mapModel.currentInteractiveTarget as Container;
            if(groundContainer)
            {
               equipment = groundContainer.equipment_;
               equipCount = equipment.length;
               for(openIndex = 0; openIndex < equipCount; openIndex++)
               {
                  if(equipment[openIndex] < 0)
                  {
                     break;
                  }
               }
               if(openIndex < equipCount)
               {
                  this.dropWithoutDestTile(itemTile,groundContainer,openIndex);
               }
               else
               {
                  GameServerConnection.instance.invDrop(this.view.owner,itemTile.tileId,itemTile.getItemId());
               }
            }
            else
            {
               GameServerConnection.instance.invDrop(this.view.owner,itemTile.tileId,itemTile.getItemId());
            }
         }
         itemTile.setItem(-1, null);
      }

      private function swapItemTiles(sourceTile:ItemTile, destTile:ItemTile) : Boolean
      {
         if(!GameServerConnection.instance || !this.view.interactive || !sourceTile || !destTile)
         {
            return false;
         }
         GameServerConnection.instance.invSwap(this.view.curPlayer,this.view.owner,sourceTile.tileId,sourceTile.itemSprite.itemId,destTile.ownerGrid.owner,destTile.tileId,destTile.itemSprite.itemId);
         var tempItemId:int = sourceTile.getItemId();
         var tempItemData:Object = sourceTile.getItemData();
         sourceTile.setItem(destTile.getItemId(), destTile.getItemData());
         destTile.setItem(tempItemId, tempItemData);
         sourceTile.updateUseability(this.view.curPlayer);
         destTile.updateUseability(this.view.curPlayer);
         return true;
      }

      private function dropWithoutDestTile(sourceTile:ItemTile, container:Container, containerIndex:int) : void
      {
         if(!GameServerConnection.instance || !this.view.interactive || !sourceTile || !container)
         {
            return;
         }
         GameServerConnection.instance.invSwap(this.view.curPlayer,this.view.owner,sourceTile.tileId,sourceTile.itemSprite.itemId,container,containerIndex,-1);
         sourceTile.setItem(ItemConstants.NO_ITEM, null);
      }

      private function onShiftClick(e:ItemTileEvent) : void
      {
         var tile:InteractiveItemTile = e.tile;
         if(tile.ownerGrid is InventoryGrid || tile.ownerGrid is ContainerGrid)
         {
            GameServerConnection.instance.useItem_new(tile.ownerGrid.owner,tile.tileId);
         }
      }

      private function onRightCtrlClick(e:ItemTileEvent) : void
      {
         var tile:InteractiveItemTile = e.tile;
         if(tile.ownerGrid is InventoryGrid || tile.ownerGrid is ContainerGrid)
         {
            var slot:int = tile.tileId;
            GameServerConnection.instance.breakdownSlot(slot, tile.ownerGrid.owner.objectId_);
         }
      }

      private function onCtrlClick(e:ItemTileEvent) : void
      {
         var tile:InteractiveItemTile = null;
         var slot:int = 0;
         if(Parameters.data_.inventorySwap)
         {
            tile = e.tile;
            if(tile.ownerGrid is InventoryGrid)
            {
               slot = tile.ownerGrid.curPlayer.swapInventoryIndex(this.tabStripModel.currentSelection);
               if(slot != -1)
               {
                  GameServerConnection.instance.invSwap(this.view.curPlayer,tile.ownerGrid.owner,tile.tileId,tile.itemSprite.itemId,this.view.curPlayer,slot,ItemConstants.NO_ITEM);
                  tile.setItem(ItemConstants.NO_ITEM, null);
                  tile.updateUseability(this.view.curPlayer);
               }
            }
         }
      }

      private function onDoubleClick(e:ItemTileEvent) : void
      {
         var tile:InteractiveItemTile = e.tile;
         if(this.isStackablePotion(tile))
         {
            this.addToPotionStack(tile);
         }
         else if(tile.ownerGrid is ContainerGrid)
         {
            this.equipOrUseContainer(tile);
         }
         else
         {
            this.equipOrUseInventory(tile);
         }
      }

      private function isStackablePotion(tile:InteractiveItemTile) : Boolean
      {
         return tile.getItemId() == PotionInventoryModel.HEALTH_POTION_ID || tile.getItemId() == PotionInventoryModel.MAGIC_POTION_ID;
      }

      private function pickUpItem(tile:InteractiveItemTile) : void
      {
         var nextAvailable:int = this.view.curPlayer.nextAvailableInventorySlot();
         if(nextAvailable != -1)
         {
            GameServerConnection.instance.invSwap(this.view.curPlayer,this.view.owner,tile.tileId,tile.itemSprite.itemId,this.view.curPlayer,nextAvailable,ItemConstants.NO_ITEM);
         }
      }

      private function equipOrUseContainer(tile:InteractiveItemTile) : void
      {
         var tileOwner:GameObject = tile.ownerGrid.owner;
         var player:Player = this.view.curPlayer;
         var nextAvailableSlotIndex:int = this.view.curPlayer.nextAvailableInventorySlot();
         if(nextAvailableSlotIndex != -1)
         {
            GameServerConnection.instance.invSwap(player,this.view.owner,tile.tileId,tile.itemSprite.itemId,this.view.curPlayer,nextAvailableSlotIndex,ItemConstants.NO_ITEM);
         }
         else
         {
            GameServerConnection.instance.useItem_new(tileOwner,tile.tileId);
         }
      }

      private function equipOrUseInventory(tile:InteractiveItemTile) : void
      {
         var tileOwner:GameObject = tile.ownerGrid.owner;
         var player:Player = this.view.curPlayer;
         var matchingSlotIndex:int = ObjectLibrary.getMatchingSlotIndex(tile.getItemId(),player);
         if(matchingSlotIndex != -1)
         {
            GameServerConnection.instance.invSwap(player,tileOwner,tile.tileId,tile.getItemId(),player,matchingSlotIndex,player.equipment_[matchingSlotIndex]);
         }
         else
         {
            GameServerConnection.instance.useItem_new(tileOwner,tile.tileId);
         }
      }
   }
}
