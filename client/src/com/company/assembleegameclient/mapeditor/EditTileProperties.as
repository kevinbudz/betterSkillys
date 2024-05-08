package com.company.assembleegameclient.mapeditor
{
   import com.company.util.IntPoint;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class EditTileProperties extends Sprite
   {
       
      
      public var tiles_:Vector.<IntPoint>;
      
      private var darkBox_:Shape;
      
      private var frame_:EditTilePropertiesFrame;
      
      public function EditTileProperties(tiles:Vector.<IntPoint>, oldName:String)
      {
         super();
         this.tiles_ = tiles;
         this.darkBox_ = new Shape();
         var g:Graphics = this.darkBox_.graphics;
         g.clear();
         g.beginFill(0,0.8);
         g.drawRect(0,0,800,600);
         g.endFill();
         addChild(this.darkBox_);
         this.frame_ = new EditTilePropertiesFrame(oldName);
         this.frame_.addEventListener(Event.COMPLETE,this.onComplete);
         this.frame_.addEventListener(Event.CANCEL,this.onCancel);
         addChild(this.frame_);
      }
      
      public function getObjectName() : String
      {
         if(this.frame_.objectName_.text() == "")
         {
            return null;
         }
         return this.frame_.objectName_.text();
      }
      
      public function onComplete(event:Event) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         parent.removeChild(this);
      }
      
      public function onCancel(event:Event) : void
      {
         parent.removeChild(this);
      }
   }
}
