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

      public static const WIDTH:int = 600;
      public static const HEIGHT:int = 60;
       
      
      public const selected:Signal = new Signal(Legend);
      
      private var legend:Legend;
      
      private var placeText:SimpleText;
      
      private var characterBitmap:Bitmap;
      
      private var nameText:SimpleText;
      
      private var inventoryGrid:EquippedGrid;
      
      private var totalFameText:SimpleText;
      
      private var fameIcon:Bitmap;
      
      private var isOver:Boolean;

      [inject]
      public var logger:ILogger;
      
      public function LegendListItem(legend:Legend)
      {
         super();
         this.legend = legend;
         this.makePlaceText();
         this.makeCharacterBitmap();
         this.makeNameText();
         this.makeInventory();
         this.makeTotalFame();
         this.makeFameIcon();
         this.addMouseListeners();
         this.draw();
      }
      
      private function makePlaceText() : void
      {
         this.placeText = new SimpleText(22,this.getTextColor(),false,0,0);
         this.placeText.setBold(this.legend.place != -1);
         this.placeText.text = this.legend.place == -1?"---":this.legend.place.toString();
         this.placeText.useTextDimensions();
         this.placeText.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.placeText.x = 20 - (this.placeText.width / 2);
         this.placeText.y = 16;
         addChild(this.placeText);
      }
      
      private function makeCharacterBitmap() : void
      {
         this.characterBitmap = new Bitmap(this.legend.character);
         this.characterBitmap.x = 40;
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
         this.nameText.x = 95;
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
         this.inventoryGrid.x = WIDTH / 2 - (this.inventoryGrid.width / 2) + 6;
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
         this.totalFameText.x = 550 - this.totalFameText.width;
         this.totalFameText.y = 16;
         addChild(this.totalFameText);
      }
      
      private function makeFameIcon() : void
      {
         var fameBD:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",224);
         this.fameIcon = new Bitmap(TextureRedrawer.redraw(fameBD,40,true,0));
         this.fameIcon.x = 542;
         this.fameIcon.y = HEIGHT / 2 - this.fameIcon.height / 2;
         addChild(this.fameIcon);
      }

      private function getTextColor() : uint
      {
         var textColor:uint = 0;

         if(this.legend.place == 1)
         {
            textColor = 0xFFD700;
         }
         else if (this.legend.place == 2)
         {
            textColor = 0xC0C0C0;
         }
         else if (this.legend.place == 3)
         {
            textColor = 0xcd7f32;
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

      private function draw() : void {
         var place:int;
         if (this.legend.place == 1)
         {
            place = 0xFFD700;
         }
         else if (this.legend.place == 2)
         {
            place = 0xC0C0C0;
         }
         else if (this.legend.place == 3)
         {
            place = 0xcd7f32;
         }
         else
         {
            place = 0;
         }
         graphics.clear();
         graphics.beginFill(place,!!this.isOver?Number(0.3):Number(0.2));
         graphics.drawRect(0,0,WIDTH,HEIGHT);
         graphics.endFill();
         graphics.beginFill(0, 0.4);
         graphics.drawCircle(20, 30, 15);
         graphics.endFill();
      }
   }
}
