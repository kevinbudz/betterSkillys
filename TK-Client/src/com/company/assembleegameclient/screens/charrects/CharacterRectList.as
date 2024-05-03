package com.company.assembleegameclient.screens.charrects
{
   import com.company.assembleegameclient.appengine.CharacterStats;
   import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import kabam.rotmg.assets.services.CharacterFactory;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.core.model.PlayerModel;
   import org.osflash.signals.Signal;
   import org.swiftsuspenders.Injector;
   
   public class CharacterRectList extends Sprite
   {
      private var classes:ClassesModel;
      private var model:PlayerModel;
      private var assetFactory:CharacterFactory;
      public var newCharacter:Signal;
      public var buyCharacterSlot:Signal;
      
      public function CharacterRectList()
      {
         var savedChar:SavedCharacter = null;
         var buyRect:BuyCharacterRect = null;
         var charType:CharacterClass = null;
         var charStats:CharacterStats = null;
         var currCharBox:CurrentCharacterRect = null;
         var i:int = 0;
         var newCharRect:CreateNewCharacterRect = null;
         super();
         var injector:Injector = StaticInjectorContext.getInjector();
         this.classes = injector.getInstance(ClassesModel);
         this.model = injector.getInstance(PlayerModel);
         this.assetFactory = injector.getInstance(CharacterFactory);
         this.newCharacter = new Signal();
         this.buyCharacterSlot = new Signal();
         var charName:String = this.model.getName();
         var yOffset:int = 4;
         var savedChars:Vector.<SavedCharacter> = this.model.getSavedCharacters();
         for each(savedChar in savedChars)
         {
            charType = this.classes.getCharacterClass(savedChar.objectType());
            charStats = charType.getStats();
            currCharBox = new CurrentCharacterRect(charName,charType,savedChar,charStats);
            currCharBox.setIcon(this.getIcon(savedChar));
            currCharBox.y = yOffset;
            addChild(currCharBox);
            yOffset = yOffset + (CharacterRect.HEIGHT + 4);
         }
         if(this.model.hasAvailableCharSlot())
         {
            for(i = 0; i < this.model.getAvailableCharSlots(); i++)
            {
               newCharRect = new CreateNewCharacterRect(this.model);
               newCharRect.addEventListener(MouseEvent.MOUSE_DOWN,this.onNewChar);
               newCharRect.y = yOffset;
               addChild(newCharRect);
               yOffset = yOffset + (CharacterRect.HEIGHT + 4);
            }
         }
         buyRect = new BuyCharacterRect(this.model);
         buyRect.addEventListener(MouseEvent.MOUSE_DOWN,this.onBuyCharSlot);
         buyRect.y = yOffset;
         addChild(buyRect);
      }
      
      private function getIcon(savedChar:SavedCharacter) : DisplayObject
      {
         var type:CharacterClass = this.classes.getCharacterClass(savedChar.objectType());
         var skin:CharacterSkin = type.skins.getSkin(savedChar.skinType()) || type.skins.getDefaultSkin();
         var data:BitmapData = this.assetFactory.makeIcon(skin.template,skin.is16x16 ? 50 : 100,savedChar.tex1(),savedChar.tex2());
         return new Bitmap(data);
      }
      
      private function onNewChar(event:Event) : void
      {
         this.newCharacter.dispatch();
      }
      
      private function onBuyCharSlot(event:Event) : void
      {
         this.buyCharacterSlot.dispatch(this.model.getNextCharSlotPrice());
      }
   }
}
