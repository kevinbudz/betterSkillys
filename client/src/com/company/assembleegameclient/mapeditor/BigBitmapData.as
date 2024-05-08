package com.company.assembleegameclient.mapeditor
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class BigBitmapData
   {
      
      private static const CHUNK_SIZE:int = 256;
       
      
      public var width_:int;
      
      public var height_:int;
      
      public var fillColor_:uint;
      
      private var maxChunkX_:int;
      
      private var maxChunkY_:int;
      
      private var chunks_:Vector.<BitmapData>;
      
      public function BigBitmapData(width:int, height:int, transparent:Boolean, fillColor:uint)
      {
         var cY:int = 0;
         var sizeX:int = 0;
         var sizeY:int = 0;
         super();
         this.width_ = width;
         this.height_ = height;
         this.fillColor_ = fillColor;
         this.maxChunkX_ = Math.ceil(this.width_ / CHUNK_SIZE);
         this.maxChunkY_ = Math.ceil(this.height_ / CHUNK_SIZE);
         this.chunks_ = new Vector.<BitmapData>(this.maxChunkX_ * this.maxChunkY_,true);
         for(var cX:int = 0; cX < this.maxChunkX_; cX++)
         {
            for(cY = 0; cY < this.maxChunkY_; cY++)
            {
               sizeX = Math.min(CHUNK_SIZE,this.width_ - cX * CHUNK_SIZE);
               sizeY = Math.min(CHUNK_SIZE,this.height_ - cY * CHUNK_SIZE);
               this.chunks_[cX + cY * this.maxChunkX_] = new BitmapData(sizeX,sizeY,transparent,this.fillColor_);
            }
         }
      }
      
      public function copyTo(source:BitmapData, sourceRect:Rectangle, destRect:Rectangle) : void
      {
         var cY:int = 0;
         var chunk:BitmapData = null;
         var clipRect:Rectangle = null;
         var scaleX:Number = destRect.width / sourceRect.width;
         var scaleY:Number = destRect.height / sourceRect.height;
         var startChunkX:int = int(destRect.x / CHUNK_SIZE);
         var startChunkY:int = int(destRect.y / CHUNK_SIZE);
         var endChunkX:int = Math.ceil(destRect.right / CHUNK_SIZE);
         var endChunkY:int = Math.ceil(destRect.bottom / CHUNK_SIZE);
         var m:Matrix = new Matrix();
         for(var cX:int = startChunkX; cX < endChunkX; cX++)
         {
            for(cY = startChunkY; cY < endChunkY; cY++)
            {
               chunk = this.chunks_[cX + cY * this.maxChunkX_];
               m.identity();
               m.scale(scaleX,scaleY);
               m.translate(destRect.x - cX * CHUNK_SIZE - sourceRect.x * scaleX,destRect.y - cY * CHUNK_SIZE - sourceRect.x * scaleY);
               clipRect = new Rectangle(destRect.x - cX * CHUNK_SIZE,destRect.y - cY * CHUNK_SIZE,destRect.width,destRect.height);
               chunk.draw(source,m,null,null,clipRect,false);
            }
         }
      }
      
      public function copyFrom(sourceRect:Rectangle, dest:BitmapData, destRect:Rectangle) : void
      {
         var cY:int = 0;
         var chunk:BitmapData = null;
         var scaleX:Number = destRect.width / sourceRect.width;
         var scaleY:Number = destRect.height / sourceRect.height;
         var startChunkX:int = Math.max(0,int(sourceRect.x / CHUNK_SIZE));
         var startChunkY:int = Math.max(0,int(sourceRect.y / CHUNK_SIZE));
         var endChunkX:int = Math.min(this.maxChunkX_ - 1,int(sourceRect.right / CHUNK_SIZE));
         var endChunkY:int = Math.min(this.maxChunkY_ - 1,int(sourceRect.bottom / CHUNK_SIZE));
         var chunkRect:Rectangle = new Rectangle();
         var m:Matrix = new Matrix();
         for(var cX:int = startChunkX; cX <= endChunkX; cX++)
         {
            for(cY = startChunkY; cY <= endChunkY; cY++)
            {
               chunk = this.chunks_[cX + cY * this.maxChunkX_];
               m.identity();
               m.translate(destRect.x / scaleX - sourceRect.x + cX * CHUNK_SIZE,destRect.y / scaleY - sourceRect.y + cY * CHUNK_SIZE);
               m.scale(scaleX,scaleY);
               dest.draw(chunk,m,null,null,destRect,false);
            }
         }
      }
      
      public function erase(rect:Rectangle) : void
      {
         var cY:int = 0;
         var chunk:BitmapData = null;
         var startChunkX:int = int(rect.x / CHUNK_SIZE);
         var startChunkY:int = int(rect.y / CHUNK_SIZE);
         var endChunkX:int = Math.ceil(rect.right / CHUNK_SIZE);
         var endChunkY:int = Math.ceil(rect.bottom / CHUNK_SIZE);
         var chunkRect:Rectangle = new Rectangle();
         for(var cX:int = startChunkX; cX < endChunkX; cX++)
         {
            for(cY = startChunkY; cY < endChunkY; cY++)
            {
               chunk = this.chunks_[cX + cY * this.maxChunkX_];
               chunkRect.x = rect.x - cX * CHUNK_SIZE;
               chunkRect.y = rect.y - cY * CHUNK_SIZE;
               chunkRect.right = rect.right - cX * CHUNK_SIZE;
               chunkRect.bottom = rect.bottom - cY * CHUNK_SIZE;
               chunk.fillRect(chunkRect,this.fillColor_);
            }
         }
      }
      
      public function getDebugSprite() : Sprite
      {
         var cY:int = 0;
         var chunk:BitmapData = null;
         var chunkBitmap:Bitmap = null;
         var debugSprite:Sprite = new Sprite();
         for(var cX:int = 0; cX < this.maxChunkX_; cX++)
         {
            for(cY = 0; cY < this.maxChunkY_; cY++)
            {
               chunk = this.chunks_[cX + cY * this.maxChunkX_];
               chunkBitmap = new Bitmap(chunk);
               chunkBitmap.x = cX * CHUNK_SIZE;
               chunkBitmap.y = cY * CHUNK_SIZE;
               debugSprite.addChild(chunkBitmap);
            }
         }
         return debugSprite;
      }
   }
}
