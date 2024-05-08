package kabam.rotmg.ui.view.components
{
   import flash.display.Shape;
   
   public class DarkenFactory
   {
       
      
      public function DarkenFactory()
      {
         super();
      }
      
      public function create() : Shape
      {
         var shape:Shape = new Shape();
         shape.graphics.beginFill(2829099,0.8);
         shape.graphics.drawRect(0,0,800,600);
         shape.graphics.endFill();
         return shape;
      }
   }
}
