package kabam.rotmg.classes.view
{
   import com.company.assembleegameclient.screens.AccountScreen;
   import com.company.assembleegameclient.screens.TitleMenuOption;
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
import io.decagames.rotmg.utils.colors.GreyScale;

import kabam.rotmg.game.view.CreditDisplay;
import kabam.rotmg.ui.view.components.MenuOptionsBar;
import kabam.rotmg.ui.view.components.ScreenBase;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class CharacterSkinView extends Sprite
   {
      private const base:ScreenBase = makeScreenBase();
      private const account:AccountScreen = makeAccountScreen();
      private const lines:Shape = makeLines();
      private const titleText:SimpleText = makeTitleText();
      private const creditsDisplay:CreditDisplay = makeCreditDisplay();
      private const menuOptions:Sprite = makeMenuOptionsBar();
      private const playBtn:TitleMenuOption = makePlayButton();
      private const backBtn:TitleMenuOption = makeBackButton();
      private var list:CharacterSkinListView;
      private const detail:ClassDetailView = makeClassDetailView();
      public const play:Signal = new NativeMappedSignal(playBtn,MouseEvent.CLICK);
      public const back:Signal = new NativeMappedSignal(backBtn,MouseEvent.CLICK);
      private var buttonsBackground:SliceScalingBitmap;
      
      public function CharacterSkinView()
      {
         if (WebMain.STAGE)
            WebMain.STAGE.addEventListener(Event.RESIZE, positionButtons);
         this.makeListView();
         this.positionButtons();
      }

      private var duringResizing:Boolean = false;
      private function positionButtons(e:Event = null) : void
      {
         if (e != null)
         {
            if (!duringResizing)
            {
               duringResizing = true;
               WebMain.STAGE.addEventListener(MouseEvent.MOUSE_OUT, redraw);
            }
            ScreenBase.reSize(e);
            AccountScreen.reSize(e);
         }

         var width:int = WebMain.STAGE.stageWidth;
         var height:int = WebMain.STAGE.stageHeight;
         this.lines.width = width;
         this.menuOptions.width = width;
         this.menuOptions.y = height - 75;
         this.detail.x = (width / 2) - 400;
         this.list.x = (width / 2) - 45;
         this.creditsDisplay.x = width;
         this.titleText.x = (width / 2) - (this.titleText.width / 2);
         this.playBtn.x = (width / 2) - (this.playBtn.width / 2);
         this.playBtn.y = height - 75;
         this.backBtn.y = height - 65;
      }

      public function redraw(e:Event):void
      {
         duringResizing = false;
         removeChild(this.list);
         this.makeListView();

         WebMain.STAGE.removeEventListener(MouseEvent.MOUSE_OUT, redraw);
      }

      private function makeTitleText():SimpleText {
         var title:SimpleText = new SimpleText(32, 11776947, false, 0, 0);
         title.setBold(true);
         title.text = "Skins";
         title.updateMetrics();
         title.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
         title.x = 400 - title.width / 2;
         title.y = 24;
         addChild(title);
         return title;
      }

      private function makeMenuOptionsBar():Sprite {
         var box:Sprite = new Sprite();
         var b:Graphics = box.graphics;
         b.clear();
         b.beginFill(0, 0.5);
         b.drawRect(0, 0, 800, 75);
         b.endFill();
         addChild(box);
         return box;
      }
      
      private function makeScreenBase() : ScreenBase
      {
         var base:ScreenBase = new ScreenBase();
         addChild(base);
         return base;
      }
      
      private function makeAccountScreen() : AccountScreen
      {
         var screen:AccountScreen = new AccountScreen();
         addChild(screen);
         return screen;
      }
      
      private function makeCreditDisplay() : CreditDisplay
      {
         var display:CreditDisplay = new CreditDisplay();
         display.y = 32;
         addChild(display);
         return display;
      }
      
      private function makeLines() : Shape
      {
         var shape:Shape = new Shape();
         shape.graphics.clear();
         shape.graphics.lineStyle(2,5526612);
         shape.graphics.moveTo(0,100);
         shape.graphics.lineTo(800,100);
         addChild(shape);
         return shape;
      }

      private function makePlayButton() : TitleMenuOption
      {
         var option:TitleMenuOption = null;
         option = new TitleMenuOption("play",36,false);
         addChild(option);
         return option;
      }

      private function makeBackButton() : TitleMenuOption
      {
         var option:TitleMenuOption = new TitleMenuOption("back",22,false);
         option.x = 30;
         addChild(option);
         return option;
      }
      
      private function makeListView():void
      {
         this.list = new CharacterSkinListView(WebMain.STAGE.stageHeight - 600);
         this.list.x = (WebMain.STAGE.width / 2) - 45;
         this.list.y = 110;
         addChild(this.list);
      }
      
      private function makeClassDetailView() : ClassDetailView
      {
         var view:ClassDetailView = new ClassDetailView();
         view.y = 110;
         addChild(view);
         return view;
      }

      public function setPlayButtonEnabled(activate:Boolean):void {
         if (!activate) {
            this.playBtn.deactivate();
         }
      }
   }
}
