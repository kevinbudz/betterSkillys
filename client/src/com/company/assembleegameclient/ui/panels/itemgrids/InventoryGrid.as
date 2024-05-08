package com.company.assembleegameclient.ui.panels.itemgrids
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InventoryTile;
import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;

public class InventoryGrid extends ItemGrid
   {
       
      
      private const NUM_SLOTS:uint = 8;
      
      private var tiles:Vector.<InventoryTile>;
      
      private var isBackpack:Boolean;
      
      public function InventoryGrid(gridOwner:GameObject, currentPlayer:Player, itemIndexOffset:int = 0, isBackpack:Boolean = false)
      {
         var tile:InventoryTile = null;
         super(gridOwner,currentPlayer,itemIndexOffset);
         this.tiles = new Vector.<InventoryTile>(this.NUM_SLOTS);
         this.isBackpack = isBackpack;
         for(var i:int = 0; i < this.NUM_SLOTS; i++)
         {
            tile = new InventoryTile(i + indexOffset,this,interactive);
            tile.addTileNumber(i + 1);
            addToGrid(tile,2,i);
            this.tiles[i] = tile;
         }
      }

      override public function setItems(items:Vector.<int>, datas:Vector.<Object>, itemIndexOffset:int = 0) : void
      {
         var numItems:int = 0;
         var i:int = 0;
         if(items)
         {
            numItems = items.length;
            for(i = 0; i < this.NUM_SLOTS; i++)
            {
               if(i + indexOffset < numItems)
               {
                  this.tiles[i].setItem(items[i + indexOffset], datas[i + indexOffset]);
               }
               else
               {
                  this.tiles[i].setItem(-1, null);
               }
            }
         }
      }

      public function toggleTierTags(_arg_1:Boolean) : void
      {
         var _local_2:ItemTile = null;
         for each(_local_2 in this.tiles)
         {
            _local_2.toggleTierTag(_arg_1);
         }
      }
   }
}
