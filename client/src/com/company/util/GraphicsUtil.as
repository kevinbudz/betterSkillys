package com.company.util
{
import flash.display.Graphics;
import flash.display.GraphicsEndFill;
import flash.display.GraphicsPathCommand;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.geom.Matrix;

public class GraphicsUtil
{
   public static const QUAD_COMMANDS:Vector.<int> = new <int>[GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO];

   private static const TWO_PI:Number = 2 * Math.PI;

   public static const ALL_CUTS:Array = [true, true, true, true];

   public static const OUTER_FILL:GraphicsSolidFill = new GraphicsSolidFill(0x222222, 1);
   public static const BACKGROUND_FILL:GraphicsSolidFill = new GraphicsSolidFill(0x323232, 1);

   public static const CELL_OUTER_FILL:GraphicsSolidFill = new GraphicsSolidFill(0x363636, 1);
   public static const CELL_BACKGROUND_FILL:GraphicsSolidFill = new GraphicsSolidFill(0x262626, 1);

   public static const LINE_STYLE:GraphicsStroke = new GraphicsStroke(3, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, OUTER_FILL);
   public static const ALT_LINE_STYLE:GraphicsStroke = new GraphicsStroke(3, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, CELL_OUTER_FILL);

   public static const END_FILL:GraphicsEndFill = new GraphicsEndFill();
   public static const END_STROKE:GraphicsStroke = new GraphicsStroke();
   public static const DEBUG_STROKE:GraphicsStroke = new GraphicsStroke(1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, new GraphicsSolidFill(16711680));

   public static const PATH:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());

   public static const PANEL_DATA:Vector.<IGraphicsData> = new <IGraphicsData>[LINE_STYLE, BACKGROUND_FILL, PATH, END_FILL];
   public static const INSET_DATA:Vector.<IGraphicsData> = new <IGraphicsData>[LINE_STYLE, OUTER_FILL, PATH, END_FILL];
   public static const ALT_INSET_DATA:Vector.<IGraphicsData> = new <IGraphicsData>[ALT_LINE_STYLE, BACKGROUND_FILL, PATH, END_FILL];
   public static const CELL_DATA:Vector.<IGraphicsData> = new <IGraphicsData>[ALT_LINE_STYLE, CELL_BACKGROUND_FILL, PATH, END_FILL];

   public static function drawTriangle(x:int, y:int, width:int, height:int, up:Boolean, data:GraphicsPath):void
   {
      if (up) {
         data.moveTo(x + width, y + height);
         data.lineTo(x, y + height);
         data.lineTo(x + width / 2, y);
      } else {
         data.moveTo(x, y);
         data.lineTo(x + width, y);
         data.lineTo(x + width / 2, y + height);
      }
   }

   public static function drawUI(x:int, y:int, width:int, height:int, cornerRadius:int, corner:Array, data:GraphicsPath):void
   {
      if (corner[0] != 0) {
         data.moveTo(x, y + cornerRadius);
         data.lineTo(x + cornerRadius, y);
      } else {
         data.moveTo(x, y);
      }
      if (corner[1] != 0) {
         data.lineTo((x + width) - cornerRadius, y);
         data.lineTo(x + width, y + cornerRadius);
      } else {
         data.lineTo(x + width, y);
      }
      if (corner[2] != 0) {
         data.lineTo(x + width, (y + height) - cornerRadius);
         data.lineTo((x + width) - cornerRadius, y + height);
      } else {
         data.lineTo(x + width, y + height);
      }
      if (corner[3] != 0) {
         data.lineTo(x + cornerRadius, y + height);
         data.lineTo(x, (y + height) - cornerRadius);
      } else {
         data.lineTo(x, y + height);
      }
      if (corner[0] != 0) {
         data.lineTo(x, y + cornerRadius);
      } else {
         data.lineTo(x, y);
      }
   }

   public static function drawInset(w:int, h:int, cut:int = 12, alt:Boolean = false):Sprite
   {
      var s:Sprite = new Sprite();
      clearPath(PATH);
      drawCutEdgeRect(0, 0, w, h, cut, [1, 1, 1, 1], PATH);
      s.graphics.clear();
      s.graphics.drawGraphicsData(alt ? ALT_INSET_DATA : INSET_DATA);
      return s;
   }

   public static function drawBackground(w:int, h:int, cut:int = 12):Sprite
   {
      var s:Sprite = new Sprite();
      clearPath(PATH);
      drawCutEdgeRect(0, 0, w, h, cut, [1, 1, 1, 1], PATH);
      s.graphics.clear();
      s.graphics.drawGraphicsData(PANEL_DATA);
      return s;
   }

   public static function drawCellBackground(w:int, h:int, cut:int = 12):Sprite
   {
      var s:Sprite = new Sprite();
      clearPath(PATH);
      drawCutEdgeRect(0, 0, w, h, cut, [1, 1, 1, 1], PATH);
      s.graphics.clear();
      s.graphics.drawGraphicsData(CELL_DATA);
      return s;
   }

   public static function drawCellDecor(w:int, h:int, offset:int = 10):Sprite
   {
      var s:Sprite = new Sprite();
      var g:Graphics = s.graphics;
      g.clear();
      g.beginFill(0x323232, 1);
      g.drawRect(offset, 0, w, h);
      g.endFill();
      return s;
   }

   public static function clearPath(graphicsPath:GraphicsPath):void
   {
      graphicsPath.commands.length = 0;
      graphicsPath.data.length = 0;
   }

   public static function drawCutEdgeRect(x:int, y:int, width:int, height:int, cutLen:int, cuts:Array, path:GraphicsPath):void
   {
      if (cuts[0] != 0)
      {
         path.moveTo(x, y + cutLen);
         path.lineTo(x + cutLen, y);
      }
      else
      {
         path.moveTo(x, y);
      }
      if (cuts[1] != 0)
      {
         path.lineTo(x + width - cutLen, y);
         path.lineTo(x + width, y + cutLen);
      }
      else
      {
         path.lineTo(x + width, y);
      }
      if (cuts[2] != 0)
      {
         path.lineTo(x + width, y + height - cutLen);
         path.lineTo(x + width - cutLen, y + height);
      }
      else
      {
         path.lineTo(x + width, y + height);
      }
      if (cuts[3] != 0)
      {
         path.lineTo(x + cutLen, y + height);
         path.lineTo(x, y + height - cutLen);
      }
      else
      {
         path.lineTo(x, y + height);
      }
      if (cuts[0] != 0)
      {
         path.lineTo(x, y + cutLen);
      }
      else
      {
         path.lineTo(x, y);
      }
   }

   public static function drawCircle(centerX:Number, centerY:Number, radius:Number, path:GraphicsPath, numPoints:int = 8):void
   {
      var th:Number;
      var thm:Number;
      var px:Number;
      var py:Number;
      var hx:Number;
      var hy:Number;
      var curve:Number = 1 + 1 / (numPoints * 1.75);
      path.moveTo(centerX + radius, centerY);
      for (var i:int = 1; i <= numPoints; i++)
      {
         th = 2 * Math.PI * i / numPoints;
         thm = 2 * Math.PI * (i - 0.5) / numPoints;
         px = centerX + radius * Math.cos(th);
         py = centerY + radius * Math.sin(th);
         hx = centerX + radius * curve * Math.cos(thm);
         hy = centerY + radius * curve * Math.sin(thm);
         path.curveTo(hx, hy, px, py);
      }
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

   public static function drawDiamond(x:Number, y:Number, radius:Number, path:GraphicsPath):void
   {
      path.moveTo(x, y - radius);
      path.lineTo(x + radius, y);
      path.lineTo(x, y + radius);
      path.lineTo(x - radius, y);
   }
}
}
