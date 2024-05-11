package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles
{
import com.company.assembleegameclient.misc.UILabel;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.ObjectProperties;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
import com.company.assembleegameclient.util.FilterUtil;
import com.company.assembleegameclient.util.TierUtil;
import com.company.util.GraphicsUtil;

import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Shape;
import flash.display.Sprite;

import kabam.rotmg.constants.ItemConstants;

public class ItemTile extends Sprite
{
   public static const TILE_DOUBLE_CLICK:String = "TILE_DOUBLE_CLICK";
   public static const TILE_SINGLE_CLICK:String = "TILE_SINGLE_CLICK";

   public static const WIDTH:int = 40;

   public static const HEIGHT:int = 40;

   public static const BORDER:int = 3;


   private var fill_:GraphicsSolidFill;
   private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
   private var graphicsData_:Vector.<IGraphicsData>;

   private var restrictedUseIndicator:Shape;

   public var itemSprite:ItemTileSprite;

   public var tileId:int;

   public var ownerGrid:ItemGrid;
   private var tierText:UILabel;
   private var isItemUsable:Boolean;
   private var itemContainer:Sprite;
   private var tagContainer:Sprite;

   public function ItemTile(id:int, parentGrid:ItemGrid)
   {
      super();
      this.tileId = id;
      this.ownerGrid = parentGrid;
      this.restrictedUseIndicator = new Shape();
      addChild(this.restrictedUseIndicator);
      this.setItemSprite(new ItemTileSprite());

      fill_ = new GraphicsSolidFill(getBackgroundColor(),1);
      graphicsData_ = new <IGraphicsData>[fill_,path_,GraphicsUtil.END_FILL];
   }

   public function drawBackground(cuts:Array) : void
   {
      GraphicsUtil.clearPath(this.path_);
      GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,cuts,this.path_);
      graphics.clear();
      graphics.drawGraphicsData(this.graphicsData_);
      var fill:GraphicsSolidFill = new GraphicsSolidFill(6036765,1);
      GraphicsUtil.clearPath(this.path_);
      var graphicsData:Vector.<IGraphicsData> = new <IGraphicsData>[fill,this.path_,GraphicsUtil.END_FILL];
      GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,cuts,this.path_);
      this.restrictedUseIndicator.graphics.drawGraphicsData(graphicsData);
      this.restrictedUseIndicator.cacheAsBitmap = true;
      this.restrictedUseIndicator.visible = false;
   }

   public function setItem(itemId:int, itemData:Object) : Boolean
   {
      if(itemId == this.itemSprite.itemId && itemData == this.itemSprite.itemData)
         return false;
      this.itemSprite.setType(itemId, itemData);
      this.setTierTag();
      this.updateUseability(this.ownerGrid.curPlayer);
      return true;
   }

   public function setItemSprite(itemTileSprite:ItemTileSprite) : void
   {
      if(!this.itemContainer)
      {
         this.itemContainer = new Sprite();
         addChild(this.itemContainer);
      }
      this.itemSprite = itemTileSprite;
      this.itemSprite.x = WIDTH / 2;
      this.itemSprite.y = HEIGHT / 2;
      this.itemContainer.addChild(this.itemSprite);
   }

   public function updateUseability(player:Player) : void
   {
      if(this.itemSprite.itemId != ItemConstants.NO_ITEM)
      {
         this.restrictedUseIndicator.visible = !ObjectLibrary.isUsableByPlayer(this.itemSprite.itemId,player);
      }
      else
      {
         this.restrictedUseIndicator.visible = false;
      }
   }

   public function canHoldItem(type:int) : Boolean
   {
      return true;
   }

   public function canHoldItemPlayer(player:Player, type:int):Boolean
   {
      return canHoldItem(type);
   }

   public function resetItemPosition() : void
   {
      this.setItemSprite(this.itemSprite);
   }

   public function getItemId() : int
   {
      return this.itemSprite.itemId;
   }

   public function getItemData() : Object
   {
      return this.itemSprite.itemData;
   }

   protected function getBackgroundColor() : int
   {
      return 5526612;
   }

   public function setTierTag() : void
   {
      this.clearTierTag();
      var props:ObjectProperties = ObjectLibrary.propsLibrary_[this.itemSprite.itemId];
      if(props)
      {
         this.tierText = TierUtil.getTierTag(props, 12);
         if(this.tierText)
         {
            if(!this.tagContainer)
            {
               this.tagContainer = new Sprite();
               addChild(this.tagContainer);
            }
            this.tierText.filters = FilterUtil.getTextOutlineFilter();
            this.tierText.x = WIDTH - this.tierText.width;
            this.tierText.y = HEIGHT / 2 + 4;
            this.toggleTierTag(Parameters.data_.showTierTag);
            this.tagContainer.addChild(this.tierText);
         }
      }
   }

   private function clearTierTag() : void
   {
      if(this.tierText && this.tagContainer && this.tagContainer.contains(this.tierText))
      {
         this.tagContainer.removeChild(this.tierText);
         this.tierText = null;
      }
   }

   public function toggleTierTag(_arg_1:Boolean) : void
   {
      if(this.tierText)
      {
         this.tierText.visible = _arg_1;
      }
   }

   protected function toggleDragState(_arg_1:Boolean) : void
   {
      if(this.tierText && Parameters.data_.showTierTag)
      {
         this.tierText.visible = _arg_1;
      }
      if(!this.isItemUsable && !_arg_1)
      {
         this.restrictedUseIndicator.visible = _arg_1;
      }
   }
}
}
