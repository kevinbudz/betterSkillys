package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.util.GuildUtil;
   import com.company.ui.SimpleText;
   import com.company.util.SpriteUtil;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   
   public class GuildText extends Sprite
   {
       
      
      private var name_:String;
      
      private var rank_:int;
      
      private var icon_:Bitmap;
      
      private var guildName_:SimpleText;
      
      public function GuildText(name:String, rank:int, w:int = 0)
      {
         super();
         this.icon_ = new Bitmap(null);
         this.icon_.y = -8;
         this.icon_.x = -8;
         var stWidth:int = w == 0?int(0):int(w - (this.icon_.width - 16));
         this.guildName_ = new SimpleText(16,16777215,false,stWidth,0);
         this.guildName_.filters = [new DropShadowFilter(0,0,0)];
         this.guildName_.x = 24;
         this.draw(name,rank);
      }
      
      public function draw(name:String, rank:int) : void
      {
         if(this.name_ == name && rank == rank)
         {
            return;
         }
         this.name_ = name;
         this.rank_ = rank;
         if(this.name_ == null || this.name_ == "")
         {
            SpriteUtil.safeRemoveChild(this,this.icon_);
            SpriteUtil.safeRemoveChild(this,this.guildName_);
         }
         else
         {
            this.icon_.bitmapData = GuildUtil.rankToIcon(this.rank_,20);
            SpriteUtil.safeAddChild(this,this.icon_);
            this.guildName_.text = this.name_;
            this.guildName_.useTextDimensions();
            SpriteUtil.safeAddChild(this,this.guildName_);
         }
      }
   }
}
