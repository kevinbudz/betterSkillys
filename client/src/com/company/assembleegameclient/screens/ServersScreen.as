package com.company.assembleegameclient.screens
{
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.IconButton;
import com.company.assembleegameclient.ui.Scrollbar;
import com.company.assembleegameclient.ui.dialogs.Dialog;
import com.company.rotmg.graphics.ScreenGraphic;
   import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;

import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
import flash.utils.getTimer;

import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.servers.api.Server;
import kabam.rotmg.servers.api.ServerModel;
import kabam.rotmg.servers.signals.RefreshServerSignal;
import kabam.rotmg.ui.noservers.NoServersDialogFactory;
import kabam.rotmg.ui.view.components.ScreenBase;
   import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeSignal;

public class ServersScreen extends Sprite
   {
       
      
      private var doneButton_:TitleMenuOption;
      
      private var selectServerText_:SimpleText;
      
      private var lines_:Shape;
      
      private var content_:Sprite;
      
      private var serverBoxes_:ServerBoxes;
      
      private var scrollBar_:Scrollbar;

      private var button:IconButton;

      public var gotoTitle:Signal;
      public var updateServers:Signal;
      private var nexusClicked:NativeSignal;
      private var title:SimpleText;
      private var screenGraphic:Sprite;

      public function ServersScreen()
      {
         super();
         addChild(new ScreenBase());
         this.gotoTitle = new Signal();
         this.updateServers = new Signal();
         addChild(new ScreenBase());
         addChild(new AccountScreen());
         this.screenGraphic = makeScreenGraphic();
         addChild(this.screenGraphic);
         this.makeTitleText();
      }

      public function positionAssets(e:Event = null):void
      {
         if (e != null)
         {
            ScreenBase.reSize(e);
            AccountScreen.reSize(e);
         }
         var width:int = WebMain.STAGE.stageWidth;
         var height:int = WebMain.STAGE.stageHeight;

         this.title.x = width / 2 - this.title.width / 2;
         this.lines_.width = width;
         this.screenGraphic.width = width;
         this.screenGraphic.y = height - 75;
         this.button.x = width / 2 + 200;
         this.doneButton_.x = width / 2 - this.doneButton_.width / 2;
         this.doneButton_.y = height - 70;
         this.content_.x = width / 2 - this.content_.width / 2;
      }

      private function makeTitleText() : void
      {
         this.title = new SimpleText(32,11776947,false,0,0);
         this.title.setBold(true);
         this.title.text = "Servers";
         this.title.updateMetrics();
         this.title.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.title.y = 24;
         addChild(this.title);
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
      
      private function onScrollBarChange(event:Event) : void
      {
         this.serverBoxes_.y = 8 - this.scrollBar_.pos() * (this.serverBoxes_.height - 400);
      }
      
      public function initialize(servers:Vector.<Server>) : void
      {
         this.selectServerText_ = new SimpleText(18,11776947,false,0,0);
         this.selectServerText_.setBold(true);
         this.selectServerText_.text = "Select Server";
         this.selectServerText_.updateMetrics();
         this.selectServerText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.selectServerText_.x = 18;
         this.selectServerText_.y = 72;
         addChild(this.selectServerText_);
         this.lines_ = new Shape();
         addChild(this.lines_);
         this.content_ = new Sprite();
         this.content_.y = 100;
         var maskShape:Shape = new Shape();
         maskShape.graphics.beginFill(16777215);
         maskShape.graphics.drawRect(0,0,776,430);
         maskShape.graphics.endFill();
         this.content_.addChild(maskShape);
         this.content_.mask = maskShape;
         addChild(this.content_);
         this.serverBoxes_ = new ServerBoxes(servers);
         this.serverBoxes_.y = 8;
         this.serverBoxes_.addEventListener(Event.COMPLETE,this.onDone);
         this.content_.addChild(this.serverBoxes_);
         if(this.serverBoxes_.height > 400)
         {
            this.scrollBar_ = new Scrollbar(16,400);
            this.scrollBar_.x = 800 - this.scrollBar_.width - 4;
            this.scrollBar_.y = 104;
            this.scrollBar_.setIndicatorSize(400,this.serverBoxes_.height);
            this.scrollBar_.addEventListener(Event.CHANGE,this.onScrollBarChange);
            addChild(this.scrollBar_);
         }

         this.doneButton_ = new TitleMenuOption("done",36,false);
         this.doneButton_.addEventListener(MouseEvent.CLICK,this.onDone);
         addChild(this.doneButton_);
         var g:Graphics = this.lines_.graphics;
         g.clear();
         g.lineStyle(2,5526612);
         g.moveTo(0,100);
         g.lineTo(stage.stageWidth,100);
         g.lineStyle();

         this.button = new IconButton(AssetLibrary.getImageFromSet("lofiInterfaceBig",15),"Refresh","refresh_button_servers");
         this.button.y = 126;
         addChild(this.button);

         this.nexusClicked = new NativeSignal(this.button,MouseEvent.CLICK,MouseEvent);
         this.nexusClicked.add(this.onNexusClick);

         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.positionAssets();
         if (WebMain.STAGE)
             WebMain.STAGE.addEventListener(Event.RESIZE, positionAssets);
      }

      private function onAddedToStage(event:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }

      private function onRemovedFromStage(event:Event) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }

      private var lastTime:int = 200;

      private function onKeyDown(event:KeyboardEvent) : void {
         if (getTimer() - lastTime >= 200 && event.keyCode == Parameters.data_.refresh_button_servers) {
            this.request();
            lastTime = getTimer();
         }
      }

      private function onDone(event:Event) : void
      {
         this.gotoTitle.dispatch();
      }

      private function onNexusClick(event:MouseEvent) : void
      {
         request();
      }

      private function request():void{

         var client:AppEngineClient = StaticInjectorContext.getInjector().getInstance(AppEngineClient);

         client.complete.addOnce(this.onComplete);
         client.sendRequest("/app/serverList", {});
      }

      private function onComplete(isOK:Boolean, data:*) : void {
         var refreshServerSignal:RefreshServerSignal = StaticInjectorContext.getInjector().getInstance(RefreshServerSignal);
         refreshServerSignal.dispatch(XML(data));

         var serverModel:ServerModel = StaticInjectorContext.getInjector().getInstance(ServerModel);

         if (this.content_.contains(this.serverBoxes_)) {
            this.serverBoxes_.removeEventListener(Event.COMPLETE, this.onDone);
            this.content_.removeChild(this.serverBoxes_);
         }

         if (this.scrollBar_ && contains(this.scrollBar_)) {
            this.scrollBar_.removeEventListener(Event.CHANGE, this.onScrollBarChange);
            removeChild(this.scrollBar_);
         }

         var servers:Vector.<Server> = serverModel.getServers();
         this.serverBoxes_ = new ServerBoxes(servers);
         this.serverBoxes_.y = 8;
         this.serverBoxes_.addEventListener(Event.COMPLETE, this.onDone);
         this.content_.addChild(this.serverBoxes_);
         if (this.serverBoxes_.height > 400) {
            this.scrollBar_ = new Scrollbar(16, 400);
            this.scrollBar_.x = 800 - this.scrollBar_.width - 4;
            this.scrollBar_.y = 104;
            this.scrollBar_.setIndicatorSize(400, this.serverBoxes_.height);
            this.scrollBar_.addEventListener(Event.CHANGE, this.onScrollBarChange);
            addChild(this.scrollBar_);
         }

         if (servers.length == 0) {

            var noServersDialogFactory:NoServersDialogFactory = StaticInjectorContext.getInjector().getInstance(NoServersDialogFactory);
            var openDialog:OpenDialogSignal = StaticInjectorContext.getInjector().getInstance(OpenDialogSignal);

            var dialog:Dialog = noServersDialogFactory.makeDialog();
            dialog.addEventListener(Dialog.BUTTON1_EVENT, this.closeDialog);
            openDialog.dispatch(dialog);
         }
      }

      private function closeDialog(_arg1:Event):void
      {
         var closeDialogs:CloseDialogsSignal = StaticInjectorContext.getInjector().getInstance(CloseDialogsSignal);
         closeDialogs.dispatch();
      }
   }
}
