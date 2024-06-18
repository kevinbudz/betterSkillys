package com.company.assembleegameclient.screens.charrects
{
import com.company.assembleegameclient.appengine.CharacterStats;
import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.screens.events.DeleteCharacterEvent;
import com.company.assembleegameclient.ui.tooltip.MyPlayerToolTip;
import com.company.assembleegameclient.ui.tooltip.TextToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.assembleegameclient.util.FameUtil;
import com.company.rotmg.graphics.DeleteXGraphic;
import com.company.rotmg.graphics.StarGraphic;
import com.company.ui.SimpleText;

import flash.display.Bitmap;

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

import io.decagames.rotmg.fame.FameContentPopup;

import kabam.rotmg.assets.services.IconFactory;

import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dialogs.control.OpenDialogSignal;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;
import org.swiftsuspenders.Injector;

public class CurrentCharacterRect extends CharacterRect
{
   private static var toolTip_:ToolTip = null;
   private static var fameToolTip:TextToolTip = null;

   public const showToolTip:Signal = new Signal(Sprite);
   public const hideTooltip:Signal = new Signal();

   public var charName:String;
   private var charType:CharacterClass;
   public var char:SavedCharacter;
   public var charStats:CharacterStats;
   protected var taglineIcon:Sprite;
   protected var taglineText:SimpleText;
   protected var classNameText:SimpleText;
   private var statsMaxedText:SimpleText;
   private var deleteButton:Sprite;
   public var selected:Signal;
   public var deleteCharacter:Signal;
   private var icon:DisplayObject;
   private var fameBitmap:Bitmap;
   private var fameBitmapContainer:Sprite;

   public function CurrentCharacterRect(charName:String, charType:CharacterClass, char:SavedCharacter, charStats:CharacterStats)
   {
      super(6052956,8355711);
      this.charName = charName;
      this.charType = charType;
      this.char = char;
      this.charStats = charStats;
      makeContainer();
      this.makeClassNameText();
      this.makeTagline();
      this.makeDeleteButton();
      this.makeStatsMaxedText();
      this.makeFameUIIcon();
      this.selected = new NativeMappedSignal(selectContainer,MouseEvent.CLICK).mapTo(char);
      this.deleteCharacter = new NativeMappedSignal(this.deleteButton,MouseEvent.CLICK).mapTo(char);
      addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      this.fameBitmapContainer.addEventListener(MouseEvent.CLICK, this.onFameClick);
   }

   public function setIcon(value:DisplayObject) : void
   {
      this.icon && selectContainer.removeChild(this.icon);
      this.icon = value;
      this.icon.x = 0;
      this.icon.y = 3;
      this.icon && selectContainer.addChild(this.icon);
   }

   private function onFameClick(_arg_1:MouseEvent):void
   {
      var _local_2:Injector = StaticInjectorContext.getInjector();
      var _local_3:OpenDialogSignal = _local_2.getInstance(OpenDialogSignal);
      _local_3.dispatch(new FameContentPopup(this.char.charId()));
   }

   private function makeFameUIIcon():void
   {
      var _local_1:BitmapData = IconFactory.makeFame();
      this.fameBitmap = new Bitmap(_local_1);
      this.fameBitmapContainer = new Sprite();
      this.fameBitmapContainer.name = "fame_ui";
      this.fameBitmapContainer.addChild(this.fameBitmap);
      this.fameBitmapContainer.x = this.width - 70;
      this.fameBitmapContainer.y = 20;
      addChild(this.fameBitmapContainer);
   }


   private function makeClassNameText() : void
   {
      this.classNameText = new SimpleText(18,16777215,false,0,0);
      this.classNameText.setBold(true);
      this.classNameText.text = this.charType.name + " " + this.char.level();
      this.classNameText.updateMetrics();
      this.classNameText.filters = [new DropShadowFilter(0,0,0,1,8,8)];
      this.classNameText.x = 58;
      this.classNameText.y = 6;
      selectContainer.addChild(this.classNameText);
   }

   private function makeTagline() : void
   {
      var nextStarFame:int = this.getNextStarFame();
      if(nextStarFame > 0)
      {
         this.makeTaglineIcon();
         this.makeTaglineText(nextStarFame);
      }
   }

   private function getNextStarFame() : int
   {
      return FameUtil.nextStarFame(this.charStats == null?int(0):int(this.charStats.bestFame()),this.char.fame());
   }

   private function makeTaglineIcon() : void
   {
      this.taglineIcon = new StarGraphic();
      this.taglineIcon.transform.colorTransform = new ColorTransform(179 / 255,179 / 255,179 / 255);
      this.taglineIcon.scaleX = 1.2;
      this.taglineIcon.scaleY = 1.2;
      this.taglineIcon.x = 58;
      this.taglineIcon.y = 31;
      this.taglineIcon.filters = [new DropShadowFilter(0,0,0)];
      selectContainer.addChild(this.taglineIcon);
   }

   private function makeTaglineText(nextStarFame:int) : void
   {
      this.taglineText = new SimpleText(14,11776947,false,0,0);
      this.taglineText.text = "Class Quest: " + this.char.fame() + " of " + nextStarFame + " Fame";
      this.taglineText.updateMetrics();
      this.taglineText.filters = [new DropShadowFilter(0,0,0,1,8,8)];
      this.taglineText.x = 58 + this.taglineIcon.width + 2;
      this.taglineText.y = 31;
      selectContainer.addChild(this.taglineText);
   }

   private function makeDeleteButton() : void
   {
      this.deleteButton = new DeleteXGraphic();
      this.deleteButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onDeleteDown);
      this.deleteButton.x = this.width - 25;
      this.deleteButton.y = 5;
      addChild(this.deleteButton);
   }

   private function makeStatsMaxedText():void
   {
      var maxedStat:int = this.grabStats();
      var color:* = 11776947;
      this.statsMaxedText = new SimpleText(18, 16777215);
      this.statsMaxedText.filters = [new DropShadowFilter(0,0,0,1,8,8)];
      this.statsMaxedText.setBold(true);
      this.statsMaxedText.setText(maxedStat + "/8");
      this.statsMaxedText.x = this.width - 105;
      this.statsMaxedText.y = 18;
      if (maxedStat == 8){
         color = uint(16572160)
      }
      this.statsMaxedText.setColor(color);
      selectContainer.addChild(this.statsMaxedText);
   }

   private function grabStats():int
   {
      var locl:int = 0;
      if(this.char.hp() >= this.charType.hp.max)
         locl++;
      if(this.char.mp() >= this.charType.mp.max)
         locl++;
      if(this.char.att() >= this.charType.attack.max)
         locl++;
      if(this.char.def() >= this.charType.defense.max)
         locl++;
      if(this.char.wis() >= this.charType.mpRegeneration.max)
         locl++;
      if(this.char.vit() >= this.charType.hpRegeneration.max)
         locl++;
      if(this.char.dex() >= this.charType.dexterity.max)
         locl++;
      if(this.char.spd() >= this.charType.speed.max)
         locl++;
      return locl;
   }

   override protected function onMouseOver(event:MouseEvent) : void
   {
      super.onMouseOver(event);
      this.removeToolTip();
      if (event.target.name == "fame_ui")
      {
         fameToolTip = new TextToolTip(0x363636, 0x9B9B9B, "Fame", "Click to get an Overview!", 225);
         this.showToolTip.dispatch(fameToolTip);
      } else
      {
         toolTip_ = new MyPlayerToolTip(this.charName,this.char.charXML_,this.charStats);
         stage.addChild(toolTip_);
      }
   }

   override protected function onRollOut(event:MouseEvent) : void
   {
      super.onRollOut(event);
      this.removeToolTip();
   }

   private function onRemovedFromStage(event:Event) : void
   {
      this.removeToolTip();
      this.fameBitmapContainer.removeEventListener(MouseEvent.CLICK, this.onFameClick);
   }

   private function removeToolTip() : void
   {
      if(toolTip_ != null)
      {
         if(toolTip_.parent != null && toolTip_.parent.contains(toolTip_))
         {
            toolTip_.parent.removeChild(toolTip_);
         }
         toolTip_ = null;
      }
   }

   private function onDeleteDown(event:MouseEvent) : void
   {
      event.stopImmediatePropagation();
      dispatchEvent(new DeleteCharacterEvent(this.char));
   }
}
}
