package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.GuildBoardPanel;
   import com.company.assembleegameclient.ui.panels.Panel;
   
   public class GuildBoard extends GameObject implements IInteractiveObject
   {
       
      
      public function GuildBoard(objectXML:XML)
      {
         super(objectXML);
         isInteractive_ = true;
      }
      
      public function getPanel(gs:GameSprite) : Panel
      {
         return new GuildBoardPanel(gs);
      }
   }
}
