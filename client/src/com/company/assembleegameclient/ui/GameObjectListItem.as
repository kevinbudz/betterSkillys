package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.ui.SimpleText;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   
   public class GameObjectListItem extends Sprite
   {
       
      
      public var portrait_:Bitmap;
      
      private var nameText_:SimpleText;
      
      private var rankIcon_:Sprite;
      
      private var color_:uint;
      
      public var longVersion_:Boolean;
      
      public var go_:GameObject;
      
      private var drawColor_:uint = 16777215;
      
      private var drawText_:String = null;
      
      private var isHtml_:Boolean = false;
      
      private var drawCT_:ColorTransform = null;

      private var positionClassBelow:Boolean;

      private var showAccId:Boolean;

      private var showFame:Boolean;
      
      public function GameObjectListItem(color:uint, longVersion:Boolean, go:GameObject, posClassBelow:Boolean = false, showAccId:Boolean = false, showFamePlayer:Boolean = false)
      {
         super();
         this.positionClassBelow = posClassBelow;
         this.showAccId = showAccId;
         this.longVersion_ = longVersion;
         this.showFame = showFamePlayer;
         this.color_ = color;
         this.portrait_ = new Bitmap();
         this.portrait_.x = -4;
         this.portrait_.y = posClassBelow ? -1 : -4;
         if (showAccId) {
            this.portrait_.y = -2;
         }
         addChild(this.portrait_);
         if(this.longVersion_)
         {
            this.nameText_ = new SimpleText(13,color,false,0,0);
         }
         else
         {
            this.nameText_ = new SimpleText(13,color,false,66,20);
            this.nameText_.setBold(true);
         }
         this.nameText_.x = 32;
         this.nameText_.y = 6;
         this.nameText_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.nameText_);
         this.draw(go);
      }
      
      public function draw(go:GameObject, ct:ColorTransform = null) : void
      {
         this.go_ = go;
         visible = this.go_ != null;
         if(!visible)
         {
            return;
         }
         this.portrait_.bitmapData = this.go_.getPortrait();
         var drawColor:uint = this.color_;
         var drawText:String = null;
         var isHtml:Boolean = false;
         var p:Player = this.go_ as Player;
         if(p != null)
         {
            if(p.isFellowGuild_)
            {
               drawColor = Parameters.FELLOW_GUILD_COLOR;
            }
            else if(p.isPartyMember_)
            {
               drawColor = Parameters.PARTY_MEMBER_COLOR;
            }
            else if(p.nameChosen_)
            {
               drawColor = Parameters.NAME_CHOSEN_COLOR;
            }
         }
         if(this.longVersion_)
         {
            isHtml = true;
            var player:Player = null;
            if(this.go_ is Player)
            {
               player = (this.go_ as Player);
            }
            if(this.go_.name_ != null && this.go_.name_ != "")
            {
               drawText = "<b>" + this.go_.name_ + "</b> (" + ObjectLibrary.typeToDisplayId_[this.go_.objectType_];
               if(this.go_.level_ < 1)
               {
                  drawText = drawText + ")";
               }
               else
               {
                  drawText = drawText + (" " + this.go_.level_ + ")\n");
               }
               if (this.showAccId) {
                  drawText += "<b>AccID: " + player.accountId_ + " ";
               }
               if(this.showFame){
                  drawText += "<b>Fame: " + player.fame_ + "</b>";
               }
            }
            else
            {
               drawText = "<b>" + ObjectLibrary.typeToDisplayId_[this.go_.objectType_] + "</b>";
            }
         }
         else if(this.go_.name_ == null || this.go_.name_ == "")
         {
            drawText = ObjectLibrary.typeToDisplayId_[this.go_.objectType_];
         }
         else
         {
            drawText = this.go_.name_;
         }
         this.internalDraw(drawColor,drawText,isHtml,ct);
      }
      
      private function internalDraw(drawColor:uint, drawText:String, isHtml:Boolean, drawCT:ColorTransform) : void
      {
         if(drawColor == this.drawColor_ && drawText == this.drawText_ && isHtml == this.isHtml_ && drawCT == this.drawCT_)
         {
            return;
         }
         this.nameText_.setColor(drawColor);
         if(isHtml)
         {
            this.nameText_.htmlText = drawText;
         }
         else
         {
            this.nameText_.text = drawText;
         }
         this.nameText_.updateMetrics();
         if(this.drawCT_ != null || drawCT != null)
         {
            transform.colorTransform = drawCT == null?MoreColorUtil.identity:drawCT;
         }
         this.drawColor_ = drawColor;
         this.drawText_ = drawText;
         this.isHtml_ = isHtml;
         this.drawCT_ = drawCT;
      }
   }
}
