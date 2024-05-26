package com.company.assembleegameclient.ui.panels
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.Party;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.GameObjectListItem;
   import com.company.assembleegameclient.ui.menu.PlayerMenu;
   import com.company.assembleegameclient.ui.tooltip.PlayerToolTip;
   import com.company.util.MoreColorUtil;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.utils.getTimer;
   import flash.display.DisplayObjectContainer;

import kabam.rotmg.core.StaticInjectorContext;

import kabam.rotmg.core.view.Layers;

public class PartyPanel extends Panel
   {
       
      
      public var memberPanels_:Vector.<GameObjectListItem>;
      
      private var toolTip_:PlayerToolTip = null;
      
      private var menu_:PlayerMenu = null;
      
      private var mouseOver_:Boolean = false;

      private var menuLayer:DisplayObjectContainer;
      
      public function PartyPanel(gs:GameSprite)
      {
         this.memberPanels_ = new Vector.<GameObjectListItem>(Party.NUM_MEMBERS,true);
         super(gs);
         var layers:Layers = StaticInjectorContext.getInjector().getInstance(Layers);
         this.menuLayer = layers.top;
         this.memberPanels_[0] = this.createPartyMemberPanel(0,-10);
         this.memberPanels_[1] = this.createPartyMemberPanel(100,-10);
         this.memberPanels_[2] = this.createPartyMemberPanel(0,22);
         this.memberPanels_[3] = this.createPartyMemberPanel(100,22);
         this.memberPanels_[4] = this.createPartyMemberPanel(0,54);
         this.memberPanels_[5] = this.createPartyMemberPanel(100,54);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function createPartyMemberPanel(xPos:int, yPos:int) : GameObjectListItem
      {
         var pmp:GameObjectListItem = null;
         pmp = new GameObjectListItem(16777215,false,null);
         addChild(pmp);
         pmp.x = xPos;
         pmp.y = yPos;
         return pmp;
      }
      
      private function onAddedToStage(event:Event) : void
      {
         var pmp:GameObjectListItem = null;
         for each(pmp in this.memberPanels_)
         {
            pmp.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            pmp.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            pmp.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         }
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         var pmp:GameObjectListItem = null;
         this.removeTooltip();
         this.removeMenu();
         for each(pmp in this.memberPanels_)
         {
            pmp.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
            pmp.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            pmp.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         }
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.removeTooltip();
         if(this.menu_ != null && this.menu_.parent != null)
         {
            return;
         }
         var pmp:GameObjectListItem = event.target as GameObjectListItem;
         var player:Player = pmp.go_ as Player;
         if(player == null || player.texture_ == null)
         {
            return;
         }
         this.toolTip_ = new PlayerToolTip(player);
         stage.addChild(this.toolTip_);
         this.mouseOver_ = true;
      }
      
      private function onMouseOut(event:MouseEvent) : void
      {
         this.removeTooltip();
         this.mouseOver_ = false;
      }
      
      private function onMouseDown(event:MouseEvent) : void
      {
         this.removeTooltip();
         this.removeMenu();
         var pmp:GameObjectListItem = event.target as GameObjectListItem;
         this.menu_ = new PlayerMenu();
         this.menu_.init(gs_,pmp.go_ as Player);
         stage.addChild(this.menu_);
      }
      
      private function removeTooltip() : void
      {
         if(this.toolTip_ != null)
         {
            if(this.toolTip_.parent != null)
            {
               this.toolTip_.parent.removeChild(this.toolTip_);
            }
            this.toolTip_ = null;
         }
      }
      
      private function removeMenu() : void
      {
         if(this.menu_ != null)
         {
            if(this.menu_.parent != null)
            {
               this.menu_.parent.removeChild(this.menu_);
            }
            this.menu_ = null;
         }
      }
      
      override public function draw() : void
      {
         var memberPanel:GameObjectListItem = null;
         var player:Player = null;
         var ct:ColorTransform = null;
         var rv:Number = NaN;
         var c:int = 0;
         var party:Party = gs_.map.party_;
         if(party == null)
         {
            for each(memberPanel in this.memberPanels_)
            {
               memberPanel.draw(null);
            }
            return;
         }
         var time:int = 0;
         for(var i:int = 0; i < Party.NUM_MEMBERS; i++)
         {
            if(this.mouseOver_ || this.menu_ != null && this.menu_.parent != null)
            {
               player = this.memberPanels_[i].go_ as Player;
            }
            else
            {
               player = party.members_[i];
            }
            if(player != null && player.map_ == null)
            {
               player = null;
            }
            ct = null;
            if(player != null)
            {
               if(player.hp_ < player.maxHP_ * 0.2)
               {
                  if(time == 0)
                  {
                     time = getTimer();
                  }
                  rv = int(Math.abs(Math.sin(time / 200)) * 10) / 10;
                  c = 128;
                  ct = new ColorTransform(1,1,1,1,rv * c,-rv * c,-rv * c);
               }
               if(!player.starred_)
               {
                  if(ct != null)
                  {
                     ct.concat(MoreColorUtil.darkCT);
                  }
                  else
                  {
                     ct = MoreColorUtil.darkCT;
                  }
               }
            }
            this.memberPanels_[i].draw(player,ct);
         }
         if(this.toolTip_ != null)
         {
            this.toolTip_.draw();
         }
      }
   }
}
