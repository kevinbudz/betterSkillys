package kabam.rotmg.ui.view
{
import com.company.assembleegameclient.constants.ScreenTypes;
import com.company.assembleegameclient.screens.AccountLoadingScreen;
import com.company.assembleegameclient.screens.AccountScreen;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.ui.SoundIcon;
import com.company.rotmg.graphics.ScreenGraphic;
import com.company.ui.SimpleText;

import flash.display.Bitmap;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.geom.Vector3D;

import kabam.rotmg.ui.model.EnvironmentData;
import kabam.rotmg.ui.view.components.DarkenFactory;
import kabam.rotmg.ui.view.components.MapBackground;
import org.osflash.signals.Signal;

public class TitleView extends Sprite
{
   private static var TitleScreenGraphic:Class = TitleView_TitleScreenGraphic;

   private static const COPYRIGHT:String = "© betterSkillys :)";


   public var playClicked:Signal;
   public var serversClicked:Signal;
   public var creditsClicked:Signal;
   public var accountClicked:Signal;
   public var legendsClicked:Signal;
   public var editorClicked:Signal;

   private var container:Sprite;
   private var parallaxLayers:Vector.<Bitmap>;
   private var graphic:Sprite;

   private var playButton:TitleMenuOption;
   private var serversButton:TitleMenuOption;
   private var creditsButton:TitleMenuOption;
   private var accountButton:TitleMenuOption;
   private var legendsButton:TitleMenuOption;
   private var editorButton:TitleMenuOption;

   private var versionText:SimpleText;
   private var copyrightText:SimpleText;
   private var darkenFactory:DarkenFactory;
   private var data:EnvironmentData;
   public static var anchor:Point = new Point(-40, -40);
   public static var anchor2:Point = new Point(0, -20);

   public function TitleView()
   {
      this.darkenFactory = new DarkenFactory();
      super();
      this.initLayers();
      this.graphic = this.makeScreenGraphic();
      addChild(this.graphic);
      addChild(new AccountScreen());
      this.makeChildren();
      addChild(new SoundIcon());
   }

   public function initLayers(): void
   {
      this.parallaxLayers = new Vector.<Bitmap>();
      this.parallaxLayers[0] = new TitleView_BackgroundLayer();
      this.parallaxLayers[1] = new TitleView_FlamesLayer();

      this.parallaxLayers[0].x = 40;
      this.parallaxLayers[0].y = 40;
      this.parallaxLayers[1].x = 0;
      this.parallaxLayers[1].y = 20;

      for (var i:int = 0; i < 2; i++)
      {
         this.parallaxLayers.push(this.parallaxLayers[i]);
         addChild(this.parallaxLayers[i]);
         this.parallaxLayers[i].addEventListener(Event.ENTER_FRAME, onParallax);
      }
   }

   public function onParallax(e:Event): void
   {
      var bgOffset:Vector3D = new Vector3D(anchor.x-mouseX,anchor.y-mouseY, 0);
      var flameOffset:Vector3D = new Vector3D(anchor2.x-mouseX,anchor2.y-mouseY, 0);
      this.parallaxLayers[0].x += (anchor.x + bgOffset.x * 0.015 - this.parallaxLayers[0].x) * 0.015;
      this.parallaxLayers[0].y += (anchor.y + bgOffset.y * 0.015 - this.parallaxLayers[0].y) * 0.15;
      this.parallaxLayers[1].x += (anchor2.x + flameOffset.x * 0.025 - this.parallaxLayers[1].x) * 0.025;
      this.parallaxLayers[1].y += (anchor2.y + flameOffset.y * 0.025 - this.parallaxLayers[1].y) * 0.025;
   }

   private function makeScreenGraphic():Sprite
   {
      var box:Sprite = new Sprite();
      var b:Graphics = box.graphics;
      b.clear();
      b.beginFill(0, 0.5);
      b.drawRect(0, 0, 1, 75);
      b.endFill();
      addChild(box);
      return box;
   }

   private function makeChildren() : void
   {
      this.container = new Sprite();
      this.playButton = new TitleMenuOption(ScreenTypes.PLAY,36,true);
      this.playButton.addEventListener(MouseEvent.CLICK, removeListener);
      this.playClicked = this.playButton.clicked;
      this.container.addChild(this.playButton);
      this.serversButton = new TitleMenuOption(ScreenTypes.SERVERS,22,false);
      this.serversButton.addEventListener(MouseEvent.CLICK, removeListener);
      this.serversClicked = this.serversButton.clicked;
      this.container.addChild(this.serversButton);
      this.creditsButton = new TitleMenuOption(ScreenTypes.CREDITS,22,false);
      this.creditsClicked = this.creditsButton.clicked;
      //this.container.addChild(this.creditsButton);
      this.accountButton = new TitleMenuOption(ScreenTypes.ACCOUNT,22,false);
      this.accountButton.addEventListener(MouseEvent.CLICK, removeListener);
      this.accountClicked = this.accountButton.clicked;
      this.container.addChild(this.accountButton);
      this.legendsButton = new TitleMenuOption(ScreenTypes.LEGENDS,22,false);
      this.legendsButton.addEventListener(MouseEvent.CLICK, removeListener);
      this.legendsClicked = this.legendsButton.clicked;
      this.container.addChild(this.legendsButton);
      this.editorButton = new TitleMenuOption(ScreenTypes.EDITOR,22,false);
      this.editorButton.addEventListener(MouseEvent.CLICK, removeListener);
      this.editorClicked = this.editorButton.clicked;
      this.versionText = new SimpleText(12,0xaaaaaa,false,0,0);
      this.versionText.filters = [new DropShadowFilter(0,0,0)];
      this.container.addChild(this.versionText);
      this.copyrightText = new SimpleText(12,0xaaaaaa,false,0,0);
      this.copyrightText.text = COPYRIGHT;
      this.copyrightText.updateMetrics();
      this.copyrightText.filters = [new DropShadowFilter(0,0,0)];
      this.container.addChild(this.copyrightText);
   }

   public function addListeners():void
   {
      this.playButton.addEventListener(MouseEvent.CLICK, removeListener);
      this.serversButton.addEventListener(MouseEvent.CLICK, removeListener);
      this.accountButton.addEventListener(MouseEvent.CLICK, removeListener);
      this.legendsButton.addEventListener(MouseEvent.CLICK, removeListener);
      this.editorButton.addEventListener(MouseEvent.CLICK, removeListener);
   }

   public function removeListener(e:Event):void
   {
      if (stage)
         stage.removeEventListener("resize", positionButtons);
      this.playButton.removeEventListener(MouseEvent.CLICK, removeListener);
      this.serversButton.removeEventListener(MouseEvent.CLICK, removeListener);
      this.accountButton.removeEventListener(MouseEvent.CLICK, removeListener);
      this.legendsButton.removeEventListener(MouseEvent.CLICK, removeListener);
      this.editorButton.removeEventListener(MouseEvent.CLICK, removeListener);
   }

   public function initialize(data:EnvironmentData) : void
   {
      this.data = data;
      this.updateVersionText();
      this.positionButtons();
      this.addChildren();
      this.addListeners();
      if (stage)
         stage.addEventListener("resize", positionButtons);
   }

   private function updateVersionText() : void
   {
      this.versionText.htmlText = this.data.buildLabel;
      this.versionText.updateMetrics();
   }

   private function addChildren() : void
   {
      addChild(this.container);
      this.container.addChild(this.editorButton);
   }

   public function positionButtons(e:Event = null) : void
   {
      if (stage)
      {
         if (e != null)
            AccountScreen.reSize(e);
         this.graphic.width = stage.stageWidth;
         this.graphic.y = stage.stageHeight - 75;
         this.parallaxLayers[0].scaleX = this.parallaxLayers[1].scaleX = stage.stageWidth / 800;
         this.parallaxLayers[0].scaleY = this.parallaxLayers[1].scaleY = stage.stageHeight / 600;

         this.playButton.x = stage.stageWidth / 2 - this.playButton.width / 2;
         this.playButton.y = stage.stageHeight - 75;
         this.serversButton.x = stage.stageWidth / 2 - this.serversButton.width / 2 - 94;
         this.serversButton.y =  stage.stageHeight - 65;
         this.accountButton.x = stage.stageWidth / 2 - this.accountButton.width / 2 + 96;
         this.accountButton.y = stage.stageHeight - 65;
         this.legendsButton.x = this.accountButton.x + 96;
         this.legendsButton.y = stage.stageHeight - 65;
         this.editorButton.x = this.serversButton.x - 96;
         this.editorButton.y = stage.stageHeight - 65;
         this.versionText.y = stage.stageHeight - this.versionText.height;
         this.copyrightText.x = stage.stageWidth - this.copyrightText.width;
         this.copyrightText.y = stage.stageHeight - this.copyrightText.height;
      }
   }
}
}
