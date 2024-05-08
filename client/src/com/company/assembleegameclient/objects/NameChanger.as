package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.panels.Panel;
   import kabam.rotmg.game.view.NameChangerPanel;
   
   public class NameChanger extends GameObject implements IInteractiveObject
   {
       
      
      public var rankRequired_:int = 0;
      
      public function NameChanger(objectXML:XML)
      {
         super(objectXML);
         isInteractive_ = true;
      }
      
      public function setRankRequired(rank:int) : void
      {
         this.rankRequired_ = rank;
      }
      
      public function getPanel(gs:GameSprite) : Panel
      {
         return new NameChangerPanel(gs,this.rankRequired_);
      }
   }
}
