package com.company.assembleegameclient.ui.panels.itemgrids
{
   import com.company.assembleegameclient.constants.InventoryOwnerTypes;
   import com.company.assembleegameclient.objects.Container;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.Panel;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.EquipmentTile;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.ItemTile;
   import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.events.MouseEvent;
   import kabam.rotmg.constants.ItemConstants;
   
   public class ItemGrid extends Panel
   {
      
      private static const NO_CUT:Array = [0,0,0,0];
      
      private static const CutsByNum:Object = {
         1:[[1,0,0,1],NO_CUT,NO_CUT,[0,1,1,0]],
         2:[[1,0,0,0],NO_CUT,NO_CUT,[0,1,0,0],[0,0,0,1],NO_CUT,NO_CUT,[0,0,1,0]],
         3:[[1,0,0,1],NO_CUT,NO_CUT,[0,1,1,0],[1,0,0,0],NO_CUT,NO_CUT,[0,1,0,0],[0,0,0,1],NO_CUT,NO_CUT,[0,0,1,0]]
      };
       
      
      private const padding:uint = 4;
      
      private const rowLength:uint = 4;
      
      public var owner:GameObject;
      
      private var tooltip:ToolTip;
      
      public var curPlayer:Player;
      
      protected var indexOffset:int;
      
      public var interactive:Boolean;
      
      public function ItemGrid(gridOwner:GameObject, currentPlayer:Player, itemIndexOffset:int)
      {
         super(null);
         this.owner = gridOwner;
         this.curPlayer = currentPlayer;
         this.indexOffset = itemIndexOffset;
         var container:Container = gridOwner as Container;
         if(gridOwner == currentPlayer || container)
         {
            this.interactive = true;
         }
      }
      
      public function hideTooltip() : void
      {
         if(this.tooltip)
         {
            this.tooltip.detachFromTarget();
            this.tooltip = null;
         }
      }
      
      private function onTileHover(e:MouseEvent) : void
      {
         var itemName:String = null;
         if(!stage)
         {
            return;
         }
         var tile:ItemTile = e.currentTarget as ItemTile;
         if(tile.itemSprite.itemId > 0)
         {
            this.tooltip = new EquipmentToolTip(tile.itemSprite.itemId,this.curPlayer,Boolean(this.owner)?int(this.owner.objectType_):int(-1),this.getCharacterType(),tile.tileId, false, tile.itemSprite.itemData);
         }
         else
         {
            if(tile is EquipmentTile)
            {
               itemName = ItemConstants.itemTypeToName((tile as EquipmentTile).itemType);
            }
            else
            {
               itemName = "item";
            }
            this.tooltip = new TextToolTip(3552822,10197915,null,"Empty " + itemName + " Slot",200);
         }
         this.tooltip.attachToTarget(tile);
         stage.addChild(this.tooltip);
      }
      
      private function getCharacterType() : String
      {
         if(this.owner == this.curPlayer)
         {
            return InventoryOwnerTypes.CURRENT_PLAYER;
         }
         if(this.owner is Player)
         {
            return InventoryOwnerTypes.OTHER_PLAYER;
         }
         return InventoryOwnerTypes.NPC;
      }
      
      protected function addToGrid(tile:ItemTile, numRows:uint, tileIndex:uint) : void
      {
         tile.drawBackground(CutsByNum[numRows][tileIndex]);
         tile.addEventListener(MouseEvent.ROLL_OVER,this.onTileHover);
         tile.x = int(tileIndex % this.rowLength) * (ItemTile.WIDTH + this.padding);
         tile.y = int(tileIndex / this.rowLength) * (ItemTile.HEIGHT + this.padding);
         addChild(tile);
      }
      
      public function setItems(items:Vector.<int>, datas:Vector.<Object>, itemIndexOffset:int = 0) : void
      {
      }
      
      public function enableInteraction(enabled:Boolean) : void
      {
         mouseEnabled = enabled;
      }
      
      override public function draw() : void
      {
         this.setItems(this.owner.equipment_, this.owner.equipData_,this.indexOffset);
      }
   }
}
