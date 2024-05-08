package kabam.lib.ui.api
{
   import flash.display.DisplayObject;
   
   public interface Layout
   {
       
      
      function getPadding() : int;
      
      function setPadding(param1:int) : void;
      
      function layout(param1:Vector.<DisplayObject>, param2:int = 0) : void;
   }
}
