package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.options.Options;
   import com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid;
   import com.company.assembleegameclient.ui.panels.itemgrids.InventoryGrid;
   import com.company.ui.SimpleText;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class GameObjectStatusPanel extends Sprite
   {
       
      
      private var gs_:GameSprite;
      
      private var go_:Player;
      
      private var w_:int;
      
      private var h_:int;
      
      private var portrait_:Bitmap;
      
      private var nameText_:SimpleText;
      
      private var rankIcon_:Sprite;
      
      private var nexusButton_:IconButton = null;
      
      private var expBar_:StatusBar;
      
      private var fameBar_:StatusBar;
      
      private var hpBar_:StatusBar;
      
      private var mpBar_:StatusBar;
      
      private var stats_:Stats;
      
      private var ePanel:EquippedGrid;
      
      private var iPanel:InventoryGrid;
      
      public function GameObjectStatusPanel(gs:GameSprite, go:Player, w:int, h:int)
      {
         super();
         this.gs_ = gs;
         this.go_ = go;
         this.w_ = w;
         this.h_ = h;
         this.portrait_ = new Bitmap(null);
         this.portrait_.x = -2;
         this.portrait_.y = -8;
         addChild(this.portrait_);
         this.nameText_ = new SimpleText(20,11776947,false,0,0);
         this.nameText_.setBold(true);
         this.nameText_.x = 56;
         this.nameText_.y = 0;
         if(this.gs_.model.getName() == null)
         {
            this.nameText_.text = this.go_.name_;
         }
         else
         {
            this.nameText_.text = this.gs_.model.getName();
         }
         this.nameText_.updateMetrics();
         this.nameText_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.nameText_);
         if(this.gs_.gsc_.gameId_ != Parameters.NEXUS_GAMEID)
         {
            this.nexusButton_ = new IconButton(AssetLibrary.getImageFromSet("lofiInterfaceBig",6),"Nexus","escapeToNexus");
            this.nexusButton_.addEventListener(MouseEvent.CLICK,this.onNexusClick);
            this.nexusButton_.x = 172;
            this.nexusButton_.y = 4;
            addChild(this.nexusButton_);
         }
         else
         {
            this.nexusButton_ = new IconButton(AssetLibrary.getImageFromSet("lofiInterfaceBig",5),"Options","options");
            this.nexusButton_.addEventListener(MouseEvent.CLICK,this.onOptionsClick);
            this.nexusButton_.x = 172;
            this.nexusButton_.y = 4;
            addChild(this.nexusButton_);
         }
         this.expBar_ = new StatusBar(176,16,5931045,5526612,"Lvl X");
         this.expBar_.x = 12;
         this.expBar_.y = 32;
         addChild(this.expBar_);
         this.expBar_.visible = true;
         this.fameBar_ = new StatusBar(176,16,14835456,5526612,"Fame");
         this.fameBar_.x = 12;
         this.fameBar_.y = 32;
         addChild(this.fameBar_);
         this.fameBar_.visible = false;
         this.hpBar_ = new StatusBar(176,16,14693428,5526612,"HP");
         this.hpBar_.x = 12;
         this.hpBar_.y = 56;
         addChild(this.hpBar_);
         this.mpBar_ = new StatusBar(176,16,6325472,5526612,"MP");
         this.mpBar_.x = 12;
         this.mpBar_.y = 80;
         this.mpBar_.visible = true;
         addChild(this.mpBar_);
         this.stats_ = new Stats(180,46);
         this.stats_.x = 22;
         this.stats_.y = 88;
         addChild(this.stats_);
         this.ePanel = new EquippedGrid(go,go.slotTypes_,go);
         this.ePanel.x = 14;
         this.ePanel.y = 164;
         addChild(this.ePanel);
         this.iPanel = new InventoryGrid(go,go,4);
         this.iPanel.x = 14;
         this.iPanel.y = this.ePanel.y + this.ePanel.height + 3;
         addChild(this.iPanel);
         mouseEnabled = false;
         this.draw();
      }
      
      public function setName(name:String) : void
      {
         this.nameText_.text = name;
         this.nameText_.updateMetrics();
      }
      
      private function onNexusClick(event:MouseEvent) : void
      {
         this.gs_.gsc_.escape();
      }
      
      private function onOptionsClick(event:MouseEvent) : void
      {
         this.gs_.mui_.clearInput();
         this.gs_.forceScaledLayer.addChild(new Options(this.gs_));
      }
      
      public function draw() : void
      {
         this.portrait_.bitmapData = this.go_.getPortrait();
         var lvlText:String = "Lvl " + this.go_.level_;
         if(lvlText != this.expBar_.labelText_.text)
         {
            this.expBar_.labelText_.text = lvlText;
            this.expBar_.labelText_.updateMetrics();
         }

         if(this.go_.level_ != 20)
         {
            if(!this.expBar_.visible)
            {
               this.expBar_.visible = true;
               this.fameBar_.visible = false;
            }
            this.expBar_.draw(this.go_.exp_,this.go_.nextLevelExp_,0);
         }
         else
         {
            if(!this.fameBar_.visible)
            {
               this.fameBar_.visible = true;
               this.expBar_.visible = false;
            }
            this.fameBar_.draw(this.go_.currFame_,this.go_.nextClassQuestFame_,0);
         }
         this.hpBar_.draw(this.go_.hp_,this.go_.maxHP_,this.go_.maxHPBoost_,this.go_.maxHPMax_);
         this.mpBar_.draw(this.go_.mp_,this.go_.maxMP_,this.go_.maxMPBoost_,this.go_.maxMPMax_);
         this.stats_.draw(this.go_);
         this.ePanel.draw();
         this.iPanel.draw();
      }
      
      public function destroy() : void
      {
      }
   }
}
