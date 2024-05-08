package com.company.assembleegameclient.ui.guild
{
   import com.company.assembleegameclient.ui.Scrollbar;
   import com.company.assembleegameclient.util.GuildUtil;
   import com.company.ui.SimpleText;
   import com.company.util.MoreObjectUtil;
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
import flash.globalization.DateTimeFormatter;

import io.decagames.rotmg.ui.scroll.UIScrollbar;

import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.texture.TextureParser;

import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.core.StaticInjectorContext;
   
   public class GuildPlayerList extends Sprite
   {
       
      
      private var num_:int;
      private var offset_:int;
      private var myName_:String;
      private var myRank_:int;
      private var listClient_:AppEngineClient;
      private var loadingText_:SimpleText;
      private var titleText_:SimpleText;
      private var guildFameText_:SimpleText;
      private var guildFameIcon_:Bitmap;
      private var lines_:Shape;
      private var mainSprite_:Sprite;
      private var listSprite_:Sprite;
      private var openSlotsText_:SimpleText;
      private var scrollBar_:UIScrollbar;
      private var titleBackground:SliceScalingBitmap;
      private var titleOtherBackground:SliceScalingBitmap;
      private var fameBackground:SliceScalingBitmap;
      
      public function GuildPlayerList(num:int, offset:int, myName:String = "", myRank:int = 0)
      {
         super();
         this.num_ = num;
         this.offset_ = offset;
         this.myName_ = myName;
         this.myRank_ = myRank;
         this.loadingText_ = new SimpleText(22,11776947,false,0,0);
         this.loadingText_.setBold(true);
         this.loadingText_.text = "Loading...";
         this.loadingText_.useTextDimensions();
         this.loadingText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.loadingText_.x = 800 / 2 - this.loadingText_.width / 2;
         this.loadingText_.y = 600 / 2 - this.loadingText_.height / 2;
         addChild(this.loadingText_);
         var account:Account = StaticInjectorContext.getInjector().getInstance(Account);
         var params:Object = {
            "num":num,
            "offset":offset
         };
         MoreObjectUtil.addToObject(params,account.getCredentials());
         this.listClient_ = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
         this.listClient_.setMaxRetries(2);
         this.listClient_.complete.addOnce(this.onComplete);
         this.listClient_.sendRequest("/guild/listMembers",params);
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.onGenericData(data);
         }
         else
         {
            this.onTextError(data);
         }
      }
      
      private function onGenericData(data:String) : void
      {
         this.build(XML(data));
      }
      
      private function onTextError(error:String) : void
      {
         trace("error event: " + error);
      }
      
      private function build(guildXML:XML) : void
      {
         var g:Graphics = null;
         var id:int = 0;
         var memberXML:XML = null;
         var openSlots:int = 0;
         var isMe:Boolean = false;
         var rank:int = 0;
         var listLine:MemberListLine = null;
         trace("guildXML: " + guildXML);
         removeChild(this.loadingText_);
         this.titleText_ = new SimpleText(32,11776947,false,0,0);
         this.titleText_.setBold(true);
         this.titleText_.text = guildXML.@name;
         this.titleText_.useTextDimensions();
         this.titleText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.titleText_.y = (((stage.stageHeight / 2) / stage.stageHeight * 600) - 250) - 20;
         this.titleText_.x = 400 - this.titleText_.width * 0.5;
         this.titleOtherBackground = TextureParser.instance.getSliceScalingBitmap("UI", "popup_header_title", 500);
         this.titleOtherBackground.y = this.titleText_.y - 11;
         this.titleOtherBackground.x = 150;
         this.titleBackground = TextureParser.instance.getSliceScalingBitmap("UI", "popup_header", 800);
         this.titleBackground.y = this.titleText_.y - 39;
         addChild(this.titleBackground);
         addChild(this.titleOtherBackground);
         addChild(this.titleText_);
         this.guildFameText_ = new SimpleText(22,16777215,false,0,0);
         this.guildFameText_.text = guildXML.CurrentFame;
         this.guildFameText_.useTextDimensions();
         this.guildFameText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.guildFameText_.x = (0x0300 - this.guildFameText_.width);
         this.guildFameText_.y = ((32 / 2) - (this.guildFameText_.height / 2)) + 37;
         this.fameBackground = TextureParser.instance.getSliceScalingBitmap("UI", "shop_box_background", 400);
         this.fameBackground.x = 600;
         this.fameBackground.y = this.guildFameText_.y;
         addChild(this.fameBackground);
         addChild(this.guildFameText_);
         this.guildFameIcon_ = new Bitmap(GuildUtil.guildFameIcon(40));
         this.guildFameIcon_.x = 760;
         this.guildFameIcon_.y = ((32 / 2) - (this.guildFameIcon_.height / 2))  + 37;
         addChild(this.guildFameIcon_);
         this.lines_ = new Shape();
         g = this.lines_.graphics;
         g.clear();
         g.lineStyle(2,5526612);
         g.moveTo(18,100);
         g.lineTo(18,600);
         g.moveTo(780,100);
         g.lineTo(780,600);
         g.lineStyle();
         addChild(this.lines_);
         this.mainSprite_ = new Sprite();
         this.mainSprite_.x = 10;
         this.mainSprite_.y = 110;
         var shape:Shape = new Shape();
         g = shape.graphics;
         g.beginFill(0);
         g.drawRect(0,0,MemberListLine.WIDTH,430);
         g.endFill();
         this.mainSprite_.addChild(shape);
         this.mainSprite_.mask = shape;
         addChild(this.mainSprite_);
         this.listSprite_ = new Sprite();
         id = 0;
         for each(memberXML in guildXML.Member)
         {
            isMe = this.myName_ == memberXML.Name;
            rank = memberXML.Rank;
            listLine = new MemberListLine(this.offset_ + id + 1,memberXML.Name,memberXML.Rank,memberXML.Fame,isMe,this.myRank_, memberXML.LastSeen);
            listLine.y = id * MemberListLine.HEIGHT;
            this.listSprite_.addChild(listLine);
            id++;
         }
         openSlots = GuildUtil.MAX_MEMBERS - (this.offset_ + id);
         this.openSlotsText_ = new SimpleText(22,11776947,false,0,0);
         this.openSlotsText_.text = openSlots + " open slots";
         this.openSlotsText_.useTextDimensions();
         this.openSlotsText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.openSlotsText_.x = MemberListLine.WIDTH / 2 - this.openSlotsText_.width / 2;
         this.openSlotsText_.y = id * MemberListLine.HEIGHT;
         this.listSprite_.addChild(this.openSlotsText_);
         this.mainSprite_.addChild(this.listSprite_);
         if(this.listSprite_.height > 400)
         {
            this.scrollBar_ = new UIScrollbar(400);
            this.scrollBar_.x = 800 - this.scrollBar_.width - 4;
            this.scrollBar_.y = 104;
            this.scrollBar_.content = this.listSprite_;
            //this.scrollBar_.setIndicatorSize(400,this.listSprite_.height);
            //this.scrollBar_.addEventListener(Event.CHANGE,this.onScrollBarChange);
            addChild(this.scrollBar_);
         }
      }
      
      /*private function onScrollBarChange(event:Event) : void
      {
         this.listSprite_.y = -this.scrollBar_.pos() * (this.listSprite_.height - 400);
      }*/
   }
}
