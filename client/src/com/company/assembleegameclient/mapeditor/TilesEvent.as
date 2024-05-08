package com.company.assembleegameclient.mapeditor
{
   import com.company.util.IntPoint;
   import flash.events.Event;
   
   internal class TilesEvent extends Event
   {
      
      public static const TILES_EVENT:String = "TILES_EVENT";
       
      
      public var tiles_:Vector.<IntPoint>;
      
      function TilesEvent(tiles:Vector.<IntPoint>)
      {
         super(TILES_EVENT);
         this.tiles_ = tiles;
      }
   }
}
