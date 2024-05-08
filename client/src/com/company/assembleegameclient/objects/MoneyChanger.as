package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import kabam.rotmg.game.view.MoneyChangerPanel;
   
   public class MoneyChanger extends GameObject implements IInteractiveObject
   {
       
      
      public function MoneyChanger(objectXML:XML)
      {
         super(objectXML);
         isInteractive_ = true;
      }
      
      public function getPanel(gs:GameSprite) : Panel
      {
         return new MoneyChangerPanel(gs);
      }
   }
}
