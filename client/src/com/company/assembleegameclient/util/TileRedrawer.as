package com.company.assembleegameclient.util
{
   import com.company.assembleegameclient.map.GroundLibrary;
   import com.company.assembleegameclient.map.GroundProperties;
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.map.Square;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.util.AssetLibrary;
   import com.company.util.BitmapUtil;
   import com.company.util.ImageSet;
   import com.company.util.PointUtil;
import com.hurlant.util.Hex;

import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class TileRedrawer
   {

      private static const rect0:Rectangle = new Rectangle(0,0,4,4);

      private static const p0:Point = new Point(0,0);

      private static const rect1:Rectangle = new Rectangle(4,0,4,4);

      private static const p1:Point = new Point(4,0);

      private static const rect2:Rectangle = new Rectangle(0,4,4,4);

      private static const p2:Point = new Point(0,4);

      private static const rect3:Rectangle = new Rectangle(4,4,4,4);

      private static const p3:Point = new Point(4,4);

      private static const INNER:int = 0;

      private static const SIDE0:int = 1;

      private static const SIDE1:int = 2;

      private static const OUTER:int = 3;

      private static const INNERP1:int = 4;

      private static const INNERP2:int = 5;

      private static const mlist_:Vector.<Vector.<ImageSet>> = getMasks();

      private static var cache__:Vector.<Object> = new <Object>[null, new Object()];

      private static const RECT01:Rectangle = new Rectangle(0,0,8,4);

      private static const RECT13:Rectangle = new Rectangle(4,0,4,8);

      private static const RECT23:Rectangle = new Rectangle(0,4,8,4);

      private static const RECT02:Rectangle = new Rectangle(0,0,4,8);

      private static const RECT0:Rectangle = new Rectangle(0,0,4,4);

      private static const RECT1:Rectangle = new Rectangle(4,0,4,4);

      private static const RECT2:Rectangle = new Rectangle(0,4,4,4);

      private static const RECT3:Rectangle = new Rectangle(4,4,4,4);

      private static const POINT0:Point = new Point(0,0);

      private static const POINT1:Point = new Point(4,0);

      private static const POINT2:Point = new Point(0,4);

      private static const POINT3:Point = new Point(4,4);

      public function TileRedrawer()
      {
         super();
      }

      public static function redraw(square:Square, origBackground:Boolean) : BitmapData
      {
         var sig:Array;
         var newBitmapData:BitmapData = null;
         if(square.tileType_ == 253)
         {
            sig = getCompositeSig(square);
         }
         else if(square.props_.hasEdge_)
         {
            sig = getEdgeSig(square);
         }
         else
         {
            sig = getSig(square);
         }

         if(sig == null)
         {
            return null;
         }

         var cache:Object = cache__[1];
         if (cache.hasOwnProperty(sig)){
            return (cache[sig]);
         }

         if(square.tileType_ == 253)
         {
            newBitmapData = buildComposite(sig);
            cache[sig] = newBitmapData;
            return newBitmapData;
         }

         if(square.props_.hasEdge_)
         {
            newBitmapData = drawEdges(sig);
            cache[sig] = newBitmapData;
            return newBitmapData;
         }
         var redraw0:Boolean = false;
         var redraw1:Boolean = false;
         var redraw2:Boolean = false;
         var redraw3:Boolean = false;
         if(sig[1] != sig[4])
         {
            redraw0 = true;
            redraw1 = true;
         }
         if(sig[3] != sig[4])
         {
            redraw0 = true;
            redraw2 = true;
         }
         if(sig[5] != sig[4])
         {
            redraw1 = true;
            redraw3 = true;
         }
         if(sig[7] != sig[4])
         {
            redraw2 = true;
            redraw3 = true;
         }
         if(!redraw0 && sig[0] != sig[4])
         {
            redraw0 = true;
         }
         if(!redraw1 && sig[2] != sig[4])
         {
            redraw1 = true;
         }
         if(!redraw2 && sig[6] != sig[4])
         {
            redraw2 = true;
         }
         if(!redraw3 && sig[8] != sig[4])
         {
            redraw3 = true;
         }
         if(!redraw0 && !redraw1 && !redraw2 && !redraw3)
         {
            cache[sig] = null;
            return null;
         }
         var orig:BitmapData = GroundLibrary.getBitmapData(square.tileType_);
         if(origBackground)
         {
            newBitmapData = orig.clone();
         }
         else
         {
            newBitmapData = new BitmapData(orig.width,orig.height,true,0);
         }
         if(redraw0)
         {
            redrawRect(newBitmapData,rect0,p0,mlist_[0],sig[4],sig[3],sig[0],sig[1]);
         }
         if(redraw1)
         {
            redrawRect(newBitmapData,rect1,p1,mlist_[1],sig[4],sig[1],sig[2],sig[5]);
         }
         if(redraw2)
         {
            redrawRect(newBitmapData,rect2,p2,mlist_[2],sig[4],sig[7],sig[6],sig[3]);
         }
         if(redraw3)
         {
            redrawRect(newBitmapData,rect3,p3,mlist_[3],sig[4],sig[5],sig[8],sig[7]);
         }
         cache[sig] = newBitmapData;
         return newBitmapData;
      }

      private static function redrawRect(bitmapData:BitmapData, rect:Rectangle, p:Point, masks:Vector.<ImageSet>, base:uint, n0:uint, n1:uint, n2:uint) : void
      {
         var blend:BitmapData = null;
         var mask:BitmapData = null;
         if(base == n0 && base == n2)
         {
            mask = masks[OUTER].random();
            blend = GroundLibrary.getBitmapData(n1);
         }
         else if(base != n0 && base != n2)
         {
            if(n0 != n2)
            {
               bitmapData.copyPixels(GroundLibrary.getBitmapData(n0),rect,p,masks[INNERP1].random(),p0,true);
               bitmapData.copyPixels(GroundLibrary.getBitmapData(n2),rect,p,masks[INNERP2].random(),p0,true);
               return;
            }
            mask = masks[INNER].random();
            blend = GroundLibrary.getBitmapData(n0);
         }
         else if(base != n0)
         {
            mask = masks[SIDE0].random();
            blend = GroundLibrary.getBitmapData(n0);
         }
         else
         {
            mask = masks[SIDE1].random();
            blend = GroundLibrary.getBitmapData(n2);
         }
         bitmapData.copyPixels(blend,rect,p,mask,p0,true);
      }

      private static function getSig(square:Square) : Array
      {
         var x:int = 0;
         var n:Square = null;
         var sig:Array = new Array();
         var map:Map = square.map_;
         var baseType:uint = square.tileType_;
         for(var y:int = square.y_ - 1; y <= square.y_ + 1; y++)
         {
            for(x = square.x_ - 1; x <= square.x_ + 1; x++)
            {
               if(x < 0 || x >= map.width_ || y < 0 || y >= map.height_ || x == square.x_ && y == square.y_)
               {
                  sig.push(baseType);
               }
               else
               {
                  n = map.squares_[x + y * map.width_];
                  if(n == null || n.props_.blendPriority_ <= square.props_.blendPriority_)
                  {
                     sig.push(baseType);
                  }
                  else
                  {
                     sig.push(n.tileType_);
                  }
               }
            }
         }
         return sig;
      }

      private static function getMasks() : Vector.<Vector.<ImageSet>>
      {
         var mlist:Vector.<Vector.<ImageSet>> = new Vector.<Vector.<ImageSet>>();
         addMasks(mlist,AssetLibrary.getImageSet("inner_mask"),AssetLibrary.getImageSet("sides_mask"),AssetLibrary.getImageSet("outer_mask"),AssetLibrary.getImageSet("innerP1_mask"),AssetLibrary.getImageSet("innerP2_mask"));
         return mlist;
      }

      private static function addMasks(mlist:Vector.<Vector.<ImageSet>>, inner:ImageSet, side:ImageSet, outer:ImageSet, innerP1:ImageSet, innerP2:ImageSet) : void
      {
         var i:int = 0;
         for each(i in [-1,0,2,1])
         {
            mlist.push(new <ImageSet>[rotateImageSet(inner,i),rotateImageSet(side,i - 1),rotateImageSet(side,i),rotateImageSet(outer,i),rotateImageSet(innerP1,i),rotateImageSet(innerP2,i)]);
         }
      }

      private static function rotateImageSet(imageSet:ImageSet, clockwiseTurns:int) : ImageSet
      {
         var bitmapData:BitmapData = null;
         var newImageSet:ImageSet = new ImageSet();
         for each(bitmapData in imageSet.images_)
         {
            newImageSet.add(BitmapUtil.rotateBitmapData(bitmapData,clockwiseTurns));
         }
         return newImageSet;
      }

      private static function getCompositeSig(square:Square) : Array
      {
         var n0:Square = null;
         var n2:Square = null;
         var n6:Square = null;
         var n8:Square = null;
         var sig:Array = new Array();
         sig.length = 4;
         var map:Map = square.map_;
         var x:int = square.x_;
         var y:int = square.y_;
         var n1:Square = map.lookupSquare(x,y - 1);
         var n3:Square = map.lookupSquare(x - 1,y);
         var n5:Square = map.lookupSquare(x + 1,y);
         var n7:Square = map.lookupSquare(x,y + 1);
         var p1:int = n1 != null?int(n1.props_.compositePriority_):int(-1);
         var p3:int = n3 != null?int(n3.props_.compositePriority_):int(-1);
         var p5:int = n5 != null?int(n5.props_.compositePriority_):int(-1);
         var p7:int = n7 != null?int(n7.props_.compositePriority_):int(-1);
         if(p1 < 0 && p3 < 0)
         {
            n0 = map.lookupSquare(x - 1,y - 1);
            sig[0] = n0 == null || n0.props_.compositePriority_ < 0?255:n0.tileType_;
         }
         else if(p1 < p3)
         {
            sig[0] = n3.tileType_;
         }
         else
         {
            sig[0] = n1.tileType_;
         }
         if(p1 < 0 && p5 < 0)
         {
            n2 = map.lookupSquare(x + 1,y - 1);
            sig[1] = n2 == null || n2.props_.compositePriority_ < 0?255:n2.tileType_;
         }
         else if(p1 < p5)
         {
            sig[1] = n5.tileType_;
         }
         else
         {
            sig[1] = n1.tileType_;
         }
         if(p3 < 0 && p7 < 0)
         {
            n6 = map.lookupSquare(x - 1,y + 1);
            sig[2] = n6 == null || n6.props_.compositePriority_ < 0?255:n6.tileType_;
         }
         else if(p3 < p7)
         {
            sig[2] = n7.tileType_;
         }
         else
         {
            sig[2] = n3.tileType_;
         }
         if(p5 < 0 && p7 < 0)
         {
            n8 = map.lookupSquare(x + 1,y + 1);
            sig[3] = n8 == null || n8.props_.compositePriority_ < 0?255:n8.tileType_;
         }
         else if(p5 < p7)
         {
            sig[3] = n7.tileType_;
         }
         else
         {
            sig[3] = n5.tileType_;
         }
         return sig;
      }

      private static function buildComposite(sig:Array) : BitmapData
      {
         var neighbor:BitmapData = null;
         var newBitmapData:BitmapData = new BitmapData(8,8,false,0);
         if(sig[0] != 255)
         {
            neighbor = GroundLibrary.getBitmapData(sig[0]);
            newBitmapData.copyPixels(neighbor,RECT0,POINT0);
         }
         if(sig[1] != 255)
         {
            neighbor = GroundLibrary.getBitmapData(sig[1]);
            newBitmapData.copyPixels(neighbor,RECT1,POINT1);
         }
         if(sig[2] != 255)
         {
            neighbor = GroundLibrary.getBitmapData(sig[2]);
            newBitmapData.copyPixels(neighbor,RECT2,POINT2);
         }
         if(sig[3] != 255)
         {
            neighbor = GroundLibrary.getBitmapData(sig[3]);
            newBitmapData.copyPixels(neighbor,RECT3,POINT3);
         }
         return newBitmapData;
      }

      private static function getEdgeSig(square:Square) : Array
      {
         var x:int = 0;
         var n:Square = null;
         var b:Boolean = false;
         var sig:Array = new Array();
         var map:Map = square.map_;
         var hasEdge:Boolean = false;
         var sameTypeEdgeMode:Boolean = square.props_.sameTypeEdgeMode_;
         for(var y:int = square.y_ - 1; y <= square.y_ + 1; y++)
         {
            for(x = square.x_ - 1; x <= square.x_ + 1; x++)
            {
               n = map.lookupSquare(x,y);
               if(x == square.x_ && y == square.y_)
               {
                  sig.push(n.tileType_);
               }
               else
               {
                  if(sameTypeEdgeMode)
                  {
                     b = n == null || n.tileType_ == square.tileType_;
                  }
                  else
                  {
                     b = n == null || n.tileType_ != 0xFF;
                  }
                  sig.push(b);
                  hasEdge = hasEdge || !b;
               }
            }
         }
         return !!hasEdge?sig:null;
      }

      private static function drawEdges(sig:Array) : BitmapData
      {
         var orig:BitmapData = GroundLibrary.getBitmapData(sig[4]);
         var newBitmapData:BitmapData = orig.clone();
         var props:GroundProperties = GroundLibrary.propsLibrary_[sig[4]];
         var edges:Vector.<BitmapData> = props.getEdges();
         var innerCorners:Vector.<BitmapData> = props.getInnerCorners();
         for(var i:int = 1; i < 8; i = i + 2)
         {
            if(!sig[i])
            {
               newBitmapData.copyPixels(edges[i],edges[i].rect,PointUtil.ORIGIN,null,null,true);
            }
         }
         if(edges[0] != null)
         {
            if(sig[3] && sig[1] && !sig[0])
            {
               newBitmapData.copyPixels(edges[0],edges[0].rect,PointUtil.ORIGIN,null,null,true);
            }
            if(sig[1] && sig[5] && !sig[2])
            {
               newBitmapData.copyPixels(edges[2],edges[2].rect,PointUtil.ORIGIN,null,null,true);
            }
            if(sig[5] && sig[7] && !sig[8])
            {
               newBitmapData.copyPixels(edges[8],edges[8].rect,PointUtil.ORIGIN,null,null,true);
            }
            if(sig[3] && sig[7] && !sig[6])
            {
               newBitmapData.copyPixels(edges[6],edges[6].rect,PointUtil.ORIGIN,null,null,true);
            }
         }
         if(innerCorners != null)
         {
            if(!sig[3] && !sig[1])
            {
               newBitmapData.copyPixels(innerCorners[0],innerCorners[0].rect,PointUtil.ORIGIN,null,null,true);
            }
            if(!sig[1] && !sig[5])
            {
               newBitmapData.copyPixels(innerCorners[2],innerCorners[2].rect,PointUtil.ORIGIN,null,null,true);
            }
            if(!sig[5] && !sig[7])
            {
               newBitmapData.copyPixels(innerCorners[8],innerCorners[8].rect,PointUtil.ORIGIN,null,null,true);
            }
            if(!sig[3] && !sig[7])
            {
               newBitmapData.copyPixels(innerCorners[6],innerCorners[6].rect,PointUtil.ORIGIN,null,null,true);
            }
         }
         return newBitmapData;
      }
   }
}
