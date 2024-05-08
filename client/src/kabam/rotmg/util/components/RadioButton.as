package kabam.rotmg.util.components
{
   import com.company.util.GraphicsUtil;
   import flash.display.CapsStyle;
   import flash.display.Graphics;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import org.osflash.signals.Signal;
   
   public class RadioButton extends Sprite
   {
       
      
      public const changed:Signal = new Signal(Boolean);
      
      private const WIDTH:int = 28;
      
      private const HEIGHT:int = 28;
      
      private var unselected:Shape;
      
      private var selected:Shape;
      
      public function RadioButton()
      {
         super();
         addChild(this.unselected = this.makeUnselected());
         addChild(this.selected = this.makeSelected());
         this.setSelected(false);
      }
      
      public function setSelected(value:Boolean) : void
      {
         this.unselected.visible = !value;
         this.selected.visible = value;
         this.changed.dispatch(value);
      }
      
      private function makeUnselected() : Shape
      {
         var shape:Shape = new Shape();
         this.drawOutline(shape.graphics);
         return shape;
      }
      
      private function makeSelected() : Shape
      {
         var shape:Shape = new Shape();
         this.drawOutline(shape.graphics);
         this.drawFill(shape.graphics);
         return shape;
      }
      
      private function drawOutline(graphics:Graphics) : void
      {
         var internalFill:GraphicsSolidFill = new GraphicsSolidFill(0,0.01);
         var outlineFill:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
         var outlineStyle:GraphicsStroke = new GraphicsStroke(2,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,outlineFill);
         var outlinePath:GraphicsPath = new GraphicsPath();
         GraphicsUtil.drawCutEdgeRect(0,0,this.WIDTH,this.HEIGHT,4,GraphicsUtil.ALL_CUTS,outlinePath);
         var data:Vector.<IGraphicsData> = new <IGraphicsData>[outlineStyle,internalFill,outlinePath,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
         graphics.drawGraphicsData(data);
      }
      
      private function drawFill(graphics:Graphics) : void
      {
         var boxFill:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
         var boxPath:GraphicsPath = new GraphicsPath();
         GraphicsUtil.drawCutEdgeRect(4,4,this.WIDTH - 8,this.HEIGHT - 8,2,GraphicsUtil.ALL_CUTS,boxPath);
         var data:Vector.<IGraphicsData> = new <IGraphicsData>[boxFill,boxPath,GraphicsUtil.END_FILL];
         graphics.drawGraphicsData(data);
      }
   }
}
