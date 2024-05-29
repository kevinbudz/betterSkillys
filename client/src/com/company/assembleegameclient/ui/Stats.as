package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.tooltip.TextToolTip;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class Stats extends Sprite {

   public static const ATTACK:int = 0;

   public static const DEFENSE:int = 1;

   public static const SPEED:int = 2;

   public static const DEXTERITY:int = 3;

   public static const VITALITY:int = 4;

   public static const WISDOM:int = 5;

   public static const NUM_STAT:int = 6;

   private static const statsXML:XML = <Stats>
      <Stat>
         <Abbr>ATT</Abbr>
         <Name>Attack</Name>
         <Description>This stat increases the amount of damage done.</Description>
         <RedOnZero/>
      </Stat>
      <Stat>
         <Abbr>DEF</Abbr>
         <Name>Defense</Name>
         <Description>This stat decreases the amount of damage taken.</Description>
      </Stat>
      <Stat>
         <Abbr>SPD</Abbr>
         <Name>Speed</Name>
         <Description>This stat increases the speed at which the character moves.</Description>
         <RedOnZero/>
      </Stat>
      <Stat>
         <Abbr>DEX</Abbr>
         <Name>Dexterity</Name>
         <Description>This stat increases the speed at which the character attacks.</Description>
         <RedOnZero/>
      </Stat>
      <Stat>
         <Abbr>VIT</Abbr>
         <Name>Vitality</Name>
         <Description>This stat increases the speed at which hit points are recovered.</Description>
         <RedOnZero/>
      </Stat>
      <Stat>
         <Abbr>WIS</Abbr>
         <Name>Wisdom</Name>
         <Description>This stat increases the speed at which magic points are recovered.</Description>
         <RedOnZero/>
      </Stat>
   </Stats>;


   public var w_:int;

   public var h_:int;

   public var stats_:Vector.<Stat>;

   public var toolTip_:TextToolTip;

   public function Stats(w:int, h:int) {
      var statXML:XML = null;
      var stat:Stat = null;
      this.stats_ = new Vector.<Stat>();
      this.toolTip_ = new TextToolTip(3552822, 10197915, "", "", 200);
      super();
      this.w_ = w;
      this.h_ = h;
      for each(statXML in statsXML.Stat) {
         stat = new Stat(statXML.Abbr, statXML.Name, statXML.Description, statXML.hasOwnProperty("RedOnZero"));
         stat.x = 8 + 26 + int(this.stats_.length % 2) * (this.w_ / 2 - 4);
         stat.y = 8 + this.h_ / 6 + int(this.stats_.length / 2) * this.h_ / 3;
         addChild(stat);
         this.stats_.push(stat);
      }
      addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
      addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
   }

   public function draw(go:Player):void {
      this.stats_[ATTACK].draw(go.attack_, go.attackBoost_, go.attackMax_);
      this.stats_[DEFENSE].draw(go.defense_, go.defenseBoost_, go.defenseMax_);
      this.stats_[SPEED].draw(go.speed_, go.speedBoost_, go.speedMax_);
      this.stats_[DEXTERITY].draw(go.dexterity_, go.dexterityBoost_, go.dexterityMax_);
      this.stats_[VITALITY].draw(go.vitality_, go.vitalityBoost_, go.vitalityMax_);
      this.stats_[WISDOM].draw(go.wisdom_, go.wisdomBoost_, go.wisdomMax_);
   }

   private function onAddedToStage(event:Event):void {
      var stat:Stat = null;
      for each(stat in this.stats_) {
         stat.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
         stat.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
      }
   }

   private function onRemovedFromStage(event:Event):void {
      var stat:Stat = null;
      if (this.toolTip_.parent != null) {
         this.toolTip_.parent.removeChild(this.toolTip_);
      }
      for each(stat in this.stats_) {
         stat.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
         stat.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
      }
   }

   private function onMouseOver(event:MouseEvent):void {
      var stat:Stat = event.target as Stat;
      this.toolTip_.setTitle(stat.fullName_);
      this.toolTip_.setText(stat.description_);
      if (!stage.contains(this.toolTip_)) {
         stage.addChild(this.toolTip_);
      }
   }

   private function onMouseOut(event:MouseEvent):void {
      var stat:Stat = event.target as Stat;
      if (this.toolTip_.parent != null) {
         this.toolTip_.parent.removeChild(this.toolTip_);
      }
   }

   public static function fromId(id:int):String{
      switch (id){
         case 0:
            return "Maximum HP";
         case 3:
            return "Maximum MP";
         case 20:
            return "Attack";
         case 21:
            return "Defense";
         case 22:
            return "Speed";
         case 28:
            return "Dexterity";
         case 26:
            return "Vitality";
         case 27:
            return "Wisdom";
      }
      return "Invalid Stat!";
   }
}
}

import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.text.TextFormat;

class Stat extends Sprite {


   public var fullName_:String;

   public var description_:String;

   public var nameText_:SimpleText;

   public var valText_:SimpleText;

   public var redOnZero_:Boolean;

   public var val_:int = -1;

   public var boost_:int = -1;

   public var valColor_:uint = 11776947;

   function Stat(name:String, fullName:String, desc:String, redOnZero:Boolean) {
      super();
      this.fullName_ = fullName;
      this.description_ = desc;
      this.nameText_ = new SimpleText(12, 11776947, false, 0, 0);
      this.nameText_.text = name + " -";
      this.nameText_.updateMetrics();
      this.nameText_.x = -this.nameText_.width;
      this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
      addChild(this.nameText_);
      this.valText_ = new SimpleText(12, this.valColor_, false, 0, 0);
      this.valText_.setBold(true);
      this.valText_.text = "-";
      this.valText_.updateMetrics();
      this.valText_.filters = [new DropShadowFilter(0, 0, 0)];
      addChild(this.valText_);
      this.redOnZero_ = redOnZero;
   }

   public function draw(val:int, boost:int, max:int):void {
      var newValColor:uint = 0;
      var format:TextFormat = null;
      if (val == this.val_ && boost == this.boost_) {
         return;
      }
      this.val_ = val;
      this.boost_ = boost;
      if (val - boost >= max) {
         newValColor = 16572160;
      }
      else if (this.redOnZero_ && this.val_ <= 0 || this.boost_ < 0) {
         newValColor = 16726072;
      }
      else if (this.boost_ > 0) {
         newValColor = 6206769;
      }
      else {
         newValColor = 11776947;
      }
      if (this.valColor_ != newValColor) {
         this.valColor_ = newValColor;
         format = this.valText_.defaultTextFormat;
         format.color = this.valColor_;
         this.valText_.setTextFormat(format);
         this.valText_.defaultTextFormat = format;
      }
      this.valText_.text = this.val_.toString();
      if (this.boost_ != 0) {
         this.valText_.text = this.valText_.text + (" (" + (this.boost_ > 0 ? "+" : "") + this.boost_.toString() + ")");
      }
      this.valText_.updateMetrics();
   }
}
