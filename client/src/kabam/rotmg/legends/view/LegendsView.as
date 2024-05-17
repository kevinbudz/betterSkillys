package kabam.rotmg.legends.view
{
   import com.company.assembleegameclient.screens.TitleMenuOption;
   import com.company.assembleegameclient.ui.Scrollbar;
   import com.company.rotmg.graphics.ScreenGraphic;
   import com.company.ui.SimpleText;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.texture.TextureParser;

import kabam.rotmg.legends.model.Legend;
   import kabam.rotmg.legends.model.Timespan;
   import kabam.rotmg.ui.view.components.ScreenBase;
   import org.osflash.signals.Signal;

   public class LegendsView extends Sprite
   {


      public const timespanChanged:Signal = new Signal(Timespan);

      public const showDetail:Signal = new Signal(Legend);

      public const close:Signal = new Signal();

      private const items:Vector.<LegendListItem> = new Vector.<LegendListItem>(0);

      private const tabs:Object = {};

      private var title:SimpleText;

      private var loadingBanner:SimpleText;

      private var mainContainer:Sprite;

      private var closeButton:TitleMenuOption;

      private var scrollBar:Scrollbar;

      private var listContainer:Sprite;

      private var selectedTab:LegendsTab;

      private var legends:Vector.<Legend>;

      private var count:int;

      private var screenGraphic:Sprite;

      private var lines:Shape;

      public function LegendsView()
      {
         super();
         this.makeScreenBase();
         this.makeTitleText();
         this.makeLoadingBanner();
         this.makeMainContainer();
         this.screenGraphic = this.makeScreenGraphic();
         addChild(this.screenGraphic);

         this.makeLines();
         this.makeScrollbar();
         this.makeTimespanTabs();
         this.makeCloseButton();
         this.positionAssets();
         if (WebMain.STAGE)
             WebMain.STAGE.addEventListener(Event.RESIZE, positionAssets);
      }

      private function makeScreenBase() : void
      {
         addChild(new ScreenBase());
      }

      private function positionAssets(e:Event = null)
      {
         if (e != null)
         {
            ScreenBase.reSize(e);
         }
            var width:int = WebMain.STAGE.stageWidth;
            var height:int = WebMain.STAGE.stageHeight;
            this.title.x = width / 2 - this.title.width / 2;
            this.closeButton.x = width / 2 - this.closeButton.width / 2;
            this.closeButton.y = height - 70;
            this.mainContainer.x = width / 2 - this.mainContainer.width / 2;

            this.lines.width = width;
            this.screenGraphic.width = width;
            this.screenGraphic.y = height - 75;
            this.scrollBar.x = width - this.scrollBar.width - 4;
      }

      private function makeTitleText() : void
      {
         this.title = new SimpleText(32,11776947,false,0,0);
         this.title.setBold(true);
         this.title.text = "Legends";
         this.title.updateMetrics();
         this.title.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.title.y = 24;
         addChild(this.title);
      }

      private function makeLoadingBanner() : void
      {
         this.loadingBanner = new SimpleText(22,11776947,false,0,0);
         this.loadingBanner.setBold(true);
         this.loadingBanner.text = "Loading...";
         this.loadingBanner.useTextDimensions();
         this.loadingBanner.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.loadingBanner.x = 800 / 2 - this.loadingBanner.width / 2;
         this.loadingBanner.y = 600 / 2 - this.loadingBanner.height / 2;
         this.loadingBanner.visible = false;
         addChild(this.loadingBanner);
      }

      private function makeMainContainer() : void
      {
         var shape:Shape = null;
         shape = new Shape();
         var g:Graphics = shape.graphics;
         g.beginFill(0);
         g.drawRect(0,0,LegendListItem.WIDTH,430);
         g.endFill();
         this.mainContainer = new Sprite();
         this.mainContainer.y = 110;
         this.mainContainer.addChild(shape);
         this.mainContainer.mask = shape;
         addChild(this.mainContainer);
      }

      private function makeScreenGraphic():Sprite
      {
         var box:Sprite = new Sprite();
         var b:Graphics = box.graphics;
         b.clear();
         b.beginFill(0, 0.5);
         b.drawRect(0, 0, 800, 75);
         b.endFill();
         addChild(box);
         return box;
      }

      private function makeLines() : void
      {
         this.lines = new Shape();
         addChild(this.lines);
         var g:Graphics = this.lines.graphics;
         g.lineStyle(2,5526612);
         g.moveTo(0,100);
         g.lineTo(800,100);
      }

      private function makeScrollbar() : void
      {
         this.scrollBar = new Scrollbar(16,400);
         this.scrollBar.y = 104;
         addChild(this.scrollBar);
      }

      private function makeTimespanTabs() : void
      {
         var timespans:Vector.<Timespan> = Timespan.TIMESPANS;
         var count:int = timespans.length;
         for(var i:int = 0; i < count; i++)
         {
            this.makeTab(timespans[i],i);
         }
      }

      private function makeTab(timespan:Timespan, i:int) : LegendsTab
      {
         var tab:LegendsTab = null;
         tab = new LegendsTab(timespan);
         this.tabs[timespan.getId()] = tab;
         tab.x = 20 + i * 90;
         tab.y = 70;
         tab.selected.add(this.onTabSelected);
         addChild(tab);
         return tab;
      }

      private function onTabSelected(tab:LegendsTab) : void
      {
         if(this.selectedTab != tab)
         {
            this.updateTabAndSelectTimespan(tab);
         }
      }

      private function updateTabAndSelectTimespan(tab:LegendsTab) : void
      {
         this.updateTabs(tab);
         this.timespanChanged.dispatch(this.selectedTab.getTimespan());
      }

      private function updateTabs(selected:LegendsTab) : void
      {
         this.selectedTab && this.selectedTab.setIsSelected(false);
         this.selectedTab = selected;
         this.selectedTab.setIsSelected(true);
      }

      private function makeCloseButton() : void
      {
         this.closeButton = new TitleMenuOption("done",36,false);
         addChild(this.closeButton);
         this.closeButton.addEventListener(MouseEvent.CLICK,this.onCloseClick);
      }

      private function onCloseClick(event:MouseEvent) : void
      {
         if (WebMain.STAGE)
            WebMain.STAGE.addEventListener(Event.RESIZE, positionAssets);
         this.close.dispatch();
      }

      public function clear() : void
      {
         this.listContainer && this.clearLegendsList();
         this.listContainer = null;
         this.scrollBar.visible = false;
      }

      private function clearLegendsList() : void
      {
         var item:LegendListItem = null;
         for each(item in this.items)
         {
            item.selected.remove(this.onItemSelected);
         }
         this.items.length = 0;
         this.mainContainer.removeChild(this.listContainer);
         this.listContainer = null;
      }

      public function setLegendsList(timespan:Timespan, legends:Vector.<Legend>) : void
      {
         this.clear();
         this.updateTabs(this.tabs[timespan.getId()]);
         this.listContainer = new Sprite();
         this.legends = legends;
         this.count = legends.length;
         this.items.length = this.count;
         this.makeItemsFromLegends();
         this.mainContainer.addChild(this.listContainer);
         this.updateScrollbar();
      }

      private function makeItemsFromLegends() : void
      {
         for(var i:int = 0; i < this.count; i++)
         {
            this.items[i] = this.makeItemFromLegend(i);
         }
      }

      private function makeItemFromLegend(index:int) : LegendListItem
      {
         var legend:Legend = this.legends[index];
         legend.place = index + 1;
         var item:LegendListItem = new LegendListItem(legend);
         item.y = index * LegendListItem.HEIGHT + (5 * index);
         item.selected.add(this.onItemSelected);
         this.listContainer.addChild(item);
         return item;
      }

      private function updateScrollbar() : void
      {
         if(this.listContainer.height > 400)
         {
            this.scrollBar.visible = true;
            this.scrollBar.setIndicatorSize(400,this.listContainer.height);
            this.scrollBar.addEventListener(Event.CHANGE,this.onScrollBarChange);
            this.positionScrollbarToDisplayFocussedLegend();
         }
         else
         {
            this.scrollBar.removeEventListener(Event.CHANGE,this.onScrollBarChange);
            this.scrollBar.visible = false;
         }
      }

      private function positionScrollbarToDisplayFocussedLegend() : void
      {
         var index:int = 0;
         var position:int = 0;
         var legend:Legend = this.getLegendFocus();
         if(legend)
         {
            index = this.legends.indexOf(legend);
            position = (index + 0.5) * LegendListItem.HEIGHT;
            this.scrollBar.setPos((position - 200) / (this.listContainer.height - 400));
         }
      }

      private function getLegendFocus() : Legend
      {
         var focus:Legend = null;
         var legend:Legend = null;
         for each(legend in this.legends)
         {
            if(legend.isFocus)
            {
               focus = legend;
               break;
            }
         }
         return focus;
      }

      private function onItemSelected(legend:Legend) : void
      {
         this.showDetail.dispatch(legend);
      }

      private function onScrollBarChange(event:Event) : void
      {
         this.listContainer.y = -this.scrollBar.pos() * (this.listContainer.height - 400);
      }

      public function showLoading() : void
      {
         this.loadingBanner.visible = true;
      }

      public function hideLoading() : void
      {
         this.loadingBanner.visible = false;
      }
   }
}
