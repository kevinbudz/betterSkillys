package kabam.rotmg.util.components
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import kabam.rotmg.util.graphics.BevelRect;
   import kabam.rotmg.util.graphics.GraphicsHelper;
   import org.osflash.signals.Signal;
   
   internal final class VerticalScrollbarBar extends Sprite
   {
      public static const WIDTH:int = VerticalScrollbar.WIDTH;
      public static const BEVEL:int = VerticalScrollbar.BEVEL;
      public static const PADDING:int = VerticalScrollbar.PADDING;

      public const dragging:Signal = new Signal(int);
      public const rect:BevelRect = new BevelRect(WIDTH - PADDING * 2,0,BEVEL);
      private const helper:GraphicsHelper = new GraphicsHelper();
      private var downOffset:Number;
      private var isOver:Boolean;
      private var isDown:Boolean;
      
      function VerticalScrollbarBar()
      {
         super();
      }
      
      public function redraw() : void
      {
         var color:int = this.isOver || this.isDown?int(16767876):int(13421772);
         graphics.clear();
         graphics.beginFill(color);
         this.helper.drawBevelRect(PADDING,0,this.rect,graphics);
         graphics.endFill();
      }
      
      public function addMouseListeners() : void
      {
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
      }
      
      public function removeMouseListeners() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.onMouseUp();
      }
      
      private function onMouseDown(event:MouseEvent = null) : void
      {
         this.isDown = true;
         this.downOffset = parent.mouseY - y;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(Event.ENTER_FRAME,this.iterate);
         this.redraw();
      }
      
      private function onMouseUp(event:MouseEvent = null) : void
      {
         this.isDown = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         removeEventListener(Event.ENTER_FRAME,this.iterate);
         this.redraw();
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.isOver = true;
         this.redraw();
      }
      
      private function onMouseOut(event:MouseEvent) : void
      {
         this.isOver = false;
         this.redraw();
      }
      
      private function iterate(event:Event) : void
      {
         this.dragging.dispatch(int(parent.mouseY - this.downOffset));
      }
   }
}
