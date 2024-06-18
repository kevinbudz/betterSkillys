package com.company.assembleegameclient.ui.tooltip
{
import com.company.assembleegameclient.constants.InventoryOwnerTypes;
import com.company.assembleegameclient.desc.ActivateEffect;
import com.company.assembleegameclient.desc.CondEffect;
import com.company.assembleegameclient.desc.ItemAttributes;
import com.company.assembleegameclient.desc.ProjectileDesc;
import com.company.assembleegameclient.desc.StatBoost;
import com.company.assembleegameclient.misc.UILabel;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.ObjectProperties;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.LineBreakDesign;
import com.company.assembleegameclient.ui.Stats;
import com.company.assembleegameclient.util.FilterUtil;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util.TierUtil;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;
import com.company.util.BitmapUtil;
import com.company.util.KeyCodes;
import com.company.util.MathUtil2;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.text.StyleSheet;
import flash.utils.Timer;

import kabam.rotmg.constants.ActivationType;
import kabam.rotmg.constants.ItemConstants;
import kabam.rotmg.market.content.MemMarketItem;
import kabam.rotmg.messaging.impl.data.StatData;

public class EquipmentToolTip extends ToolTip
{
   private static const MAX_WISMOD:int = 195;
   private static const MIN_WISMOD:int = 30;


   private static const MAX_WIDTH:int = 230;
   private static const CSS_TEXT:String = ".in { margin-left:10px; text-indent: -10px; }";
   private var iconSize:Number = 60;
   private var icon_:Bitmap;
   private var titleText_:SimpleText;
   private var tierText_:UILabel;
   private var descText_:SimpleText;
   private var line1_:LineBreakDesign;
   private var line2_:LineBreakDesign;
   private var restrictionsText_:SimpleText;
   private var player_:Player;
   private var isEquippable_:Boolean = false;
   private var objectType_:int;
   private var curItemXML_:XML = null;
   private var objectXML_:XML = null;
   private var slotTypeToTextBuilder:SlotComparisonFactory;
   private var playerCanUse:Boolean;
   private var restrictions:Vector.<Restriction>;
   private var effects:Vector.<Effect>;
   private var invType:int;
   private var inventoryOwnerType:String;
   private var inventorySlotID:uint;
   private var isInventoryFull:Boolean;
   private var yOffset:int;
   private var comparisonResults:SlotComparisonResult;
   private var isMarketItem:Boolean;
   private var backgroundColor:uint;
   private var outlineColor:uint;
   private var time:Timer;
   private var flashtext:SimpleText;
   private var repeat:int = 0;
   private var itemData_:Object = null;
   private var props_:ObjectProperties = null;
   private var attributes:String;
   private var attributesText:SimpleText;

   private var itemAtr:ItemAttributes;
   private var equipData:ItemAttributes;

   public function EquipmentToolTip(objectType:int, player:Player, invType:int, inventoryOwnerType:String, inventorySlotID:uint = 1.0, isMarketItem:Boolean = false, itemData:Object = null)
   {
      this.itemData_ = itemData;
      this.isMarketItem = isMarketItem;
      this.inventoryOwnerType = inventoryOwnerType;
      this.inventorySlotID = inventorySlotID;
      this.isInventoryFull = Boolean(player)?Boolean(player.isInventoryFull()):Boolean(false);
      this.playerCanUse = player != null?Boolean(ObjectLibrary.isUsableByPlayer(objectType,player)):Boolean(false);
      this.slotTypeToTextBuilder = new SlotComparisonFactory();
      this.objectType_ = objectType;
      this.objectXML_ = ObjectLibrary.xmlLibrary_[objectType];

      this.itemAtr = ItemAttributes.FromXML(objectType);
      var equips:Vector.<ItemAttributes> = new Vector.<ItemAttributes>;
      for (var i:int = 0; i < 4; i++)
      {
         equips[i] = ItemAttributes.FromXML(player.equipment_[i]);
      }
      if (player) {
         this.player_ = player;
         var equipId:int = GetEquipIndex(this.itemAtr.SlotType, equips);
         if (equipId != -1)
            this.equipData = ItemAttributes.FromXML(player.equipment_[equipId]);
      }

      var equipSlotIndex:int = Boolean(this.player_)?int(ObjectLibrary.getMatchingSlotIndex(this.objectType_,this.player_)):int(-1);
      this.isEquippable_ = equipSlotIndex != -1;
      this.effects = new Vector.<Effect>();
      this.invType = invType;

      this.props_ = ObjectLibrary.propsLibrary_[objectType];

      this.backgroundColor = this.playerCanUse || this.player_ == null ? 0x363636 : 6036765;
      this.outlineColor = this.playerCanUse || player == null ? 0x9B9B9B : 10965039;
      super(backgroundColor, 1, outlineColor, 1, true);

      if(this.player_ == null)
      {
         this.curItemXML_ = this.objectXML_;
      }
      else if(this.isEquippable_)
      {
         if(this.player_.equipment_[equipSlotIndex] != -1)
         {
            this.curItemXML_ = ObjectLibrary.xmlLibrary_[this.player_.equipment_[equipSlotIndex]];
         }
      }
      this.addIcon();
      this.addTitle();
      this.addTierText();
      this.handleWisMod();
      this.addDescriptionText();
      this.buildCategorySpecificText();
      this.makeAttributes();
      this.drawAttributes();
      this.makeLineTwo();
      this.makeRestrictionList();
      this.makeRestrictionText();
   }

   private static function GetEquipIndex(slotType:int, items:Vector.<ItemAttributes>):int {
      for (var i:int = 0; i < 4; i++)
         if (items[i] && items[i].SlotType == slotType)
            return i;
      return -1
   }

   private static function GetConditionEffectIndex(eff:int, effects:Vector.<CondEffect>):int {
      for (var i:int = 0; i < effects.length; i++)
         if (effects[i].Effect == eff)
            return i;
      return -1;
   }

   private function buildUniqueTooltipData() : String
   {
      var effectDataList:XMLList = null;
      var uniqueEffectList:Vector.<Effect> = null;
      var effectDataXML:XML = null;
      if(this.objectXML_.hasOwnProperty("ExtraTooltipData"))
      {
         effectDataList = this.objectXML_.ExtraTooltipData.EffectInfo;
         uniqueEffectList = new Vector.<Effect>();
         for each(effectDataXML in effectDataList)
         {
            uniqueEffectList.push(new Effect(effectDataXML.attribute("name"),effectDataXML.attribute("description")));
         }
         return this.BuildEffectsHTML(uniqueEffectList) + "\n";
      }
      return "";
   }

   private static function BuildRestrictionsHTML(restrictions:Vector.<Restriction>) : String
   {
      var restriction:Restriction = null;
      var line:String = null;
      var html:String = "";
      var first:Boolean = true;
      for each(restriction in restrictions)
      {
         if(!first)
         {
            html = html + "\n";
         }
         else
         {
            first = false;
         }
         line = "<font color=\"#" + restriction.color_.toString(16) + "\">" + restriction.text_ + "</font>";
         if(restriction.bold_)
         {
            line = "<b>" + line + "</b>";
         }
         html = html + line;
      }
      return html;
   }

   private function isEmptyEquipSlot() : Boolean
   {
      return this.isEquippable_ && this.curItemXML_ == null;
   }

   private function addIcon() : void
   {
      var scaleValue:int = 5;
      var texture:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.objectType_,60,true,true,scaleValue);
      texture = BitmapUtil.cropToBitmapData(texture,4,4,texture.width - 8,texture.height - 8);
      this.icon_ = new Bitmap(texture);
      addChild(this.icon_);
   }


   private function addTierText() : void
   {
      this.tierText_ = TierUtil.getTierTag(props_,16);
      if(this.tierText_)
      {
         switch(Parameters.data_.itemDataOutlines)
         {
            case 0:
               this.tierText_.filters = FilterUtil.getTextOutlineFilter();
               break;
            case 1:
               this.tierText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         }
         addChild(this.tierText_);
      }
   }

   private function addTitle() : void {
      var color:int = this.playerCanUse ? 0xffffff : 10965039;
      this.titleText_ = new SimpleText(16, color, false, MAX_WIDTH - this.icon_.width - 4 - 30, 0);
      this.titleText_.setBold(true);
      this.titleText_.wordWrap = true;
      this.titleText_.text = this.itemAtr.DisplayName;
      if(this.itemData_ != null)
      {
         if(this.itemData_.ObjectId != null)
            this.titleText_.text = this.itemData_.ObjectId;
         if(this.itemData_.Stack > 0)
            this.titleText_.text += " x" + this.itemData_.Stack;
      }
      this.titleText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
      this.titleText_.x = this.icon_.width + 4;
      this.titleText_.y = this.icon_.height / 2 - this.titleText_.actualHeight_ / 2;
      this.titleText_.updateMetrics();
      switch (Parameters.data_.itemDataOutlines) {
         case 0:
            this.titleText_.filters = FilterUtil.getTextOutlineFilter();
            break;
         case 1:
            this.titleText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
      }
      addChild(this.titleText_);
   }

   private function makeAttributes():void {
      this.attributes = "";
      this.makeProjAttributes();
      this.makeActivateEffects();
      this.makeStatBoosts();
      this.makeGlobalAttributes();
   }

   private function drawAttributes():void {
      if (this.attributes.length <= 0)
         return;
      this.line1_ = new LineBreakDesign(MAX_WIDTH - 15, 0x151515);
      addChild(this.line1_);
      var sheet:StyleSheet = new StyleSheet();
      //sheet.parseCSS(CSS_TEXT);
      this.attributesText = new SimpleText(14, 0xB3B3B3, false, MAX_WIDTH - 10);
      //this.attributesText.styleSheet = sheet;
      this.attributesText.wordWrap = true;
      this.attributesText.htmlText = this.buildUniqueTooltipData() + this.attributes;
      this.attributesText.useTextDimensions();
      switch(Parameters.data_.itemDataOutlines)
      {
         case 0:
            this.attributesText.filters = FilterUtil.getTextOutlineFilter();
            break;
         case 1:
            this.attributesText.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
      }
      addChild(this.attributesText);
   }

   private function makeProjAttributes():void {
      var proj:ProjectileDesc = this.itemAtr.Projectile;
      var proj2:ProjectileDesc = this.equipData ? this.equipData.Projectile : null;
      if (!proj)
         return;
      this.makeProjCount(proj, proj2);
      this.makeProjEffects(proj, proj2);
      this.makeProjDamage(proj, proj2);
      this.makeProjRange(proj, proj2);
      this.makeProjRoF(proj, proj2);
      this.makeProjArcGap(proj, proj2);
      this.makeProjProperties(proj, proj2);
   }

   private function makeProjCount(proj:ProjectileDesc, proj2:ProjectileDesc):void {
      var count:int = this.itemAtr.NumProjectiles;
      var color:String = TooltipHelper.NO_DIFF_COLOR;
      if (this.equipData) {
         var count2:int = this.equipData.NumProjectiles;
         color = TooltipHelper.getTextColor(count - count2);
      }
      else if (this.isEquippable_)
         color = TooltipHelper.BETTER_COLOR;
      this.attributes += "Shots: " + TooltipHelper.wrapInFontTag(String(count), color) + "\n";
   }

   private function makeProjEffects(proj:ProjectileDesc, proj2:ProjectileDesc):void {
      if (!proj.Effects || proj.Effects.length < 1)
         return;

      this.attributes += "Shot Effect(s):\n";
      for (var i:int = 0; i < proj.Effects.length; i++) {
         var condEff:CondEffect = proj.Effects[i];
         var duration:Number = MathUtil2.roundTo(condEff.DurationMS / 1000.0, 2);
         var color:String = TooltipHelper.NO_DIFF_COLOR;
         if (proj2 && proj.Effects && proj.Effects.length > 0) {
            var i2:int = GetConditionEffectIndex(condEff.Effect, proj2.Effects);
            if (i2 != -1) {
               var duration2:Number = MathUtil2.roundTo(proj2.Effects[i2].DurationMS / 1000.0, 2);
               color = TooltipHelper.getTextColor(duration - duration2);
            }
            else color = TooltipHelper.BETTER_COLOR;
         }
         else if (this.isEquippable_)
            color = TooltipHelper.BETTER_COLOR;
         this.attributes += "    Inflicts " + TooltipHelper.wrapInFontTag(condEff.EffectName, color) + " for " + TooltipHelper.wrapInFontTag(String(duration), color) + " secs" + "\n";
      }
   }

   private function makeProjDamage(proj:ProjectileDesc, proj2:ProjectileDesc):void {
      var minD:int = proj.MinDamage;
      var maxD:int = proj.MaxDamage;
      var color:String = TooltipHelper.NO_DIFF_COLOR;
      if (proj2) {
         var minD2:int = proj2.MinDamage;
         var maxD2:int = proj2.MaxDamage;
         var avg1:Number = (minD + maxD) / 2.0;
         var avg2:Number = (minD2 + maxD2) / 2.0;
         color = TooltipHelper.getTextColor(avg1 - avg2);
      }
      else if (this.isEquippable_)
         color = TooltipHelper.BETTER_COLOR;
      this.attributes += "Damage: " + TooltipHelper.wrapInFontTag(minD == maxD ? String(minD) : minD + " - " + maxD, color) + "\n";
   }

   private function makeProjRange(proj:ProjectileDesc, proj2:ProjectileDesc):void {
      var range:Number = TooltipHelper.getFormattedRangeString(proj.Speed * proj.LifetimeMS / 10000.0);
      var color:String = TooltipHelper.NO_DIFF_COLOR;
      if (proj2) {
         var range2:Number = TooltipHelper.getFormattedRangeString(proj2.Speed * proj2.LifetimeMS / 10000.0);
         color = TooltipHelper.getTextColor(range - range2);
      }
      else if (this.isEquippable_)
         color = TooltipHelper.BETTER_COLOR;
      this.attributes += "Range: " + TooltipHelper.wrapInFontTag(String(range), color) + "\n";
   }

   private function makeProjRoF(proj:ProjectileDesc, proj2:ProjectileDesc):void {
      var slotTypes:Array = [1, 2, 3, 8, 17, 24];
      if (slotTypes.indexOf(this.itemAtr.SlotType) == -1)
          return;
      if (this.itemAtr.RateOfFire == -1)
         return;

      var rof:Number = this.itemAtr.RateOfFire * 100;
      var color:String = TooltipHelper.NO_DIFF_COLOR;
      if (this.equipData) {
         var rof2:Number = this.equipData.RateOfFire * 100;
         color = TooltipHelper.getTextColor(rof - rof2);
      }
      else if (this.isEquippable_)
         color = TooltipHelper.BETTER_COLOR;
      this.attributes += "Rate of Fire: " + TooltipHelper.wrapInFontTag(rof.toFixed(0) + "%", color) + "\n";
   }

   private static function GetMatches(eff:String, effects:Vector.<ActivateEffect>):Vector.<ActivateEffect> {
      var matches:Vector.<ActivateEffect> = new Vector.<ActivateEffect>();
      for (var i:int = 0; i < effects.length; i++) {
         if (effects[i].EffectName == eff)
            matches.push(effects[i]);
      }
      return matches;
   }

   private static function GetMatchId(eff:ActivateEffect, effects:Vector.<ActivateEffect>):int {
      var matches:Vector.<ActivateEffect> = GetMatches(eff.EffectName, effects);
      for each (var match:ActivateEffect in matches)
         if (match == eff)
            return matches.indexOf(match);
      return -1;
   }

   private static function GetAE(eff:String, matchId:int, effects:Vector.<ActivateEffect>):ActivateEffect {
      var matches:Vector.<ActivateEffect> = GetMatches(eff, effects);
      if (matches.length < matchId + 1)
         return null;
      return matches[matchId];
   }

   private static function HasAEStat(stat:String, effName:String, effects:Vector.<ActivateEffect>):Boolean {
      if (!effects || effects.length < 1)
         return false;

      for each (var ae:ActivateEffect in effects) {
         if (!ae.EffectName || ae.EffectName == "" || ae.EffectName != effName)
            continue;
         if (Stats.fromId(ae.Stats) == stat)
            return true;
      }
      return false;
   }

   private static function GetWisModText(val:Number, wisModVal:Number, color:String):String {
      if (wisModVal - val <= 0)
         return TooltipHelper.wrapInFontTag(String(val), color);
      return TooltipHelper.wrapInFontTag(String(wisModVal), color) + TooltipHelper.wrapInFontTag(" (+" + (wisModVal - val) + ")", TooltipHelper.WISMOD_COLOR);
   }

   private function makeProjArcGap(proj:ProjectileDesc, proj2:ProjectileDesc):void {
      if (this.itemAtr.ArcGap <= 0)
         return;
      if (this.itemAtr.NumProjectiles == 1)
          return;
      var arc:Number = this.itemAtr.ArcGap;
      var color:String = TooltipHelper.NO_DIFF_COLOR;
      if (this.itemAtr && this.equipData && this.equipData.ArcGap > 0) {
         var arc2:Number = this.equipData.ArcGap;
         color = TooltipHelper.getTextColor(arc2 - arc);
      }
      else if (this.isEquippable_)
         color = TooltipHelper.BETTER_COLOR;
      this.attributes += "Arc Gap: " + TooltipHelper.wrapInFontTag(String(arc), color) + "\n";
   }

   private function makeProjProperties(proj:ProjectileDesc, proj2:ProjectileDesc):void {
      if (proj.ArmorPiercing)
         this.attributes += TooltipHelper.wrapInFontTag("Shots ignore defense of target", TooltipHelper.SPECIAL_COLOR) + "\n";
      if (proj.Boomerang)
         this.attributes += TooltipHelper.wrapInFontTag("Shots boomerang", TooltipHelper.NO_DIFF_COLOR) + "\n";
      if (proj.MultiHit)
         this.attributes += TooltipHelper.wrapInFontTag("Shots hit multiple targets", TooltipHelper.NO_DIFF_COLOR) + "\n";
      if (proj.PassesCover)
         this.attributes += TooltipHelper.wrapInFontTag("Shots pass through obstacles", TooltipHelper.NO_DIFF_COLOR) + "\n";
      if (proj.Parametric)
         this.attributes += TooltipHelper.wrapInFontTag("Shots are parametric", TooltipHelper.NO_DIFF_COLOR) + "\n";
   }

   private function makeActivateEffects():void {
      var effs:Vector.<ActivateEffect> = new Vector.<ActivateEffect>();
      for each (var ae:ActivateEffect in this.itemAtr.ActivateEffects) {
         if (!ae.EffectName || ae.EffectName == "")
            continue;
         effs.push(ae);
      }
      if (effs.length < 1)
         return;
      var atrText:String = "";
      atrText += "On Use:\n";
      atrText += "<span class=\'aeIn\'>";
      for each (ae in effs) {
         if (ae.DosesReq > 0)
            atrText += TooltipHelper.wrapInFontTag("(Requires at least " + ae.DosesReq + " doses)", "#E0761E");
         if (ae.NodeReq != -1)
            atrText += TooltipHelper.wrapInFontTag("(Requires blessing)", "#E0761E");
         if (ae.DosesReq > 0 || ae.NodeReq != -1)
            atrText += "\n";
         var statColor:String = TooltipHelper.NO_DIFF_COLOR;
         var amountColor:String = TooltipHelper.NO_DIFF_COLOR;
         var rangeColor:String = TooltipHelper.NO_DIFF_COLOR;
         var durationColor:String = TooltipHelper.NO_DIFF_COLOR;
         var conditionColor:String = TooltipHelper.NO_DIFF_COLOR;
         var totalDmgColor:String = TooltipHelper.NO_DIFF_COLOR;
         var radiusColor:String = TooltipHelper.NO_DIFF_COLOR;
         var impactDmgColor:String = TooltipHelper.NO_DIFF_COLOR;
         var condDurationColor:String = TooltipHelper.NO_DIFF_COLOR;
         var maxTargetsColor:String = TooltipHelper.NO_DIFF_COLOR;
         var healAmountColor:String = TooltipHelper.NO_DIFF_COLOR;
         var stat:String = Stats.fromId(ae.Stats);
         var amount:int = ae.Amount;
         var range:Number = ae.Range;
         var duration:Number = ae.DurationSec;
         var condition:String = ae.ConditionEffect;
         var totalDamage:int = ae.TotalDamage;
         var radius:Number = ae.Radius;
         var impactDmg:int = ae.ImpactDmg;
         var condDuration:Number = ae.EffectDuration;
         var maxTargets:int = ae.MaxTargets;
         var healAmount:int = ae.HealAmount;
         var wisModAmount:int = ApplyWisMod(amount, this.player_, 0);
         var wisModRange:Number = ApplyWisMod(range, this.player_);
         var wisModDuration:Number = ApplyWisMod(duration, this.player_);
         var wisModTotalDamage:Number = ApplyWisMod(totalDamage, this.player_, 0);
         var wisModRadius:Number = ApplyWisMod(radius, this.player_);
         var wisModCondDuration:Number = ApplyWisMod(condDuration, this.player_);
         var wisModMaxTargets:Number = ApplyWisMod(maxTargets, this.player_);
         var wisModHealAmount:Number = ApplyWisMod(healAmount, this.player_);
         var ae2:ActivateEffect;
         var stat2:String;
         var amount2:int;
         var range2:Number;
         var duration2:Number;
         var totalDamage2:int;
         var radius2:Number;
         var impactDmg2:int;
         var condDuration2:Number;
         var maxTargets2:int;
         var healAmount2:int;
         var wisModAmount2:int;
         var wisModRange2:Number;
         var wisModDuration2:Number;
         var wisModTotalDamage2:Number;
         var wisModRadius2:Number;
         var wisModCondDuration2:Number;
         var wisModMaxTargets2:Number;
         var wisModHealAmount2:Number;
         if (this.equipData && this.equipData.ActivateEffects && this.equipData.ActivateEffects.length > 0) {
            var matchId:int = GetMatchId(ae, this.itemAtr.ActivateEffects);
            ae2 = GetAE(ae.EffectName, matchId, this.equipData.ActivateEffects);
            if (ae2) {
               stat2 = Stats.fromId(ae2.Stats);
               amount2 = ae2.Amount;
               range2 = ae2.Range;
               duration2 = ae2.DurationSec;
               totalDamage2 = ae2.TotalDamage;
               radius2 = ae2.Radius;
               impactDmg2 = ae2.ImpactDmg;
               condDuration2 = ae2.EffectDuration;
               maxTargets2 = ae2.MaxTargets;
               healAmount2 = ae2.HealAmount;
               wisModAmount2 = ApplyWisMod(amount2, this.player_, 0);
               wisModRange2 = ApplyWisMod(range2, this.player_);
               wisModDuration2 = ApplyWisMod(duration2, this.player_);
               wisModTotalDamage2 = ApplyWisMod(totalDamage2, this.player_, 0);
               wisModRadius2 = ApplyWisMod(radius2, this.player_);
               wisModCondDuration2 = ApplyWisMod(condDuration2, this.player_);
               wisModMaxTargets2 = ApplyWisMod(maxTargets2, this.player_);
               wisModHealAmount2 = ApplyWisMod(healAmount2, this.player_);
               if (!HasAEStat(stat, ae.EffectName, this.equipData.ActivateEffects)) {
                  statColor = TooltipHelper.BETTER_COLOR;
               }
               if (!HasAECondition(condition, ae.EffectName, this.equipData.ActivateEffects)) {
                  conditionColor = TooltipHelper.BETTER_COLOR;
               }
               if (ae.UseWisMod) {
                  if (ae2.UseWisMod) {
                     amountColor = TooltipHelper.getTextColor(wisModAmount - wisModAmount2);
                     rangeColor = TooltipHelper.getTextColor(wisModRange - wisModRange2);
                     durationColor = TooltipHelper.getTextColor(wisModDuration - wisModDuration2);
                     totalDmgColor = TooltipHelper.getTextColor(wisModTotalDamage - wisModTotalDamage2);
                     radiusColor = TooltipHelper.getTextColor(wisModRadius - wisModRadius2);
                     impactDmgColor = TooltipHelper.getTextColor(impactDmg - impactDmg2);
                     condDurationColor = TooltipHelper.getTextColor(wisModCondDuration - wisModCondDuration2);
                     maxTargetsColor = TooltipHelper.getTextColor(wisModMaxTargets - wisModMaxTargets2);
                     healAmountColor = TooltipHelper.getTextColor(wisModHealAmount - wisModHealAmount2);
                  }
                  else {
                     amountColor = TooltipHelper.getTextColor(wisModAmount - amount2);
                     rangeColor = TooltipHelper.getTextColor(wisModRange - range2);
                     durationColor = TooltipHelper.getTextColor(wisModDuration - duration2);
                     totalDmgColor = TooltipHelper.getTextColor(wisModTotalDamage - totalDamage2);
                     radiusColor = TooltipHelper.getTextColor(wisModRadius - radius2);
                     impactDmgColor = TooltipHelper.getTextColor(impactDmg - impactDmg2);
                     condDurationColor = TooltipHelper.getTextColor(wisModCondDuration - condDuration2);
                     maxTargetsColor = TooltipHelper.getTextColor(wisModMaxTargets - maxTargets2);
                     healAmountColor = TooltipHelper.getTextColor(wisModHealAmount - healAmount2);
                  }
               }
               else {
                  if (ae2.UseWisMod) {
                     amountColor = TooltipHelper.getTextColor(amount - wisModAmount2);
                     rangeColor = TooltipHelper.getTextColor(range - wisModRange2);
                     durationColor = TooltipHelper.getTextColor(duration - wisModDuration2);
                     totalDmgColor = TooltipHelper.getTextColor(totalDamage - wisModTotalDamage2);
                     radiusColor = TooltipHelper.getTextColor(radius - wisModRadius2);
                     impactDmgColor = TooltipHelper.getTextColor(impactDmg - impactDmg2);
                     condDurationColor = TooltipHelper.getTextColor(condDuration - wisModCondDuration2);
                     maxTargetsColor = TooltipHelper.getTextColor(maxTargets - wisModMaxTargets2);
                     healAmountColor = TooltipHelper.getTextColor(healAmount - wisModHealAmount2);
                  }
                  else {
                     amountColor = TooltipHelper.getTextColor(amount - amount2);
                     rangeColor = TooltipHelper.getTextColor(range - range2);
                     durationColor = TooltipHelper.getTextColor(duration - duration2);
                     totalDmgColor = TooltipHelper.getTextColor(totalDamage - totalDamage2);
                     radiusColor = TooltipHelper.getTextColor(radius - radius2);
                     impactDmgColor = TooltipHelper.getTextColor(impactDmg - impactDmg2);
                     condDurationColor = TooltipHelper.getTextColor(condDuration - condDuration2);
                     maxTargetsColor = TooltipHelper.getTextColor(maxTargets - maxTargets2);
                     healAmountColor = TooltipHelper.getTextColor(healAmount - healAmount2);
                  }
               }
            }
         }
         if (!this.isEquippable_) {
            statColor = TooltipHelper.NO_DIFF_COLOR;
            amountColor = TooltipHelper.NO_DIFF_COLOR;
            rangeColor = TooltipHelper.NO_DIFF_COLOR;
            durationColor = TooltipHelper.NO_DIFF_COLOR;
            conditionColor = TooltipHelper.NO_DIFF_COLOR;
            totalDmgColor = TooltipHelper.NO_DIFF_COLOR;
            radiusColor = TooltipHelper.NO_DIFF_COLOR;
            impactDmgColor = TooltipHelper.NO_DIFF_COLOR;
            condDurationColor = TooltipHelper.NO_DIFF_COLOR;
            maxTargetsColor = TooltipHelper.NO_DIFF_COLOR;
            healAmountColor = TooltipHelper.NO_DIFF_COLOR;
         }
         else if (!ae2) {
            statColor = TooltipHelper.BETTER_COLOR;
            amountColor = TooltipHelper.BETTER_COLOR;
            rangeColor = TooltipHelper.BETTER_COLOR;
            durationColor = TooltipHelper.BETTER_COLOR;
            conditionColor = TooltipHelper.BETTER_COLOR;
            totalDmgColor = TooltipHelper.BETTER_COLOR;
            radiusColor = TooltipHelper.BETTER_COLOR;
            impactDmgColor = TooltipHelper.BETTER_COLOR;
            condDurationColor = TooltipHelper.BETTER_COLOR;
            maxTargetsColor = TooltipHelper.BETTER_COLOR;
            healAmountColor = TooltipHelper.BETTER_COLOR;
         }
         switch (ae.EffectName) {
            case ActivationType.GENERIC_ACTIVATE:
               atrText += BuildGenericAE(
                       ae, ae.UseWisMod,
                       duration, wisModDuration, durationColor,
                       range, wisModRange, rangeColor,
                       condition, conditionColor
               );
               break;
            case ActivationType.INCREMENT_STAT:
               atrText += "- Increases " + TooltipHelper.wrapInFontTag(stat, TooltipHelper.NO_DIFF_COLOR) + " by " + TooltipHelper.wrapInFontTag(String(amount), TooltipHelper.NO_DIFF_COLOR);
               break;
            case ActivationType.HEAL:
               if (ae.UseWisMod && wisModAmount != amount)
                  atrText += "- Heals " + GetWisModText(amount, wisModAmount, amountColor) + " HP";
               else
                  atrText += "- Heals " + TooltipHelper.wrapInFontTag(String(amount), amountColor) + " HP";
               break;
            case ActivationType.MAGIC:
               if (ae.UseWisMod && wisModAmount != amount)
                  atrText += "- Heals " + GetWisModText(amount, wisModAmount, amountColor) + " MP";
               else
                  atrText += "- Heals " + TooltipHelper.wrapInFontTag(String(amount), amountColor) + " MP";
               break;
            case ActivationType.HEAL_NOVA:
               if (ae.UseWisMod && (wisModAmount != amount || wisModRange != range))
                  atrText += "- Heals " + GetWisModText(amount, wisModAmount, amountColor) + " in " + GetWisModText(range, wisModRange, rangeColor) + " sqrs";
               else
                  atrText += "- Heals " + TooltipHelper.wrapInFontTag(String(amount), amountColor) + " HP in " + TooltipHelper.wrapInFontTag(String(range), rangeColor) + " sqrs";
               break;
            case ActivationType.STAT_BOOST_SELF:
               if (ae.UseWisMod && (wisModAmount != amount || wisModDuration != duration))
                  atrText += "- On Self: " + GetSign(amount) + GetWisModText(amount, wisModAmount, amountColor) + " " + TooltipHelper.wrapInFontTag(stat, statColor) + " for " + GetWisModText(duration, wisModDuration, durationColor) + " secs";
               else
                  atrText += "- On Self: " + GetSign(amount) + TooltipHelper.wrapInFontTag(String(amount), amountColor) + " " + TooltipHelper.wrapInFontTag(stat, statColor) + " for " + TooltipHelper.wrapInFontTag(String(duration), durationColor) + " secs";
               break;
            case ActivationType.STAT_BOOST_AURA:
               if (ae.UseWisMod && (wisModAmount != amount || wisModDuration != duration || wisModRange != range))
                  atrText += "- On Allies: " + GetSign(amount) + GetWisModText(amount, wisModAmount, amountColor) + " " + TooltipHelper.wrapInFontTag(stat, statColor) + " in " + GetWisModText(range, wisModRange, rangeColor) + " sqrs for " + GetWisModText(duration, wisModDuration, durationColor) + " secs";
               else
                  atrText += "- On Allies: " + GetSign(amount) + TooltipHelper.wrapInFontTag(String(amount), amountColor) + " " + TooltipHelper.wrapInFontTag(stat, statColor) + " in " + TooltipHelper.wrapInFontTag(String(range), rangeColor) + " sqrs for " + TooltipHelper.wrapInFontTag(String(duration), durationColor) + " secs";
               break;
            case ActivationType.BULLET_NOVA:
               atrText += TooltipHelper.wrapInFontTag("Spell: ", TooltipHelper.SPECIAL_COLOR) + TooltipHelper.wrapInFontTag(ae.NumShots.toString(), TooltipHelper.NO_DIFF_COLOR) + " shots";
               break;
            case ActivationType.COND_EFFECT_SELF:
               if (ae.UseWisMod && wisModDuration != duration)
                  atrText += "- On Self: " + TooltipHelper.wrapInFontTag(condition, conditionColor) + " for " + GetWisModText(duration, wisModDuration, durationColor) + " secs";
               else
                  atrText += "- On Self: " + TooltipHelper.wrapInFontTag(condition, conditionColor) + " for " + TooltipHelper.wrapInFontTag(String(duration), durationColor) + " secs";
               break;
            case ActivationType.COND_EFFECT_AURA:
               if (ae.UseWisMod && (wisModDuration != duration || wisModRange != range))
                  atrText += "- On Allies: " + TooltipHelper.wrapInFontTag(condition, conditionColor) + " in " + GetWisModText(range, wisModRange, rangeColor) + " sqrs for " + GetWisModText(duration, wisModDuration, durationColor) + " secs";
               else
                  atrText += "- On Allies: " + TooltipHelper.wrapInFontTag(condition, conditionColor) + " in " + TooltipHelper.wrapInFontTag(String(range), rangeColor) + " sqrs for " + TooltipHelper.wrapInFontTag(String(duration), durationColor) + " secs";
               break;
            case ActivationType.TELEPORT:
               atrText += "- Teleports to cursor";
               break;
            case ActivationType.POISON_GRENADE:
               if (ae.UseWisMod && (wisModTotalDamage != totalDamage))
                  atrText += "- Poison: Deals " + GetWisModText(totalDamage, wisModTotalDamage, totalDmgColor) + " damage (" + TooltipHelper.wrapInFontTag(String(impactDmg), impactDmgColor) + " on impact) in " + TooltipHelper.wrapInFontTag(String(radius), radiusColor) + " sqrs for " + TooltipHelper.wrapInFontTag(String(duration), durationColor) + " secs";
               else
                  atrText += "- Poison: Deals " + TooltipHelper.wrapInFontTag(String(totalDamage), totalDmgColor) + " damage (" + TooltipHelper.wrapInFontTag(String(impactDmg), impactDmgColor) + " on impact) in " + TooltipHelper.wrapInFontTag(String(radius), radiusColor) + " sqrs for " + TooltipHelper.wrapInFontTag(String(duration), durationColor) + " secs";
               break;
            case ActivationType.VAMPIRE_BLAST:
               if (ae.UseWisMod && (wisModTotalDamage != totalDamage || wisModRadius != radius))
                  atrText += "- Skull: Heals " + TooltipHelper.wrapInFontTag(String(healAmount), healAmountColor) + " HP dealing " + GetWisModText(totalDamage, wisModTotalDamage, totalDmgColor) + " damage in " + GetWisModText(radius, wisModRadius, radiusColor) + " sqrs";
               else
                  atrText += "- Skull: Heals " + TooltipHelper.wrapInFontTag(String(healAmount), healAmountColor) + " HP dealing " + TooltipHelper.wrapInFontTag(String(totalDamage), totalDmgColor) + " damage in " + TooltipHelper.wrapInFontTag(String(radius), radiusColor) + " sqrs";
               break;
            case ActivationType.TRAP:
               if (ae.UseWisMod && (wisModTotalDamage != totalDamage || wisModRadius != radius || wisModCondDuration != condDuration)) {
                  atrText += "- Trap: Deals " + GetWisModText(totalDamage, wisModTotalDamage, totalDmgColor) + " damage in " + GetWisModText(radius, wisModRadius, radiusColor) + " sqrs\n";
                  atrText += "    Applies " + TooltipHelper.wrapInFontTag(!condition ? "Slowed" : condition, conditionColor) + " for " + GetWisModText(condDuration, wisModCondDuration, condDurationColor) + " secs";
               }
               else {
                  atrText += "- Trap: Deals " + TooltipHelper.wrapInFontTag(String(totalDamage), totalDmgColor) + " damage in " + TooltipHelper.wrapInFontTag(String(radius), radiusColor) + " sqrs\n";
                  atrText += "    Applies " + TooltipHelper.wrapInFontTag(!condition ? "Slowed" : condition, conditionColor) + " for " + TooltipHelper.wrapInFontTag(String(condDuration), condDurationColor) + " secs";
               }
               break;
            case ActivationType.STASIS_BLAST:
               if (ae.UseWisMod && (wisModDuration != duration))
                  atrText += "- Stasies enemies within 3 sqrs for " + GetWisModText(duration, wisModDuration, durationColor) + " secs";
               else
                  atrText += "- Stasies enemies within 3 sqrs for " + TooltipHelper.wrapInFontTag(String(duration), durationColor) + " secs";
               break;
            case ActivationType.DECOY:
               atrText += "- Decoy: Lasts for " + TooltipHelper.wrapInFontTag(String(duration), durationColor) + " secs";
               break;
            case ActivationType.LIGHTNING:
               if (ae.UseWisMod && (wisModMaxTargets != maxTargets || wisModTotalDamage != totalDamage)) {
                  atrText += "- Lightning: Targets " + GetWisModText(maxTargets, wisModMaxTargets, maxTargetsColor) + " enemies dealing " + GetWisModText(totalDamage, wisModTotalDamage, totalDmgColor) + " damage";
                  if (condition)
                     atrText += "\n    Applies " + TooltipHelper.wrapInFontTag(condition, conditionColor) + " for " + TooltipHelper.wrapInFontTag(String(condDuration), condDurationColor) + " secs";
               }
               else {
                  atrText += "- Lightning: Targets " + TooltipHelper.wrapInFontTag(String(maxTargets), maxTargetsColor) + " enemies dealing " + TooltipHelper.wrapInFontTag(String(totalDamage), totalDmgColor) + " damage";
                  if (condition)
                     atrText += "\n    Applies " + TooltipHelper.wrapInFontTag(condition, conditionColor) + " for " + TooltipHelper.wrapInFontTag(String(condDuration), condDurationColor) + " secs";
               }
               break;
            case ActivationType.MAGIC_NOVA:
               if (ae.UseWisMod && (wisModAmount != amount || wisModRange != range))
                  atrText += "- Heals " + GetWisModText(amount, wisModAmount, amountColor) + " MP in " + GetWisModText(range, wisModRange, rangeColor) + " sqrs";
               else
                  atrText += "- Heals " + TooltipHelper.wrapInFontTag(String(amount), amountColor) + " MP in " + TooltipHelper.wrapInFontTag(String(range), rangeColor) + " sqrs";
               break;
            case ActivationType.CLEAR_COND_EFFECT_AURA:
               atrText += "- Removes all condition effects from allies in " + TooltipHelper.wrapInFontTag(String(range), rangeColor) + " sqrs";
               break;
            case ActivationType.REMOVE_NEG_COND:
               atrText += "- Removes all negative condition effects from allies in " + TooltipHelper.wrapInFontTag(String(range), rangeColor) + " sqrs";
               break;
            case ActivationType.CLEAR_COND_EFFECT_SELF:
               atrText += "- Removes all condition effects";
               break;
            case ActivationType.REMOVE_NEG_COND_SELF:
               atrText += "- Removes all negative condition effects";
               break;
         }
         if (!LastElement(ae, effs))
            atrText += "\n";
      }
      atrText += "</span>\n";
      if (atrText.length > 36)
         this.attributes += atrText;
   }

   private static function BuildGenericAE(eff:ActivateEffect, useWisMod:Boolean,
                                          duration:Number, wisModDuration:Number, durationColor:String,
                                          range:Number, wisModRange:Number, rangeColor:String,
                                          condition:String, conditionColor:String):String {
      var ret:String = "";
      var targetPlayer:Boolean = eff.Target == "player";
      var aimAtCursor:Boolean = eff.Center == "mouse";
      if (!targetPlayer)
         ret += "On enemies: ";
      else ret += "On allies: ";
      ret += TooltipHelper.wrapInFontTag(condition, conditionColor) + " within ";
      if (useWisMod)
         ret += GetWisModText(range, wisModRange, rangeColor);
      else ret += TooltipHelper.wrapInFontTag(String(range), rangeColor);
      ret += " sqrs";
      if (aimAtCursor)
         ret += " at cursor";
      ret += " for ";
      if (useWisMod)
         ret += GetWisModText(duration, wisModDuration, durationColor);
      else ret += TooltipHelper.wrapInFontTag(String(duration), durationColor);
      ret += " secs";
      return ret;
   }

   private static function GetSign(val:int):String {
      if (val > 0)
         return "+"; // YEP
      return "";
   }

   private static function LastElement(elem:*, arr:*):Boolean {
      return arr.indexOf(elem) == arr.length - 1;
   }

   private static function HasAECondition(condition:String, effName:String, effects:Vector.<ActivateEffect>):Boolean {
      if (!effects || effects.length < 1)
         return false;

      for each (var ae:ActivateEffect in effects) {
         if (!ae.EffectName || ae.EffectName == "" || ae.EffectName != effName)
            continue;
         if (ae.ConditionEffect == condition)
            return true;
      }
      return false;
   }

   private function makeStatBoosts():void {
      if (!this.itemAtr.StatsBoosts || this.itemAtr.StatsBoosts.length < 1)
         return;

      this.attributes += "On Equip:\n";
      var amountColor:String = TooltipHelper.NO_DIFF_COLOR;
      if (this.isEquippable_) {
         amountColor = TooltipHelper.BETTER_COLOR;
      }
      for each (var statBoost:StatBoost in this.itemAtr.StatsBoosts) {
         var stat:String = Stats.fromId(statBoost.Stat);
         var amount:int = statBoost.Amount;
         if (this.isEquippable_) {
            amountColor = TooltipHelper.BETTER_COLOR;
         }
         else amountColor = TooltipHelper.NO_DIFF_COLOR;
         if (this.equipData && this.equipData.StatsBoosts && this.equipData.StatsBoosts.length > 0) {
            var statBoost2:StatBoost = GetStatBoost(this.equipData.StatsBoosts, statBoost.Stat);
            if (statBoost2) {
               var amount2:int = statBoost2.Amount;
               amountColor = TooltipHelper.getTextColor(amount - amount2);
            }
            else if (amount < 0) {
               amountColor = TooltipHelper.WORSE_COLOR;
            }
         }
         else if (amount < 0) {
            amountColor = TooltipHelper.WORSE_COLOR;
         }
         this.attributes += "    ";
         this.attributes += TooltipHelper.wrapInFontTag(GetSign(amount) + amount, amountColor) + " " + TooltipHelper.wrapInFontTag(stat, amountColor) + "\n";
      }
   }

   private static function GetStatBoost(boosts:Vector.<StatBoost>, stat:int):StatBoost {
      for each (var boost:StatBoost in boosts)
         if (boost.Stat == stat)
            return boost;
      return null;
   }

   private function makeGlobalAttributes():void {
      if (this.itemAtr.Doses > 0)
         this.makeItemDoses();
      if (!this.itemAtr.MultiPhase && this.itemAtr.MpCost != -1)
         this.makeItemMpCost();
      if (this.itemAtr.MultiPhase)
         this.makeItemMpEndCost();
      if (this.itemAtr.Usable)
         this.makeItemCooldown();
      if (this.itemAtr.Resurrects)
         this.attributes += "This item resurrects you from death\n";
      if (this.itemAtr.FameBonus > 0)
         this.makeItemFameBonus();
   }

   private static function ApplyWisMod(value:Number, player:Player, offset:int = 1):Number {
      if (!player)
         return value;

      var wisdom:Number = Math.min(player.wisdom_, MAX_WISMOD);
      if (wisdom < MIN_WISMOD)
         return value;
      else {
         var m:int = value < 0 ? -1 : 1;
         var n:Number = ((value * (wisdom)) / 150) + (value * m);
         n = Math.floor(n * Math.pow(10, offset)) / Math.pow(10, offset);
         if (n - (int(n) * m) >= (1 / Math.pow(10, offset)) * m)
            return Math.round(MathUtil2.roundTo(n, 1));
         return int(n);
      }
   }

   private function makeItemDoses():void {
      var maxDoses:int = this.itemAtr.MaxDoses;
      var doses:int = this.itemAtr.Doses;
      var color:String = TooltipHelper.NO_DIFF_COLOR;
      if (this.equipData && this.equipData.Doses > 0 && this.equipData.DisplayId == this.itemAtr.DisplayId) {
         var doses2:int = this.equipData.Doses;
         color = TooltipHelper.getTextColor(doses - doses2);
      }
      else if (this.isEquippable_)
         color = TooltipHelper.BETTER_COLOR;
      this.attributes += "Max Doses: " + TooltipHelper.wrapInFontTag(String(maxDoses), TooltipHelper.NO_DIFF_COLOR) + "\n";
      this.attributes += "Doses: " + TooltipHelper.wrapInFontTag(String(doses), color) + "\n";
   }

   private function makeItemFameBonus():void {
      var fame:int = this.itemAtr.FameBonus;
      var color:String = TooltipHelper.NO_DIFF_COLOR;
      if (this.equipData && this.equipData.FameBonus > 0) {
         var fame2:int = this.equipData.FameBonus;
         color = TooltipHelper.getTextColor(fame - fame2);
      }
      else if (this.isEquippable_)
         color = TooltipHelper.BETTER_COLOR;
      this.attributes += "Fame Bonus: " + TooltipHelper.wrapInFontTag(fame + "%", color) + "\n";
   }

   private function makeItemMpCost():void {
      if (!this.itemAtr.Usable)
         return;
      var cost:int = this.itemAtr.MpCost;
      var color:String = TooltipHelper.NO_DIFF_COLOR;
      if (this.equipData && this.equipData.MpCost > 0) {
         var cost2:int = this.equipData.MpCost;
         color = TooltipHelper.getTextColor(cost2 - cost);
      }
      else if (this.isEquippable_)
         color = TooltipHelper.BETTER_COLOR;
      this.attributes += "MP Cost: " + TooltipHelper.wrapInFontTag(String(cost), color) + "\n";
   }

   private function makeItemMpEndCost():void {
      if (!this.itemAtr.Usable)
         return;
      var cost:int = this.itemAtr.MpEndCost;
      var color:String = TooltipHelper.NO_DIFF_COLOR;
      if (this.equipData && this.equipData.MpEndCost > 0) {
         var cost2:int = this.equipData.MpEndCost;
         color = TooltipHelper.getTextColor(cost2 - cost);
      }
      else if (this.isEquippable_)
         color = TooltipHelper.BETTER_COLOR;
      this.attributes += "MP Cost: " + TooltipHelper.wrapInFontTag(String(cost), color) + "\n";
   }

   private function makeItemCooldown():void {
      var cd:Number = this.itemAtr.Cooldown;
      var color:String = TooltipHelper.NO_DIFF_COLOR;
      if (this.equipData && this.equipData.Usable) {
         var cd2:Number = this.equipData.Cooldown;
         color = TooltipHelper.getTextColor(cd2 - cd);
      }
      else if (this.isEquippable_)
         color = TooltipHelper.BETTER_COLOR;
      this.attributes += "Cooldown: " + TooltipHelper.wrapInFontTag(cd + " secs", color) + "\n";
   }

   override protected function alignUI():void {
      this.titleText_.x = (this.icon_.width + 4);
      this.titleText_.y = ((this.icon_.height / 2) - (this.titleText_.height / 2));
      if (this.tierText_) {
         this.tierText_.y = this.icon_.height / 2 - (this.tierText_.height / 2);
         this.tierText_.x = (MAX_WIDTH - 10) - (this.tierText_.width);
      }
      this.descText_.x = 4;
      this.descText_.y = (this.icon_.height + 2);
      if (this.line1_ != null && this.attributesText != null) {
         this.line1_.x = 8;
         this.line1_.y = ((this.descText_.y + this.descText_.height) + 4);
         this.attributesText.x = 4;
         this.attributesText.y = (this.line1_.y + 8);
      }
      this.line2_.x = 8;
      this.line2_.y = this.attributesText != null ? ((this.attributesText.y + this.attributesText.height) + 8) : ((this.descText_.y + this.descText_.height));
      var _local1:uint = (this.line2_.y + 8);
      if (this.restrictionsText_) {
         this.restrictionsText_.x = 4;
         this.restrictionsText_.y = _local1;
         _local1 = (_local1 + this.restrictionsText_.height);
      }
      /*if (this.powerText) {
         if (contains(this.powerText)) {
            this.powerText.x = 4;
            this.powerText.y = _local1;
         }
      }*/
   }

   private static function formatStringForPluralValue(amount:uint, string:String) : String
   {
      if(amount > 1)
      {
         string = string + "s";
      }
      return string;
   }

   private function addEquipmentItemRestrictions() : void
   {
      this.restrictions.push(new Restriction("Must be equipped to use",11776947,false));
      if(this.isInventoryFull || this.inventoryOwnerType == InventoryOwnerTypes.CURRENT_PLAYER)
      {
         this.restrictions.push(new Restriction("Double-Click to equip",11776947,false));
      }
      else
      {
         this.restrictions.push(new Restriction("Double-Click to take",11776947,false));
      }
   }

   private function addAbilityItemRestrictions() : void
   {
      this.restrictions.push(new Restriction("Press [" + KeyCodes.CharCodeStrings[Parameters.data_.useSpecial] + "] in world to use",16777215,false));
   }

   private function addConsumableItemRestrictions() : void
   {
      this.restrictions.push(new Restriction("Consumed with use",11776947,false));
      if(this.isInventoryFull || this.inventoryOwnerType == InventoryOwnerTypes.CURRENT_PLAYER)
      {
         this.restrictions.push(new Restriction("Double-Click or Shift-Click on item to use",16777215,false));
      }
      else
      {
         this.restrictions.push(new Restriction("Double-Click to take & Shift-Click to use",16777215,false));
      }
   }

   private function addReusableItemRestrictions() : void
   {
      this.restrictions.push(new Restriction("Can be used multiple times",11776947,false));
      this.restrictions.push(new Restriction("Double-Click or Shift-Click on item to use",16777215,false));
   }
   private static function parse(str:String):Number {
      for (var i:Number = 0; i < str.length; i++) {
         var c:String = str.charAt(i);
         if (c != "0") break;
      }

      return Number(str.substr(i));
   }
   private var spriteFile:String = null;
   private var first:Number = -1;
   private var last:Number = -1;
   private var next:Number = -1;
   private var animatedTimer:Timer;

   private function makeAnimation(event:TimerEvent = null):void {
      if (this.spriteFile == null)
         return;

      var size:int = this.iconSize;
      var bitmapData:BitmapData = AssetLibrary.getImageFromSet(this.spriteFile, this.next);

      //  if (Parameters.itemTypes16.indexOf(this.objectType_) != -1 || bitmapData.height == 16)
      //      size = (size * 0.5);

      bitmapData = TextureRedrawer.redraw(bitmapData, size, true, 0, true, 5);

      this.icon_.bitmapData = bitmapData;
      this.icon_.x = this.icon_.y = - 4;

      this.next++;

      if (this.next > this.last)
         this.next = this.first;
   }

   private function makeRestrictionList() : void
   {
      var reqXML:XML = null;
      var reqMet:Boolean = false;
      var stat:int = 0;
      var value:int = 0;

      var spritePeriod:int = -1;
      var spriteFile:String = null;
      var spriteArray:Array = null;
      var first:Number = -1;
      var last:Number = -1;
      var next:Number = -1;
      var makeAnimation:Function;
      var hasPeriod:Boolean = this.objectXML_.hasOwnProperty("@spritePeriod");
      var hasFile:Boolean = this.objectXML_.hasOwnProperty("@spriteFile");
      var hasArray:Boolean = this.objectXML_.hasOwnProperty("@spriteArray");
      var hasAnimatedSprites:Boolean = hasPeriod && hasFile && hasArray;

      if (hasPeriod)
         spritePeriod = 1000 / this.objectXML_.attribute("spritePeriod");

      if (hasFile)
         spriteFile = this.objectXML_.attribute("spriteFile");

      if (hasArray) {
         spriteArray = String(this.objectXML_.attribute("spriteArray")).split('-');
         first = parse(spriteArray[0]);
         last = parse(spriteArray[1]);
      }

      if (hasAnimatedSprites && spritePeriod != -1 && spriteFile != null && spriteArray != null && first != -1 && last != -1) {
         this.spriteFile = spriteFile;
         this.first = first;
         this.last = last;
         this.next = this.first;
         this.animatedTimer = new Timer(spritePeriod);
         this.animatedTimer.addEventListener(TimerEvent.TIMER, this.makeAnimation);
         this.animatedTimer.start();
      }

      this.restrictions = new Vector.<Restriction>();
      if(this.objectXML_.hasOwnProperty("VaultItem") && this.invType != -1 && this.invType != ObjectLibrary.idToType_["Vault Chest"])
      {
         this.restrictions.push(new Restriction("Store this item in your Vault to avoid losing it!",16549442,true));
      }
      if(this.objectXML_.hasOwnProperty("Soulbound"))
      {
         this.restrictions.push(new Restriction("Soulbound",11776947,false));
      }
      if(this.playerCanUse)
      {
         if(this.objectXML_.hasOwnProperty("Usable"))
         {
            this.addAbilityItemRestrictions();
            this.addEquipmentItemRestrictions();
         }
         else if(this.objectXML_.hasOwnProperty("Consumable"))
         {
            this.addConsumableItemRestrictions();
         }
         else if(this.objectXML_.hasOwnProperty("InvUse"))
         {
            this.addReusableItemRestrictions();
         }
         else
         {
            this.addEquipmentItemRestrictions();
         }
      }
      else if(this.player_ != null)
      {
         this.restrictions.push(new Restriction("Not usable by " + ObjectLibrary.typeToDisplayId_[this.player_.objectType_],16549442,true));
      }
      var usable:Vector.<String> = ObjectLibrary.usableBy(this.objectType_);
      if(usable != null)
      {
         this.restrictions.push(new Restriction("Usable by: " + usable.join(", "),11776947,false));
      }
      for each(reqXML in this.objectXML_.EquipRequirement)
      {
         reqMet = ObjectLibrary.playerMeetsRequirement(reqXML,this.player_);
         if(reqXML.toString() == "Stat")
         {
            stat = int(reqXML.@stat);
            value = int(reqXML.@value);
            this.restrictions.push(new Restriction("Requires " + StatData.statToName(stat) + " of " + value,reqMet?11776947:16549442,reqMet?Boolean(false):Boolean(true)));
         }
      }
   }

   private function makeLineTwo():void{
      this.line2_ = new LineBreakDesign((MAX_WIDTH - 15), 0x151515);
      addChild(this.line2_);
   }

   private function makeRestrictionText() : void
   {
      var sheet:StyleSheet = null;
      if(this.restrictions.length != 0)
      {
         //sheet = new StyleSheet();
         //sheet.parseCSS(CSS_TEXT);
         this.restrictionsText_ = new SimpleText(14,11776947,false,MAX_WIDTH - 4,0);
         //this.restrictionsText_.styleSheet = sheet;
         this.restrictionsText_.wordWrap = true;
         this.restrictionsText_.htmlText = "<span class=\'in\'>" + BuildRestrictionsHTML(this.restrictions) + "</span>";
         this.restrictionsText_.useTextDimensions();
         this.restrictionsText_.x = 4;
         this.restrictionsText_.y = this.line2_.y + 8;
         switch(Parameters.data_.itemDataOutlines)
         {
            case 0:
               this.restrictionsText_.filters = FilterUtil.getTextOutlineFilter();
               break;
            case 1:
               this.restrictionsText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         }
         addChild(this.restrictionsText_);
      }
   }

   private function addDescriptionText() : void
   {
      var _local_1:int = 0xB3B3B3;
      this.descText_ = new SimpleText(14, _local_1, false, MAX_WIDTH - 10);
      this.descText_.wordWrap = true;
      this.descText_.htmlText = this.itemAtr.Description;
      this.descText_.useTextDimensions();
      switch(Parameters.data_.itemDataOutlines)
      {
         case 0:
            this.descText_.filters = FilterUtil.getTextOutlineFilter();
            break;
         case 1:
            this.descText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
      }
      this.descText_.updateMetrics();
      addChild(this.descText_);
   }

   private function buildCategorySpecificText() : void
   {
      /*if(this.curItemXML_ != null)
      {
         this.comparisonResults = this.slotTypeToTextBuilder.getComparisonResults(this.objectXML_,this.curItemXML_);
      }
      else
      {
         this.comparisonResults = new SlotComparisonResult();
      }*/
   }

   private function handleWisMod():void {
      var _local3:XML;
      var _local4:XML;
      var _local5:String;
      var _local6:String;
      if (this.player_ == null) {
         return;
      }
      var _local1:Number = (this.player_.wisdom_ + this.player_.wisdomBoost_);
      if (_local1 < 30) {
         return;
      }
      var _local2:Vector.<XML> = new Vector.<XML>();
      if (this.curItemXML_ != null) {
         this.curItemXML_ = this.curItemXML_.copy();
         _local2.push(this.curItemXML_);
      }
      if (this.objectXML_ != null) {
         this.objectXML_ = this.objectXML_.copy();
         _local2.push(this.objectXML_);
      }
      for each (_local4 in _local2) {
         for each (_local3 in _local4.Activate) {
            _local5 = _local3.toString();
            if (_local3.@effect != "Stasis") {
               _local6 = _local3.@useWisMod;
               if (!(((((((_local6 == "")) || ((_local6 == "false")))) || ((_local6 == "0")))) || ((_local3.@effect == "Stasis")))) {
                  switch (_local5) {
                     case ActivationType.HEAL_NOVA:
                        _local3.@amount = this.modifyWisModStat(_local3.@amount, 0);
                        _local3.@range = this.modifyWisModStat(_local3.@range);
                        break;
                     case ActivationType.COND_EFFECT_AURA:
                        _local3.@duration = this.modifyWisModStat(_local3.@duration);
                        _local3.@range = this.modifyWisModStat(_local3.@range);
                        break;
                     case ActivationType.COND_EFFECT_SELF:
                        _local3.@duration = this.modifyWisModStat(_local3.@duration);
                        break;
                     case ActivationType.STAT_BOOST_AURA:
                        _local3.@amount = this.modifyWisModStat(_local3.@amount, 0);
                        _local3.@duration = this.modifyWisModStat(_local3.@duration);
                        _local3.@range = this.modifyWisModStat(_local3.@range);
                        break;
                     case ActivationType.GENERIC_ACTIVATE:
                        _local3.@duration = this.modifyWisModStat(_local3.@duration);
                        _local3.@range = this.modifyWisModStat(_local3.@range);
                        break;
                     case ActivationType.POISON_GRENADE:
                        _local3.@impactDamage = this.modifyWisModStat(_local3.@impactDamage, 0);
                        _local3.@totalDamage = this.modifyWisModStat(_local3.@totalDamage, 0);
                        break;
                     case ActivationType.LIGHTNING:
                        _local3.@totalDamage = this.modifyWisModStat(_local3.@totalDamage, 0);
                        break;
                     case ActivationType.VAMPIRE_BLAST:
                        _local3.@totalDamage = this.modifyWisModStat(_local3.@totalDamage, 0);
                        break;
                  }
               }
            }
         }
      }
   }

   public function modifyWisModStat(_arg1:String, _arg2:Number = 1):String {
      var _local5:Number;
      var _local6:int;
      var _local7:Number;
      var _local3:String = "-1";
      var _local4:Number = (this.player_.wisdom_ + this.player_.wisdomBoost_);
      if (_local4 < 50) {
         _local3 = _arg1;
      }
      else {
         _local5 = Number(_arg1);
         _local6 = (((_local5) < 0) ? -1 : 1);
         _local7 = (((_local5 * _local4) / 150) + (_local5 * _local6));
         _local7 = (Math.floor((_local7 * Math.pow(10, _arg2))) / Math.pow(10, _arg2));
         if ((_local7 - (int(_local7) * _local6)) >= ((1 / Math.pow(10, _arg2)) * _local6)) {
            _local3 = _local7.toFixed(1);
         }
         else {
            _local3 = _local7.toFixed(0);
         }
      }
      return (_local3);
   }

   private function BuildEffectsHTML(effects:Vector.<Effect>) : String
   {
      var effect:Effect = null;
      var textColor:String = null;
      var nameColor:String = null;
      var html:String = "";
      var first:Boolean = true;
      for each(effect in effects)
      {
         textColor = "#FFFF8F";
         if(!first)
         {
            html = html + "\n";
         }
         else
         {
            first = false;
         }
         nameColor = effect.color_ != "" ? effect.color_ : null;
         if(effect.name_ != "")
         {
            html = html + ("<font color=\"" + nameColor + "\">" + effect.name_ + "</font>" + (effect.name_.charAt(effect.name_.length - 1) == ":" ? " " : ": "));
         }
         if(this.isEmptyEquipSlot())
         {
            textColor = "#00ff00";
         }
         html = html + ("<font color=\"" + textColor + "\">" + effect.value_ + "</font>");
      }
      return html;
   }

}
}

class ComPair
{
   public var a:Number;
   public var b:Number;

   public function ComPair(_arg1:XML, _arg2:XML, _arg3:String, _arg4:Number=0)
   {
      this.a = (this.b = ((_arg1.hasOwnProperty(("@" + _arg3))) ? _arg1.@[_arg3] : _arg4));
      if (_arg2){
         this.b = ((_arg2.hasOwnProperty(("@" + _arg3))) ? _arg2.@[_arg3] : _arg4);
      };
   }
   public function add(_arg1:Number):void
   {
      this.a = (this.a + _arg1);
      this.b = (this.b + _arg1);
   }

}

class Effect
{


   public var name_:String;

   public var value_:String;

   public var color_:String = "#B3B3B3";

   function Effect(name:String, value:String)
   {
      super();
      this.name_ = name;
      this.value_ = value;
   }

   public function setColor(_arg1:String):Effect {
      this.color_ = _arg1;
      return (this);
   }

}

class Restriction
{


   public var text_:String;

   public var color_:uint;

   public var bold_:Boolean;

   function Restriction(text:String, color:uint, bold:Boolean)
   {
      super();
      this.text_ = text;
      this.color_ = color;
      this.bold_ = bold;
   }
}
