package kabam.lib.ui.impl
{
   import flash.display.DisplayObject;
   import kabam.lib.ui.api.Layout;
   
   public class NullLayout implements Layout
   {
       
      
      public function NullLayout()
      {
         super();
      }
      
      public function getPadding() : int
      {
         return 0;
      }
      
      public function setPadding(value:int) : void
      {
      }
      
      public function layout(elements:Vector.<DisplayObject>, offset:int = 0) : void
      {
      }
   }
}
