package com.company.assembleegameclient.game
{
import com.company.assembleegameclient.game.GameStatistics;
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.IInteractiveObject;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects.Projectile;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.tutorial.Tutorial;
import com.company.assembleegameclient.ui.GuildText;
import com.company.assembleegameclient.ui.RankText;
import com.company.assembleegameclient.ui.TextBox;
import com.company.assembleegameclient.ui.menu.PlayerMenu;
import com.company.assembleegameclient.util.FreeList;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util.TileRedrawer;
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.ui.SimpleText;
import com.company.util.BitmapUtil;
import com.company.util.CachingColorTransformer;
import com.company.util.MoreColorUtil;
import com.company.util.PointUtil;
import com.gskinner.motion.GTween;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.external.ExternalInterface;
import flash.filters.ColorMatrixFilter;
import flash.filters.DropShadowFilter;
import flash.system.System;
import flash.utils.ByteArray;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import kabam.lib.loopedprocs.LoopedCallback;
import kabam.lib.loopedprocs.LoopedProcess;
import kabam.rotmg.constants.GeneralConstants;
import kabam.rotmg.core.model.MapModel;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.core.view.Layers;
import kabam.rotmg.game.view.CreditDisplay;
import kabam.rotmg.messaging.impl.GameServerConnection;
import kabam.rotmg.messaging.impl.incoming.MapInfo;
import kabam.rotmg.servers.api.Server;
import kabam.rotmg.stage3D.Renderer;
import kabam.rotmg.ui.UIUtils;
import kabam.rotmg.ui.view.BossHealthBar;
import kabam.rotmg.ui.view.HUDView;

import org.osflash.signals.Signal;

public class GameSprite extends Sprite
{
   protected static const PAUSED_FILTER:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix);

   public const closed:Signal = new Signal();
   public const modelInitialized:Signal = new Signal();
   public const drawCharacterWindow:Signal = new Signal(Player);
   public var map:Map;
   public var camera_:Camera;
   public var gsc_:GameServerConnection;
   public var mui_:MapUserInput;
   public var textBox_:TextBox;
   public var tutorial_:Tutorial;
   public var isNexus_:Boolean = false;
   public var isVault_:Boolean = false;
   public var idleWatcher_:IdleWatcher;
   public var hudView:HUDView;
   public var rankText_:RankText;
   public var guildText_:GuildText;
   public var creditDisplay_:CreditDisplay;
   public var isEditor:Boolean;
   public var lastUpdate_:int = 0;
   public var moveRecords_:MoveRecords;
   public var mapModel:MapModel;
   public var model:PlayerModel;
   private var focus:GameObject;
   private var isGameStarted:Boolean;
   private var displaysPosY:uint = 4;
   public var chatPlayerMenu:PlayerMenu;
   public var bossHealthBar:BossHealthBar;

   public function GameSprite(server:Server, gameId:int, createCharacter:Boolean, charId:int, keyTime:int, key:ByteArray, model:PlayerModel, mapJSON:String)
   {
      this.camera_ = new Camera();
      this.moveRecords_ = new MoveRecords();
      super();
      this.model = model;
      this.map = new Map(this);
      addChild(this.map);
      this.gsc_ = new GameServerConnection(this,server,gameId,createCharacter,charId,keyTime,key,mapJSON);
      this.mui_ = new MapUserInput(this);
      this.textBox_ = new TextBox(this,600,600);
      addChild(this.textBox_);
      this.textBox_.addEventListener(MouseEvent.MOUSE_DOWN,this.onChatDown);
      this.textBox_.addEventListener(MouseEvent.MOUSE_UP,this.onChatUp);
      this.idleWatcher_ = new IdleWatcher();
      this.bossHealthBar = new BossHealthBar();
      this.bossHealthBar.x = 5;
      this.bossHealthBar.y = 5;
      this.bossHealthBar.visible = false;
      addChild(this.bossHealthBar);
   }

   public function updateBossBar() : void
   {
      var gameObject:GameObject = null;
      var objectId:int = 0;

      for each(gameObject in map.goDict_)
      {
         if((gameObject.props_.isQuest_ || gameObject.props_.isChest_) && Parameters.DamageCounter[gameObject.objectId_] > 0 && objectId == 0)
         {
            objectId = gameObject.objectId_;
         }

         if(objectId == 0){
            bossHealthBar.setDamageInflicted(-1);
         }

         if((gameObject.props_.isQuest_ || gameObject.props_.isChest_) && Parameters.DamageCounter[gameObject.objectId_] > 0)
         {
            if(gameObject != null)
            {
               if(Parameters.DamageCounter[gameObject.objectId_] > gameObject.maxHP_)
                  Parameters.DamageCounter[gameObject.objectId_] = gameObject.maxHP_;
               var dmgInflicted:int = Parameters.DamageCounter[gameObject.objectId_] / gameObject.maxHP_ * 100;
               bossHealthBar.setDamageInflicted(dmgInflicted);
            }
         }
      }
   }

   public function setFocus(focus:GameObject) : void
   {
      focus = focus || this.map.player_;
      this.focus = focus;
   }

   public function applyMapInfo(mapInfo:MapInfo) : void
   {
      this.map.setProps(mapInfo.width_,mapInfo.height_,mapInfo.name_,mapInfo.background_,mapInfo.allowPlayerTeleport_,mapInfo.showDisplays_,mapInfo.disableShooting_,mapInfo.disableAbilitites_);
      this.showPreloader(mapInfo);
   }

   public function showPreloader(mapInfo:MapInfo) : void
   {
      //var showMapLoading:ShowMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(ShowMapLoadingSignal);
      //showMapLoading && showMapLoading.dispatch(mapInfo);
   }

   private function hidePreloader() : void
   {
      //var hideMapLoading:HideMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
      //hideMapLoading && hideMapLoading.dispatch();
   }

   public function hudModelInitialized() : void
   {
      this.hudView = new HUDView();
      this.hudView.x = 600;
      addChild(this.hudView);
   }

   public function initialize() : void
   {
      this.map.initialize();
      this.creditDisplay_ = new CreditDisplay(this, true);
      this.creditDisplay_.x = 594;
      this.creditDisplay_.y = 0;
      addChild(this.creditDisplay_);
      this.modelInitialized.dispatch();

      if(this.map.showDisplays_)
         this.showSafeAreaDisplays();
      if(this.map.name_ == "Tutorial")
         this.startTutorial();
      if (this.map.name_ == "Nexus")
         isNexus_ = true;
      if (this.map.name_ == "Vault")
         isVault_ = true;

      this.hidePreloader();
      stage.dispatchEvent(new Event(Event.RESIZE));
      this.parent.parent.setChildIndex((this.parent.parent as Layers).top, 2);

      if(Parameters.data_.showStatistics)
      {
         this.creditDisplay_.visible = false;
         this.enableGameStatistics();
      } else
      {
         this.creditDisplay_.visible = true;
      }

      WebMain.STAGE.frameRate = Parameters.data_.fps;
   }

   private function showSafeAreaDisplays() : void
   {
      this.showRankText();
      this.showGuildText();
   }

   private function showGuildText() : void
   {
      this.guildText_ = new GuildText("",-1);
      this.guildText_.x = 64;
      this.guildText_.y = 6;
      addChild(this.guildText_);
   }

   private function showRankText() : void
   {
      this.rankText_ = new RankText(-1,true,false);
      this.rankText_.x = 8;
      this.rankText_.y = this.displaysPosY;
      this.displaysPosY = this.displaysPosY + UIUtils.NOTIFICATION_SPACE;
      addChild(this.rankText_);
   }

   private function startTutorial() : void
   {
      this.tutorial_ = new Tutorial(this);
      addChild(this.tutorial_);
   }

   private function updateNearestInteractive() : void
   {
      var dist:Number = NaN;
      var go:GameObject = null;
      var iObj:IInteractiveObject = null;
      if(!this.map || !this.map.player_)
      {
         return;
      }
      var player:Player = this.map.player_;
      var minDist:Number = GeneralConstants.MAXIMUM_INTERACTION_DISTANCE;
      var closestInteractive:IInteractiveObject = null;
      var playerX:Number = player.x_;
      var playerY:Number = player.y_;
      for each(go in this.map.goDict_)
      {
         iObj = go as IInteractiveObject;
         if(iObj)
         {
            if(Math.abs(playerX - go.x_) < GeneralConstants.MAXIMUM_INTERACTION_DISTANCE || Math.abs(playerY - go.y_) < GeneralConstants.MAXIMUM_INTERACTION_DISTANCE)
            {
               dist = PointUtil.distanceXY(go.x_,go.y_,playerX,playerY);
               if(dist < GeneralConstants.MAXIMUM_INTERACTION_DISTANCE && dist < minDist)
               {
                  minDist = dist;
                  closestInteractive = iObj;
               }
            }
         }
      }
      this.mapModel.currentInteractiveTarget = closestInteractive;
   }

   public function onScreenResize(_arg_1:Event):void
   {
      var uiscale:Boolean = Parameters.data_.uiscale;
      var sWidth:Number = (800 / stage.stageWidth);
      var sHeight:Number = (600 / stage.stageHeight);
      var result:Number = (sWidth / sHeight);
      if (this.map != null)
      {
         this.map.scaleX = (sWidth * Parameters.data_.mscale);
         this.map.scaleY = (sHeight * Parameters.data_.mscale);
      }
      if (this.bossHealthBar != null)
      {
         if (uiscale)
         {
            this.bossHealthBar.scaleX = result;
            this.bossHealthBar.scaleY = 1;
         }
         else
         {
            this.bossHealthBar.scaleX = sWidth;
            this.bossHealthBar.scaleY = sHeight;
         }
      }
      if (this.hudView != null)
      {
         if (!Parameters.data_.hudscale)
         {
            this.hudView.scaleX = result;
            this.hudView.scaleY = 1;
            this.hudView.y = 0;
         }
         else
         {
            this.hudView.scaleX = sWidth;
            this.hudView.scaleY = sHeight;
            //this.hudView.y = (300 * (1 - sHeight));
         }
         this.hudView.x = (800 - (200 * this.hudView.scaleX));
         if (this.creditDisplay_ != null)
         {
            this.creditDisplay_.x = (this.hudView.x - (6 * this.creditDisplay_.scaleX));
         }
      }
      if (this.textBox_ != null) {
         if (uiscale) {
            this.textBox_.scaleX = result;
            this.textBox_.scaleY = 1;
            this.textBox_.y = 0;
         } else {
            this.textBox_.scaleX = sWidth;
            this.textBox_.scaleY = sHeight;
            this.textBox_.y = (600 * (1 - sHeight));
         }
         //trace("resize",chatBox_.y,chatBox_.list.y)
      }
      if (this.rankText_ != null)
      {
         if (uiscale)
         {
            this.rankText_.scaleX = result;
            this.rankText_.scaleY = 1;
         }
         else
         {
            this.rankText_.scaleX = sWidth;
            this.rankText_.scaleY = sHeight;
         }
         this.rankText_.x = (8 * this.rankText_.scaleX);
         this.rankText_.y = (2 * this.rankText_.scaleY);
      }
      if (this.guildText_ != null)
      {
         if (uiscale)
         {
            this.guildText_.scaleX = result;
            this.guildText_.scaleY = 1;
         }
         else
         {
            this.guildText_.scaleX = sWidth;
            this.guildText_.scaleY = sHeight;
         }
         this.guildText_.x = (64 * this.guildText_.scaleX);
         this.guildText_.y = (2 * this.guildText_.scaleY);
      }
      if (this.creditDisplay_ != null)
      {
         if (uiscale)
         {
            this.creditDisplay_.scaleX = result;
            this.creditDisplay_.scaleY = 1;
         }
         else
         {
            this.creditDisplay_.scaleX = sWidth;
            this.creditDisplay_.scaleY = sHeight;
         }
      }
      if (this.gameStatistics_ != null)
      {
         if (uiscale)
         {
            this.gameStatistics_.scaleX = result;
            this.gameStatistics_.scaleY = 1;
         }
         else
         {
            this.gameStatistics_.scaleX = sWidth;
            this.gameStatistics_.scaleY = sHeight;
         }
      }
      if (this.gameStatistics_ != null)
      {
         this.gameStatistics_.x = this.hudView.x - (this.gameStatistics_.container_.width * this.gameStatistics_.scaleX);
      }
   }

   public var gameStatistics_:GameStatistics;
   public function enableGameStatistics():void {
      if (this.gameStatistics_ != null) {
         this.gameStatistics_.visible = true;
      }
      else {
         this.gameStatistics_ = new GameStatistics();
         if (Parameters.data_.uiscale)
         {
            this.gameStatistics_.scaleX = (800 / stage.stageWidth) / (600 / stage.stageHeight);
            this.gameStatistics_.scaleY = 1;
         }
         else
         {
            this.gameStatistics_.scaleX = 800 / stage.stageWidth;
            this.gameStatistics_.scaleY = 600 / stage.stageHeight;
         }
         this.gameStatistics_.x = this.hudView.x - (this.gameStatistics_.container_.width * this.gameStatistics_.scaleX);
         addChild(this.gameStatistics_);
      }
   }

   public function disableGameStatistics():void {
      if (this.gameStatistics_ != null) {
         this.gameStatistics_.visible = false;
      }
   }

   public function connect() : void
   {
      if(!this.isGameStarted)
      {
         this.isGameStarted = true;
         Renderer.inGame = true;
         this.gsc_.connect();
         this.idleWatcher_.start(this);
         this.lastUpdate_ = getTimer();
         stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         if(Parameters.data_.FS){
            if (Parameters.data_.mscale == undefined)
            {
               Parameters.data_.mscale = "1.0";
            }
            if (Parameters.data_.stageScale == undefined)
            {
               Parameters.data_.stageScale = StageScaleMode.NO_SCALE;
            }
            if (Parameters.data_.uiscale == undefined)
            {
               Parameters.data_.uiscale = true;
            }
            Parameters.save();
            stage.scaleMode = Parameters.data_.stageScale;
            stage.addEventListener(Event.RESIZE, this.onScreenResize);
            stage.dispatchEvent(new Event(Event.RESIZE));
         }
         Parameters.DamageCounter = [];
      }
   }

   public function disconnect() : void
   {
      if(this.isGameStarted)
      {
         this.isGameStarted = false;
         Renderer.inGame = false;
         this.idleWatcher_.stop();
         this.gsc_.serverConnection.disconnect();
         stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.removeEventListener(Event.RESIZE, this.onScreenResize);
         stage.scaleMode = StageScaleMode.EXACT_FIT;
         stage.dispatchEvent(new Event(Event.RESIZE));
         contains(this.map) && removeChild(this.map);
         this.map.dispose();
         this.hudView && this.hudView.miniMap.dispose();
         CachingColorTransformer.clear();
         TextureRedrawer.clearCache();
         GlowRedrawer.clearCache();
         Projectile.dispose();
         FreeList.dispose();
         this.gsc_.disconnect();
         Parameters.DamageCounter = [];
         if(this.gameStatistics_ != null && contains(this.gameStatistics_)){
            removeChild(this.gameStatistics_);
         }
      }
   }

   private function onEnterFrame(event:Event) : void
   {
      var time:int = getTimer();
      var dt:int = time - this.lastUpdate_;
      if(this.idleWatcher_.update(dt))
      {
         this.closed.dispatch();
         return;
      }

      this.updateNearestInteractive();
      if(this.bossHealthBar != null && this.bossHealthBar.visible){
         this.bossHealthBar.draw();
      }

      this.map.update(time,dt);
      this.camera_.update(dt);
      var player:Player = this.map.player_;
      if(this.focus)
      {
         this.camera_.configureCamera(this.focus,Boolean(player)?Boolean(player.isHallucinating()):Boolean(false));
         this.map.draw(this.camera_,time);
      }
      if(player != null)
      {
         this.creditDisplay_.draw(player.credits_,player.fame_);
         this.drawCharacterWindow.dispatch(player); // might be causing leak
         if(this.map.showDisplays_)
         {
            this.rankText_.draw(player.numStars_);
            this.guildText_.draw(player.guildName_,player.guildRank_);
         }

         if(player.isPaused())
         {
            this.map.filters = [PAUSED_FILTER];
            this.hudView.filters = [PAUSED_FILTER];
            this.map.mouseEnabled = false;
            this.map.mouseChildren = false;
            this.hudView.mouseEnabled = false;
            this.hudView.mouseChildren = false;
         }
         else if(this.map.filters.length > 0)
         {
            this.map.filters = [];
            this.hudView.filters = [];
            this.map.mouseEnabled = true;
            this.map.mouseChildren = true;
            this.hudView.mouseEnabled = true;
            this.hudView.mouseChildren = true;
         }
         this.moveRecords_.addRecord(time,player.x_,player.y_);
      }
      this.lastUpdate_ = time;
      updateBossBar();
   }

   public function onChatDown(param1:MouseEvent) : void
   {
      if(this.chatPlayerMenu != null)
      {
         this.removeChatPlayerMenu();
      }
      this.mui_.onMouseDown(param1);
   }

   public function onChatUp(param1:MouseEvent) : void
   {
      this.mui_.onMouseUp(param1);
   }

   public function addChatPlayerMenu(param1:Player, param2:Number, param3:Number) : void
   {
      this.removeChatPlayerMenu();
      this.chatPlayerMenu = new PlayerMenu();
      this.chatPlayerMenu.init(this,param1);
      stage.addChild(this.chatPlayerMenu);
      this.chatPlayerMenu.x = param2;
      this.chatPlayerMenu.y = param3 - this.chatPlayerMenu.height;
   }

   public function removeChatPlayerMenu() : void
   {
      if(this.chatPlayerMenu != null && this.chatPlayerMenu.parent != null)
      {
         removeChild(this.chatPlayerMenu);
         this.chatPlayerMenu = null;
      }
   }
}
}
