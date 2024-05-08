package kabam.lib.ui.api
{
   import flash.display.DisplayObject;
   
   public interface List
   {
       
      
      function addItem(param1:DisplayObject) : void;
      
      function setItems(param1:Vector.<DisplayObject>) : void;
      
      function getItemAt(param1:int) : DisplayObject;
      
      function getItemCount() : int;
   }
}
