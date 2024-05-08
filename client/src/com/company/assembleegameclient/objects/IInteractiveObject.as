package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   
   public interface IInteractiveObject
   {
      function getPanel(param1:GameSprite) : Panel;
   }
}
