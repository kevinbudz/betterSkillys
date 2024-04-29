package kabam.rotmg.ui.view
{
import com.company.assembleegameclient.constants.ScreenTypes;
import com.company.assembleegameclient.screens.AccountLoadingScreen;
import com.company.assembleegameclient.screens.AccountScreen;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.ui.SoundIcon;
import com.company.rotmg.graphics.ScreenGraphic;
import com.company.ui.SimpleText;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import kabam.rotmg.ui.model.EnvironmentData;
import kabam.rotmg.ui.view.components.DarkenFactory;
import kabam.rotmg.ui.view.components.MapBackground;
import org.osflash.signals.Signal;

public class TitleView extends Sprite
{
   private static var TitleScreenGraphic:Class = TitleView_TitleScreenGraphic;

   private static const COPYRIGHT:String = "© ripped by runes :)";


   public var playClicked:Signal;
   public var serversClicked:Signal;
   public var creditsClicked:Signal;
   public var accountClicked:Signal;
   public var legendsClicked:Signal;
   public var editorClicked:Signal;

   private var container:Sprite;

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

   public function TitleView()
   {
      this.darkenFactory = new DarkenFactory();
      super();
      //addChild(new MapBackground());
      addChild(new TitleView_TitleScreenBackground());
      addChild(this.darkenFactory.create());
      addChild(new TitleScreenGraphic());
      this.makeScreenGraphic();
      addChild(new AccountScreen());
      this.makeChildren();
      addChild(new SoundIcon());
   }

   private function makeScreenGraphic():void
   {
      var box:Sprite = new Sprite();
      var b:Graphics = box.graphics;
      b.clear();
      b.beginFill(0, 0.5);
      b.drawRect(0, 525, 800, 75);
      b.endFill();
      addChild(box);
   }

   private function makeChildren() : void
   {
      this.container = new Sprite();
      this.playButton = new TitleMenuOption(ScreenTypes.PLAY,36,true);
      this.playClicked = this.playButton.clicked;
      this.container.addChild(this.playButton);
      this.serversButton = new TitleMenuOption(ScreenTypes.SERVERS,22,false);
      this.serversClicked = this.serversButton.clicked;
      this.container.addChild(this.serversButton);
      this.creditsButton = new TitleMenuOption(ScreenTypes.CREDITS,22,false);
      this.creditsClicked = this.creditsButton.clicked;
      //this.container.addChild(this.creditsButton);
      this.accountButton = new TitleMenuOption(ScreenTypes.ACCOUNT,22,false);
      this.accountClicked = this.accountButton.clicked;
      this.container.addChild(this.accountButton);
      this.legendsButton = new TitleMenuOption(ScreenTypes.LEGENDS,22,false);
      this.legendsClicked = this.legendsButton.clicked;
      this.container.addChild(this.legendsButton);
      this.editorButton = new TitleMenuOption(ScreenTypes.EDITOR,22,false);
      this.editorClicked = this.editorButton.clicked;
      this.versionText = new SimpleText(12,8355711,false,0,0);
      this.versionText.filters = [new DropShadowFilter(0,0,0)];
      this.container.addChild(this.versionText);
      this.copyrightText = new SimpleText(12,8355711,false,0,0);
      this.copyrightText.text = COPYRIGHT;
      this.copyrightText.updateMetrics();
      this.copyrightText.filters = [new DropShadowFilter(0,0,0)];
      this.container.addChild(this.copyrightText);
   }

   public function initialize(data:EnvironmentData) : void
   {
      this.data = data;
      this.updateVersionText();
      this.positionButtons();
      this.addChildren();
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

   private function positionButtons() : void
   {
      this.playButton.x = stage.stageWidth / 2 - this.playButton.width / 2;
      this.playButton.y = 525;
      this.serversButton.x = stage.stageWidth / 2 - this.serversButton.width / 2 - 94;
      this.serversButton.y = 535;
      this.accountButton.x = stage.stageWidth / 2 - this.accountButton.width / 2 + 96;
      this.accountButton.y = 535;
      this.legendsButton.x = 550;
      this.legendsButton.y = 535;
      this.editorButton.x = 180;
      this.editorButton.y = 535;
      this.versionText.y = stage.stageHeight - this.versionText.height;
      this.copyrightText.x = stage.stageWidth - this.copyrightText.width;
      this.copyrightText.y = stage.stageHeight - this.copyrightText.height;
   }
}
}
