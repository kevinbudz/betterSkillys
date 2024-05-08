package kabam.lib.ui.impl
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import kabam.lib.ui.api.Layout;
   import kabam.lib.ui.api.List;
   import kabam.lib.ui.api.Size;
   import org.osflash.signals.Signal;
   
   public class LayoutList extends Sprite implements List
   {
      
      private static const NULL_LAYOUT:Layout = new NullLayout();
      
      private static const ZERO_SIZE:Size = new Size(0,0);
       
      
      public const itemsChanged:Signal = new Signal();
      
      private const list:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      private const container:Sprite = new Sprite();
      
      private const containerMask:Shape = new Shape();
      
      private var layout:Layout;
      
      private var size:Size;
      
      private var offset:int = 0;
      
      public function LayoutList()
      {
         this.layout = NULL_LAYOUT;
         this.size = ZERO_SIZE;
         super();
         addChild(this.container);
         addChild(this.containerMask);
      }
      
      public function getLayout() : Layout
      {
         return this.layout;
      }
      
      public function setLayout(layout:Layout) : void
      {
         this.layout = layout || NULL_LAYOUT;
         layout.layout(this.list,-this.offset);
      }
      
      public function getSize() : Size
      {
         return this.size;
      }
      
      public function setSize(size:Size) : void
      {
         this.size = size || ZERO_SIZE;
         this.applySizeToMask();
      }
      
      public function getSizeOfItems() : Size
      {
         var rect:Rectangle = this.container.getRect(this.container);
         return new Size(rect.width,rect.height);
      }
      
      private function applySizeToMask() : void
      {
         var g:Graphics = this.containerMask.graphics;
         g.clear();
         g.beginFill(10027263);
         g.drawRect(0,0,this.size.width,this.size.height);
         g.endFill();
         this.container.mask = this.containerMask;
      }
      
      public function addItem(item:DisplayObject) : void
      {
         this.addToListAndContainer(item);
         this.updateLayout();
         this.itemsChanged.dispatch();
      }
      
      public function getItemAt(index:int) : DisplayObject
      {
         return this.list[index];
      }
      
      public function setItems(items:Vector.<DisplayObject>) : void
      {
         this.clearList();
         this.addItemsToListAndContainer(items);
         this.offset = 0;
         this.updateLayout();
         this.itemsChanged.dispatch();
      }
      
      public function getItemCount() : int
      {
         return this.list.length;
      }
      
      private function clearList() : void
      {
         var i:int = this.list.length;
         while(i--)
         {
            this.container.removeChild(this.list[i]);
         }
         this.list.length = 0;
      }
      
      private function addItemsToListAndContainer(items:Vector.<DisplayObject>) : void
      {
         var item:DisplayObject = null;
         for each(item in items)
         {
            this.addToListAndContainer(item);
         }
      }
      
      private function addToListAndContainer(item:DisplayObject) : void
      {
         this.list.push(item);
         this.container.addChild(item);
      }
      
      public function setOffset(value:int) : void
      {
         this.offset = value;
         this.updateLayout();
      }
      
      public function getOffset() : int
      {
         return this.offset;
      }
      
      public function updateLayout() : void
      {
         this.layout.layout(this.list,-this.offset);
      }
   }
}
