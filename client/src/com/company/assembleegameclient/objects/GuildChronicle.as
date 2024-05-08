package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.GuildChroniclePanel;
   import com.company.assembleegameclient.ui.panels.Panel;
   
   public class GuildChronicle extends GameObject implements IInteractiveObject
   {
       
      
      public function GuildChronicle(objectXML:XML)
      {
         super(objectXML);
         isInteractive_ = true;
      }
      
      public function getPanel(gs:GameSprite) : Panel
      {
         return new GuildChroniclePanel(gs);
      }
   }
}
