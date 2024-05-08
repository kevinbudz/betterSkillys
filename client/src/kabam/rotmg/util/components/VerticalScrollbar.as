package kabam.rotmg.util.components
{
   import flash.display.Sprite;
   import kabam.lib.ui.api.Scrollbar;
   import org.osflash.signals.Signal;
   
   public class VerticalScrollbar extends Sprite implements Scrollbar
   {
      public static const WIDTH:int = 20;
      public static const BEVEL:int = 4;
      public static const PADDING:int = 0;

      private var _positionChanged:Signal;
      public const groove:VerticalScrollbarGroove = new VerticalScrollbarGroove();
      public const bar:VerticalScrollbarBar = new VerticalScrollbarBar();
      
      private var position:Number = 0;
      private var range:int;
      private var invRange:Number;
      private var isEnabled:Boolean = true;
      
      public function VerticalScrollbar()
      {
         super();
         addChild(this.groove);
         addChild(this.bar);
         this.addMouseListeners();
      }
      
      public function get positionChanged() : Signal
      {
         return this._positionChanged = this._positionChanged || new Signal(Number);
      }
      
      public function getIsEnabled() : Boolean
      {
         return this.isEnabled;
      }
      
      public function setIsEnabled(isEnabled:Boolean) : void
      {
         if(this.isEnabled != isEnabled)
         {
            this.isEnabled = isEnabled;
            if(isEnabled)
            {
               this.addMouseListeners();
            }
            else
            {
               this.removeMouseListeners();
            }
         }
      }
      
      private function addMouseListeners() : void
      {
         this.groove.addMouseListeners();
         this.groove.clicked.add(this.onGrooveClicked);
         this.bar.addMouseListeners();
         this.bar.dragging.add(this.onBarDrag);
      }
      
      private function removeMouseListeners() : void
      {
         this.groove.removeMouseListeners();
         this.groove.clicked.remove(this.onGrooveClicked);
         this.bar.removeMouseListeners();
         this.bar.dragging.remove(this.onBarDrag);
      }
      
      public function setSize(barSize:int, grooveSize:int) : void
      {
         this.bar.rect.height = barSize;
         this.groove.rect.height = grooveSize;
         this.range = grooveSize - barSize - PADDING * 2;
         this.invRange = 1 / this.range;
         this.groove.redraw();
         this.bar.redraw();
         this.setPosition(this.getPosition());
      }
      
      public function getBarSize() : int
      {
         return this.bar.rect.height;
      }
      
      public function getGrooveSize() : int
      {
         return this.groove.rect.height;
      }
      
      public function getPosition() : Number
      {
         return this.position;
      }
      
      public function setPosition(value:Number) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         else if(value > 1)
         {
            value = 1;
         }
         this.position = value;
         this.bar.y = PADDING + this.range * this.position;
         this._positionChanged && this._positionChanged.dispatch(this.position);
      }

      public function scrollPosition(value:Number):void {
         var position:Number = (this.position + value);
         this.setPosition(position);
      }
      
      private function onBarDrag(value:int) : void
      {
         this.setPosition((value - PADDING) * this.invRange);
      }
      
      private function onGrooveClicked(value:int) : void
      {
         var barHeight:int = this.bar.rect.height;
         var numerator:int = value - barHeight * 0.5;
         var denominator:int = this.groove.rect.height - barHeight;
         this.setPosition(numerator / denominator);
      }
   }
}
