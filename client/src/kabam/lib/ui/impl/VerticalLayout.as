package kabam.lib.ui.impl
{
   import flash.display.DisplayObject;
   import kabam.lib.ui.api.Layout;
   
   public class VerticalLayout implements Layout
   {
       
      
      private var padding:int = -3;
      
      public function VerticalLayout()
      {
         super();
      }
      
      public function getPadding() : int
      {
         return this.padding;
      }
      
      public function setPadding(value:int) : void
      {
         this.padding = value;
      }
      
      public function layout(elements:Vector.<DisplayObject>, offset:int = 0) : void
      {
         var element:DisplayObject = null;
         var y:int = offset;
         var length:int = elements.length;
         for(var i:int = 0; i < length; i++)
         {
            element = elements[i];
            element.x = 1;
            element.y = 1 + y;
            y = y + (element.height + this.padding);
         }
      }
   }
}
