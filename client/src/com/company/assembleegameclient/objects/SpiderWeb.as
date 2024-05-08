package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Square;
   import flash.display.IGraphicsData;
   
   public class SpiderWeb extends GameObject
   {
       
      
      private var wallFound_:Boolean = false;
      
      public function SpiderWeb(objectXML:XML)
      {
         super(objectXML);
      }
      
      override public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         if(!this.wallFound_)
         {
            this.wallFound_ = this.findWall();
         }
         if(this.wallFound_)
         {
            super.draw(graphicsData,camera,time);
         }
      }
      
      private function findWall() : Boolean
      {
         var sq:Square = null;
         sq = map_.lookupSquare(x_ - 1,y_);
         if(sq != null && sq.obj_ is Wall)
         {
            return true;
         }
         sq = map_.lookupSquare(x_,y_ - 1);
         if(sq != null && sq.obj_ is Wall)
         {
            obj3D_.setPosition(x_,y_,0,90);
            return true;
         }
         sq = map_.lookupSquare(x_ + 1,y_);
         if(sq != null && sq.obj_ is Wall)
         {
            obj3D_.setPosition(x_,y_,0,180);
            return true;
         }
         sq = map_.lookupSquare(x_,y_ + 1);
         if(sq != null && sq.obj_ is Wall)
         {
            obj3D_.setPosition(x_,y_,0,270);
            return true;
         }
         return false;
      }
   }
}
