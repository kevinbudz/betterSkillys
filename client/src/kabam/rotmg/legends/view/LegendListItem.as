package kabam.rotmg.legends.view
{
   import com.company.assembleegameclient.ui.Slot;
   import com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid;
   import com.company.assembleegameclient.ui.panels.itemgrids.itemtiles.InteractiveItemTile;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.ui.SimpleText;
   import com.company.util.AssetLibrary;
   import com.company.util.IIterator;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;

import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.texture.TextureParser;

import kabam.rotmg.legends.model.Legend;
   import org.osflash.signals.Signal;
   import robotlegs.bender.framework.api.ILogger;
   
   public class LegendListItem extends Sprite
   {

      public static const WIDTH:int = 770;
      public static const HEIGHT:int = 70;
       
      
      public const selected:Signal = new Signal(Legend);
      
      private var legend:Legend;
      
      private var placeText:SimpleText;
      
      private var characterBitmap:Bitmap;
      
      private var nameText:SimpleText;
      
      private var inventoryGrid:EquippedGrid;
      
      private var totalFameText:SimpleText;
      
      private var fameIcon:Bitmap;
      
      private var isOver:Boolean;

      private var nameBackground:SliceScalingBitmap;
      
      [inject]
      public var logger:ILogger;
      
      public function LegendListItem(legend:Legend)
      {
         super();
         this.legend = legend;
         this.charBackground();
         this.makePlaceText();
         this.makeCharacterBitmap();
         this.makeNameText();
         this.makeInventory();
         this.makeTotalFame();
         this.makeFameIcon();
         this.addMouseListeners();
         this.draw();
      }
      
      public function getLegend() : Legend
      {
         return this.legend;
      }

      private function charBackground():void{
         this.nameBackground = TextureParser.instance.getSliceScalingBitmap("UI", "popup_header_title", 770);
         addChild(this.nameBackground);
      }
      
      private function makePlaceText() : void
      {
         this.placeText = new SimpleText(22,this.getTextColor(),false,0,0);
         this.placeText.setBold(this.legend.place != -1);
         this.placeText.text = this.legend.place == -1?"---":this.legend.place.toString() + ".";
         this.placeText.useTextDimensions();
         this.placeText.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.placeText.x = 82 - this.placeText.width;
         this.placeText.y = HEIGHT / 2 - this.placeText.height / 2;
         addChild(this.placeText);
      }
      
      private function makeCharacterBitmap() : void
      {
         this.characterBitmap = new Bitmap(this.legend.character);
         this.characterBitmap.x = 104;
         this.characterBitmap.y = HEIGHT / 2 - this.characterBitmap.height / 2 - 2;
         addChild(this.characterBitmap);
      }
      
      private function makeNameText() : void
      {
         this.nameText = new SimpleText(22,this.getTextColor(),false,0,0);
         this.nameText.setBold(true);
         this.nameText.text = this.legend.name;
         this.nameText.useTextDimensions();
         this.nameText.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.nameText.x = 170;
         this.nameText.y = HEIGHT / 2 - this.nameText.height / 2;
         addChild(this.nameText);
      }
      
      private function makeInventory() : void
      {
         var interactiveItemTileIterator:InteractiveItemTile = null;
         this.inventoryGrid = new EquippedGrid(null,this.legend.equipmentSlots,null);
         var iterator:IIterator = this.inventoryGrid.createInteractiveItemTileIterator();
         while(iterator.hasNext())
         {
            interactiveItemTileIterator = InteractiveItemTile(iterator.next());
            interactiveItemTileIterator.setInteractive(false);
         }
         this.inventoryGrid.setItems(this.legend.equipment, this.legend.itemDatas_);
         this.inventoryGrid.x = 400;
         this.inventoryGrid.y = HEIGHT / 2 - Slot.HEIGHT / 2;
         addChild(this.inventoryGrid);
      }
      
      private function makeTotalFame() : void
      {
         this.totalFameText = new SimpleText(22,this.getTextColor(),false,0,0);
         this.totalFameText.setBold(true);
         this.totalFameText.text = this.legend.totalFame.toString();
         this.totalFameText.useTextDimensions();
         this.totalFameText.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.totalFameText.x = 660 - this.totalFameText.width;
         this.totalFameText.y = HEIGHT / 2 - this.totalFameText.height / 2;
         addChild(this.totalFameText);
      }
      
      private function makeFameIcon() : void
      {
         var fameBD:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",224);
         this.fameIcon = new Bitmap(TextureRedrawer.redraw(fameBD,40,true,0));
         this.fameIcon.x = 652;
         this.fameIcon.y = HEIGHT / 2 - this.fameIcon.height / 2;
         addChild(this.fameIcon);
      }
      
      private function getTextColor() : uint
      {
         var textColor:uint = 0;
         if(this.legend.isOwnLegend)
         {
            textColor = 16564761;
         }
         else if(this.legend.place == 1)
         {
            textColor = 16646031;
         }
         else
         {
            textColor = 16777215;
         }
         return textColor;
      }
      
      private function addMouseListeners() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.isOver = true;
         this.draw();
      }
      
      private function onRollOut(event:MouseEvent) : void
      {
         this.isOver = false;
         this.draw();
      }
      
      private function onClick(event:MouseEvent) : void
      {
         this.selected.dispatch(this.legend);
      }
      
      private function draw() : void
      {
         graphics.clear();
         graphics.beginFill(0,this.isOver?Number(0.4):Number(0.001));
         graphics.drawRect(0,0,WIDTH,HEIGHT);
         graphics.endFill();
      }
   }
}
