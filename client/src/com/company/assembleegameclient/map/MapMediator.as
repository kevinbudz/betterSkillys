package com.company.assembleegameclient.map
{
   import kabam.rotmg.game.view.components.QueuedStatusText;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class MapMediator extends Mediator
   {
       
      
      [Inject]
      public var view:Map;
      
      [Inject]
      public var queueStatusText:QueueStatusTextSignal;
      
      public function MapMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.queueStatusText.add(this.onQueuedStatusText);
      }
      
      override public function destroy() : void
      {
         this.queueStatusText.remove(this.onQueuedStatusText);
      }
      
      private function onQueuedStatusText(text:String, color:uint) : void
      {
         this.view.player_ && this.queueText(text,color);
      }
      
      private function queueText(text:String, color:uint) : void
      {
         var status:QueuedStatusText = new QueuedStatusText(this.view.player_,text,color,2000,0);
         this.view.mapOverlay_.addQueuedText(status);
      }
   }
}
