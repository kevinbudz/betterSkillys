package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.CharacterChangerPanel;
   import com.company.assembleegameclient.ui.panels.Panel;
   
   public class CharacterChanger extends GameObject implements IInteractiveObject
   {
       
      
      public function CharacterChanger(objectXML:XML)
      {
         super(objectXML);
         isInteractive_ = true;
      }
      
      public function getPanel(gs:GameSprite) : Panel
      {
         return new CharacterChangerPanel(gs);
      }
   }
}
