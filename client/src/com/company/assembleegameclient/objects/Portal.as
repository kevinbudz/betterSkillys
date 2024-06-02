package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.ui.panels.Panel;
   import com.company.assembleegameclient.ui.panels.PortalPanel;
   import flash.display.IGraphicsData;
   
   public class Portal extends GameObject implements IInteractiveObject
   {
       
      
      public var nexusPortal_:Boolean;
      
      public var lockedPortal_:Boolean;
      
      public var active_:Boolean = true;
      
      public function Portal(objectXML:XML)
      {
         super(objectXML);
         isInteractive_ = true;
         this.nexusPortal_ = objectXML.hasOwnProperty("NexusPortal");
         this.lockedPortal_ = objectXML.hasOwnProperty("LockedPortal");
      }
      
      override public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         super.draw(graphicsData,camera,time);
         if(this.nexusPortal_)
         {
            drawName(graphicsData,camera);
         }
      }
      
      public function getPanel(gs:GameSprite) : Panel
      {
         return new PortalPanel(gs,this);
      }
   }
}
