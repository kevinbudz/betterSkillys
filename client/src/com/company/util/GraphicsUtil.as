package com.company.util
{
   import flash.display.CapsStyle;
   import flash.display.GraphicsEndFill;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsPathCommand;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.geom.Matrix;
   
   public class GraphicsUtil
   {
      
      public static const END_FILL:GraphicsEndFill = new GraphicsEndFill();
      
      public static const QUAD_COMMANDS:Vector.<int> = new <int>[GraphicsPathCommand.MOVE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO];
      
      public static const DEBUG_STROKE:GraphicsStroke = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,new GraphicsSolidFill(16711680));
      
      public static const END_STROKE:GraphicsStroke = new GraphicsStroke();
      
      private static const TWO_PI:Number = 2 * Math.PI;
      
      public static const ALL_CUTS:Array = [true,true,true,true];
       
      
      public function GraphicsUtil()
      {
         super();
      }
      
      public static function clearPath(graphicsPath:GraphicsPath) : void
      {
         graphicsPath.commands.length = 0;
         graphicsPath.data.length = 0;
      }
      
      public static function getRectPath(x:int, y:int, width:int, height:int) : GraphicsPath
      {
         return new GraphicsPath(QUAD_COMMANDS,new <Number>[x,y,x + width,y,x + width,y + height,x,y + height]);
      }
      
      public static function getGradientMatrix(width:Number, height:Number, rotation:Number = 0.0, tx:Number = 0.0, ty:Number = 0.0) : Matrix
      {
         var m:Matrix = new Matrix();
         m.createGradientBox(width,height,rotation,tx,ty);
         return m;
      }
      
      public static function drawRect(x:int, y:int, width:int, height:int, path:GraphicsPath) : void
      {
         path.moveTo(x,y);
         path.lineTo(x + width,y);
         path.lineTo(x + width,y + height);
         path.lineTo(x,y + height);
      }
      
      public static function drawCircle(centerX:Number, centerY:Number, radius:Number, path:GraphicsPath, numPoints:int = 8) : void
      {
         var th:Number = NaN;
         var thm:Number = NaN;
         var px:Number = NaN;
         var py:Number = NaN;
         var hx:Number = NaN;
         var hy:Number = NaN;
         var curve:Number = 1 + 1 / (numPoints * 1.75);
         path.moveTo(centerX + radius,centerY);
         for(var i:int = 1; i <= numPoints; i++)
         {
            th = TWO_PI * i / numPoints;
            thm = TWO_PI * (i - 0.5) / numPoints;
            px = centerX + radius * Math.cos(th);
            py = centerY + radius * Math.sin(th);
            hx = centerX + radius * curve * Math.cos(thm);
            hy = centerY + radius * curve * Math.sin(thm);
            path.curveTo(hx,hy,px,py);
         }
      }
      
      public static function drawCutEdgeRect(x:int, y:int, width:int, height:int, cutLen:int, cuts:Array, path:GraphicsPath) : void
      {
         if(cuts[0] != 0)
         {
            path.moveTo(x,y + cutLen);
            path.lineTo(x + cutLen,y);
         }
         else
         {
            path.moveTo(x,y);
         }
         if(cuts[1] != 0)
         {
            path.lineTo(x + width - cutLen,y);
            path.lineTo(x + width,y + cutLen);
         }
         else
         {
            path.lineTo(x + width,y);
         }
         if(cuts[2] != 0)
         {
            path.lineTo(x + width,y + height - cutLen);
            path.lineTo(x + width - cutLen,y + height);
         }
         else
         {
            path.lineTo(x + width,y + height);
         }
         if(cuts[3] != 0)
         {
            path.lineTo(x + cutLen,y + height);
            path.lineTo(x,y + height - cutLen);
         }
         else
         {
            path.lineTo(x,y + height);
         }
         if(cuts[0] != 0)
         {
            path.lineTo(x,y + cutLen);
         }
         else
         {
            path.lineTo(x,y);
         }
      }
      
      public static function drawDiamond(x:Number, y:Number, radius:Number, path:GraphicsPath) : void
      {
         path.moveTo(x,y - radius);
         path.lineTo(x + radius,y);
         path.lineTo(x,y + radius);
         path.lineTo(x - radius,y);
      }
   }
}
