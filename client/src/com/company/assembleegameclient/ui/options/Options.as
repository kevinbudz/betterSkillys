package com.company.assembleegameclient.ui.options
{
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.sound.Music;
import com.company.assembleegameclient.sound.SFX;
import com.company.assembleegameclient.ui.StatusBar;
import com.company.rotmg.graphics.ScreenGraphic;
import com.company.ui.SimpleText;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;
import com.company.util.KeyCodes;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.system.Capabilities;
import flash.text.TextFieldAutoSize;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.ui.MouseCursorData;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.texture.TextureParser;
import io.decagames.rotmg.utils.colors.GreyScale;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.messaging.impl.GameServerConnection;

import kabam.rotmg.ui.signals.ToggleShowTierTagSignal;

import kabam.rotmg.ui.view.components.MenuOptionsBar;

public class Options extends Sprite
{
   private static const CONTROLS_TAB:String = "Controls";
   private static const HOTKEYS_TAB:String = "Hot Keys";
   private static const CHAT_TAB:String = "Chat";
   private static const GRAPHICS_TAB:String = "Graphics";
   private static const SOUND_TAB:String = "Sound";
   private static const MISC_TAB:String = "Misc";
   private static const HOTKEYSV2:String = "Recon";
   public static const CHAT_COMMAND:String = "chatCommand";
   public static const CHAT:String = "chat";
   public static const TELL:String = "tell";
   public static const GUILD_CHAT:String = "guildChat";
   public static const SCROLL_CHAT_UP:String = "scrollChatUp";
   public static const SCROLL_CHAT_DOWN:String = "scrollChatDown";
   private static const TABS:Vector.<String> = new <String>[CONTROLS_TAB,HOTKEYS_TAB,CHAT_TAB,GRAPHICS_TAB,SOUND_TAB,MISC_TAB,HOTKEYSV2];

   private static var registeredCursors:Vector.<String> = new <String>[];

   private var gs_:GameSprite;
   private var title_:SimpleText;
   private var continueButton_:TitleMenuOption;
   private var resetToDefaultsButton_:TitleMenuOption;
   private var homeButton_:TitleMenuOption;
   private var optionsBackground:SliceScalingBitmap;
   private var tabs_:Vector.<OptionsTabTitle>;
   private var selected_:OptionsTabTitle = null;
   private var options_:Vector.<Sprite>;
   private var optionIndex_:int = 0;
   private var screenGraphic:Sprite;
   private var background:Sprite;
   private var lines:Sprite;

   public function Options(gs:GameSprite)
   {
      var tab:OptionsTabTitle = null;
      this.tabs_ = new Vector.<OptionsTabTitle>();
      this.options_ = new Vector.<Sprite>();
      super();
      this.gs_ = gs;
      this.background = this.drawBackground();
      addChild(this.background);
      this.lines = this.drawLines();
      addChild(this.lines);
      this.screenGraphic = this.makeBar();
      addChild(this.screenGraphic);
      this.title_ = new SimpleText(36,16777215,false,800,0);
      this.title_.setBold(true);
      this.title_.htmlText = "<p align=\"center\">Options</p>";
      this.title_.autoSize = TextFieldAutoSize.CENTER;
      this.title_.filters = [new DropShadowFilter(0,0,0)];
      this.title_.updateMetrics();
      this.title_.y = 8;
      addChild(this.title_);
      this.makeBar();
      this.continueButton_ = new TitleMenuOption("continue",36,false);
      this.continueButton_.addEventListener(MouseEvent.CLICK,this.onContinueClick);
      addChild(this.continueButton_);
      this.resetToDefaultsButton_ = new TitleMenuOption("reset",22,false);
      this.resetToDefaultsButton_.addEventListener(MouseEvent.CLICK,this.onResetToDefaultsClick);
      addChild(this.resetToDefaultsButton_);
      this.homeButton_ = new TitleMenuOption("home",22,false);
      this.homeButton_.addEventListener(MouseEvent.CLICK,this.onHomeClick);
      addChild(this.homeButton_);
      var xOffset:int = 14;
      for(var i:int = 0; i < TABS.length; i++)
      {
         tab = new OptionsTabTitle(TABS[i]);
         tab.x = xOffset;
         tab.y = 70;
         addChild(tab);
         tab.addEventListener(MouseEvent.CLICK,this.onTabClick);
         this.tabs_.push(tab);
         xOffset = xOffset + 108;
      }
      addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      this.positionAssets();
      if (WebMain.STAGE)
         WebMain.STAGE.stage.addEventListener(Event.RESIZE, positionAssets);
   }

   private function positionAssets(e:Event = null):void
   {
      var width:int = WebMain.STAGE.stageWidth;
      var height:int = WebMain.STAGE.stageHeight;
      var sWidth:* = 800 / width;
      var sHeight:* = 600 / height;
      var result:* = sHeight / sWidth;
      this.lines.width = 800 * result;
      this.background.width = 800 * result;
      this.screenGraphic.width = 800 * result;
      this.title_.x = (400 * result) - this.title_.width / 2;
      this.continueButton_.x =  (400 * result) - this.continueButton_.width / 2;
      this.resetToDefaultsButton_.x = this.continueButton_.x - 175;
      this.homeButton_.x = this.continueButton_.x + 250;
   }

   private function drawBackground():Sprite
   {
      var box:Sprite = new Sprite();
      var b:Graphics = box.graphics;
      b.clear();
      b.beginFill(2829099,0.8);
      b.drawRect(0,0,800,600);
      b.endFill();
      addChild(box);
      return box;
   }

   private function drawLines():Sprite
   {
      var box:Sprite = new Sprite();
      var b:Graphics = box.graphics;
      b.clear();
      b.lineStyle(2,6184542);
      b.moveTo(0,100);
      b.lineTo(800,100);
      b.lineStyle();
      addChild(box);
      return box;
   }
   private function makeBar():Sprite
   {
      var box:Sprite = new Sprite();
      var b:Graphics = box.graphics;
      b.clear();
      b.beginFill(0, 0.5);
      b.drawRect(0, 525, 800, 75);
      b.endFill();
      addChild(box);
      return box;
   }

   private function onContinueClick(event:MouseEvent) : void
   {
      this.close();
   }

   private function onResetToDefaultsClick(event:MouseEvent) : void
   {
      var option:Option = null;
      for(var i:int = 0; i < this.options_.length; i++)
      {
         option = this.options_[i] as Option;
         if(option != null)
         {
            delete Parameters.data_[option.paramName_];
         }
      }
      Parameters.setDefaults();
      Parameters.save();
      this.refresh();
   }

   public static function refreshCursor():void {
      var _local1:MouseCursorData;
      var _local2:Vector.<BitmapData>;
      if (((!((Parameters.data_.cursorSelect == MouseCursor.AUTO))) && ((registeredCursors.indexOf(Parameters.data_.cursorSelect) == -1)))) {
         _local1 = new MouseCursorData();
         _local1.hotSpot = new Point(15, 15);
         _local2 = new Vector.<BitmapData>(1, true);
         _local2[0] = AssetLibrary.getImageFromSet("cursorsEmbed", int(Parameters.data_.cursorSelect));
         _local1.data = _local2;
         Mouse.registerCursor(Parameters.data_.cursorSelect, _local1);
         registeredCursors.push(Parameters.data_.cursorSelect);
      }
      Mouse.cursor = Parameters.data_.cursorSelect;
   }

   private function onHomeClick(event:MouseEvent) : void
   {
      this.close();
      this.gs_.closed.dispatch();
   }

   private function onTabClick(event:MouseEvent) : void
   {
      var tab:OptionsTabTitle = event.target as OptionsTabTitle;
      this.setSelected(tab);
   }

   private function setSelected(tab:OptionsTabTitle) : void
   {
      if(tab == this.selected_)
      {
         return;
      }
      if(this.selected_ != null)
      {
         this.selected_.setSelected(false);
      }
      this.selected_ = tab;
      this.selected_.setSelected(true);
      this.removeOptions();
      switch(this.selected_.text_)
      {
         case CONTROLS_TAB:
            this.addControlsOptions();
            break;
         case HOTKEYS_TAB:
            this.addHotKeysOptions();
            break;
         case CHAT_TAB:
            this.addChatOptions();
            break;
         case GRAPHICS_TAB:
            this.addGraphicsOptions();
            break;
         case SOUND_TAB:
            this.addSoundOptions();
            break;
         case MISC_TAB:
            this.addMiscOptions();
            break;
         case HOTKEYSV2:
              this.addHotKeys2Options();
      }
   }

   private function onAddedToStage(event:Event) : void
   {
      this.setSelected(this.tabs_[0]);
      stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,1);
      stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false,1);
      this.continueButton_.y = 525;
      this.resetToDefaultsButton_.y = 535;
      this.homeButton_.y = 535;
   }

   private function onRemovedFromStage(event:Event) : void
   {
      stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false);
      stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false);
   }

   private function onKeyDown(event:KeyboardEvent) : void
   {
      if(event.keyCode == Parameters.data_.options)
      {
         this.close();
      }
      event.stopImmediatePropagation();
   }

   private function close() : void
   {
      if (this.gs_.stage)
         this.gs_.stage.removeEventListener(Event.RESIZE, positionAssets);
      stage.focus = null;
      parent.removeChild(this);
   }

   private function onKeyUp(event:KeyboardEvent) : void
   {
      event.stopImmediatePropagation();
   }

   private function removeOptions() : void
   {
      var option:Sprite = null;
      for each(option in this.options_)
      {
         removeChild(option);
      }
      this.options_.length = 0;
      this.optionIndex_ = 0;
   }

   private function addControlsOptions() : void
   {
      this.addOption(new KeyMapper("moveUp","Move Up","Key to will move character up"));
      this.addOption(new KeyMapper("moveLeft","Move Left","Key to will move character to the left"));
      this.addOption(new KeyMapper("moveDown","Move Down","Key to will move character down"));
      this.addOption(new KeyMapper("moveRight","Move Right","Key to will move character to the right"));
      this.addOption(new ChoiceOption("allowRotation",new <String>["On","Off"],[true,false],"Allow Camera Rotation","Toggles whether to allow for camera rotation",this.onAllowRotationChange));
      this.addOption(new Sprite());
      this.addOption(new KeyMapper("rotateLeft","Rotate Left","Key to will rotate the camera to the left",!Parameters.data_.allowRotation));
      this.addOption(new KeyMapper("rotateRight","Rotate Right","Key to will rotate the camera to the right",!Parameters.data_.allowRotation));
      this.addOption(new KeyMapper("useSpecial","Use Special Ability","This key will activate your special ability"));
      this.addOption(new KeyMapper("autofireToggle","Autofire Toggle","This key will toggle autofire"));
      this.addOption(new KeyMapper("resetToDefaultCameraAngle","Reset To Default Camera Angle","This key will reset the camera angle to the default " + "position"));
      this.addOption(new KeyMapper("togglePerformanceStats","Toggle Performance Stats","This key will toggle a display of fps and memory usage"));
      this.addOption(new KeyMapper("toggleCentering","Toggle Centering of Player","This key will toggle the position between centered and " + "offset"));
      this.addOption(new KeyMapper("interact","Interact/Buy","This key will allow you to enter a portal or buy an item"));
      this.addOption(new ChoiceOption("contextualClick",new <String>["On","Off"],[true,false],"Contextual Click","Toggle the contextual click functionality",null));
   }

   private function onAllowRotationChange() : void
   {
      var keyMapper:KeyMapper = null;
      for(var i:int = 0; i < this.options_.length; i++)
      {
         keyMapper = this.options_[i] as KeyMapper;
         if(keyMapper != null)
         {
            if(keyMapper.paramName_ == "rotateLeft" || keyMapper.paramName_ == "rotateRight")
            {
               keyMapper.setDisabled(!Parameters.data_.allowRotation);
            }
         }
      }
   }

   private function addHotKeysOptions() : void
   {
      this.addOption(new KeyMapper("useHealthPotion","Use/Buy Health Potion","This key will use health potions if available, buy if unavailable"));
      this.addOption(new KeyMapper("useMagicPotion","Use/Buy Magic Potion","This key will use magic potions if available, buy if unavailable"));
      this.addOption(new KeyMapper("useInvSlot1","Use Inventory Slot 1","Use item in inventory slot 1"));
      this.addOption(new KeyMapper("useInvSlot2","Use Inventory Slot 2","Use item in inventory slot 1"));
      this.addOption(new KeyMapper("useInvSlot3","Use Inventory Slot 3","Use item in inventory slot 1"));
      this.addOption(new KeyMapper("useInvSlot4","Use Inventory Slot 4","Use item in inventory slot 1"));
      this.addOption(new KeyMapper("useInvSlot5","Use Inventory Slot 5","Use item in inventory slot 1"));
      this.addOption(new KeyMapper("useInvSlot6","Use Inventory Slot 6","Use item in inventory slot 1"));
      this.addOption(new KeyMapper("useInvSlot7","Use Inventory Slot 7","Use item in inventory slot 1"));
      this.addOption(new KeyMapper("useInvSlot8","Use Inventory Slot 8","Use item in inventory slot 1"));
      this.addOption(new KeyMapper("miniMapZoomIn","Mini-Map Zoom In","This key will zoom in the minimap"));
      this.addOption(new KeyMapper("miniMapZoomOut","Mini-Map Zoom Out","This key will zoom out the minimap"));
      this.addOption(new KeyMapper("escapeToNexus","Escape To Nexus","This key will instantly escape you to the Nexus"));
      this.addOption(new KeyMapper("options","Show Options","This key will bring up the options screen"));
      this.addOption(new KeyMapper("switchTabs", "Switch Tabs", "This key will switch from available tabs"));
      var key:String = Capabilities.os.split(" ")[0] == "Mac"?"Command":"Ctrl";
      this.addOption(new ChoiceOption("inventorySwap",new <String>["On","Off"],[true,false],"Switch item to/from backpack.","Hold the " + key + " key and click on an item to swap it between your inventory and your backpack.",null));
   }

   private function addChatOptions() : void
   {
      this.addOption(new KeyMapper("chat","Activate Chat","This key will bring up the chat input box"));
      this.addOption(new KeyMapper("chatCommand","Start Chat Command","This key will bring up the chat with a \'/\' prepended to " + "allow for commands such as /who, /ignore, etc."));
      this.addOption(new KeyMapper("tell","Begin Tell","This key will bring up a tell (private message) in the chat" + " input box"));
      this.addOption(new KeyMapper("guildChat","Begin Guild Chat","This key will bring up a guild chat in the chat" + " input box"));
      this.addOption(new KeyMapper("partyChat","Begin Party Chat","This key will bring up a Party Chat in the chat" + " input box"));
      this.addOption(new KeyMapper("scrollChatUp","Scroll Chat Up","This key will scroll up to older messages in the chat " + "buffer"));
      this.addOption(new KeyMapper("scrollChatDown","Scroll Chat Down","This key will scroll down to newer messages in the chat " + "buffer"));
   }

   private function addGraphicsOptions() : void
   {
      this.addOption(new ChoiceOption("defaultCameraAngle",new <String>["45°","0°"],[7 * Math.PI / 4,0],"Default Camera Angle","This toggles the default camera angle",this.onDefaultCameraAngleChange));
      this.addOption(new ChoiceOption("centerOnPlayer",new <String>["On","Off"],[true,false],"Center On Player","This toggles whether the player is centered or offset",null));
      this.addOption(new ChoiceOption("showQuestPortraits",new <String>["On","Off"],[true,false],"Show Quest Portraits","This toggles whether quest portraits are displayed",this.onShowQuestPortraitsChange));
      this.addOption(new ChoiceOption("toggleBarText", new <String>["On","Off"], [1, 0], "Toggle HP/MP Text", "Always show text value for remaining HP/MP", onBarTextToggle));
      this.addOption(new ChoiceOption("drawShadows",new <String>["On","Off"],[true,false],"Draw Shadows","This toggles whether to draw shadows",null));
      this.addOption(new ChoiceOption("textBubbles",new <String>["On","Off"],[true,false],"Draw Text Bubbles","This toggles whether to draw text bubbles",null));
      this.addOption(new ChoiceOption("showTradePopup",new <String>["On","Off"],[true,false],"Show Trade Request Panel","This toggles whether to show trade requests in the " + "lower-right panel or just in chat.",null));
      this.addOption(new ChoiceOption("showGuildInvitePopup",new <String>["On","Off"],[true,false],"Show Guild Invite Panel","This toggles whether to show guild invites in the " + "lower-right panel or just in chat.",null));
      this.addOption(new ChoiceOption("cursorSelect", new <String>["Off", "ProX", "X2", "X3", "X4", "Corner1", "Corner2", "Symb", "Alien", "Xhair", "Dystopia+"], [MouseCursor.AUTO, "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"], "Custom Cursor", "Click here to change the mouse cursor. May help with aiming.", refreshCursor));
      this.addOption(new ChoiceOption("GPURender", new <String>["On","Off"],[true,false],"Hardware Acceleration","Enables Hardware Acceleration if your system supports it",this.renderer));
      this.addOption(new ChoiceOption("hpBars", new <String>["On","Off"], [true,false], "Health Bars", "This toggles whether to health bars under entities (players & enemies).", null));
      this.addOption(new ChoiceOption("uiQuality", new <String>["On","Off"], [true, false], "UI Quality", "Enable High/Low UI Quality.", this.onUIQualityToggle));
      this.addOption(new ChoiceOption("hideList", new <String>["Off", "Locked", "Guild", "Party", "L/G/P"], [0, 1, 2, 3, 4], "Hide Players", "Hide players on screen", null));
      this.addOption(new ChoiceOption("showTierTag", new <String>["On","Off"], [true,false], "Show Tier Tag","This toggles whether to show tier tags on your gear", onToggleTierTag));
      this.addOption(new ChoiceOption("fps", new <String>["60", "75", "120", "144", "165", "240", "360"], [60, 75, 120, 144, 165, 240, 360], "FPS", "Increase or Decrease the framerate.", this.fps));
      this.addOption(new ChoiceOption("toggleFullscreen", new <String>["On","Off"], [true,false], "Fullscreen Mode", "Changes your game to Fullscreen mode.", this.fsv3));
      this.addOption(new ChoiceOption("showStatistics", new <String>["On","Off"], [true, false], "Performance Stats", "Changes whether or not you see performance stats.", this.statistics));
   }

   private function addMiscOptions() : void
   {
      this.addOption(new ChoiceOption("disableAllyParticles", new <String>["On","Off"], [true, false], "Disable ally Particles", "Disable particles produces by shooting ally.", null));
      this.addOption(new ChoiceOption("disableAllParticles", new <String>["On","Off"], [true, false], "Disable ALL Particles", "Enable/Disable ALL Particles.", null));
      this.addOption(new ChoiceOption("itemDataOutlines",new <String>["On","Off"],[0,1],"Tooltip Outlines","Change the outlines of the xml\'s!",null));
      this.addOption(new ChoiceOption("uiscale", new <String>["On","Off"], [true, false], "Element Scaling", "Scales chat and other elements.", this.renderer));
      this.addOption(new ChoiceOption("hudscale", new <String>["On","Off"], [true, false], "HUD Scaling", "Scales chat and other elements.", this.renderer));
      //this.addOption(new ChoiceOption("eyeCandyParticles", new <String>["On","Off"], [true,false], "Eye Candy Particles", "This toggles whether to show eye candy particles, disabling this will improve performance.", null));
      this.addOption(new ChoiceOption("allyShots", new <String>["On","Off"], [true,false], "Ally Shots", "This toggles whether to show and render ally shots. Disable this to improve performance.", null));
      this.addOption(new ChoiceOption("allyDamage", new <String>["On","Off"], [true,false], "Ally Damage", "This toggles whether to show damage dealt to and by allies. Disable this to improve performance.", null));
      this.addOption(new ChoiceOption("noAllyNotifications", new <String>["On","Off"], [true, false], "Disable Ally Notifications", "Disable text notifications above allies.", null));
      this.addOption(new ChoiceOption("projOutline", new <String>["On", "Off"], [true,false], "Projectile Outline", "Makes projectiles have an outline.", null));
      this.addOption(new ChoiceOption("smartProjectiles", new <String>["On", "Off"], [true,false], "Projectile Direction", "Makes projectiles face the direction they're going.", null));
      this.addOption(new ChoiceOption("HPBarcolors",new <String>["On","Off"],[true,false],"Dynamic HP Colors","Make the background of HPBar and others have color.",null));
      this.addOption(new ChoiceOption("dynamicHPcolor", new <String>["On","Off"],[true,false],"Dynamic Damage Text","Makes the damage text change color based on health",null));
   }

    private function renderer() : void
    {
        Parameters.root.dispatchEvent(new Event(Event.RESIZE));
    }

   private function fps() : void
   {
      WebMain.STAGE.frameRate = Parameters.data_.fps;
   }

   private function statistics():void
   {
      this.gs_.toggleStatistics();
   }

    private function fsv3() : void
   {
      if (Parameters.data_.toggleFullscreen)
         this.gs_.stage.displayState = "fullScreenInteractive";
      else
         this.gs_.stage.displayState = StageDisplayState.NORMAL;
   }

   public function onUIQualityToggle():void {
      this.toggleQuality(Parameters.data_.uiQuality);
   }

   public function toggleQuality(_arg1:Boolean):void {
      if (WebMain.STAGE != null) {
         WebMain.STAGE.quality = ((_arg1) ? StageQuality.HIGH : StageQuality.LOW);
      }
   }

   public static function toggleQualityOption(_arg1:Boolean):void {
      if (WebMain.STAGE != null) {
         WebMain.STAGE.quality = ((_arg1) ? StageQuality.HIGH : StageQuality.LOW);
      }
   }

   private function addHotKeys2Options() : void
   {
      this.addOption(new KeyMapper("reconGuildHall","Recon Guild Hall","Allows you to reconnect to the Guild Hall!"));
      this.addOption(new KeyMapper("reconVault","Recon Vault","Allows you to reconnect to Vault!"));
      this.addOption(new KeyMapper("reconRealm","Recon Realm","Allows you to reconnect to Realm!"));
      this.addOption(new KeyMapper("GPURenderToggle","GPU Render Toggle","Enable and Disable the Hardware Acceleration."));
      this.addOption(new KeyMapper("uiQualityToggle","UI Quality Toggle","Enable High/Low UI Quality."));
      this.addOption(new KeyMapper("partyInviteWorld","Invite World Party","Invite your members Party to your World!"));
      this.addOption(new KeyMapper("partyJoinWorld","Join World Party","Join to the World you were invited!"));
   }

   private static function onToggleTierTag() : void {
      StaticInjectorContext.getInjector().getInstance(ToggleShowTierTagSignal).dispatch(Parameters.data_.showTierTag);
   }

   private function onDefaultCameraAngleChange() : void
   {
      Parameters.data_.cameraAngle = Parameters.data_.defaultCameraAngle;
      Parameters.save();
   }

   private static function onBarTextToggle():void {
      //StatusBar.barTextSignal.dispatch(Parameters.data_.toggleBarText);
   }

   private function onShowQuestPortraitsChange() : void
   {
      if(this.gs_ != null && this.gs_.map != null && this.gs_.map.partyOverlay_ != null && this.gs_.map.partyOverlay_.questArrow_ != null)
      {
         this.gs_.map.partyOverlay_.questArrow_.refreshToolTip();
      }
   }

   private function addSoundOptions() : void
   {
      this.addOption(new ChoiceOption("playMusic",new <String>["On","Off"],[true,false],"Play Music","This toggles whether music is played",this.onPlayMusicChange));
      this.addOption(new Sprite());
      this.addOption(new SliderOption("musicVolume", onMusicVolumeChange), 90, 15);
      this.addOption(new Sprite());
      this.addOption(new ChoiceOption("playSFX",new <String>["On","Off"],[true,false],"Play Sound Effects","This toggles whether sound effects are played",this.onPlaySoundEffectsChange));
      this.addOption(new Sprite());
      this.addOption(new ChoiceOption("playPewPew",new <String>["On","Off"],[true,false],"Play Weapon Sounds","This toggles whether weapon sounds are played",null));
   }

   private function onPlayMusicChange() : void
   {
      Music.setPlayMusic(Parameters.data_.playMusic);
      this.refresh();
   }

   private static function onMusicVolumeChange(_arg1:Number):void {
      Music.setMusicVolume(_arg1);
   }

   private function onPlaySoundEffectsChange() : void
   {
      SFX.setPlaySFX(Parameters.data_.playSFX);
   }

   private function addOption(option:Sprite, offsetX:Number = 0, offsetY:Number = 0) : void
   {
      option.x = (this.optionIndex_ % 2 == 0?Number(20):Number(415)) + Number(offsetX);
      option.y = (int(this.optionIndex_ / 2) * 44 + 122) + Number(offsetY);
      addChild(option);
      option.addEventListener(Event.CHANGE,this.onChange);
      this.options_.push(option);
      this.optionIndex_++;
   }
/*
   private function addOptionAndPosition(option:Sprite, offsetX:Number = 0, offsetY:Number = 0):void {
      option.x = this.optionIndex_ % 2 == 0?Number(20):Number(415) + offsetX;
      option.y = int(this.optionIndex_ / 2) * 44 + 122 +offsetY;
      option.addEventListener(Event.CHANGE,this.onChange);
      this.options_.push(option);
      this.optionIndex_++;
   }*/

   private function onChange(event:Event) : void
   {
      this.refresh();
   }

   private function refresh() : void
   {
      var option:Option = null;
      for(var i:int = 0; i < this.options_.length; i++)
      {
         option = this.options_[i] as Option;
         if(option != null)
         {
            option.refresh();
         }
      }
   }
}
}
