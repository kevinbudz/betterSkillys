package kabam.rotmg.ui.view.components
{
   import com.company.assembleegameclient.background.Background;
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.map.serialization.MapDecoder;
   import com.company.util.IntPoint;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class MapBackground extends Sprite
   {
      
      private static const BORDER:int = 10;
      
      private static const RECTANGLE:Rectangle = new Rectangle(-400,-300,800,600);
      
      private static const ANGLE:Number = 7 * Math.PI / 4;
      
      private static const TO_MILLISECONDS:Number = 1 / 1000;
      
      private static const EMBEDDED_BACKGROUNDMAP:Class = MapBackground_EMBEDDED_BACKGROUNDMAP;
      
      private static var backgroundMap:Map;
      
      private static var mapSize:IntPoint;
      
      private static var xVal:Number;
      
      private static var yVal:Number;
      
      private static var camera:Camera;
       
      
      private var lastUpdate:int;
      
      private var time:Number;
      
      public function MapBackground()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage(event:Event) : void
      {
         addChildAt(backgroundMap = backgroundMap || this.makeMap(),0);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.lastUpdate = getTimer();
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(event:Event) : void
      {
         this.time = getTimer();
         xVal = xVal + (this.time - this.lastUpdate) * TO_MILLISECONDS;
         if(xVal > mapSize.x_ + BORDER)
         {
            xVal = xVal - mapSize.x_;
         }
         camera.configure(xVal,yVal,12,ANGLE,RECTANGLE,false);
         backgroundMap.draw(camera,this.time);
         this.lastUpdate = this.time;
      }
      
      private function makeMap() : Map
      {
         var data:ByteArray = new EMBEDDED_BACKGROUNDMAP();
         var encodedMap:String = data.readUTFBytes(data.length);
         mapSize = MapDecoder.getSize(encodedMap);
         xVal = BORDER;
         yVal = BORDER + int((mapSize.y_ - 2 * BORDER) * Math.random());
         camera = new Camera();
         var map:Map = new Map(null);
         map.setProps(mapSize.x_ + 2 * BORDER,mapSize.y_,"Background Map",Background.NO_BACKGROUND,false,false);
         map.initialize();
         MapDecoder.writeMap(encodedMap,map,0,0);
         MapDecoder.writeMap(encodedMap,map,mapSize.x_,0);
         return map;
      }
   }
}
