package com.company.util
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   
   public class ConversionUtil
   {
       
      
      public function ConversionUtil(se:StaticEnforcer)
      {
         super();
      }
      
      public static function toIntArray(obj:Object, delim:String = ",") : Array
      {
         if(obj == null)
         {
            return new Array();
         }
         var a:Array = obj.toString().split(delim).map(mapParseInt);
         return a;
      }
      
      public static function toNumberArray(obj:Object, delim:String = ",") : Array
      {
         if(obj == null)
         {
            return new Array();
         }
         var a:Array = obj.toString().split(delim).map(mapParseFloat);
         return a;
      }
      
      public static function toIntVector(obj:Object, delim:String = ",") : Vector.<int>
      {
         if(obj == null)
         {
            return new Vector.<int>();
         }
         var v:Vector.<int> = Vector.<int>(obj.toString().split(delim).map(mapParseInt));
         return v;
      }

      public static function ArrayToObject(obj:Object, delim:String = ",") : Vector.<Object>
      {
         if(obj == null) return new Vector.<Object>();
         var a:Vector.<Object> = Vector.<Object>(obj.toString().split(delim));
         return a;
      }
      
      public static function toNumberVector(obj:Object, delim:String = ",") : Vector.<Number>
      {
         if(obj == null)
         {
            return new Vector.<Number>();
         }
         var v:Vector.<Number> = Vector.<Number>(obj.toString().split(delim).map(mapParseFloat));
         return v;
      }
      
      public static function toStringArray(obj:Object, delim:String = ",") : Array
      {
         if(obj == null)
         {
            return new Array();
         }
         var a:Array = obj.toString().split(delim);
         return a;
      }
      
      public static function toRectangle(obj:Object, delim:String = ",") : Rectangle
      {
         if(obj == null)
         {
            return new Rectangle();
         }
         var a:Array = obj.toString().split(delim).map(mapParseFloat);
         return a == null || a.length < 4?new Rectangle():new Rectangle(a[0],a[1],a[2],a[3]);
      }
      
      public static function toPoint(obj:Object, delim:String = ",") : Point
      {
         if(obj == null)
         {
            return new Point();
         }
         var a:Array = obj.toString().split(delim).map(ConversionUtil.mapParseFloat);
         return a == null || a.length < 2?new Point():new Point(a[0],a[1]);
      }
      
      public static function toPointPair(obj:Object, delim:String = ",") : Array
      {
         var ret:Array = new Array();
         if(obj == null)
         {
            ret.push(new Point());
            ret.push(new Point());
            return ret;
         }
         var a:Array = obj.toString().split(delim).map(ConversionUtil.mapParseFloat);
         if(a == null || a.length < 4)
         {
            ret.push(new Point());
            ret.push(new Point());
            return ret;
         }
         ret.push(new Point(a[0],a[1]));
         ret.push(new Point(a[2],a[3]));
         return ret;
      }
      
      public static function toVector3D(obj:Object, delim:String = ",") : Vector3D
      {
         if(obj == null)
         {
            return new Vector3D();
         }
         var a:Array = obj.toString().split(delim).map(ConversionUtil.mapParseFloat);
         return a == null || a.length < 3?new Vector3D():new Vector3D(a[0],a[1],a[2]);
      }
      
      public static function toCharCodesVector(obj:Object, delim:String = ",") : Vector.<int>
      {
         if(obj == null)
         {
            return new Vector.<int>();
         }
         var v:Vector.<int> = Vector.<int>(obj.toString().split(delim).map(mapParseCharCode));
         return v;
      }
      
      public static function addToNumberVector(obj:Object, vec:Vector.<Number>, delim:String = ",") : void
      {
         var f:Number = NaN;
         if(obj == null)
         {
            return;
         }
         var a:Array = obj.toString().split(delim).map(mapParseFloat);
         for each(f in a)
         {
            vec.push(f);
         }
      }
      
      public static function addToIntVector(obj:Object, vec:Vector.<int>, delim:String = ",") : void
      {
         var i:int = 0;
         if(obj == null)
         {
            return;
         }
         var a:Array = obj.toString().split(delim).map(mapParseFloat);
         for each(i in a)
         {
            vec.push(i);
         }
      }
      
      public static function mapParseFloat(str:*, ... args) : Number
      {
         return parseFloat(str);
      }
      
      public static function mapParseInt(str:*, ... args) : Number
      {
         return parseInt(str);
      }
      
      public static function mapParseCharCode(str:*, ... args) : Number
      {
         return String(str).charCodeAt();
      }
      
      public static function vector3DToShaderParameter(v:Vector3D) : Array
      {
         return [v.x,v.y,v.z];
      }
   }
}

class StaticEnforcer
{
    
   
   function StaticEnforcer()
   {
      super();
   }
}
