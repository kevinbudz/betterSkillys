package com.company.assembleegameclient.map.partyoverlay
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.menu.Menu;
   import com.company.assembleegameclient.ui.menu.PlayerGroupMenu;
   import com.company.assembleegameclient.ui.tooltip.PlayerGroupToolTip;
   import flash.events.MouseEvent;
   
   public class PlayerArrow extends GameObjectArrow
   {
       
      
      public function PlayerArrow()
      {
         super(16777215,4179794,false);
      }
      
      override protected function onMouseOver(event:MouseEvent) : void
      {
         super.onMouseOver(event);
         setToolTip(new PlayerGroupToolTip(this.getFullPlayerVec(),false));
      }
      
      override protected function onMouseOut(event:MouseEvent) : void
      {
         super.onMouseOut(event);
         setToolTip(null);
      }
      
      override protected function onMouseDown(event:MouseEvent) : void
      {
         super.onMouseDown(event);
         removeMenu();
         setMenu(this.getMenu());
      }
      
      protected function getMenu() : Menu
      {
         var player:Player = go_ as Player;
         if(player == null || player.map_ == null)
         {
            return null;
         }
         var myPlayer:Player = player.map_.player_;
         if(myPlayer == null)
         {
            return null;
         }
         return new PlayerGroupMenu(player.map_,this.getFullPlayerVec());
      }
      
      private function getFullPlayerVec() : Vector.<Player>
      {
         var go:GameObject = null;
         var vec:Vector.<Player> = new <Player>[go_ as Player];
         for each(go in extraGOs_)
         {
            vec.push(go as Player);
         }
         return vec;
      }
   }
}
