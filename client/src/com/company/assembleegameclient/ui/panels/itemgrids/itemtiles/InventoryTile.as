package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles
{
   import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
   import com.company.ui.SimpleText;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class InventoryTile extends InteractiveItemTile
   {
       
      
      public var hotKey:int;
      
      private var hotKeyBMP:Bitmap;
      
      public function InventoryTile(id:int, parentGrid:ItemGrid, isInteractive:Boolean)
      {
         super(id,parentGrid,isInteractive);
      }
      
      public function addTileNumber(tileNumber:int) : void
      {
         this.hotKey = tileNumber;
         this.buildHotKeyBMP();
      }
      
      public function buildHotKeyBMP() : void
      {
         var tempText:SimpleText = new SimpleText(26,3552822,false,0,0);
         tempText.text = String(this.hotKey);
         tempText.setBold(true);
         tempText.updateMetrics();
         var bmpData:BitmapData = new BitmapData(26,30,true,0);
         bmpData.draw(tempText);
         this.hotKeyBMP = new Bitmap(bmpData);
         this.hotKeyBMP.x = WIDTH / 2 - tempText.width / 2;
         this.hotKeyBMP.y = HEIGHT / 2 - 18;
         addChildAt(this.hotKeyBMP,0);
      }
      
      override public function setItemSprite(newItemSprite:ItemTileSprite) : void
      {
         super.setItemSprite(newItemSprite);
         newItemSprite.setDim(false);
      }
      
      override public function setItem(itemId:int, itemData:Object) : Boolean
      {
         var changed:Boolean = super.setItem(itemId, itemData);
         if(changed)
         {
            this.hotKeyBMP.visible = itemSprite.itemId <= 0;
         }
         return changed;
      }
      
      override protected function beginDragCallback() : void
      {
         this.hotKeyBMP.visible = true;
      }
      
      override protected function endDragCallback() : void
      {
         this.hotKeyBMP.visible = itemSprite.itemId <= 0;
      }
   }
}
