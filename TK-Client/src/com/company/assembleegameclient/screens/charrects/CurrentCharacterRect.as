package com.company.assembleegameclient.screens.charrects
{
import com.company.assembleegameclient.appengine.CharacterStats;
import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.screens.events.DeleteCharacterEvent;
import com.company.assembleegameclient.ui.tooltip.MyPlayerToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.assembleegameclient.util.FameUtil;
import com.company.rotmg.graphics.DeleteXGraphic;
import com.company.rotmg.graphics.StarGraphic;
import com.company.ui.SimpleText;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;
import kabam.rotmg.classes.model.CharacterClass;
import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class CurrentCharacterRect extends CharacterRect
{
   private static var toolTip_:ToolTip = null;

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
      this.selected = new NativeMappedSignal(selectContainer,MouseEvent.CLICK).mapTo(char);
      this.deleteCharacter = new NativeMappedSignal(this.deleteButton,MouseEvent.CLICK).mapTo(char);
      addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
   }

   public function setIcon(value:DisplayObject) : void
   {
      this.icon && selectContainer.removeChild(this.icon);
      this.icon = value;
      this.icon.x = 0;
      this.icon.y = 3;
      this.icon && selectContainer.addChild(this.icon);
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
      this.deleteButton.x = WIDTH - 25;
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
      this.statsMaxedText.x = 350;
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
      toolTip_ = new MyPlayerToolTip(this.charName,this.char.charXML_,this.charStats);
      stage.addChild(toolTip_);
   }

   override protected function onRollOut(event:MouseEvent) : void
   {
      super.onRollOut(event);
      this.removeToolTip();
   }

   private function onRemovedFromStage(event:Event) : void
   {
      this.removeToolTip();
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
