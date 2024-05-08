package com.company.assembleegameclient.ui.guild
{
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.game.events.GuildResultEvent;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.texture.TextureParser;

import kabam.rotmg.ui.view.components.MenuOptionsBar;

public class GuildChronicleScreen extends Sprite
   {
       
      
      private var gs_:GameSprite;
      
      private var guildPlayerList_:GuildPlayerList;

      private var continueButton_:SliceScalingButton;
      private var menuOptionsBar:MenuOptionsBar;
      private var buttonsBackground:SliceScalingBitmap;
      
      public function GuildChronicleScreen(gs:GameSprite)
      {
         super();
         this.gs_ = gs;
         graphics.clear();
         graphics.beginFill(2829099,0.8);
         graphics.drawRect(0,0,800,600);
         graphics.endFill();
         this.addList();
         this.buttonsBackground = TextureParser.instance.getSliceScalingBitmap("UI", "popup_header_title", 800);
         this.buttonsBackground.y = 515;
         addChild(this.buttonsBackground);
         this.menuOptionsBar = new MenuOptionsBar();
         this.continueButton_ = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
         this.menuOptionsBar.addButton(this.continueButton_, MenuOptionsBar.CENTER);
         this.continueButton_.y = this.continueButton_.y + 12;
         this.continueButton_.width = 100;
         this.continueButton_.setLabel("continue",DefaultLabelFormat.defaultModalTitle);
         this.continueButton_.addEventListener(MouseEvent.CLICK,this.onContinueClick);
         addChild(this.continueButton_);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function addList() : void
      {
         var player:Player = this.gs_.map.player_;
         this.guildPlayerList_ = new GuildPlayerList(50,0,player == null?"":player.name_,player.guildRank_);
         this.guildPlayerList_.addEventListener(GuildPlayerListEvent.SET_RANK,this.onSetRank);
         this.guildPlayerList_.addEventListener(GuildPlayerListEvent.REMOVE_MEMBER,this.onRemoveMember);
         addChild(this.guildPlayerList_);
      }
      
      private function removeList() : void
      {
         this.guildPlayerList_.removeEventListener(GuildPlayerListEvent.SET_RANK,this.onSetRank);
         this.guildPlayerList_.removeEventListener(GuildPlayerListEvent.REMOVE_MEMBER,this.onRemoveMember);
         removeChild(this.guildPlayerList_);
      }
      
      private function onSetRank(event:GuildPlayerListEvent) : void
      {
         this.removeList();
         this.gs_.addEventListener(GuildResultEvent.EVENT,this.onSetRankResult);
         this.gs_.gsc_.changeGuildRank(event.name_,event.rank_);
      }
      
      private function onSetRankResult(event:GuildResultEvent) : void
      {
         this.gs_.removeEventListener(GuildResultEvent.EVENT,this.onSetRankResult);
         if(!event.success_)
         {
            this.showError(event.errorText_);
         }
         else
         {
            this.addList();
         }
      }
      
      private function onRemoveMember(event:GuildPlayerListEvent) : void
      {
         this.removeList();
         this.gs_.addEventListener(GuildResultEvent.EVENT,this.onRemoveResult);
         this.gs_.gsc_.guildRemove(event.name_);
      }
      
      private function onRemoveResult(event:GuildResultEvent) : void
      {
         this.gs_.removeEventListener(GuildResultEvent.EVENT,this.onRemoveResult);
         if(!event.success_)
         {
            this.showError(event.errorText_);
         }
         else
         {
            this.addList();
         }
      }
      
      private function showError(errorText:String) : void
      {
         var dialog:Dialog = new Dialog(errorText,"Error","Ok",null);
         dialog.addEventListener(Dialog.BUTTON1_EVENT,this.onErrorTextDone);
         stage.addChild(dialog);
      }
      
      private function onErrorTextDone(event:Event) : void
      {
         var dialog:Dialog = event.currentTarget as Dialog;
         stage.removeChild(dialog);
         this.addList();
      }
      
      private function onContinueClick(event:MouseEvent) : void
      {
         this.close();
      }
      
      private function onAddedToStage(event:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,1);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false,1);
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false);
      }
      
      private function onKeyDown(event:KeyboardEvent) : void
      {
         event.stopImmediatePropagation();
      }
      
      private function onKeyUp(event:KeyboardEvent) : void
      {
         event.stopImmediatePropagation();
      }
      
      private function close() : void
      {
         stage.focus = null;
         parent.removeChild(this);
      }
   }
}
