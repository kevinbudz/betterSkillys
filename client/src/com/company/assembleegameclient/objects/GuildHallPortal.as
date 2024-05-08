package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.GuildHallPortalPanel;
   import com.company.assembleegameclient.ui.panels.Panel;
   
   public class GuildHallPortal extends GameObject implements IInteractiveObject
   {
      public function GuildHallPortal(objectXML:XML)
      {
         super(objectXML);
         isInteractive_ = true;
      }
      
      public function getPanel(gs:GameSprite) : Panel
      {
         return new GuildHallPortalPanel(gs,this);
      }
   }
}
