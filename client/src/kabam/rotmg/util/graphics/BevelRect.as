package kabam.rotmg.util.graphics
{
   public class BevelRect
   {
       
      
      public var topLeftBevel:Boolean = true;
      
      public var topRightBevel:Boolean = true;
      
      public var bottomLeftBevel:Boolean = true;
      
      public var bottomRightBevel:Boolean = true;
      
      public var width:int;
      
      public var height:int;
      
      public var bevel:int;
      
      public function BevelRect(width:int, height:int, bevel:int)
      {
         super();
         this.width = width;
         this.height = height;
         this.bevel = bevel;
      }
   }
}
