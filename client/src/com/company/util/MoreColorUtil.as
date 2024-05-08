package com.company.util
{
   import flash.geom.ColorTransform;
   
   public class MoreColorUtil
   {
      
      public static const greyscaleFilterMatrix:Array = [0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0];
      
      public static const redFilterMatrix:Array = [0.3,0.59,0.11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0];
      
      public static const identity:ColorTransform = new ColorTransform();
      
      public static const invisible:ColorTransform = new ColorTransform(1,1,1,0,0,0,0,0);
      
      public static const transparentCT:ColorTransform = new ColorTransform(1,1,1,0.3,0,0,0,0);
      
      public static const slightlyTransparentCT:ColorTransform = new ColorTransform(1,1,1,0.7,0,0,0,0);
      
      public static const greenCT:ColorTransform = new ColorTransform(0.6,1,0.6,1,0,0,0,0);
      
      public static const lightGreenCT:ColorTransform = new ColorTransform(0.8,1,0.8,1,0,0,0,0);
      
      public static const veryGreenCT:ColorTransform = new ColorTransform(0.2,1,0.2,1,0,100,0,0);
      
      public static const transparentGreenCT:ColorTransform = new ColorTransform(0.5,1,0.5,0.3,0,0,0,0);
      
      public static const transparentVeryGreenCT:ColorTransform = new ColorTransform(0.3,1,0.3,0.5,0,0,0,0);
      
      public static const redCT:ColorTransform = new ColorTransform(1,0.5,0.5,1,0,0,0,0);
      
      public static const lightRedCT:ColorTransform = new ColorTransform(1,0.7,0.7,1,0,0,0,0);
      
      public static const veryRedCT:ColorTransform = new ColorTransform(1,0.2,0.2,1,100,0,0,0);
      
      public static const transparentRedCT:ColorTransform = new ColorTransform(1,0.5,0.5,0.3,0,0,0,0);
      
      public static const transparentVeryRedCT:ColorTransform = new ColorTransform(1,0.3,0.3,0.5,0,0,0,0);
      
      public static const blueCT:ColorTransform = new ColorTransform(0.5,0.5,1,1,0,0,0,0);
      
      public static const lightBlueCT:ColorTransform = new ColorTransform(0.7,0.7,1,1,0,0,100,0);
      
      public static const veryBlueCT:ColorTransform = new ColorTransform(0.3,0.3,1,1,0,0,100,0);
      
      public static const transparentBlueCT:ColorTransform = new ColorTransform(0.5,0.5,1,0.3,0,0,0,0);
      
      public static const transparentVeryBlueCT:ColorTransform = new ColorTransform(0.3,0.3,1,0.5,0,0,0,0);
      
      public static const purpleCT:ColorTransform = new ColorTransform(1,0.5,1,1,0,0,0,0);
      
      public static const veryPurpleCT:ColorTransform = new ColorTransform(1,0.2,1,1,100,0,100,0);
      
      public static const darkCT:ColorTransform = new ColorTransform(0.6,0.6,0.6,1,0,0,0,0);
      
      public static const veryDarkCT:ColorTransform = new ColorTransform(0.4,0.4,0.4,1,0,0,0,0);
      
      public static const makeWhiteCT:ColorTransform = new ColorTransform(1,1,1,1,255,255,255,0);
       
      
      public function MoreColorUtil(se:StaticEnforcer)
      {
         super();
      }
      
      public static function hsvToRgb(h:Number, s:Number, v:Number) : int
      {
         var r:Number = NaN;
         var g:Number = NaN;
         var b:Number = NaN;
         var hi:int = int(h / 60) % 6;
         var f:Number = h / 60 - Math.floor(h / 60);
         var p:Number = v * (1 - s);
         var q:Number = v * (1 - f * s);
         var t:Number = v * (1 - (1 - f) * s);
         switch(hi)
         {
            case 0:
               r = v;
               g = t;
               b = p;
               break;
            case 1:
               r = q;
               g = v;
               b = p;
               break;
            case 2:
               r = p;
               g = v;
               b = t;
               break;
            case 3:
               r = p;
               g = q;
               b = v;
               break;
            case 4:
               r = t;
               g = p;
               b = v;
               break;
            case 5:
               r = v;
               g = p;
               b = q;
         }
         return int(Math.min(255,Math.floor(r * 255))) << 16 | int(Math.min(255,Math.floor(g * 255))) << 8 | int(Math.min(255,Math.floor(b * 255)));
      }
      
      public static function randomColor() : uint
      {
         return uint(16777215 * Math.random());
      }
      
      public static function randomColor32() : uint
      {
         return uint(16777215 * Math.random()) | 4278190080;
      }
      
      public static function transformColor(ct:ColorTransform, color:uint) : uint
      {
         var r:int = ((color & 16711680) >> 16) * ct.redMultiplier + ct.redOffset;
         r = r < 0?int(0):r > 255?int(255):int(r);
         var g:int = ((color & 65280) >> 8) * ct.greenMultiplier + ct.greenOffset;
         g = g < 0?int(0):g > 255?int(255):int(g);
         var b:int = (color & 255) * ct.blueMultiplier + ct.blueOffset;
         b = b < 0?int(0):b > 255?int(255):int(b);
         return r << 16 | g << 8 | b;
      }
      
      public static function copyColorTransform(ct:ColorTransform) : ColorTransform
      {
         return new ColorTransform(ct.redMultiplier,ct.greenMultiplier,ct.blueMultiplier,ct.alphaMultiplier,ct.redOffset,ct.greenOffset,ct.blueOffset,ct.alphaOffset);
      }
      
      public static function lerpColorTransform(startCT:ColorTransform, endCT:ColorTransform, val:Number) : ColorTransform
      {
         if(startCT == null)
         {
            startCT = identity;
         }
         if(endCT == null)
         {
            endCT = identity;
         }
         var ival:Number = 1 - val;
         var ct:ColorTransform = new ColorTransform(startCT.redMultiplier * ival + endCT.redMultiplier * val,startCT.greenMultiplier * ival + endCT.greenMultiplier * val,startCT.blueMultiplier * ival + endCT.blueMultiplier * val,startCT.alphaMultiplier * ival + endCT.alphaMultiplier * val,startCT.redOffset * ival + endCT.redOffset * val,startCT.greenOffset * ival + endCT.greenOffset * val,startCT.blueOffset * ival + endCT.blueOffset * val,startCT.alphaOffset * ival + endCT.alphaOffset * val);
         return ct;
      }
      
      public static function lerpColor(fromColor:uint, toColor:uint, progress:Number) : uint
      {
         var q:Number = 1 - progress;
         var fromA:uint = fromColor >> 24 & 255;
         var fromR:uint = fromColor >> 16 & 255;
         var fromG:uint = fromColor >> 8 & 255;
         var fromB:uint = fromColor & 255;
         var toA:uint = toColor >> 24 & 255;
         var toR:uint = toColor >> 16 & 255;
         var toG:uint = toColor >> 8 & 255;
         var toB:uint = toColor & 255;
         var resultA:uint = fromA * q + toA * progress;
         var resultR:uint = fromR * q + toR * progress;
         var resultG:uint = fromG * q + toG * progress;
         var resultB:uint = fromB * q + toB * progress;
         var resultColor:uint = resultA << 24 | resultR << 16 | resultG << 8 | resultB;
         return resultColor;
      }
      
      public static function transformAlpha(ct:ColorTransform, alpha:Number) : Number
      {
         var da:uint = alpha * 255;
         var a:uint = da * ct.alphaMultiplier + ct.alphaOffset;
         a = a < 0?uint(0):a > 255?uint(255):uint(a);
         return a / 255;
      }
      
      public static function multiplyColor(color:uint, multiply:Number) : uint
      {
         var r:int = ((color & 16711680) >> 16) * multiply;
         r = r < 0?int(0):r > 255?int(255):int(r);
         var g:int = ((color & 65280) >> 8) * multiply;
         g = g < 0?int(0):g > 255?int(255):int(g);
         var b:int = (color & 255) * multiply;
         b = b < 0?int(0):b > 255?int(255):int(b);
         return r << 16 | g << 8 | b;
      }
      
      public static function adjustBrightness(color:uint, num:Number) : uint
      {
         var a:uint = color & 4278190080;
         var r:int = ((color & 16711680) >> 16) + num * 255;
         r = r < 0?int(0):r > 255?int(255):int(r);
         var g:int = ((color & 65280) >> 8) + num * 255;
         g = g < 0?int(0):g > 255?int(255):int(g);
         var b:int = (color & 255) + num * 255;
         b = b < 0?int(0):b > 255?int(255):int(b);
         return a | r << 16 | g << 8 | b;
      }
      
      public static function colorToShaderParameter(color:uint) : Array
      {
         var alpha:Number = (color >> 24 & 255) / 256;
         return [alpha * ((color >> 16 & 255) / 256),alpha * ((color >> 8 & 255) / 256),alpha * ((color & 255) / 256),alpha];
      }
      
      public static function rgbToGreyscale(color:uint) : uint
      {
         var val:uint = ((color & 16711680) >> 16) * 0.3 + ((color & 65280) >> 8) * 0.59 + (color & 255) * 0.11;
         return (color && 4278190080) | val << 16 | val << 8 | val;
      }
      
      public static function singleColorFilterMatrix(color:uint) : Array
      {
         return [0,0,0,0,(color & 16711680) >> 16,0,0,0,0,(color & 65280) >> 8,0,0,0,0,color & 255,0,0,0,1,0];
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
