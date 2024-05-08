package kabam.rotmg.core.model
{
   public class ScreenModel
   {
       
      
      public var currentType:Class;
      
      public function ScreenModel()
      {
         super();
      }

      public function getCurrentScreenType():Class {
         return (this.currentType);
      }
   }
}
