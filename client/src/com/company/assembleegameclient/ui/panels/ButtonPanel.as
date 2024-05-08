package com.company.assembleegameclient.ui.panels
{
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui.TextButton;
import com.company.ui.SimpleText;

import flash.events.Event;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;

import kabam.rotmg.core.StaticInjectorContext;

import kabam.rotmg.dialogs.control.OpenDialogNoModalSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;

import org.swiftsuspenders.Injector;

public class ButtonPanel extends Panel
{


   private var titleText_:SimpleText;

   public var button_:TextButton;

   [Inject]
   protected var openDialogNoModal:OpenDialogNoModalSignal;
   [Inject]
   protected var openDialog:OpenDialogSignal;
   [Inject]
   protected var gameSprite:GameSprite;

   protected var injector:Injector;

   public function ButtonPanel(gs:GameSprite, title:String, button:String)
   {
      super(gs);
      this.injector = StaticInjectorContext.getInjector();
      this.openDialogNoModal = this.injector.getInstance(OpenDialogNoModalSignal);
      this.openDialog = this.injector.getInstance(OpenDialogSignal);
      this.titleText_ = new SimpleText(18,16777215,false,WIDTH,0);
      this.titleText_.setBold(true);
      this.titleText_.htmlText = "<p align=\"center\">" + title + "</p>";
      this.titleText_.wordWrap = true;
      this.titleText_.multiline = true;
      this.titleText_.autoSize = TextFieldAutoSize.CENTER;
      this.titleText_.filters = [new DropShadowFilter(0,0,0)];
      this.titleText_.y = 6;
      addChild(this.titleText_);
      this.button_ = new TextButton(16,button);
      this.button_.addEventListener(MouseEvent.CLICK,this.onButtonClick);
      addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
      addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
      this.button_.x = WIDTH / 2 - this.button_.width / 2;
      this.button_.y = HEIGHT - this.button_.height - 4;
      addChild(this.button_);
   }

   protected function onAddedToStage(_arg1:Event):void {
      stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
   }

   protected function onRemovedFromStage(_arg1:Event):void {
      stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
   }

   protected function onKeyDown(event:KeyboardEvent):void
   {
   }

   protected function onButtonClick(event:MouseEvent) : void
   {
   }
}
}
