package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import kabam.rotmg.characters.reskin.view.ReskinPanel;
   
   public class ReskinVendor extends GameObject implements IInteractiveObject
   {
       
      
      public function ReskinVendor(objectXML:XML)
      {
         super(objectXML);
         isInteractive_ = true;
      }
      
      public function getPanel(gs:GameSprite) : Panel
      {
         return new ReskinPanel(gs);
      }
   }
}
