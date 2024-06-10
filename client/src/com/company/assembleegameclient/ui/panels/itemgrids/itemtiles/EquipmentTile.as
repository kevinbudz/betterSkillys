package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles
{
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.ObjectProperties;
import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
   import com.company.util.AssetLibrary;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.filters.ColorMatrixFilter;
   import kabam.rotmg.constants.ItemConstants;

   public class EquipmentTile extends InteractiveItemTile
   {

      private static const greyColorFilter:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.singleColorFilterMatrix(3552822));


      public var backgroundDetail:Bitmap;

      public var itemType:int;

      private var minManaUsage:int;

      public function EquipmentTile(id:int, parentGrid:ItemGrid, isInteractive:Boolean, bgColor:int = -1)
      {
         if(bgColor != -1){
            backgroundColor = bgColor;
         }
         super(id,parentGrid,isInteractive);
      }

      override public function canHoldItem(type:int) : Boolean
      {
         return type <= 0 || this.itemType == ObjectLibrary.getSlotTypeFromType(type);
      }

      override public function canHoldItemPlayer(player:Player, type:int) : Boolean
      {
         return type <= 0 || this.itemType == ObjectLibrary.getSlotTypeFromType(type);
      }

      public function setType(type:int, darken:Boolean = true) : void
      {
         var bd:BitmapData = null;
         var dx:int = 0;
         var dy:int = 0;
         switch(type) {
            case ItemConstants.ALL_TYPE:
               break;
            case ItemConstants.SWORD_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj5", 48);
               break;
            case ItemConstants.DAGGER_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj5", 96);
               break;
            case ItemConstants.BOW_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj5", 80);
               break;
            case ItemConstants.TOME_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 80);
               break;
            case ItemConstants.SHIELD_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 112);
               break;
            case ItemConstants.LEATHER_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj5", 0);
               break;
            case ItemConstants.PLATE_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj5", 32);
               break;
            case ItemConstants.WAND_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj5", 64);
               break;
            case ItemConstants.RING_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj", 44);
               break;
            case ItemConstants.SPELL_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 64);
               break;
            case ItemConstants.SEAL_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 160);
               break;
            case ItemConstants.CLOAK_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 32);
               break;
            case ItemConstants.ROBE_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj5", 16);
               break;
            case ItemConstants.QUIVER_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 48);
               break;
            case ItemConstants.HELM_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 96);
               break;
            case ItemConstants.STAFF_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj5", 112);
               break;
            case ItemConstants.POISON_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 128);
               break;
            case ItemConstants.SKULL_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 0);
               break;
            case ItemConstants.TRAP_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 16);
               break;
            case ItemConstants.ORB_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 144);
               break;
            case ItemConstants.PRISM_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 176);
               break;
            case ItemConstants.SCEPTER_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 192);
               break;
            case ItemConstants.KATANA_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj3", 540);
               break;
            case ItemConstants.SHURIKEN_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj3", 555);
               break;
            case ItemConstants.NEW_ABIL_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 224);
               break;
            case ItemConstants.LUTE_TYPE:
               bd = AssetLibrary.getImageFromSet("lofiObj6", 208);
               break;
         }

         if(bd != null)
         {
            this.backgroundDetail = new Bitmap(bd);
            this.backgroundDetail.x = BORDER + dx;
            this.backgroundDetail.y = BORDER + dy;
            this.backgroundDetail.scaleX = 4;
            this.backgroundDetail.scaleY = 4;
            if(darken){
               this.backgroundDetail.filters = [greyColorFilter];
            }
            if(darken){
               this.backgroundDetail.filters = [greyColorFilter];
            }
            addChildAt(this.backgroundDetail,0);
         }
         this.itemType = type;
      }

      override public function setItem(itemId:int, itemData:Object) : Boolean
      {
         var itemChanged:Boolean = super.setItem(itemId, itemData);
         if(itemChanged)
         {
            this.backgroundDetail.visible = itemSprite.itemId <= 0;
            this.updateMinMana();
         }
         return itemChanged;
      }

      private function updateMinMana() : void
      {
         var itemDataXML:XML = null;
         if(itemSprite.itemId > 0)
         {
            itemDataXML = ObjectLibrary.xmlLibrary_[itemSprite.itemId];
            if(itemDataXML && itemDataXML.hasOwnProperty("Usable"))
            {
               if(itemDataXML.hasOwnProperty("MultiPhase"))
               {
                  this.minManaUsage = itemDataXML.MpEndCost;
               }
               else
               {
                  this.minManaUsage = itemDataXML.MpCost;
               }
            }
            else
            {
               this.minManaUsage = 0;
            }
         }
         else
         {
            this.minManaUsage = 0;
         }
      }

      public function updateDim(player:Player, slot:int) : void
      {
         var canUse:Boolean = true;
         if(player != null && player.map_ != null){
            if(player.map_.disableShooting_ && slot == 0){
               canUse = false;
            }
            else if(player.map_.disableAbilities_ && slot == 1){
               canUse = false;
            }
         }
         itemSprite.setDim(!canUse || player && player.mp_ < this.minManaUsage);
      }

      override protected function beginDragCallback() : void
      {
         this.backgroundDetail.visible = true;
      }

      override protected function endDragCallback() : void
      {
         this.backgroundDetail.visible = itemSprite.itemId <= 0;
      }

      protected var backgroundColor:int = 4539717;

      override protected function getBackgroundColor() : int
      {
         return backgroundColor;
      }
   }
}
