package com.company.assembleegameclient.ui.panels.itemgrids
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.EquipmentTile;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
   import com.company.util.ArrayIterator;
   import com.company.util.IIterator;
   import kabam.lib.util.VectorAS3Util;
   
   public class EquippedGrid extends ItemGrid
   {
      private const NUM_SLOTS:uint = 4;
      
      private var tiles:Vector.<EquipmentTile>;
      
      public function EquippedGrid(gridOwner:GameObject, invTypes:Vector.<int>, currentPlayer:Player, itemIndexOffset:int = 0)
      {
         var tile:EquipmentTile = null;
         super(gridOwner,currentPlayer,itemIndexOffset);
         this.tiles = new Vector.<EquipmentTile>(this.NUM_SLOTS);
         for(var i:int = 0; i < this.NUM_SLOTS; i++)
         {
            tile = new EquipmentTile(i,this,interactive);
            addToGrid(tile,1,i);
            tile.setType(invTypes[i]);
            this.tiles[i] = tile;
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
      
      public function createInteractiveItemTileIterator() : IIterator
      {
         return new ArrayIterator(VectorAS3Util.toArray(this.tiles));
      }
      
      override public function setItems(items:Vector.<int>, datas:Vector.<Object>, itemIndexOffset:int = 0) : void
      {
         var numItems:int = 0;
         var i:int = 0;
         if(items)
         {
            numItems = items.length;
            for(i = 0; i < this.tiles.length; i++)
            {
               if(i + itemIndexOffset < numItems)
               {
                  this.tiles[i].setItem(items[i + itemIndexOffset], datas != null ? datas[i + indexOffset] : null);
               }
               else
               {
                  this.tiles[i].setItem(-1, null);
               }
               this.tiles[i].updateDim(curPlayer, i);
            }
         }
      }
   }
}
