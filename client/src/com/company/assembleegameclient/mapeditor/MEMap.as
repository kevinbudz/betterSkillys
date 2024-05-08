package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.map.GroundLibrary;
   import com.company.assembleegameclient.map.RegionLibrary;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.util.AssetLibrary;
   import com.company.util.IntPoint;
   import com.company.util.KeyCodes;
   import com.company.util.PointUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   
   internal class MEMap extends Sprite
   {
      
      private static var transbackgroundEmbed_:Class = MEMap_transbackgroundEmbed_;
      
      private static var transbackgroundBD_:BitmapData = new transbackgroundEmbed_().bitmapData;
      
      public static const NUM_SQUARES:int = 512;
      
      public static const SQUARE_SIZE:int = 16;
      
      public static const SIZE:int = 512;
      
      public static const MIN_ZOOM:Number = 0.0625;
      
      public static const MAX_ZOOM:Number = 16;
       
      
      public var tileDict_:Dictionary;
      
      public var fullMap_:BigBitmapData;
      
      public var regionMap_:BitmapData;
      
      public var map_:BitmapData;
      
      public var overlay_:Shape;
      
      public var posT_:IntPoint;
      
      public var zoom_:Number = 1;
      
      private var mouseRectAnchorT_:IntPoint = null;
      
      private var mouseMoveAnchorT_:IntPoint = null;
      
      private var invisibleTexture_:BitmapData;
      
      private var replaceTexture_:BitmapData;
      
      function MEMap()
      {
         this.tileDict_ = new Dictionary();
         this.fullMap_ = new BigBitmapData(NUM_SQUARES * SQUARE_SIZE,NUM_SQUARES * SQUARE_SIZE,true,0);
         this.regionMap_ = new BitmapData(NUM_SQUARES,NUM_SQUARES,true,0);
         this.map_ = new BitmapData(SIZE,SIZE,true,0);
         this.overlay_ = new Shape();
         super();
         graphics.beginBitmapFill(transbackgroundBD_,null,true);
         graphics.drawRect(0,0,SIZE,SIZE);
         addChild(new Bitmap(this.map_));
         addChild(this.overlay_);
         this.posT_ = new IntPoint(NUM_SQUARES / 2 - this.sizeInTiles() / 2,NUM_SQUARES / 2 - this.sizeInTiles() / 2);
         this.invisibleTexture_ = AssetLibrary.getImageFromSet("invisible",0);
         this.replaceTexture_ = AssetLibrary.getImageFromSet("lofiObj3",255);
         this.draw();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function getType(x:int, y:int, layer:int) : int
      {
         var tile:METile = this.getTile(x,y);
         if(tile == null)
         {
            return -1;
         }
         return tile.types_[layer];
      }
      
      public function getTile(x:int, y:int) : METile
      {
         return this.tileDict_[x + y * NUM_SQUARES];
      }
      
      public function modifyTile(x:int, y:int, layer:int, type:int) : void
      {
         var tile:METile = this.getOrCreateTile(x,y);
         if(tile.types_[layer] == type)
         {
            return;
         }
         tile.types_[layer] = type;
         this.drawTile(x,y,tile);
      }
      
      public function getObjectName(x:int, y:int) : String
      {
         var tile:METile = this.getTile(x,y);
         if(tile == null)
         {
            return null;
         }
         return tile.objName_;
      }
      
      public function modifyObjectName(x:int, y:int, objName:String) : void
      {
         var tile:METile = this.getOrCreateTile(x,y);
         tile.objName_ = objName;
      }
      
      public function getAllTiles() : Vector.<IntPoint>
      {
         var indexStr:* = null;
         var index:int = 0;
         var tiles:Vector.<IntPoint> = new Vector.<IntPoint>();
         for(indexStr in this.tileDict_)
         {
            index = int(indexStr);
            tiles.push(new IntPoint(index % NUM_SQUARES,index / NUM_SQUARES));
         }
         return tiles;
      }
      
      public function setTile(x:int, y:int, tile:METile) : void
      {
         tile = tile.clone();
         this.tileDict_[x + y * NUM_SQUARES] = tile;
         this.drawTile(x,y,tile);
      }
      
      public function eraseTile(x:int, y:int) : void
      {
         this.clearTile(x,y);
         this.drawTile(x,y,null);
      }
      
      public function clear() : void
      {
         var indexStr:* = null;
         var index:int = 0;
         for(indexStr in this.tileDict_)
         {
            index = int(indexStr);
            this.eraseTile(index % NUM_SQUARES,index / NUM_SQUARES);
         }
      }
      
      public function getTileBounds() : Rectangle
      {
         var indexStr:* = null;
         var tile:METile = null;
         var index:int = 0;
         var x:int = 0;
         var y:int = 0;
         var minX:int = NUM_SQUARES;
         var minY:int = NUM_SQUARES;
         var maxX:int = 0;
         var maxY:int = 0;
         for(indexStr in this.tileDict_)
         {
            tile = this.tileDict_[indexStr];
            if(!tile.isEmpty())
            {
               index = int(indexStr);
               x = index % NUM_SQUARES;
               y = index / NUM_SQUARES;
               if(x < minX)
               {
                  minX = x;
               }
               if(y < minY)
               {
                  minY = y;
               }
               if(x + 1 > maxX)
               {
                  maxX = x + 1;
               }
               if(y + 1 > maxY)
               {
                  maxY = y + 1;
               }
            }
         }
         if(minX > maxX)
         {
            return null;
         }
         return new Rectangle(minX,minY,maxX - minX,maxY - minY);
      }
      
      private function sizeInTiles() : int
      {
         return SIZE / (SQUARE_SIZE * this.zoom_);
      }
      
      private function modifyZoom(mult:Number) : void
      {
         if(mult > 1 && this.zoom_ >= MAX_ZOOM || mult < 1 && this.zoom_ <= MIN_ZOOM)
         {
            return;
         }
         var tempMousePosT:IntPoint = this.mousePosT();
         this.zoom_ = this.zoom_ * mult;
         var newMousePosT:IntPoint = this.mousePosT();
         this.movePosT(tempMousePosT.x_ - newMousePosT.x_,tempMousePosT.y_ - newMousePosT.y_);
      }
      
      private function canMove() : Boolean
      {
         return this.mouseRectAnchorT_ == null && this.mouseMoveAnchorT_ == null;
      }
      
      private function increaseZoom() : void
      {
         if(!this.canMove())
         {
            return;
         }
         this.modifyZoom(2);
         this.draw();
      }
      
      private function decreaseZoom() : void
      {
         if(!this.canMove())
         {
            return;
         }
         this.modifyZoom(0.5);
         this.draw();
      }
      
      private function moveLeft() : void
      {
         if(!this.canMove())
         {
            return;
         }
         this.movePosT(-1,0);
         this.draw();
      }
      
      private function moveRight() : void
      {
         if(!this.canMove())
         {
            return;
         }
         this.movePosT(1,0);
         this.draw();
      }
      
      private function moveUp() : void
      {
         if(!this.canMove())
         {
            return;
         }
         this.movePosT(0,-1);
         this.draw();
      }
      
      private function moveDown() : void
      {
         if(!this.canMove())
         {
            return;
         }
         this.movePosT(0,1);
         this.draw();
      }
      
      private function movePosT(dX:int, dY:int) : void
      {
         var minT:int = 0;
         var maxT:int = NUM_SQUARES - this.sizeInTiles();
         this.posT_.x_ = Math.max(minT,Math.min(maxT,this.posT_.x_ + dX));
         this.posT_.y_ = Math.max(minT,Math.min(maxT,this.posT_.y_ + dY));
      }
      
      private function mousePosT() : IntPoint
      {
         var mX:int = Math.max(0,Math.min(SIZE - 1,mouseX));
         var mY:int = Math.max(0,Math.min(SIZE - 1,mouseY));
         return new IntPoint(this.posT_.x_ + mX / (SQUARE_SIZE * this.zoom_),this.posT_.y_ + mY / (SQUARE_SIZE * this.zoom_));
      }
      
      public function mouseRectT() : Rectangle
      {
         var mpT:IntPoint = this.mousePosT();
         if(this.mouseRectAnchorT_ == null)
         {
            return new Rectangle(mpT.x_,mpT.y_,1,1);
         }
         return new Rectangle(Math.min(mpT.x_,this.mouseRectAnchorT_.x_),Math.min(mpT.y_,this.mouseRectAnchorT_.y_),Math.abs(mpT.x_ - this.mouseRectAnchorT_.x_) + 1,Math.abs(mpT.y_ - this.mouseRectAnchorT_.y_) + 1);
      }
      
      private function posTToPosP(pT:IntPoint) : IntPoint
      {
         return new IntPoint((pT.x_ - this.posT_.x_) * SQUARE_SIZE * this.zoom_,(pT.y_ - this.posT_.y_) * SQUARE_SIZE * this.zoom_);
      }
      
      private function sizeTToSizeP(sizeT:int) : Number
      {
         return sizeT * this.zoom_ * SQUARE_SIZE;
      }
      
      private function mouseRectP() : Rectangle
      {
         var rect:Rectangle = this.mouseRectT();
         var xyP:IntPoint = this.posTToPosP(new IntPoint(rect.x,rect.y));
         rect.x = xyP.x_;
         rect.y = xyP.y_;
         rect.width = this.sizeTToSizeP(rect.width) - 1;
         rect.height = this.sizeTToSizeP(rect.height) - 1;
         return rect;
      }
      
      private function onAddedToStage(event:Event) : void
      {
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function onKeyDown(event:KeyboardEvent) : void
      {
         switch(event.keyCode)
         {
            case Keyboard.SHIFT:
               if(this.mouseRectAnchorT_ != null)
               {
                  break;
               }
               this.mouseRectAnchorT_ = this.mousePosT();
               break;
            case Keyboard.CONTROL:
               if(this.mouseMoveAnchorT_ != null)
               {
                  break;
               }
               this.mouseMoveAnchorT_ = this.mousePosT();
               break;
            case Keyboard.LEFT:
               this.moveLeft();
               break;
            case Keyboard.RIGHT:
               this.moveRight();
               break;
            case Keyboard.UP:
               this.moveUp();
               break;
            case Keyboard.DOWN:
               this.moveDown();
               break;
            case KeyCodes.MINUS:
               this.decreaseZoom();
               break;
            case KeyCodes.EQUAL:
               this.increaseZoom();
         }
         this.draw();
      }
      
      private function onKeyUp(event:KeyboardEvent) : void
      {
         switch(event.keyCode)
         {
            case Keyboard.SHIFT:
               this.mouseRectAnchorT_ = null;
               break;
            case Keyboard.CONTROL:
               this.mouseMoveAnchorT_ = null;
         }
         this.draw();
      }
      
      private function onMouseWheel(event:MouseEvent) : void
      {
         if(event.delta > 0)
         {
            this.increaseZoom();
         }
         else if(event.delta < 0)
         {
            this.decreaseZoom();
         }
      }
      
      private function onMouseDown(event:MouseEvent) : void
      {
         var yT:int = 0;
         var rectT:Rectangle = this.mouseRectT();
         var tilesT:Vector.<IntPoint> = new Vector.<IntPoint>();
         for(var xT:int = rectT.x; xT < rectT.right; xT++)
         {
            for(yT = rectT.y; yT < rectT.bottom; yT++)
            {
               tilesT.push(new IntPoint(xT,yT));
            }
         }
         dispatchEvent(new TilesEvent(tilesT));
      }
      
      private function onMouseMove(event:MouseEvent) : void
      {
         var mpT:IntPoint = null;
         if(!event.shiftKey)
         {
            this.mouseRectAnchorT_ = null;
         }
         else if(this.mouseRectAnchorT_ == null)
         {
            this.mouseRectAnchorT_ = this.mousePosT();
         }
         if(!event.ctrlKey)
         {
            this.mouseMoveAnchorT_ = null;
         }
         else if(this.mouseMoveAnchorT_ == null)
         {
            this.mouseMoveAnchorT_ = this.mousePosT();
         }
         if(event.buttonDown)
         {
            dispatchEvent(new TilesEvent(new <IntPoint>[this.mousePosT()]));
         }
         if(this.mouseMoveAnchorT_ != null)
         {
            mpT = this.mousePosT();
            this.movePosT(this.mouseMoveAnchorT_.x_ - mpT.x_,this.mouseMoveAnchorT_.y_ - mpT.y_);
            this.draw();
         }
         else
         {
            this.drawOverlay();
         }
      }
      
      private function getOrCreateTile(x:int, y:int) : METile
      {
         var index:int = x + y * NUM_SQUARES;
         var tile:METile = this.tileDict_[index];
         if(tile != null)
         {
            return tile;
         }
         tile = new METile();
         this.tileDict_[index] = tile;
         return tile;
      }
      
      private function clearTile(x:int, y:int) : void
      {
         delete this.tileDict_[x + y * NUM_SQUARES];
      }
      
      private function drawTile(x:int, y:int, tile:METile) : void
      {
         var goundBD:BitmapData = null;
         var objBD:BitmapData = null;
         var regionColor:uint = 0;
         var rect:Rectangle = new Rectangle(x * SQUARE_SIZE,y * SQUARE_SIZE,SQUARE_SIZE,SQUARE_SIZE);
         this.fullMap_.erase(rect);
         this.regionMap_.setPixel32(x,y,0);
         if(tile == null)
         {
            return;
         }
         if(tile.types_[Layer.GROUND] != -1)
         {
            goundBD = GroundLibrary.getBitmapData(tile.types_[Layer.GROUND]);
            this.fullMap_.copyTo(goundBD,goundBD.rect,rect);
         }
         if(tile.types_[Layer.OBJECT] != -1)
         {
            objBD = ObjectLibrary.getTextureFromType(tile.types_[Layer.OBJECT]);
            if(objBD == null || objBD == this.invisibleTexture_)
            {
               this.fullMap_.copyTo(this.replaceTexture_,this.replaceTexture_.rect,rect);
            }
            else
            {
               this.fullMap_.copyTo(objBD,objBD.rect,rect);
            }
         }
         if(tile.types_[Layer.REGION] != -1)
         {
            regionColor = RegionLibrary.getColor(tile.types_[Layer.REGION]);
            this.regionMap_.setPixel32(x,y,1593835520 | regionColor);
         }
      }
      
      private function drawOverlay() : void
      {
         var mrP:Rectangle = this.mouseRectP();
         var g:Graphics = this.overlay_.graphics;
         g.clear();
         g.lineStyle(1,16777215);
         g.beginFill(16777215,0.1);
         g.drawRect(mrP.x,mrP.y,mrP.width,mrP.height);
         g.endFill();
         g.lineStyle();
      }
      
      public function draw() : void
      {
         var m:Matrix = null;
         var ss:int = 0;
         var temp:BitmapData = null;
         var s:int = SIZE / this.zoom_;
         this.map_.fillRect(this.map_.rect,0);
         this.fullMap_.copyFrom(new Rectangle(this.posT_.x_ * SQUARE_SIZE,this.posT_.y_ * SQUARE_SIZE,s,s),this.map_,this.map_.rect);
         m = new Matrix();
         m.identity();
         ss = SQUARE_SIZE * this.zoom_;
         if(this.zoom_ > 2)
         {
            temp = new BitmapData(SIZE / ss,SIZE / ss);
            temp.copyPixels(this.regionMap_,new Rectangle(this.posT_.x_,this.posT_.y_,s,s),PointUtil.ORIGIN);
            m.scale(ss,ss);
            this.map_.draw(temp,m);
         }
         else
         {
            m.translate(-this.posT_.x_,-this.posT_.y_);
            m.scale(ss,ss);
            this.map_.draw(this.regionMap_,m,null,null,this.map_.rect);
         }
         this.drawOverlay();
      }
   }
}
