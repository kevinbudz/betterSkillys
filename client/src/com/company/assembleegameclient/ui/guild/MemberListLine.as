package com.company.assembleegameclient.ui.guild
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import com.company.assembleegameclient.util.GuildUtil;
   import com.company.rotmg.graphics.DeleteXGraphic;
   import com.company.ui.SimpleText;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
import flash.globalization.DateTimeFormatter;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.texture.TextureParser;

import org.hamcrest.text.re;

internal class MemberListLine extends Sprite
   {
      
      public static const WIDTH:int = 756;
      
      public static const HEIGHT:int = 32;
      
      protected static const mouseOverCT:ColorTransform = new ColorTransform(1,220 / 255,133 / 255);
       
      
      private var name_:String;
      private var rank_:int;
      private var placeText_:SimpleText;
      private var nameText_:SimpleText;
      private var guildFameText_:SimpleText;
      private var lastSeen_:SimpleText;
      private var guildFameIcon_:Bitmap;
      private var rankIcon_:Bitmap;
      private var rankText_:SimpleText;
      private var promoteButton_:Sprite;
      private var demoteButton_:Sprite;
      private var removeButton_:SliceScalingButton;
      
      function MemberListLine(place:int, name:String, rank:int, fame:int, isMe:Boolean, myRank:int, lastSeen:int)
      {
         super();
         this.name_ = name;
         this.rank_ = rank;
         var textColor:uint = 11776947;
         if(isMe)
         {
            textColor = 16564761;
         }
         this.placeText_ = new SimpleText(22,textColor,false,0,0);
         this.placeText_.setBold(true);
         this.placeText_.text = place.toString() + ".";
         this.placeText_.useTextDimensions();
         this.placeText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.placeText_.x = 60 - this.placeText_.width;
         this.placeText_.y = HEIGHT / 2 - this.placeText_.height / 2;
         addChild(this.placeText_);

         this.nameText_ = new SimpleText(22,textColor,false,0,0);
         this.nameText_.setBold(true);
         this.nameText_.text = name;
         this.nameText_.useTextDimensions();
         this.nameText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.nameText_.x = 100;
         this.nameText_.y = HEIGHT / 2 - this.nameText_.height / 2;
         addChild(this.nameText_);

         var dt:DateTimeFormatter = new DateTimeFormatter("");
         dt.setDateTimePattern("yyyy-MM-dd HH:mm");

         var playerDate:Date = new Date(lastSeen * 1000);
         var myTimeDate:Date = new Date();

         var playerTime:String = getLastSeen(playerDate, myTimeDate, isMe);

         this.lastSeen_ = new SimpleText(18, textColor, false, 0, 0);
         this.lastSeen_.text = playerTime;
         this.lastSeen_.setBold(true).useTextDimensions();
         this.lastSeen_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.lastSeen_.x = 250;
         this.lastSeen_.y = HEIGHT / 2 - this.nameText_.height / 2;
         addChild(this.lastSeen_);

         this.guildFameText_ = new SimpleText(22,textColor,false,0,0);
         this.guildFameText_.text = fame.toString();
         this.guildFameText_.useTextDimensions();
         this.guildFameText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.guildFameText_.x = 523 - this.guildFameText_.width;
         this.guildFameText_.y = HEIGHT / 2 - this.guildFameText_.height / 2;
         addChild(this.guildFameText_);

         this.guildFameIcon_ = new Bitmap(GuildUtil.guildFameIcon(40));
         this.guildFameIcon_.x = 525;
         this.guildFameIcon_.y = HEIGHT / 2 - this.guildFameIcon_.height / 2;
         addChild(this.guildFameIcon_);

         this.rankIcon_ = new Bitmap(GuildUtil.rankToIcon(rank,20));
         this.rankIcon_.x = 548;
         this.rankIcon_.y = HEIGHT / 2 - this.rankIcon_.height / 2;
         addChild(this.rankIcon_);

         this.rankText_ = new SimpleText(22,textColor,false,0,0);
         this.rankText_.text = GuildUtil.rankToString(rank);
         this.rankText_.useTextDimensions();
         this.rankText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.rankText_.x = 580;
         this.rankText_.y = HEIGHT / 2 - this.rankText_.height / 2;
         addChild(this.rankText_);

         if(GuildUtil.canPromote(myRank,rank))
         {
            this.promoteButton_ = this.createArrow(true);
            this.addHighlighting(this.promoteButton_);
            this.promoteButton_.addEventListener(MouseEvent.CLICK,this.onPromote);
            this.promoteButton_.x = 670 + 6;
            this.promoteButton_.y = HEIGHT / 2;
            addChild(this.promoteButton_);
         }
         if(GuildUtil.canDemote(myRank,rank))
         {
            this.demoteButton_ = this.createArrow(false);
            this.addHighlighting(this.demoteButton_);
            this.demoteButton_.addEventListener(MouseEvent.CLICK,this.onDemote);
            this.demoteButton_.x = 700 + 6;
            this.demoteButton_.y = HEIGHT / 2;
            addChild(this.demoteButton_);
         }
         if(GuildUtil.canRemove(myRank,rank))
         {
            this.removeButton_ = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","close_button"));
            this.addHighlighting(this.removeButton_);
            this.removeButton_.addEventListener(MouseEvent.CLICK, this.onRemove);
            this.removeButton_.x = 720;
            this.removeButton_.y = ((HEIGHT / 2) - (this.removeButton_.height / 2));
            addChild(this.removeButton_);
         }
      }

      private function getLastSeen(playerDate:Date, myTimeDate:Date, isMe:Boolean) : String
      {
         if(isMe)
         {
            return "Online";
         }
         if(myTimeDate.getFullYear() > playerDate.getFullYear())
         {
            var resultYear:int = myTimeDate.getFullYear() - playerDate.getFullYear();
            return resultYear > 1 ? resultYear + " years ago" : resultYear + " year ago";
         }
         if(myTimeDate.getMonth() > playerDate.getMonth())
         {
            var resultMonth:int = myTimeDate.getMonth() - playerDate.getMonth();
            return resultMonth > 1 ? resultMonth + " months ago" : " month ago";
         }
         else if(myTimeDate.getHours() > playerDate.getHours())
         {
            var result:int = myTimeDate.getHours() - playerDate.getHours();
            return result > 1 ? result + " hours ago" : result + " hour ago";
         }
         else if(myTimeDate.getMinutes() > playerDate.getMinutes())
         {
            var resultMinutes:int = myTimeDate.getMinutes() - playerDate.getMinutes();
            return resultMinutes > 1 ? resultMinutes + " minutes ago" : resultMinutes + " minute ago";
         }
         else
         {
            return "Online";
         }
      }
      
      private function createArrow(up:Boolean) : Sprite
      {
         var sprite:Sprite = new Sprite();
         var g:Graphics = sprite.graphics;
         g.beginFill(16777215);
         g.moveTo(-8,-6);
         g.lineTo(8,-6);
         g.lineTo(0,6);
         g.lineTo(-8,-6);
         if(up)
         {
            sprite.rotation = 180;
         }
         return sprite;
      }
      
      private function addHighlighting(sprite:Sprite) : void
      {
         sprite.addEventListener(MouseEvent.MOUSE_OVER,this.onHighlightOver);
         sprite.addEventListener(MouseEvent.ROLL_OUT,this.onHighlightOut);
      }
      
      private function onHighlightOver(event:MouseEvent) : void
      {
         var target:Sprite = event.currentTarget as Sprite;
         target.transform.colorTransform = mouseOverCT;
      }
      
      private function onHighlightOut(event:MouseEvent) : void
      {
         var target:Sprite = event.currentTarget as Sprite;
         target.transform.colorTransform = MoreColorUtil.identity;
      }
      
      private function onPromote(event:MouseEvent) : void
      {
         var dialog:Dialog = new Dialog("Are you sure you want to promote " + this.name_ + " to " + GuildUtil.rankToString(GuildUtil.promotedRank(this.rank_)) + "?","Promote " + this.name_,"Cancel","Promote");
         dialog.addEventListener(Dialog.BUTTON1_EVENT,this.onCancelDialog);
         dialog.addEventListener(Dialog.BUTTON2_EVENT,this.onVerifiedPromote);
         stage.addChild(dialog);
      }
      
      private function onVerifiedPromote(event:Event) : void
      {
         var dialog:Dialog = event.currentTarget as Dialog;
         stage.removeChild(dialog);
         dispatchEvent(new GuildPlayerListEvent(GuildPlayerListEvent.SET_RANK,this.name_,GuildUtil.promotedRank(this.rank_)));
      }
      
      private function onDemote(event:MouseEvent) : void
      {
         var dialog:Dialog = new Dialog("Are you sure you want to demote " + this.name_ + " to " + GuildUtil.rankToString(GuildUtil.demotedRank(this.rank_)) + "?","Demote " + this.name_,"Cancel","Demote");
         dialog.addEventListener(Dialog.BUTTON1_EVENT,this.onCancelDialog);
         dialog.addEventListener(Dialog.BUTTON2_EVENT,this.onVerifiedDemote);
         stage.addChild(dialog);
      }
      
      private function onVerifiedDemote(event:Event) : void
      {
         var dialog:Dialog = event.currentTarget as Dialog;
         stage.removeChild(dialog);
         dispatchEvent(new GuildPlayerListEvent(GuildPlayerListEvent.SET_RANK,this.name_,GuildUtil.demotedRank(this.rank_)));
      }
      
      private function onRemove(event:MouseEvent) : void
      {
         var dialog:Dialog = new Dialog("Are you sure you want to remove " + this.name_ + " from the guild?","Remove " + this.name_,"Cancel","Remove");
         dialog.addEventListener(Dialog.BUTTON1_EVENT,this.onCancelDialog);
         dialog.addEventListener(Dialog.BUTTON2_EVENT,this.onVerifiedRemove);
         stage.addChild(dialog);
      }
      
      private function onVerifiedRemove(event:Event) : void
      {
         var dialog:Dialog = event.currentTarget as Dialog;
         stage.removeChild(dialog);
         dispatchEvent(new GuildPlayerListEvent(GuildPlayerListEvent.REMOVE_MEMBER,this.name_));
      }
      
      private function onCancelDialog(event:Event) : void
      {
         var dialog:Dialog = event.currentTarget as Dialog;
         stage.removeChild(dialog);
      }
   }
}
