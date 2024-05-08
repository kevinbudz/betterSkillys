package com.company.assembleegameclient.map.mapoverlay
{
   import com.company.assembleegameclient.map.Camera;
   import flash.display.Sprite;
   import kabam.rotmg.game.view.components.QueuedStatusText;
   import kabam.rotmg.game.view.components.QueuedStatusTextList;
   
   public class MapOverlay extends Sprite
   {
       
      
      private const speechBalloons:Object = {};
      
      private const queuedText:Object = {};
      
      public function MapOverlay()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function addSpeechBalloon(sb:SpeechBalloon) : void
      {
         var id:int = sb.go_.objectId_;
         var currentBalloon:SpeechBalloon = this.speechBalloons[id];
         if(currentBalloon && contains(currentBalloon))
         {
            removeChild(currentBalloon);
         }
         this.speechBalloons[id] = sb;
         addChild(sb);
      }
      
      public function addStatusText(text:CharacterStatusText) : void
      {
         addChild(text);
      }
      
      public function addQueuedText(text:QueuedStatusText) : void
      {
         var id:int = text.go_.objectId_;
         var list:QueuedStatusTextList = this.queuedText[id] = this.queuedText[id] || this.makeQueuedStatusTextList();
         list.append(text);
      }
      
      private function makeQueuedStatusTextList() : QueuedStatusTextList
      {
         var list:QueuedStatusTextList = new QueuedStatusTextList();
         list.target = this;
         return list;
      }
      
      public function draw(camera:Camera, time:int) : void
      {
         var elem:IMapOverlayElement = null;
         var i:int = 0;
         while(i < numChildren)
         {
            elem = getChildAt(i) as IMapOverlayElement;
            if(!elem || elem.draw(camera, time)) {
               i++;
            }
            else {
               elem.dispose();
            }
         }
      }
   }
}
