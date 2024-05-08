package com.company.assembleegameclient.ui.tooltip
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.GameObjectListItem;
   import com.company.assembleegameclient.ui.GuildText;
   import com.company.assembleegameclient.ui.RankText;
   import com.company.assembleegameclient.ui.StatusBar;
   import com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid;
   import com.company.ui.SimpleText;
   import flash.filters.DropShadowFilter;
   
   public class PlayerToolTip extends ToolTip
   {
       
      
      public var player_:Player;
      
      private var playerPanel_:GameObjectListItem;
      
      private var rankText_:RankText;
      
      private var guildText_:GuildText;
      
      private var hpBar_:StatusBar;
      
      private var mpBar_:StatusBar;
      
      private var clickMessage_:SimpleText;
      
      private var eGrid:EquippedGrid;
      
      public function PlayerToolTip(player:Player)
      {
         var yOffset:int = 0;
         super(3552822,0.5,16777215,1);
         this.player_ = player;
         this.playerPanel_ = new GameObjectListItem(11776947,true,this.player_, false, true, true);
         addChild(this.playerPanel_);
         yOffset = 34;
         this.rankText_ = new RankText(this.player_.numStars_,false,true);
         this.rankText_.x = 6;
         this.rankText_.y = yOffset;
         addChild(this.rankText_);
         yOffset = yOffset + 30;
         if(player.guildName_ != null && player.guildName_ != "")
         {
            this.guildText_ = new GuildText(this.player_.guildName_,this.player_.guildRank_,136);
            this.guildText_.x = 6;
            this.guildText_.y = yOffset - 2;
            addChild(this.guildText_);
            yOffset = yOffset + 30;
         }
         this.hpBar_ = new StatusBar(176,16,14693428,5526612,"HP");
         this.hpBar_.x = 6;
         this.hpBar_.y = yOffset;
         addChild(this.hpBar_);
         yOffset = yOffset + 24;
         this.mpBar_ = new StatusBar(176,16,6325472,5526612,"MP");
         this.mpBar_.x = 6;
         this.mpBar_.y = yOffset;
         this.mpBar_.visible = true;
         addChild(this.mpBar_);
         yOffset = yOffset + 24;
         this.eGrid = new EquippedGrid(null,this.player_.slotTypes_,this.player_);
         this.eGrid.x = 8;
         this.eGrid.y = yOffset;
         addChild(this.eGrid);
         yOffset = yOffset + 52;
         this.clickMessage_ = new SimpleText(12,11776947,false,0,0);
         this.clickMessage_.text = "(Click to open menu)";
         this.clickMessage_.updateMetrics();
         this.clickMessage_.filters = [new DropShadowFilter(0,0,0)];
         this.clickMessage_.x = width / 2 - this.clickMessage_.width / 2;
         this.clickMessage_.y = yOffset;
         addChild(this.clickMessage_);
      }

      override public function draw() : void
      {
         this.hpBar_.draw(this.player_.hp_,this.player_.maxHP_,this.player_.maxHPBoost_,this.player_.maxHPMax_);
         this.mpBar_.draw(this.player_.mp_,this.player_.maxMP_,this.player_.maxMPBoost_,this.player_.maxMPMax_);
         this.eGrid.setItems(this.player_.equipment_, this.player_.equipData_);
         this.rankText_.draw(this.player_.numStars_);
         super.draw();
      }
   }
}
