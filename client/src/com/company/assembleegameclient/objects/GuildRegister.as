package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.GuildRegisterPanel;
   import com.company.assembleegameclient.ui.panels.Panel;
   
   public class GuildRegister extends GameObject implements IInteractiveObject
   {
       
      
      public function GuildRegister(objectXML:XML)
      {
         super(objectXML);
         isInteractive_ = true;
      }
      
      public function getPanel(gs:GameSprite) : Panel
      {
         return new GuildRegisterPanel(gs);
      }
   }
}
