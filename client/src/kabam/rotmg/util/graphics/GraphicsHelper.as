package kabam.rotmg.util.graphics
{
   import flash.display.Graphics;
   
   public class GraphicsHelper
   {
       
      
      public function GraphicsHelper()
      {
         super();
      }
      
      public function drawBevelRect(x:int, y:int, rect:BevelRect, graphics:Graphics) : void
      {
         var right:int = x + rect.width;
         var bottom:int = y + rect.height;
         var bevel:int = rect.bevel;
         if(rect.topLeftBevel)
         {
            graphics.moveTo(x,y + bevel);
            graphics.lineTo(x + bevel,y);
         }
         else
         {
            graphics.moveTo(x,y);
         }
         if(rect.topRightBevel)
         {
            graphics.lineTo(right - bevel,y);
            graphics.lineTo(right,y + bevel);
         }
         else
         {
            graphics.lineTo(right,y);
         }
         if(rect.bottomRightBevel)
         {
            graphics.lineTo(right,bottom - bevel);
            graphics.lineTo(right - bevel,bottom);
         }
         else
         {
            graphics.lineTo(right,bottom);
         }
         if(rect.bottomLeftBevel)
         {
            graphics.lineTo(x + bevel,bottom);
            graphics.lineTo(x,bottom - bevel);
         }
         else
         {
            graphics.lineTo(x,bottom);
         }
      }
   }
}
