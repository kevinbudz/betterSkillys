package com.company.assembleegameclient.ui.panels
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.IInteractiveObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class InteractPanel extends Sprite
   {
      
      public static const MAX_DIST:Number = 1;
       
      
      public var gs_:GameSprite;
      
      public var player_:Player;
      
      public var w_:int;
      
      public var h_:int;
      
      public var currentPanel:Panel = null;
      
      public var currObj_:IInteractiveObject = null;
      
      public var partyPanel_:PartyPanel;
      
      private var overridePanel_:Panel;
      
      public var requestInteractive:Function;
      
      public function InteractPanel(gs:GameSprite, player:Player, w:int, h:int)
      {
         super();
         this.gs_ = gs;
         this.player_ = player;
         this.w_ = w;
         this.h_ = h;
         this.partyPanel_ = new PartyPanel(gs);
      }
      
      public function setOverride(panel:Panel) : void
      {
         if(this.overridePanel_ != null)
         {
            this.overridePanel_.removeEventListener(Event.COMPLETE,this.onComplete);
         }
         this.overridePanel_ = panel;
         this.overridePanel_.addEventListener(Event.COMPLETE,this.onComplete);
      }
      
      public function redraw() : void
      {
         this.currentPanel.draw();
      }
      
      public function draw() : void
      {
         var closestInteractive:IInteractiveObject = null;
         var panel:Panel = null;
         if(this.overridePanel_ != null)
         {
            this.setPanel(this.overridePanel_);
            this.currentPanel.draw();
            return;
         }
         closestInteractive = this.requestInteractive();
         if(this.currentPanel == null || closestInteractive != this.currObj_)
         {
            this.currObj_ = closestInteractive;
            panel = this.currObj_ != null?this.currObj_.getPanel(this.gs_):this.partyPanel_;
            this.setPanel(panel);
         }
         this.currentPanel.draw();
      }
      
      private function onComplete(event:Event) : void
      {
         if(this.overridePanel_ != null)
         {
            this.overridePanel_.removeEventListener(Event.COMPLETE,this.onComplete);
            this.overridePanel_ = null;
         }
         this.setPanel(null);
         this.draw();
      }
      
      public function setPanel(panel:Panel) : void
      {
         if(panel != this.currentPanel)
         {
            this.currentPanel && removeChild(this.currentPanel);
            this.currentPanel = panel;
            this.currentPanel && this.positionPanelAndAdd();
         }
      }
      
      private function positionPanelAndAdd() : void
      {
         if(this.currentPanel is ItemGrid)
         {
            this.currentPanel.x = (this.w_ - this.currentPanel.width) * 0.5;
            this.currentPanel.y = 8;
         }
         else
         {
            this.currentPanel.x = 6;
            this.currentPanel.y = 8;
         }
         addChild(this.currentPanel);
      }
   }
}
