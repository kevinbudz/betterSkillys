package kabam.rotmg.util.components
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import kabam.lib.ui.api.List;
   import kabam.lib.ui.api.Size;
   import kabam.lib.ui.impl.LayoutList;
   import kabam.lib.ui.impl.VerticalLayout;
   import org.osflash.signals.Signal;
   
   public class VerticalScrollingList extends Sprite implements List
   {
      public static const SCROLLBAR_PADDING:int = 5;
      public static const SCROLLBAR_GUTTER:int = VerticalScrollbar.WIDTH + SCROLLBAR_PADDING;

      public const scrollStateChanged:Signal = new Signal(Boolean);
      private var layout:VerticalLayout;
      private var list:LayoutList;
      private var scrollbar:VerticalScrollbar;
      private var isEnabled:Boolean = true;
      private var size:Size;
      
      public function VerticalScrollingList()
      {
         super();
         this.makeLayout();
         this.makeVerticalList();
         this.makeScrollbar();
      }
      
      public function getIsEnabled() : Boolean
      {
         return this.isEnabled;
      }
      
      public function setIsEnabled(value:Boolean) : void
      {
         this.isEnabled = value;
         this.scrollbar.setIsEnabled(value);
      }
      
      public function setSize(size:Size) : void
      {
         this.size = size;
         if(this.isScrollbarVisible())
         {
            size = new Size(size.width - SCROLLBAR_GUTTER,size.height);
         }
         this.list.setSize(size);
         this.refreshScrollbar();
      }
      
      public function setPadding(padding:int) : void
      {
         this.layout.setPadding(padding);
         this.list.updateLayout();
         this.refreshScrollbar();
      }
      
      public function addItem(item:DisplayObject) : void
      {
         this.list.addItem(item);
      }
      
      public function setItems(items:Vector.<DisplayObject>) : void
      {
         this.list.setItems(items);
      }
      
      public function getItemAt(index:int) : DisplayObject
      {
         return this.list.getItemAt(index);
      }
      
      public function getItemCount() : int
      {
         return this.list.getItemCount();
      }
      
      public function getListHeight() : int
      {
         return this.list.getSizeOfItems().height;
      }
      
      private function makeLayout() : void
      {
         this.layout = new VerticalLayout();
      }
      
      public function isScrollbarVisible() : Boolean
      {
         return this.scrollbar.visible;
      }
      
      private function makeVerticalList() : void
      {
         this.list = new LayoutList();
         this.list.itemsChanged.add(this.refreshScrollbar);
         this.list.setLayout(this.layout);
         addChild(this.list);
      }
      
      private function refreshScrollbar() : void
      {
         var isVisible:Boolean = false;
         var listSize:Size = this.list.getSize();
         var visibleSize:int = listSize.height;
         var itemsSize:int = this.list.getSizeOfItems().height;
         isVisible = itemsSize > visibleSize;
         var isChanged:Boolean = this.scrollbar.visible != isVisible;
         this.scrollbar.visible = isVisible;
         isVisible && this.updateScrollbarSize(visibleSize,itemsSize);
         isChanged && this.updateUiAndDispatchStateChange(isVisible);
      }
      
      private function updateUiAndDispatchStateChange(isVisible:Boolean) : void
      {
         this.setSize(this.size);
         this.scrollStateChanged.dispatch(isVisible);
      }
      
      private function updateScrollbarSize(visibleSize:int, itemsSize:int) : void
      {
         var barSize:int = visibleSize * (visibleSize / itemsSize);
         this.scrollbar.setSize(barSize,visibleSize);
         this.scrollbar.x = this.list.getSize().width + SCROLLBAR_PADDING;
      }
      
      private function makeScrollbar() : void
      {
         this.scrollbar = new VerticalScrollbar();
         this.scrollbar.positionChanged.add(this.onPositionChanged);
         this.scrollbar.visible = false;
         addChild(this.scrollbar);
      }
      
      private function onPositionChanged(value:Number) : void
      {
         var maxOffset:int = this.list.getSizeOfItems().height - this.list.getSize().height;
         this.list.setOffset(maxOffset * value);
      }
   }
}
