package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.appengine.SavedCharactersList;
   import com.company.assembleegameclient.objects.ObjectLibrary;
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

import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.game.view.CreditDisplay;
   import kabam.rotmg.ui.view.components.ScreenBase;
   import org.osflash.signals.Signal;

   public class NewCharacterScreen extends Sprite
   {
      private var backButton_:TitleMenuOption;
      private var creditDisplay_:CreditDisplay;
      private var boxes_:Object;
      public var tooltip:Signal;
      public var close:Signal;
      public var selected:Signal;
      private var title:SimpleText;

      private var isInitialized:Boolean = false;

      public function NewCharacterScreen()
      {
         this.boxes_ = {};
         super();
         this.tooltip = new Signal(Sprite);
         this.selected = new Signal(int);
         this.close = new Signal();
         addChild(new ScreenBase());
         addChild(new AccountScreen());
      }

      private function makeBar():void
      {
         var box:Sprite = new Sprite();
         var b:Graphics = box.graphics;
         b.clear();
         b.beginFill(0, 0.5);
         b.drawRect(0, 525, 800, 75);
         b.endFill();
         addChild(box);
      }

      private function makeTitleText() : void
      {
         this.title = new SimpleText(32,11776947,false,0,0);
         this.title.setBold(true);
         this.title.text = "Classes";
         this.title.updateMetrics();
         this.title.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.title.x = 400 - this.title.width / 2;
         this.title.y = 24;
         addChild(this.title);
      }

      public function initialize(model:PlayerModel) : void
      {
         var playerXML:XML = null;
         var objectType:int = 0;
         var characterType:String = null;
         var overrideIsAvailable:Boolean = false;
         var charBox:CharacterBox = null;
         if(this.isInitialized)
         {
            return;
         }
         this.isInitialized = true;
         this.makeBar();
         this.makeTitleText();
         this.backButton_ = new TitleMenuOption("back",36,false);
         this.backButton_.addEventListener(MouseEvent.CLICK,this.onBackClick);
         addChild(this.backButton_);
         this.creditDisplay_ = new CreditDisplay();
         this.creditDisplay_.draw(model.getCredits(),model.getFame());
         addChild(this.creditDisplay_);
         for(var i:int = 0; i < ObjectLibrary.playerChars_.length; i++)
         {
            playerXML = ObjectLibrary.playerChars_[i];
            objectType = int(playerXML.@type);
            characterType = playerXML.@id;
            if(!model.isClassAvailability(characterType,SavedCharactersList.UNAVAILABLE))
            {
               overrideIsAvailable = model.isClassAvailability(characterType,SavedCharactersList.UNRESTRICTED);
               charBox = new CharacterBox(playerXML,model.getCharStats()[objectType],model,overrideIsAvailable);
               charBox.x = 92 + 120 * int(i % 5) + 70 - charBox.width / 2;
               charBox.y = 120 + 120 * int(i / 5);
               this.boxes_[objectType] = charBox;
               charBox.addEventListener(MouseEvent.ROLL_OVER,this.onCharBoxOver);
               charBox.addEventListener(MouseEvent.ROLL_OUT,this.onCharBoxOut);
               charBox.characterSelectClicked_.add(this.onCharBoxClick);
               addChild(charBox);
            }
         }
         this.backButton_.x = stage.stageWidth / 2 - this.backButton_.width / 2;
         this.backButton_.y = 530;
         this.creditDisplay_.x = stage.stageWidth;
         this.creditDisplay_.y = 32;

         var lines:Shape = new Shape();
         var g:Graphics = lines.graphics;
         g.clear();
         g.lineStyle(2,5526612);
         g.moveTo(0,100);
         g.lineTo(stage.stageWidth,100);
         g.lineStyle();
         addChild(lines);
      }

      private function onBackClick(event:Event) : void
      {
         this.close.dispatch();
      }

      private function onCharBoxOver(event:MouseEvent) : void
      {
         var charBox:CharacterBox = event.currentTarget as CharacterBox;
         charBox.setOver(true);
         this.tooltip.dispatch(charBox.getTooltip());
      }

      private function onCharBoxOut(event:MouseEvent) : void
      {
         var charBox:CharacterBox = event.currentTarget as CharacterBox;
         charBox.setOver(false);
         this.tooltip.dispatch(null);
      }

      private function onCharBoxClick(event:MouseEvent) : void
      {
         this.tooltip.dispatch(null);
         var charBox:CharacterBox = event.currentTarget.parent as CharacterBox;
         if(!charBox.available_)
         {
            return;
         }
         var objectType:int = charBox.objectType();
         var displayId:String = ObjectLibrary.typeToDisplayId_[objectType];
         this.selected.dispatch(objectType);
      }

      public function updateCreditsAndFame(credits:int, fame:int) : void
      {
         this.creditDisplay_.draw(credits,fame);
      }

      public function update(model:PlayerModel) : void
      {
         var playerXML:XML = null;
         var objectType:int = 0;
         var characterType:String = null;
         var overrideIsAvailable:Boolean = false;
         var charBox:CharacterBox = null;
         for(var i:int = 0; i < ObjectLibrary.playerChars_.length; i++)
         {
            playerXML = ObjectLibrary.playerChars_[i];
            objectType = int(playerXML.@type);
            characterType = String(playerXML.@id);
            if(!model.isClassAvailability(characterType,SavedCharactersList.UNAVAILABLE))
            {
               overrideIsAvailable = model.isClassAvailability(characterType,SavedCharactersList.UNRESTRICTED);
               charBox = this.boxes_[objectType];
               if(charBox)
               {
                  if(overrideIsAvailable || model.isLevelRequirementsMet(objectType))
                  {
                     charBox.unlock();
                  }
               }
            }
         }
      }
   }
}
