package com.company.assembleegameclient.map
{
import com.company.util.GraphicsUtil;
import flash.display.GradientType;
import flash.display.GraphicsGradientFill;
import flash.display.GraphicsPath;
import flash.display.IGraphicsData;
import flash.display.Shape;
import com.company.assembleegameclient.parameters.Parameters;

public class HurtOverlay extends Shape
{

   private const mscale:Number = Parameters.data_.mscale;
   private const scaleH:Number = WebMain.sHeight / mscale;
   private const scaleW:Number = WebMain.sWidth / mscale;

   private const s:Number = scaleH / Math.sin(Math.PI / 4);

   private const gradientFill_:GraphicsGradientFill = new GraphicsGradientFill(GradientType.RADIAL,[16777215,16777215,16777215],[0,0,0.5],[0,155,255],GraphicsUtil.getGradientMatrix(s,s,0,(scaleW-(scaleW*0.15) - s) / 2,(scaleH - s) / 2));

   private const gradientPath_:GraphicsPath = GraphicsUtil.getRectPath(-200,0,scaleW,scaleH);

   private const gradientGraphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[gradientFill_,gradientPath_,GraphicsUtil.END_FILL];

   public function HurtOverlay()
   {
      super();
      graphics.drawGraphicsData(this.gradientGraphicsData_);
      visible = false;
   }
}
}