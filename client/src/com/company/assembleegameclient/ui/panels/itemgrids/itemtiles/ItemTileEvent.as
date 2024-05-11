package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles
{
   import flash.events.Event;
   
   public class ItemTileEvent extends Event
   {
      
      public static const ITEM_MOVE:String = "ITEM_MOVE";
      
      public static const ITEM_DOUBLE_CLICK:String = "ITEM_DOUBLE_CLICK";
      
      public static const ITEM_SHIFT_CLICK:String = "ITEM_SHIFT_CLICK";
      
      public static const ITEM_CLICK:String = "ITEM_CLICK";
      
      public static const ITEM_HOTKEY_PRESS:String = "ITEM_HOTKEY_PRESS";

      public static const ITEM_CTRL_CLICK:String = "ITEM_CTRL_CLICK";

      public static const ITEM_RIGHT_CTRL_CLICK:String = "ITEM_RIGHT_CTRL_CLICK";

      
      public var tile:InteractiveItemTile;
      
      public function ItemTileEvent(type:String, itemTile:InteractiveItemTile)
      {
         super(type,true);
         this.tile = itemTile;
      }
   }
}
