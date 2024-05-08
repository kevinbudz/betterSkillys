package kabam.rotmg.util.components
{
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import kabam.rotmg.util.graphics.BevelRect;
   import kabam.rotmg.util.graphics.GraphicsHelper;
   
   public class DialogBackground extends Sprite
   {
      
      private static const BEVEL:int = 4;
       
      
      public function DialogBackground()
      {
         super();
      }
      
      public function draw(width:int, height:int) : void
      {
         var rect:BevelRect = new BevelRect(width,height,BEVEL);
         var helper:GraphicsHelper = new GraphicsHelper();
         graphics.lineStyle(1,16777215,1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3);
         graphics.beginFill(3552822);
         helper.drawBevelRect(0,0,rect,graphics);
         graphics.endFill();
      }
   }
}
